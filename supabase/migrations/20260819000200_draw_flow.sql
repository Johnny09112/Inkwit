-- Inkwit — nabídka konceptů a uložení kresby (kroky C1 a C2)
--
-- Obojí jde přes RPC, ne přes přímý zápis do tabulek. Důvody jsou dva a každý
-- sám o sobě by stačil:
--
--   1. Zadání konceptu je tajemství hry. Klient tabulku `concepts` nečte,
--      takže mu nabídku musí složit server.
--   2. „Klientu se nevěří nic — ani časy tahů" (CLAUDE.md). Odvozená čísla
--      o kresbě proto počítá server, ne prohlížeč.

-- ---------------------------------------------------------------------------
-- Limity — do konfigurace, ne do kódu (pravidlo 6)
-- ---------------------------------------------------------------------------

insert into public.game_config (key, value, is_public, note) values
  ('max_strokes_per_drawing', '2000'::jsonb, true,
   'Strop tahů na kresbu. Ochrana proti nafouknutí úložiště a egressu, ne herní pravidlo.'),
  ('max_points_per_drawing', '60000'::jsonb, true,
   'Strop bodů na kresbu celkem. Při 1500 bodech u běžné kresby je to čtyřicetinásobná rezerva.')
on conflict (key) do nothing;

-- ---------------------------------------------------------------------------
-- C1 — nabídka tří konceptů
-- ---------------------------------------------------------------------------
--
-- Jeden koncept od každé obtížnosti. Není to kosmetika: volba ze tří je ventil
-- pro toho, kdo kreslit neumí (`docs/product.md`), a ventil bez snadné možnosti
-- nefunguje.
--
-- Vyžádané koncepty mají přednost — tím se vyžádání stává skutečnou pákou
-- a ne přáním do prázdna (krok E2).

create or replace function public.offer_concepts()
returns table (
  concept_id   uuid,
  difficulty   smallint,
  prompt       text,
  requested_by text
)
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user   uuid := auth.uid();
  v_locale text;
  v_tenant uuid;
  d        smallint;
begin
  if v_user is null then
    raise exception 'Nabídku konceptů dostane jen přihlášený uživatel.'
      using errcode = '28000';
  end if;

  select locale_primary, tenant_id into v_locale, v_tenant
  from public.profiles where id = v_user;

  for d in 1..3 loop
    return query
      select c.id, c.difficulty, cl.prompt, req.display_name
      from public.concepts c
      join public.concept_locales cl
        on cl.concept_id = c.id and cl.locale = v_locale
      left join lateral (
        select p.display_name
        from public.concept_requests r
        join public.profiles p on p.id = r.requester_id
        where r.concept_id = c.id
          and r.status = 'open'
          and r.expires_at > now()
        order by r.created_at
        limit 1
      ) req on true
      where c.status = 'active'
        and c.difficulty = d
        -- Uvnitř tenanta jen koncepty označené jako bezpečné (pravidlo 1).
        and (v_tenant is null or c.is_school_safe)
        -- Nenabízet, co už člověk kreslil.
        and not exists (
          select 1 from public.drawings dr
          where dr.author_id = v_user and dr.concept_id = c.id
        )
      order by (req.display_name is not null) desc, random()
      limit 1;

    -- Když už člověk nakreslil všechno z téhle obtížnosti, opakování je lepší
    -- než prázdná nabídka.
    if not found then
      return query
        select c.id, c.difficulty, cl.prompt, null::text
        from public.concepts c
        join public.concept_locales cl
          on cl.concept_id = c.id and cl.locale = v_locale
        where c.status = 'active'
          and c.difficulty = d
          and (v_tenant is null or c.is_school_safe)
        order by random()
        limit 1;
    end if;
  end loop;
end;
$$;

revoke execute on function public.offer_concepts() from public, anon;
grant execute on function public.offer_concepts() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- C2 — kreslení ve dvou krocích
-- ---------------------------------------------------------------------------
--
-- Proč dva kroky a ne jedno odeslání: **dobu kreslení musí změřit server.**
-- Kdyby ji poslal klient, je to údaj, kterému se podle CLAUDE.md nesmí věřit —
-- a přitom je to jeden ze vstupů detekce čmáranic.
--
-- Vedlejší efekt, který se hodí: vzniká tím událost „uživatel začal kreslit"
-- oddělená od „odeslal", což je přesně to, co chce měřit krok F3. Drop-off
-- mezi nimi je klíčové číslo fáze 0.

create or replace function public.start_drawing(p_concept_id uuid)
returns uuid
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
  v_id   uuid;
begin
  if v_user is null then
    raise exception 'Kreslit může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  if not exists (select 1 from public.concepts where id = p_concept_id and status = 'active') then
    raise exception 'Takový koncept neexistuje.' using errcode = '23503';
  end if;

  insert into public.drawings (author_id, concept_id, source_locale, tenant_id, status)
  select v_user, p_concept_id, p.locale_primary, p.tenant_id, 'draft'
  from public.profiles p where p.id = v_user
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function public.submit_drawing(
  p_drawing_id  uuid,
  p_device_kind text,
  p_undo_count  integer,
  p_strokes     jsonb
)
returns uuid
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user        uuid := auth.uid();
  v_created     timestamptz;
  v_max_strokes int;
  v_max_points  int;
  v_count       int;
  v_points      int;
  v_min_x       real; v_max_x real; v_min_y real; v_max_y real;
  s             jsonb;
  seq           int := 0;
  i             int;
begin
  if v_user is null then
    raise exception 'Odeslat kresbu může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  select created_at into v_created
  from public.drawings
  where id = p_drawing_id and author_id = v_user and status = 'draft'
  for update;

  if not found then
    raise exception 'Rozepsaná kresba nenalezena.' using errcode = '23503';
  end if;

  if jsonb_typeof(p_strokes) <> 'array' or jsonb_array_length(p_strokes) = 0 then
    raise exception 'Kresba nemá žádné tahy.' using errcode = '23514';
  end if;

  select (value)::int into v_max_strokes from public.game_config where key = 'max_strokes_per_drawing';
  select (value)::int into v_max_points  from public.game_config where key = 'max_points_per_drawing';

  v_count := jsonb_array_length(p_strokes);
  if v_count > v_max_strokes then
    raise exception 'Příliš mnoho tahů.' using errcode = '23514';
  end if;

  select coalesce(sum(jsonb_array_length(x -> 'points')), 0) / 3
    into v_points
  from jsonb_array_elements(p_strokes) x;

  if v_points * 3 > v_max_points then
    raise exception 'Příliš mnoho bodů.' using errcode = '23514';
  end if;

  -- Tahy uložit v pořadí, v jakém přišly.
  for s in select * from jsonb_array_elements(p_strokes) loop
    if jsonb_typeof(s -> 'points') <> 'array'
       or jsonb_array_length(s -> 'points') = 0
       or jsonb_array_length(s -> 'points') % 3 <> 0 then
      raise exception 'Poškozený tah — body musí být ploché pole [x,y,t,…].'
        using errcode = '23514';
    end if;

    insert into public.drawing_strokes (drawing_id, seq, author_id, tool, color, width, points)
    values (
      p_drawing_id,
      seq,
      v_user,
      coalesce(s ->> 'tool', 'brush'),
      coalesce(s ->> 'color', '#2B261F'),
      coalesce((s ->> 'width')::real, 14),
      s -> 'points'
    );
    seq := seq + 1;
  end loop;

  -- Pokrytí plátna z bounding boxu všech bodů. Souřadnice jsou normalizované
  -- 0–1, takže plocha vyjde rovnou jako podíl.
  -- V plochém poli [x,y,t,…] je x na pozicích 1,4,7… a y na 2,5,8…
  -- (`ordinality` počítá od jedné), takže stačí zbytek po dělení třemi.
  select
    min(v) filter (where m = 0), max(v) filter (where m = 0),
    min(v) filter (where m = 1), max(v) filter (where m = 1)
  into v_min_x, v_max_x, v_min_y, v_max_y
  from (
    select (pt.value)::text::real as v, (pt.ord - 1) % 3 as m
    from jsonb_array_elements(p_strokes) as st
    cross join lateral jsonb_array_elements(st.value -> 'points')
      with ordinality as pt(value, ord)
  ) q;

  update public.drawings set
    status       = 'live',
    published_at = now(),
    -- Dobu měří SERVER, ne klient. Zahrnuje i to, že si člověk odskočil —
    -- rytmus kreslení se čte z časových značek v tazích, ne odsud.
    duration_ms  = greatest(0, (extract(epoch from (now() - v_created)) * 1000)::int),
    stroke_count = v_count,
    undo_count   = greatest(0, coalesce(p_undo_count, 0)),
    device_kind  = case when p_device_kind in ('mouse','touch','pen') then p_device_kind else 'unknown' end,
    coverage     = least(1.0, greatest(0.0, (v_max_x - v_min_x) * (v_max_y - v_min_y)))
  where id = p_drawing_id;

  return p_drawing_id;
end;
$$;

revoke execute on function public.start_drawing(uuid) from public, anon;
revoke execute on function public.submit_drawing(uuid, text, integer, jsonb) from public, anon;
grant execute on function public.start_drawing(uuid) to authenticated, service_role;
grant execute on function public.submit_drawing(uuid, text, integer, jsonb) to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Přímý zápis kreseb už klient nepotřebuje
-- ---------------------------------------------------------------------------
--
-- Dokud šlo vložit řádek napřímo, mohl si klient nastavit `duration_ms` sám.
-- Teď je jediná cesta přes RPC, které si čísla spočítá.

drop policy drawings_insert_own on public.drawings;
drop policy strokes_insert_own on public.drawing_strokes;
revoke insert on public.drawings from anon, authenticated;
revoke insert on public.drawing_strokes from anon, authenticated;

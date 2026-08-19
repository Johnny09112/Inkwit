-- Inkwit — kresba si nese svůj tvar
--
-- **Chyba, kterou to opravuje.** Body tahů jsou poměrné souřadnice 0–1 vůči
-- plátnu a vykreslují se jako `x * šířka`, `y * výška` — každá osa zvlášť.
-- Jenže plátno má na každé obrazovce jiný poměr stran:
--
--   kreslení s lištou   0,68     kreslení po rozbalení  0,53
--   hádání              0,75     náhled a detail        1,00
--
-- Táž kresba tedy byla při hádání o 29 % širší než při kreslení a v náhledu
-- dvakrát tolik. Nešlo o kosmetiku: kruh se vykreslil jako ovál.
--
-- **Řešení.** Kresba si uloží poměr plátna, na kterém vznikla, a všude se
-- vykresluje do obdélníku toho tvaru, vystředěného v dostupném místě.
-- Kreslicí plocha tím nepřichází o nic, jen se kolem ní podle potřeby objeví
-- volný okraj.
--
-- **Dosavadní kresby.** Poměr z poměrných souřadnic zpětně dopočítat nejde —
-- ta informace se nikdy neuložila. Existující řádky proto dostanou 0,68, což
-- byl poměr kreslicího plátna na telefonu s lištou nástrojů, na kterém všechny
-- vznikly. U testovacích dat fáze 0 je to přijatelný odhad, u nových kreseb
-- už se měří.

alter table public.drawings
  add column if not exists aspect real not null default 0.68
    check (aspect > 0.2 and aspect < 5);

comment on column public.drawings.aspect is
  'Poměr šířka/výška plátna, na kterém kresba vznikla. Bez něj se kresba při '
  'zobrazení na jinak tvarované ploše roztáhne. Řádky z doby před zavedením '
  'mají odhad 0.68 (telefon s lištou nástrojů).';

-- ---------------------------------------------------------------------------
-- Odeslání kresby přebírá poměr od klienta
-- ---------------------------------------------------------------------------
--
-- Tohle je jediný údaj od klienta, který se nedá ověřit ani dopočítat — plátno
-- existuje jen v prohlížeči. Proto aspoň rozsah: mimo něj se použije výchozí
-- hodnota, ať podvržený nesmysl nerozbije zobrazení ostatním.

create or replace function public.submit_drawing(
  p_drawing_id  uuid,
  p_device_kind text,
  p_undo_count  integer,
  p_strokes     jsonb,
  p_aspect      real default null
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
  v_aspect      real;
  s             jsonb;
  seq           int := 0;
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

  -- v_points UŽ JSOU body (pole má tři čísla na bod); násobit je znovu třemi
  -- znamenalo srovnávat délku pole se stropem počtu bodů.
  if v_points > v_max_points then
    raise exception 'Příliš mnoho bodů.' using errcode = '23514';
  end if;

  -- Nesmyslný poměr se tiše nahradí výchozím, ne odmítne — kresba za to nemůže.
  v_aspect := case
    when p_aspect is null or p_aspect <= 0.2 or p_aspect >= 5 then 0.68
    else p_aspect
  end;

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
    aspect       = v_aspect,
    coverage     = least(1.0, greatest(0.0, (v_max_x - v_min_x) * (v_max_y - v_min_y)))
  where id = p_drawing_id;

  return p_drawing_id;
end;
$$;

revoke execute on function public.submit_drawing(uuid, text, integer, jsonb, real) from public, anon;
grant execute on function public.submit_drawing(uuid, text, integer, jsonb, real) to authenticated, service_role;

-- Stará čtyřparametrová podoba by zůstala vedle nové a klient by mohl omylem
-- volat tu bez poměru. Pryč s ní.
drop function if exists public.submit_drawing(uuid, text, integer, jsonb);

-- ---------------------------------------------------------------------------
-- Poměr putuje ke každému, kdo kresbu vykresluje
-- ---------------------------------------------------------------------------

-- `create or replace` neumí změnit návratový typ (přibývá sloupec `aspect`),
-- takže se funkce musí nejdřív zahodit. Práva se níž nastavují znovu.
drop function if exists public.next_drawing();

create function public.next_drawing()
returns table (
  drawing_id    uuid,
  author_name   text,
  solved_count  integer,
  thumbs_count  integer,
  attempts_used integer,
  aspect        real,
  strokes       jsonb
)
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user   uuid := auth.uid();
  v_tenant uuid;
  v_id     uuid;
begin
  if v_user is null then
    raise exception 'Hádat může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  select tenant_id into v_tenant from public.profiles where id = v_user;

  select d.id into v_id
  from public.drawings d
  where d.status = 'live'
    and d.author_id <> v_user                      -- vlastní kresbu si nehádáš
    and (
      (d.tenant_id is null and v_tenant is null)   -- veřejná hra
      or d.tenant_id = v_tenant                    -- tenant, nikdy přes hranici
    )
    and not exists (
      select 1 from public.guesses g
      where g.drawing_id = d.id and g.user_id = v_user
    )
  order by d.solved_count, d.published_at          -- neuhodnuté a nejstarší napřed
  limit 1;

  if v_id is null then
    return;   -- prázdný feed; klient ukáže stav „zásoba došla"
  end if;

  return query
    select
      d.id,
      p.display_name,
      d.solved_count,
      d.thumbs_count,
      0,
      d.aspect,
      coalesce((
        select jsonb_agg(jsonb_build_object(
                 'tool', s.tool, 'color', s.color, 'width', s.width, 'points', s.points)
               order by s.seq)
        from public.drawing_strokes s where s.drawing_id = d.id
      ), '[]'::jsonb)
    from public.drawings d
    join public.profiles p on p.id = d.author_id
    where d.id = v_id;
end;
$$;

revoke execute on function public.next_drawing() from public, anon;
grant execute on function public.next_drawing() to authenticated, service_role;

drop function if exists public.my_drawings();

create function public.my_drawings()
returns table (
  drawing_id   uuid,
  prompt       text,
  difficulty   smallint,
  status       text,
  solved_count integer,
  thumbs_count integer,
  stars        smallint,
  aspect       real,
  created_at   timestamptz
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    d.id,
    cl.prompt,
    c.difficulty,
    d.status,
    d.solved_count,
    d.thumbs_count,
    coalesce((
      select (4 - min(g.attempt_no))::smallint
      from public.guesses g
      where g.drawing_id = d.id and g.is_correct
    ), 0)::smallint,
    d.aspect,
    d.created_at
  from public.drawings d
  join public.concepts c on c.id = d.concept_id
  join public.concept_locales cl
    on cl.concept_id = c.id and cl.locale = d.source_locale
  where d.author_id = auth.uid()
    and d.status not in ('draft', 'removed')
  order by d.created_at desc;
$$;

-- Vědomě pořád chybí `guess_count`. Kdyby tu byl, autor si počet neuhodnutí
-- dopočítá odečtením a pravidlo z `docs/product.md` padá.

revoke execute on function public.my_drawings() from public, anon;
grant execute on function public.my_drawings() to authenticated, service_role;

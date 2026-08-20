-- Inkwit — kredity se konečně někam ukládají
--
-- **Co bylo špatně.** V `ledger` byla nula řádků a žádný účet neměl XP. Za celou
-- dobu se nepřipsal jediný kredit. Konfigurace přitom obsahovala `reward_draw_solved`
-- a `reward_guess_correct` i s popisy — někdo balanc navrhl a nikdo ho nezapojil.
--
-- Aplikace navíc ukazovala „kredit +2" spočítaný **z obtížnosti v klientovi**,
-- což je zároveň porušení pravidla 6 („balanc odměn je serverová konfigurace,
-- ne konstanty v kódu"). Slibovala tedy odměnu, která nikdy nepřišla, a ještě
-- jinou, než měla nastavenou.
--
-- **Nový balanc** (majitel 2026-08-20). Základ hned při odeslání podle obtížnosti
-- a bonus, teprve když kresbu někdo uhodne:
--
--   snadné   1 + 1 = 2      střední  2 + 3 = 5      těžké  3 + 5 = 8
--
-- Víc než polovina odměny visí na tom, jestli kresbě někdo rozumí — a u těžkých
-- je ten podíl nejvyšší. Očekávaný výnos při realistické šanci na uhodnutí
-- (95 / 80 / 60 %) vychází 1,95 · 4,4 · 6,0, takže se vyplatí zkusit těžší slovo.
--
-- **Nekalibrováno daty.** V době rozhodnutí bylo v databázi 6 těžkých kreseb
-- a 5 tipů na ně; to není vzorek. Čísla jsou úvaha, ne měření — proto jsou
-- v konfiguraci a mění se bez nasazení. Sledovat: jestli se všichni nevrhnou
-- na těžká slova a nezaplní zásobu neuhodnutelnými kresbami.

insert into public.game_config (key, value, is_public, note) values
  ('reward_draw_base',  '{"1": 1, "2": 2, "3": 3}'::jsonb, true,
   'Kredit hned při odeslání, podle obtížnosti. Jistá odměna za to, že vůbec něco vzniklo.'),
  ('reward_draw_bonus', '{"1": 1, "2": 3, "3": 5}'::jsonb, true,
   'Kredit navíc, když kresbu POPRVÉ někdo uhodne. Platí se jednou, ne za každého hádače — jinak by populární kresba vyplatila třicet bonusů.'),
  ('price_color_mixer', '25'::jsonb, true,
   'Cena za odemčení míchání vlastních barev. Jednorázově. Kosmetika, ne výhoda ve hře (pravidlo 3).')
on conflict (key) do update set value = excluded.value, note = excluded.note;

-- Původní klíče zůstávají, ale přestávají platit. Mazat je nebudeme: popis
-- nese úvahu, která se může hodit, a `reward_guess_correct` se dál používá.
update public.game_config
set value = '1'::jsonb,
    note = 'Kredit za uhodnutí. Musí být výrazně méně než za kreslení — hádat je levné a nekonečné, kdežto zásoba kreseb je to, co dochází.'
where key = 'reward_guess_correct';

update public.game_config
set note = 'NEPOUŽÍVÁ SE od 2026-08-20. Nahrazeno dvojicí reward_draw_base a reward_draw_bonus, které rozlišují obtížnost.'
where key = 'reward_draw_solved';

-- ---------------------------------------------------------------------------
-- Zápis do ledgeru
-- ---------------------------------------------------------------------------
--
-- Tentýž důvod u téhož odkazu se smí připsat jen jednou. Bez toho by druhé
-- uhodnutí vyplatilo bonus znovu a balanc by nedržel.

create unique index if not exists ledger_once_idx
  on public.ledger (user_id, reason, ref_id)
  where ref_id is not null;

create or replace function private.award(
  p_user uuid, p_delta integer, p_reason text, p_ref uuid default null
)
returns void
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
begin
  if p_user is null or coalesce(p_delta, 0) = 0 then
    return;
  end if;
  insert into public.ledger (user_id, delta, reason, ref_id)
  values (p_user, p_delta, p_reason, p_ref)
  on conflict do nothing;   -- druhý pokus o tutéž odměnu tiše propadne
end;
$$;

/** Kolik kreditů má daný účet. Součet ledgeru, žádné druhé místo pravdy. */
create or replace function private.balance(p_user uuid)
returns integer
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select coalesce(sum(delta), 0)::int from public.ledger where user_id = p_user;
$$;

/** Vlastní zůstatek pro klienta. Cizí se nezobrazuje. */
create or replace function public.my_credits()
returns integer
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select private.balance(auth.uid());
$$;

revoke execute on function public.my_credits() from public, anon;
grant execute on function public.my_credits() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Odemčení míchání barev
-- ---------------------------------------------------------------------------
--
-- Kruh barev dnes namíchá cokoli zdarma, takže „kredity za barvy" by šlo obejít
-- za tři vteřiny. Placené je proto samo míchání; základní paleta zůstává zdarma.
-- Je to kosmetika — na férovost hry nemá vliv (pravidlo 3).
--
-- Paleta samotná zůstává v prohlížeči (viz decisions/predvolby-zarizeni-v-localstorage).
-- Na účtu je jen to, co se koupilo.

alter table public.profiles
  add column if not exists has_color_mixer boolean not null default false;

comment on column public.profiles.has_color_mixer is
  'Koupené odemčení míchání barev. Uživatel si ho nenastaví — UPDATE na profiles '
  'je udělený jen na vyjmenované sloupce a tenhle mezi nimi není.';

create or replace function public.buy_color_mixer()
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user  uuid := auth.uid();
  v_price int;
  v_has   boolean;
begin
  if v_user is null then
    raise exception 'Koupit může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  -- Zamknout profil na dobu nákupu: bez toho by dvě rychlá klepnutí odečetla
  -- cenu dvakrát.
  select has_color_mixer into v_has from public.profiles where id = v_user for update;
  if v_has then
    return true;   -- už koupeno, druhý nákup se neúčtuje
  end if;

  select (value)::int into v_price from public.game_config where key = 'price_color_mixer';

  if private.balance(v_user) < v_price then
    raise exception 'Nedostatek kreditů.' using errcode = '23514';
  end if;

  insert into public.ledger (user_id, delta, reason) values (v_user, -v_price, 'buy_color_mixer');
  update public.profiles set has_color_mixer = true where id = v_user;
  return true;
end;
$$;

revoke execute on function public.buy_color_mixer() from public, anon;
grant execute on function public.buy_color_mixer() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Profil vrací zůstatek a odemčení
-- ---------------------------------------------------------------------------

drop function if exists public.my_profile();

create function public.my_profile()
returns table (
  display_name    text,
  locale          text,
  ab_playback     boolean,
  drawings        integer,
  guesses         integer,
  unread          integer,
  credits         integer,
  has_color_mixer boolean
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    p.display_name,
    p.locale_primary,
    p.ab_playback,
    (select count(*)::int from public.drawings d where d.author_id = p.id and d.status <> 'removed'),
    (select count(*)::int from public.guesses g where g.user_id = p.id),
    (select count(*)::int from public.notifications n where n.user_id = p.id and n.read_at is null),
    private.balance(p.id),
    p.has_color_mixer
  from public.profiles p
  where p.id = auth.uid();
$$;

revoke execute on function public.my_profile() from public, anon;
grant execute on function public.my_profile() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Odměny se připisují tam, kde odměňovaná věc vzniká
-- ---------------------------------------------------------------------------

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
  v_diff        smallint;
  v_base        int;
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

  -- Základ podle obtížnosti, hned. Jistá odměna za to, že vůbec něco vzniklo;
  -- bonus za uhodnutí přidá submit_guess, až kresbě někdo porozumí.
  select c.difficulty into v_diff
  from public.drawings d join public.concepts c on c.id = d.concept_id
  where d.id = p_drawing_id;

  select (value -> v_diff::text)::int into v_base
  from public.game_config where key = 'reward_draw_base';

  perform private.award(v_user, coalesce(v_base, 0), 'draw_base', p_drawing_id);

  return p_drawing_id;
end;
$$;

revoke execute on function public.submit_drawing(uuid, text, integer, jsonb, real) from public, anon;
grant execute on function public.submit_drawing(uuid, text, integer, jsonb, real) to authenticated, service_role;

create or replace function public.submit_guess(p_drawing_id uuid, p_text text)
returns table (
  correct        boolean,
  attempt_no     integer,
  attempts_left  integer,
  hint           text,
  solution       text,
  stars          integer
)
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user     uuid := auth.uid();
  v_locale   text;
  v_max      int;
  v_used     int;
  v_attempt  int;
  v_concept  uuid;
  v_diff     smallint;
  v_prompt   text;
  v_correct  boolean;
  v_hint     text := null;
  v_solution text := null;
  v_hint_after int;
  v_hint_diff  int;
  v_author     uuid;
  v_reward     int;
  v_bonus      int;
begin
  if v_user is null then
    raise exception 'Hádat může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  if not private.can_view_drawing(p_drawing_id) then
    raise exception 'Tuhle kresbu hádat nemůžeš.' using errcode = '42501';
  end if;

  select d.concept_id, c.difficulty, p.locale_primary
    into v_concept, v_diff, v_locale
  from public.drawings d
  join public.concepts c on c.id = d.concept_id
  join public.profiles p on p.id = v_user
  where d.id = p_drawing_id
    and d.status = 'live'
    and d.author_id <> v_user;   -- vlastní kresbu si nehádáš

  if v_concept is null then
    raise exception 'Tuhle kresbu hádat nemůžeš.' using errcode = '42501';
  end if;

  select (value)::int into v_max from public.game_config where key = 'guess_attempts';

  select count(*) into v_used
  from public.guesses where drawing_id = p_drawing_id and user_id = v_user;

  if v_used >= v_max then
    raise exception 'Pokusy jsou vyčerpané.' using errcode = '23514';
  end if;

  -- Uhodnutím sezení končí. Bez téhle podmínky by šlo po správném tipu
  -- hádat dál a nafukovat počet tipů u cizí kresby.
  if exists (
    select 1 from public.guesses
    where drawing_id = p_drawing_id and user_id = v_user and is_correct
  ) then
    raise exception 'Tuhle kresbu už jsi uhodl.' using errcode = '23514';
  end if;

  v_attempt := v_used + 1;
  v_correct := private.answer_matches(v_concept, v_locale, p_text);

  select cl.prompt into v_prompt
  from public.concept_locales cl
  where cl.concept_id = v_concept and cl.locale = v_locale;

  select (value)::int into v_hint_after from public.game_config where key = 'hint_after_attempt';
  select (value)::int into v_hint_diff  from public.game_config where key = 'hint_min_difficulty';

  -- Nápověda se počítá ze zadání, nepíše ručně — u tisíce pojmů by ruční
  -- nápovědy znamenaly tisíc dalších rozhodnutí.
  if not v_correct
     and v_hint_after > 0
     and v_attempt >= v_hint_after
     and v_diff >= v_hint_diff
     and v_attempt < v_max then
    v_hint := upper(substr(v_prompt, 1, 1)) || repeat('·', greatest(0, length(v_prompt) - 1));
  end if;

  insert into public.guesses (drawing_id, user_id, locale, attempt_no, text_raw, is_correct, hint_shown)
  values (p_drawing_id, v_user, v_locale, v_attempt, p_text, v_correct, v_hint is not null);

  if v_correct then
    select (value)::int into v_reward from public.game_config where key = 'reward_guess_correct';
    perform private.award(v_user, coalesce(v_reward, 0), 'guess_correct', p_drawing_id);

    -- Bonus autorovi za PRVNÍ uhodnutí. Volá se při každém uhodnutí, ale
    -- unikátní index nad ledgerem druhý zápis zahodí — idempotence je
    -- v databázi, ne v podmínce, kterou by šlo obejít souběhem.
    select d.author_id into v_author from public.drawings d where d.id = p_drawing_id;
    select (value -> v_diff::text)::int into v_bonus
    from public.game_config where key = 'reward_draw_bonus';
    perform private.award(v_author, coalesce(v_bonus, 0), 'draw_bonus', p_drawing_id);
  end if;

  -- Odpověď se prozradí až když je po všem — dřív by stačilo poslat prázdný tip.
  if v_correct or v_attempt >= v_max then
    v_solution := v_prompt;
  end if;

  return query select
    v_correct,
    v_attempt,
    greatest(0, v_max - v_attempt),
    v_hint,
    v_solution,
    case when v_correct then (v_max + 1 - v_attempt) else 0 end;
end;
$$;

revoke execute on function public.submit_guess(uuid, text) from public, anon;
grant execute on function public.submit_guess(uuid, text) to authenticated, service_role;

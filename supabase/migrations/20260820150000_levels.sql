-- Inkwit — levely (blok J)
--
-- Level roste z **celkem vydělaných** kreditů, ne ze zůstatku. Kdyby se počítal
-- ze zůstatku, utracení za kosmetiku by člověka srazilo o level dolů.
--
-- ## Co levely NEGATUJÍ a proč
--
-- **Jádro hry zůstává od první minuty:** kreslení, hádání i všechny tři
-- obtížnosti. Majitel původně navrhoval zamknout hádání do třetí kresby
-- a obtížnosti na levely; obojí padlo:
--
--   * Vynucené kreslení před hádáním zabije **metriku 1** z `CLAUDE.md`
--     („podíl týdně aktivních, kteří nakreslí aspoň jednu kresbu"). Fáze 0 se
--     dělá právě proto, aby se zjistilo, jestli lidé kreslí DOBROVOLNĚ.
--   * Zamčené obtížnosti + prodej levelů = pay-to-win. Těžký pojem vydělá 8
--     kreditů proti 2 za snadný, takže koupený level je násobič výdělku
--     a přes žebříček i výhoda. Pravidlo 3 to zakazuje.
--
-- **Levely se nedají koupit.** Získávají se jen hraním. Prodávat se smí
-- kosmetika, ne postup — monetizace podle pravidla 5 jde přes firemní místnosti
-- a prémiové funkce.
--
-- **Přehrání kresby se nedá gatovat** — běží na něm A/B test kroku F4, který
-- měří, jestli přehrání pomáhá hádajícímu. Zámek by měření rozbil.

insert into public.game_config (key, value, is_public, note) values
  ('level_thresholds', '[0, 10, 25, 50, 100, 175]'::jsonb, true,
   'Kolik CELKEM vydělaných kreditů dělá který level. Index 0 = level 1. Level se počítá z vydělaných, ne ze zůstatku — jinak by utracení srazilo level.'),
  ('level_palette_full', '2'::jsonb, true,
   'Od kterého levelu je celá základní paleta. Pod ním jen prvních osm barev.'),
  ('level_color_mixer', '3'::jsonb, true,
   'Od kterého levelu jde míchat vlastní barvy. Nahrazuje dřívější nákup za kredity — dvě soustavy na jednu věc byly zbytečné.')
on conflict (key) do update set value = excluded.value, note = excluded.note;

-- ---------------------------------------------------------------------------
-- Výpočet levelu
-- ---------------------------------------------------------------------------

create or replace function private.lifetime_earned(p_user uuid)
returns integer
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  -- Jen kladné pohyby: utracené kredity level nesnižují.
  select coalesce(sum(delta) filter (where delta > 0), 0)::int
  from public.ledger where user_id = p_user;
$$;

create or replace function private.level_of(p_user uuid)
returns integer
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select coalesce((
    select count(*)::int
    from jsonb_array_elements_text(
      (select value from public.game_config where key = 'level_thresholds')
    ) as t(prah)
    where private.lifetime_earned(p_user) >= prah::int
  ), 1);
$$;

-- ---------------------------------------------------------------------------
-- Zpětný dopočet odměn
-- ---------------------------------------------------------------------------
--
-- Odměny se zapojily až 2026-08-20, takže 80 živých kreseb a 48 uhodnutých tipů
-- nikdy nic nevyneslo. Bez dopočtu by byli všichni na levelu 1 a zavedení levelů
-- by jim vzalo funkce, které dnes mají — což je horší než levely nemít.
--
-- `private.award` zapisuje přes unikátní index, takže se nic nezdvojí ani při
-- opakovaném spuštění.

do $$
declare
  r record;
  v_base  jsonb;
  v_bonus jsonb;
begin
  select value into v_base  from public.game_config where key = 'reward_draw_base';
  select value into v_bonus from public.game_config where key = 'reward_draw_bonus';

  for r in
    select d.id, d.author_id, d.solved_count, c.difficulty
    from public.drawings d
    join public.concepts c on c.id = d.concept_id
    where d.status in ('live', 'archived')
  loop
    perform private.award(r.author_id, (v_base -> r.difficulty::text)::int, 'draw_base', r.id);
    if r.solved_count > 0 then
      perform private.award(r.author_id, (v_bonus -> r.difficulty::text)::int, 'draw_bonus', r.id);
    end if;
  end loop;

  for r in
    select distinct g.user_id, g.drawing_id
    from public.guesses g where g.is_correct
  loop
    perform private.award(r.user_id, 1, 'guess_correct', r.drawing_id);
  end loop;
end;
$$;

-- ---------------------------------------------------------------------------
-- Co se NEGATUJE ani jako nejádrová funkce
-- ---------------------------------------------------------------------------
--
-- **Vyžádání pojmu zůstává od začátku.** Nabízelo se jako první kandidát na
-- zámek, ale `docs/plan.md` u bloku E říká: „Tohle nese hlavní hypotézu fáze 0.
-- Když se bude škrtat, škrtá se jinde." Zámek by poškodil měření retence
-- stejně jako zámek na hádání — a test to okamžitě odhalil.
--
-- Zbývají tedy jen kosmetické odemyky: velikost základní palety a míchání
-- vlastních barev. Ani jeden se nedotýká férovosti ani měření.

create or replace function private.require_level(p_key text)
returns void
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_need int;
begin
  select (value)::int into v_need from public.game_config where key = p_key;
  if private.level_of(auth.uid()) < coalesce(v_need, 1) then
    raise exception 'Tahle funkce se odemyká na levelu %.', v_need using errcode = '42501';
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- Nákup míchání barev se ruší — nahrazuje ho level
-- ---------------------------------------------------------------------------
--
-- Zavedeno tentýž den a hned nahrazeno: dvě soustavy na jednu věc (koupit ×
-- odemknout levelem) by si jen konkurovaly. Nikdo si ho nekoupil, takže se
-- nic neztrácí.

drop function if exists public.buy_color_mixer();
alter table public.profiles drop column if exists has_color_mixer;

-- ---------------------------------------------------------------------------
-- Profil vrací level a postup
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
  lifetime        integer,
  level           integer,
  next_level_at   integer
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
    private.lifetime_earned(p.id),
    private.level_of(p.id),
    -- Kolik celkem vydělaných chce další level. Null na stropu žebříčku.
    (select min(t.prah::int)
     from jsonb_array_elements_text(
       (select value from public.game_config where key = 'level_thresholds')
     ) as t(prah)
     where t.prah::int > private.lifetime_earned(p.id))
  from public.profiles p
  where p.id = auth.uid();
$$;

revoke execute on function public.my_profile() from public, anon;
grant execute on function public.my_profile() to authenticated, service_role;


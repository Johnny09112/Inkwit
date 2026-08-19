-- Inkwit — hádání (kroky D1, D2, D2b, D3)
--
-- Všechno přes RPC. Odpověď je tajemství, počty se musí udržet konzistentní
-- a limity drží databáze, ne prohlížeč.

-- ---------------------------------------------------------------------------
-- Počty na kresbě se udržují triggerem
-- ---------------------------------------------------------------------------
--
-- Kdyby je zvyšovala aplikace, rozejdou se při první chybě nebo souběhu.

create or replace function private.bump_guess_counts()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  update public.drawings
  set guess_count  = guess_count + 1,
      solved_count = solved_count + case when new.is_correct then 1 else 0 end
  where id = new.drawing_id;
  return new;
end;
$$;

create trigger guesses_bump_counts
  after insert on public.guesses
  for each row execute function private.bump_guess_counts();

create or replace function private.bump_thumb_counts()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if tg_op = 'INSERT' then
    update public.drawings set thumbs_count = thumbs_count + 1 where id = new.drawing_id;
  else
    update public.drawings set thumbs_count = greatest(0, thumbs_count - 1) where id = old.drawing_id;
  end if;
  return null;
end;
$$;

create trigger reactions_bump_counts
  after insert or delete on public.reactions
  for each row execute function private.bump_thumb_counts();

-- ---------------------------------------------------------------------------
-- D1 — kterou kresbu dostane hádač
-- ---------------------------------------------------------------------------
--
-- Ve fázi 0 jednoduše a férově: nejstarší neuhodnutá první. Bez trust score
-- a bez doporučování — obojí je nadstavba nad chováním, které se teprve ověřuje.

create or replace function public.next_drawing()
returns table (
  drawing_id    uuid,
  author_name   text,
  solved_count  integer,
  thumbs_count  integer,
  attempts_used integer,
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

-- ---------------------------------------------------------------------------
-- D2 + D2b — tip, vyhodnocení a nápověda
-- ---------------------------------------------------------------------------

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

-- ---------------------------------------------------------------------------
-- D3 — palec
-- ---------------------------------------------------------------------------
--
-- Jeden na uživatele a den CELKEM. Limit drží unikátní index nad sloupcem
-- `day`, tahle funkce z něj jen dělá srozumitelnou odpověď místo chyby.

create or replace function public.give_thumb(p_drawing_id uuid)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Palec může dát jen přihlášený uživatel.' using errcode = '28000';
  end if;

  if not private.can_view_drawing(p_drawing_id) then
    raise exception 'Tuhle kresbu hodnotit nemůžeš.' using errcode = '42501';
  end if;

  insert into public.reactions (drawing_id, user_id) values (p_drawing_id, v_user);
  return true;
exception
  when unique_violation then
    return false;   -- palec už dnes padl jinam, nebo právě téhle kresbě
end;
$$;

revoke execute on function public.next_drawing() from public, anon;
revoke execute on function public.submit_guess(uuid, text) from public, anon;
revoke execute on function public.give_thumb(uuid) from public, anon;
grant execute on function public.next_drawing() to authenticated, service_role;
grant execute on function public.submit_guess(uuid, text) to authenticated, service_role;
grant execute on function public.give_thumb(uuid) to authenticated, service_role;

-- Tipy i palce teď zakládá výhradně RPC, které umí vyhodnotit správnost
-- a udržet počty. Přímý zápis by obojí obešel.
drop policy guesses_insert_own on public.guesses;
drop policy reactions_insert_own on public.reactions;
revoke insert on public.guesses from anon, authenticated;
revoke insert on public.reactions from anon, authenticated;

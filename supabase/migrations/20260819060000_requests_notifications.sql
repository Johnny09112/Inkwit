-- Inkwit — vyžádání kresby a upozornění (blok E)
--
-- **Tohle nese hlavní hypotézu fáze 0.** Sdílenou sérii z Draw Something
-- nenahrazujeme jedna ku jedné; retenci má nést cizí akce nad tvojí kresbou
-- (viz `_claude/memory/decisions/retence-bez-sdilene-serie.md`).
--
-- Klíčové je, že upozornění jdou OBĚMA směry. Žadateli, že je hotovo, a
-- kreslíři, že splnil konkrétnímu člověku konkrétní přání. Druhá polovina je
-- ta, která nese retenci — bez ní je vyžádání jen fronta úkolů.

-- ---------------------------------------------------------------------------
-- Odkud přišel impuls ke kreslení
-- ---------------------------------------------------------------------------
--
-- `docs/data-model.md` to chce měřit: „odkud přišel impuls ke kreslení —
-- surge / vyžádání / vlastní iniciativa". Bez toho nejde říct, jestli
-- vyžádání vůbec funguje.

alter table public.drawings
  add column source text not null default 'own'
    check (source in ('own', 'request', 'surge'));

comment on column public.drawings.source is
  'Co člověka přimělo kreslit. Klíčové číslo fáze 0 — bez něj nejde vyhodnotit, '
  'jestli vyžádání kresby funguje jako retenční páka.';

-- ---------------------------------------------------------------------------
-- Upozornění
-- ---------------------------------------------------------------------------

create table public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles (id) on delete cascade,
  kind       text not null check (kind in ('guessed', 'thumbed', 'request_filled', 'request_served')),
  actor_id   uuid references public.profiles (id) on delete set null,
  drawing_id uuid references public.drawings (id) on delete cascade,
  concept_id uuid references public.concepts (id) on delete cascade,
  read_at    timestamptz,
  created_at timestamptz not null default now()
);

create index notifications_inbox_idx
  on public.notifications (user_id, created_at desc);

alter table public.notifications enable row level security;

-- Číst smí jen adresát; zakládají je triggery pod právy vlastníka.
create policy notifications_select_own on public.notifications
  for select to authenticated
  using (user_id = auth.uid());

create policy notifications_update_own on public.notifications
  for update to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

revoke insert, delete on public.notifications from anon, authenticated;
revoke update (user_id, kind, actor_id, drawing_id, concept_id, created_at)
  on public.notifications from authenticated;

-- ---------------------------------------------------------------------------
-- E4 — „tvoji kresbu někdo uhodl / dal jí palec"
-- ---------------------------------------------------------------------------
--
-- Rychlá emoční odměna autorovi je podle `docs/product.md` povinná. Tohle je
-- ta slabší polovina retenční mechaniky — silnější je vyžádání níž.

create or replace function private.notify_author()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_author uuid;
begin
  select author_id into v_author from public.drawings where id = new.drawing_id;
  if v_author is null or v_author = new.user_id then
    return null;   -- vlastní akce se neoznamuje
  end if;

  if tg_table_name = 'guesses' then
    if not new.is_correct then return null; end if;
    insert into public.notifications (user_id, kind, actor_id, drawing_id)
    values (v_author, 'guessed', new.user_id, new.drawing_id);
  else
    insert into public.notifications (user_id, kind, actor_id, drawing_id)
    values (v_author, 'thumbed', new.user_id, new.drawing_id);
  end if;

  return null;
end;
$$;

create trigger guesses_notify_author
  after insert on public.guesses
  for each row execute function private.notify_author();

create trigger reactions_notify_author
  after insert on public.reactions
  for each row execute function private.notify_author();

-- ---------------------------------------------------------------------------
-- E1 — vyžádání pojmu
-- ---------------------------------------------------------------------------

create or replace function public.request_concept(p_concept_id uuid)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user  uuid := auth.uid();
  v_limit int;
  v_ttl   int;
  v_today int;
begin
  if v_user is null then
    raise exception 'Vyžádat kresbu může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  select (value)::int into v_limit from public.game_config where key = 'requests_per_day';
  select (value)::int into v_ttl   from public.game_config where key = 'request_ttl_hours';

  select count(*) into v_today
  from public.concept_requests
  where requester_id = v_user
    and created_at >= (now() at time zone 'utc')::date;

  if v_today >= v_limit then
    return false;   -- denní limit; bez limitu je vyžádání spam kanál
  end if;

  insert into public.concept_requests (concept_id, requester_id, locale, expires_at)
  select p_concept_id, v_user, p.locale_primary, now() + make_interval(hours => v_ttl)
  from public.profiles p where p.id = v_user
  on conflict do nothing;

  return true;
end;
$$;

-- ---------------------------------------------------------------------------
-- E3 — splnění vyžádání, upozornění oběma směry
-- ---------------------------------------------------------------------------

create or replace function private.fulfil_requests(p_drawing_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_concept uuid;
  v_author  uuid;
  r         record;
begin
  select concept_id, author_id into v_concept, v_author
  from public.drawings where id = p_drawing_id;

  for r in
    select id, requester_id
    from public.concept_requests
    where concept_id = v_concept
      and status = 'open'
      and expires_at > now()
      and requester_id <> v_author
  loop
    update public.concept_requests
    set status = 'fulfilled', fulfilled_by = p_drawing_id
    where id = r.id;

    -- Žadateli: „pojem, na který jsi čekal, je nakreslený."
    insert into public.notifications (user_id, kind, actor_id, drawing_id, concept_id)
    values (r.requester_id, 'request_filled', v_author, p_drawing_id, v_concept);

    -- Kreslíři: „splnil jsi konkrétnímu člověku konkrétní přání."
    -- Tahle polovina nese retenci. Bez ní je vyžádání jen fronta úkolů.
    insert into public.notifications (user_id, kind, actor_id, drawing_id, concept_id)
    values (v_author, 'request_served', r.requester_id, p_drawing_id, v_concept);
  end loop;
end;
$$;

-- ---------------------------------------------------------------------------
-- Zapojení do toku kreslení
-- ---------------------------------------------------------------------------

create or replace function public.start_drawing(p_concept_id uuid)
returns uuid
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user   uuid := auth.uid();
  v_id     uuid;
  v_source text := 'own';
begin
  if v_user is null then
    raise exception 'Kreslit může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  if not exists (select 1 from public.concepts where id = p_concept_id and status = 'active') then
    raise exception 'Takový koncept neexistuje.' using errcode = '23503';
  end if;

  -- Impuls se zaznamenává při ZALOŽENÍ, ne při odeslání — jinak by ho přepsala
  -- žádost, která vznikla mezitím.
  if exists (
    select 1 from public.concept_requests
    where concept_id = p_concept_id and status = 'open' and expires_at > now()
      and requester_id <> v_user
  ) then
    v_source := 'request';
  end if;

  insert into public.drawings (author_id, concept_id, source_locale, tenant_id, status, source)
  select v_user, p_concept_id, p.locale_primary, p.tenant_id, 'draft', v_source
  from public.profiles p where p.id = v_user
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function private.on_drawing_live()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if new.status = 'live' and old.status is distinct from 'live' then
    perform private.fulfil_requests(new.id);
  end if;
  return null;
end;
$$;

create trigger drawings_fulfil_requests
  after update on public.drawings
  for each row execute function private.on_drawing_live();

revoke execute on function public.request_concept(uuid) from public, anon;
grant execute on function public.request_concept(uuid) to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Čtení upozornění
-- ---------------------------------------------------------------------------

create or replace function public.my_notifications()
returns table (
  id         uuid,
  kind       text,
  actor_name text,
  drawing_id uuid,
  prompt     text,
  read_at    timestamptz,
  created_at timestamptz
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    n.id,
    n.kind,
    a.display_name,
    n.drawing_id,
    cl.prompt,
    n.read_at,
    n.created_at
  from public.notifications n
  left join public.profiles a on a.id = n.actor_id
  join public.profiles me on me.id = n.user_id
  left join public.concept_locales cl
    on cl.concept_id = n.concept_id and cl.locale = me.locale_primary
  where n.user_id = auth.uid()
  order by n.created_at desc
  limit 50;
$$;

revoke execute on function public.my_notifications() from public, anon;
grant execute on function public.my_notifications() to authenticated, service_role;

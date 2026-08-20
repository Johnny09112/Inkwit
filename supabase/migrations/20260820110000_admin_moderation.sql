-- Inkwit — moderace pro admina (krok H2)
--
-- Všechny funkce tady mají stejný tvar: `security definer`, první řádek ověří
-- admina a jinak skončí. Práva se udělují roli `authenticated`, protože
-- kontrola je uvnitř — Supabase jinou roli pro přihlášeného člověka nemá.
--
-- **Školní tenant se vědomě nezahrnuje.** Pravidlo 1 ho tvrdě izoluje a admin,
-- který vidí napříč tenanty, by z toho udělal díru. Ve fázi 0 žádný školní
-- tenant neexistuje, takže to nic nestojí; až vznikne, bude to samostatné
-- rozhodnutí s vlastní obrazovkou, ne vedlejší efekt téhle migrace.

create or replace function private.require_admin()
returns void
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
begin
  if not private.is_admin() then
    raise exception 'Jen pro správce.' using errcode = '42501';
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- Fronta hlášení
-- ---------------------------------------------------------------------------

create or replace function public.admin_reports(p_status text default 'open')
returns table (
  report_id    uuid,
  drawing_id   uuid,
  prompt       text,
  reason       text,
  status       text,
  reporter     text,
  author       text,
  author_id    uuid,
  author_status text,
  drawing_status text,
  aspect       real,
  strokes      jsonb,
  created_at   timestamptz
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
begin
  perform private.require_admin();
  return query
    select
      r.id, d.id, cl.prompt, r.reason, r.status,
      rep.display_name, aut.display_name, aut.id, aut.status, d.status, d.aspect,
      coalesce((
        select jsonb_agg(jsonb_build_object(
                 'tool', s.tool, 'color', s.color, 'width', s.width, 'points', s.points)
               order by s.seq)
        from public.drawing_strokes s where s.drawing_id = d.id
      ), '[]'::jsonb),
      r.created_at
    from public.reports r
    join public.drawings d on d.id = r.drawing_id
    join public.profiles aut on aut.id = d.author_id
    join public.profiles rep on rep.id = r.reporter_id
    join public.concepts c on c.id = d.concept_id
    join public.concept_locales cl on cl.concept_id = c.id and cl.locale = d.source_locale
    where d.tenant_id is null
      and (p_status = 'all' or r.status = p_status)
    order by r.created_at;
end;
$$;

/** Uzavření hlášení. `resolved` = zásah proběhl, `dismissed` = planý poplach. */
create or replace function public.admin_resolve_report(p_report_id uuid, p_status text)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_rows int;
begin
  perform private.require_admin();

  if p_status not in ('resolved', 'dismissed') then
    raise exception 'Neznámý stav hlášení.' using errcode = '23514';
  end if;

  update public.reports
  set status = p_status, resolved_by = auth.uid()
  where id = p_report_id and status = 'open';

  get diagnostics v_rows = row_count;
  if v_rows > 0 then
    perform private.log_admin('report_' || p_status, 'report', p_report_id);
  end if;
  return v_rows > 0;
end;
$$;

-- ---------------------------------------------------------------------------
-- Kresby
-- ---------------------------------------------------------------------------

create or replace function public.admin_drawings(
  p_status text default 'live',
  p_limit  integer default 60,
  p_offset integer default 0
)
returns table (
  drawing_id   uuid,
  prompt       text,
  status       text,
  author       text,
  author_id    uuid,
  solved_count integer,
  guess_count  integer,
  thumbs_count integer,
  reports      integer,
  duration_ms  integer,
  stroke_count integer,
  aspect       real,
  strokes      jsonb,
  created_at   timestamptz
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
begin
  perform private.require_admin();
  return query
    select
      d.id, cl.prompt, d.status, p.display_name, p.id,
      d.solved_count, d.guess_count, d.thumbs_count,
      (select count(*)::int from public.reports r where r.drawing_id = d.id),
      d.duration_ms, d.stroke_count, d.aspect,
      coalesce((
        select jsonb_agg(jsonb_build_object(
                 'tool', s.tool, 'color', s.color, 'width', s.width, 'points', s.points)
               order by s.seq)
        from public.drawing_strokes s where s.drawing_id = d.id
      ), '[]'::jsonb),
      d.created_at
    from public.drawings d
    join public.profiles p on p.id = d.author_id
    join public.concepts c on c.id = d.concept_id
    join public.concept_locales cl on cl.concept_id = c.id and cl.locale = d.source_locale
    where d.tenant_id is null
      and (p_status = 'all' or d.status = p_status)
      and (p_status <> 'reported' or exists (select 1 from public.reports r where r.drawing_id = d.id))
    order by d.created_at desc
    limit greatest(1, least(p_limit, 200)) offset greatest(0, p_offset);
end;
$$;

/**
 * Skrytí a vrácení kresby. Měkké — `removed` kresbu vyřadí z nabídky i z
 * knihovny autora, ale cizí tipy a čísla zásoby zůstanou.
 */
create or replace function public.admin_set_drawing_status(p_drawing_id uuid, p_status text)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_rows int;
begin
  perform private.require_admin();

  if p_status not in ('live', 'removed', 'archived') then
    raise exception 'Neznámý stav kresby.' using errcode = '23514';
  end if;

  update public.drawings
  set status = p_status
  where id = p_drawing_id and status <> 'draft' and tenant_id is null;

  get diagnostics v_rows = row_count;
  if v_rows > 0 then
    perform private.log_admin('drawing_' || p_status, 'drawing', p_drawing_id);
  end if;
  return v_rows > 0;
end;
$$;

-- ---------------------------------------------------------------------------
-- Účty
-- ---------------------------------------------------------------------------

create or replace function public.admin_users()
returns table (
  user_id       uuid,
  display_name  text,
  status        text,
  is_admin      boolean,
  drawings      integer,
  guesses       integer,
  solved        integer,
  reports_against integer,
  trust_band    text,
  ban_reason    text,
  created_at    timestamptz
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
begin
  perform private.require_admin();
  return query
    select
      p.id, p.display_name, p.status, p.is_admin,
      (select count(*)::int from public.drawings d where d.author_id = p.id and d.status <> 'draft'),
      (select count(*)::int from public.guesses g where g.user_id = p.id),
      (select count(*)::int from public.guesses g where g.user_id = p.id and g.is_correct),
      (select count(*)::int from public.reports r
         join public.drawings d on d.id = r.drawing_id
        where d.author_id = p.id),
      (select t.trust_band from public.profile_trust t where t.user_id = p.id),
      p.ban_reason,
      p.created_at
    from public.profiles p
    where p.tenant_id is null
    order by p.created_at;
end;
$$;

/** Zablokování a odblokování. Admina zablokovat nejde — vyzamkl by se sám. */
create or replace function public.admin_set_user_status(
  p_user_id uuid, p_status text, p_reason text default null
)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_rows int;
begin
  perform private.require_admin();

  if p_status not in ('active', 'banned') then
    raise exception 'Neznámý stav účtu.' using errcode = '23514';
  end if;

  if p_status = 'banned' and coalesce((
       select p.is_admin from public.profiles p where p.id = p_user_id
     ), false) then
    raise exception 'Správce se zablokovat nedá.' using errcode = '42501';
  end if;

  update public.profiles
  set status     = p_status,
      banned_at  = case when p_status = 'banned' then now() else null end,
      ban_reason = case when p_status = 'banned' then left(coalesce(p_reason, ''), 300) else null end
  where id = p_user_id and tenant_id is null;

  get diagnostics v_rows = row_count;
  if v_rows > 0 then
    perform private.log_admin('user_' || p_status, 'user', p_user_id, p_reason);
  end if;
  return v_rows > 0;
end;
$$;

/** Posledních sto zásahů — kontrola sebe sama, ne statistika. */
create or replace function public.admin_log()
returns table (
  action      text,
  target_type text,
  target_id   uuid,
  note        text,
  admin_name  text,
  created_at  timestamptz
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
begin
  perform private.require_admin();
  return query
    select a.action, a.target_type, a.target_id, a.note, p.display_name, a.created_at
    from public.admin_actions a
    left join public.profiles p on p.id = a.admin_id
    order by a.created_at desc
    limit 100;
end;
$$;

revoke execute on function public.admin_reports(text) from public, anon;
revoke execute on function public.admin_resolve_report(uuid, text) from public, anon;
revoke execute on function public.admin_drawings(text, integer, integer) from public, anon;
revoke execute on function public.admin_set_drawing_status(uuid, text) from public, anon;
revoke execute on function public.admin_users() from public, anon;
revoke execute on function public.admin_set_user_status(uuid, text, text) from public, anon;
revoke execute on function public.admin_log() from public, anon;

grant execute on function public.admin_reports(text) to authenticated, service_role;
grant execute on function public.admin_resolve_report(uuid, text) to authenticated, service_role;
grant execute on function public.admin_drawings(text, integer, integer) to authenticated, service_role;
grant execute on function public.admin_set_drawing_status(uuid, text) to authenticated, service_role;
grant execute on function public.admin_users() to authenticated, service_role;
grant execute on function public.admin_set_user_status(uuid, text, text) to authenticated, service_role;
grant execute on function public.admin_log() to authenticated, service_role;

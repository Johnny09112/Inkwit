-- Inkwit — čísla pro admina (krok H3)
--
-- Pět pohledů `private.metrics_*` z kroku F3 existuje, ale jsou jen pro
-- `service_role` — prohlížeč se k nim nedostane a dostat nesmí. Tohle jsou
-- obálky pro admina: `security definer`, kontrola uvnitř.
--
-- Rozsah je vědomě malý. Nejsou to „dashboardy", ale čtyři čísla, na která se
-- majitel ptá: běží to · je co hádat · docházejí slova · čeká něco na zásah.

-- ---------------------------------------------------------------------------
-- Přehled
-- ---------------------------------------------------------------------------

create or replace function public.admin_overview()
returns table (
  obdobi          text,
  ucty            integer,
  kresby          integer,
  tipy            integer,
  uhodnute        integer,
  palce           integer,
  nova_hlaseni    integer
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
begin
  perform private.require_admin();
  return query
  with obdobi(nazev, od) as (
    values ('dnes', now() - interval '1 day'),
           ('7 dní', now() - interval '7 days'),
           ('celkem', timestamptz '-infinity')
  )
  select
    o.nazev,
    (select count(*)::int from public.profiles p where p.created_at >= o.od and p.tenant_id is null),
    (select count(*)::int from public.drawings d
      where d.published_at >= o.od and d.status <> 'draft' and d.tenant_id is null),
    (select count(*)::int from public.guesses g where g.created_at >= o.od),
    (select count(*)::int from public.guesses g where g.created_at >= o.od and g.is_correct),
    (select count(*)::int from public.reactions r where r.created_at >= o.od),
    (select count(*)::int from public.reports r where r.created_at >= o.od and r.status = 'open')
  from obdobi o;
end;
$$;

-- ---------------------------------------------------------------------------
-- Stav hry: zásoba k hádání a zásoba slov
-- ---------------------------------------------------------------------------
--
-- **Zásoba neuhodnutých kreseb je metrika 2 z `CLAUDE.md`** — když padá
-- k nule, produkt umírá. Zásoba slov je její příčina o patro výš: když dojdou
-- nenakreslené pojmy, nabídka začne opakovat a kreslíři ztratí důvod.

create or replace function public.admin_supply()
returns table (
  obtiznost          smallint,
  koncepty           integer,
  nakreslene         integer,
  nenakreslene       integer,
  kresby_ceka        integer
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
      c.difficulty,
      count(*)::int,
      count(*) filter (where exists (
        select 1 from public.drawings d
        where d.concept_id = c.id and d.status = 'live' and d.tenant_id is null))::int,
      count(*) filter (where not exists (
        select 1 from public.drawings d
        where d.concept_id = c.id and d.status = 'live' and d.tenant_id is null))::int,
      (select count(*)::int from public.drawings d
        join public.concepts c2 on c2.id = d.concept_id
       where d.status = 'live' and d.solved_count = 0
         and d.tenant_id is null and c2.difficulty = c.difficulty)
    from public.concepts c
    where c.status = 'active'
    group by c.difficulty
    order by c.difficulty;
end;
$$;

/**
 * Pojmy, které nikdo neuhodl. Není to seznam špatných kreslířů — je to seznam
 * podezřelých zadání a chybějících přijímaných tvarů. Právě tam se slovník
 * kalibruje.
 */
create or replace function public.admin_hard_concepts()
returns table (
  prompt      text,
  obtiznost   smallint,
  kresby      integer,
  tipy        integer,
  uhodnuti    integer
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
      cl.prompt, c.difficulty,
      count(distinct d.id)::int,
      coalesce(sum(d.guess_count), 0)::int,
      coalesce(sum(d.solved_count), 0)::int
    from public.concepts c
    join public.concept_locales cl on cl.concept_id = c.id and cl.locale = 'cs'
    join public.drawings d on d.concept_id = c.id and d.status = 'live' and d.tenant_id is null
    group by cl.prompt, c.difficulty
    having coalesce(sum(d.guess_count), 0) >= 3 and coalesce(sum(d.solved_count), 0) = 0
    order by coalesce(sum(d.guess_count), 0) desc
    limit 50;
end;
$$;

-- ---------------------------------------------------------------------------
-- Pět metrik z kroku F3, zpřístupněných adminovi
-- ---------------------------------------------------------------------------
--
-- Pohledy zůstávají v `private` a pro `service_role`; tohle je jen okno pro
-- admina. Vrací se jako `jsonb`, aby jeden export uměl všechny — jejich tvary
-- se liší a pět dalších funkcí by nic nepřidalo.

create or replace function public.admin_metrics(p_name text)
returns jsonb
language plpgsql
stable
security definer
set search_path = private, public, pg_temp
as $$
declare
  v_out jsonb;
begin
  perform private.require_admin();

  -- Jméno pohledu se NESKLÁDÁ do dotazu z parametru bez tohohle výčtu —
  -- jinak by to byla injektáž do `execute`.
  if p_name not in ('funnel', 'return', 'supply', 'effort', 'ab_playback') then
    raise exception 'Neznámá metrika.' using errcode = '23514';
  end if;

  execute format(
    'select coalesce(jsonb_agg(to_jsonb(x)), ''[]''::jsonb) from private.metrics_%I x',
    p_name
  ) into v_out;
  return v_out;
end;
$$;

revoke execute on function public.admin_overview() from public, anon;
revoke execute on function public.admin_supply() from public, anon;
revoke execute on function public.admin_hard_concepts() from public, anon;
revoke execute on function public.admin_metrics(text) from public, anon;

grant execute on function public.admin_overview() to authenticated, service_role;
grant execute on function public.admin_supply() to authenticated, service_role;
grant execute on function public.admin_hard_concepts() to authenticated, service_role;
grant execute on function public.admin_metrics(text) to authenticated, service_role;

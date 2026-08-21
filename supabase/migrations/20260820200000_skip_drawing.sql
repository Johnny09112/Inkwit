-- Inkwit — přeskočení kresby
--
-- ## Tlačítko „Přeskočit" dosud nedělalo NIC
--
-- Klient po klepnutí zavolal `next_drawing()` znovu. Jenže ta funkce vybírá
-- `order by d.solved_count, d.published_at limit 1` — **deterministicky** —
-- a vylučuje jen kresby, na které už člověk tipoval. Přeskočení nikde nic
-- nezapisovalo, takže druhé volání vrátilo **tutéž kresbu**.
--
-- Cena za přeskočení proto není jen ekonomika: bez záznamu by neměla co
-- omezovat, protože přeskočit stejně nešlo.
--
-- ## Co se zavádí
--
--   * `public.skips` — kdo co přeskočil. `next_drawing()` to od teď vylučuje,
--     takže se přeskočená kresba nevrátí.
--   * **První přeskočení za den zdarma, další za kredit.** Bez volného
--     přeskočení by nový hráč s nulou kreditů nemohl přeskočit vůbec — a kdo
--     nemůže dál, odejde. Obojí je v `game_config`, tedy laditelné bez
--     nasazení (pravidlo 6).
--   * Je to zároveň **první sink kreditů** (bod J4). Do teď zůstatek jen rostl.
--
-- ## Co cena NEUHLÍDÁ, a je fér to říct
--
-- `next_drawing()` vylučuje každou kresbu, na kterou člověk **jakkoli tipoval**.
-- Napsat nesmysl a odejít dál je tedy zadarmo a cena přeskočení to nezmění.
-- Rozdíl je v datech: nesmyslné tipy kazí obrazovku „Pojmy, které nikdo
-- neuhodl", ze které se kalibrují přijímané tvary. Kdyby se ukázalo, že to
-- lidé dělají, řeší se to tam — ne zdražením přeskočení.

create table if not exists public.skips (
  user_id    uuid not null references public.profiles (id) on delete cascade,
  drawing_id uuid not null references public.drawings (id) on delete cascade,
  cost       integer not null default 0 check (cost >= 0),
  created_at timestamptz not null default now(),
  primary key (user_id, drawing_id)
);

-- Denní volné přeskočení se počítá dotazem přes tenhle index.
create index if not exists skips_user_day_idx on public.skips (user_id, created_at desc);

alter table public.skips enable row level security;
revoke all on public.skips from anon, authenticated;

comment on table public.skips is
  'Kdo kterou kresbu přeskočil. next_drawing() je vylučuje. Zapisuje jen public.skip_drawing().';

insert into public.game_config (key, value, is_public, note) values
  ('skip_free_per_day', '1'::jsonb, true,
   'Kolik přeskočení denně je zdarma. Bez volného přeskočení by hráč s nulou kreditů nemohl dál.'),
  ('skip_cost', '1'::jsonb, true,
   'Kolik stojí přeskočení nad denní volný počet. První sink kreditů (bod J4 v docs/plan.md).')
on conflict (key) do update set value = excluded.value, note = excluded.note;

-- ---------------------------------------------------------------------------
-- Přeskočení
-- ---------------------------------------------------------------------------

create or replace function public.skip_drawing(p_drawing_id uuid)
returns integer
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user  uuid := auth.uid();
  v_free  int;
  v_cost  int;
  v_dnes  int;
  v_uctuj int;
begin
  if v_user is null then
    raise exception 'Přeskočit může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  if not exists (
    select 1 from public.drawings d
    where d.id = p_drawing_id and d.status = 'live' and d.author_id <> v_user
  ) then
    raise exception 'Takovou kresbu nelze přeskočit.' using errcode = '23503';
  end if;

  -- Opakované přeskočení téže kresby je bez účinku a hlavně bez ceny.
  -- Bez tohohle by dvojklik nebo obnovení stránky stálo dvakrát.
  if exists (select 1 from public.skips s
             where s.user_id = v_user and s.drawing_id = p_drawing_id) then
    return 0;
  end if;

  select (value)::int into v_free from public.game_config where key = 'skip_free_per_day';
  select (value)::int into v_cost from public.game_config where key = 'skip_cost';

  -- Den se počítá v UTC, stejně jako všechny ostatní časy v projektu.
  -- Bez explicitní zóny by hranice dne záležela na nastavení session.
  select count(*)::int into v_dnes
  from public.skips s
  where s.user_id = v_user
    and s.created_at >= date_trunc('day', (now() at time zone 'UTC')) at time zone 'UTC';

  v_uctuj := case when v_dnes < coalesce(v_free, 1) then 0 else coalesce(v_cost, 1) end;

  if v_uctuj > 0 and private.balance(v_user) < v_uctuj then
    -- Vlastní kód, ať klient pozná „nemáš kredity" od ostatních selhání
    -- a může říct něco užitečnějšího než „nepovedlo se".
    raise exception 'Na přeskočení nemáš dost kreditů.' using errcode = '55000';
  end if;

  insert into public.skips (user_id, drawing_id, cost)
  values (v_user, p_drawing_id, v_uctuj);

  if v_uctuj > 0 then
    perform private.award(v_user, -v_uctuj, 'skip', p_drawing_id);
  end if;

  return v_uctuj;
end;
$$;

revoke execute on function public.skip_drawing(uuid) from public, anon;
grant execute on function public.skip_drawing(uuid) to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Kolik bude stát PŘÍŠTÍ přeskočení
-- ---------------------------------------------------------------------------
--
-- Tlačítko musí cenu říct dopředu. Strhnout kredit a oznámit to až potom je
-- přesně ten druh překvapení, kvůli kterému lidé přestanou tlačítkům věřit.

create or replace function public.skip_price()
returns integer
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select case
    when (
      select count(*) from public.skips s
      where s.user_id = auth.uid()
        and s.created_at >= date_trunc('day', (now() at time zone 'UTC')) at time zone 'UTC'
    ) < coalesce((select (value)::int from public.game_config where key = 'skip_free_per_day'), 1)
    then 0
    else coalesce((select (value)::int from public.game_config where key = 'skip_cost'), 1)
  end;
$$;

revoke execute on function public.skip_price() from public, anon;
grant execute on function public.skip_price() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Nabídka k hádání přeskočené kresby vynechá
-- ---------------------------------------------------------------------------
--
-- Proti verzi z `20260820100000_admin_role.sql` přibyla jediná podmínka.
-- Zbytek je shodný.

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
  join public.profiles a on a.id = d.author_id
  where d.status = 'live'
    and d.author_id <> v_user                      -- vlastní kresbu si nehádáš
    and a.status <> 'banned'                       -- kresby zablokovaných nekolují
    and (
      (d.tenant_id is null and v_tenant is null)   -- veřejná hra
      or d.tenant_id = v_tenant                    -- tenant, nikdy přes hranici
    )
    and not exists (
      select 1 from public.guesses g
      where g.drawing_id = d.id and g.user_id = v_user
    )
    and not exists (
      select 1 from public.skips s
      where s.drawing_id = d.id and s.user_id = v_user
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

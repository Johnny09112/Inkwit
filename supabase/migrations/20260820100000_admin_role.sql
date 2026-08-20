-- Inkwit — role admina, blokování účtů a záznam zásahů (krok H1)
--
-- Do teď nebylo v datech nic, co by majitele odlišilo od hráče: všechno stojí
-- na `auth.uid()` a RLS. Hlášení se ukládala do `public.reports`, ale nic je
-- nečetlo — v okamžiku psaní téhle migrace tam leží tři otevřená.
--
-- **Proč to obrací dřívější rozhodnutí.** `docs/plan.md` u kroku F3 říká, že
-- fáze 0 administrátorské rozhraní nemá, protože pět dotazů ve studiu je
-- levnější. Platilo to, dokud šlo jen o čtení čísel. Neplatí pro moderaci:
-- nahlášení je akce uživatele, na kterou musí někdo odpovědět, a fronta,
-- kterou nikdo nevidí, je totéž jako žádná.

-- ---------------------------------------------------------------------------
-- Role a stav účtu
-- ---------------------------------------------------------------------------
--
-- Oba sloupce jsou chráněné tím, že `UPDATE` na `profiles` je udělený jen na
-- vyjmenované sloupce (viz migrace 20260819080000). Nový sloupec tedy uživatel
-- měnit nemůže, dokud se GRANT výslovně nerozšíří — a ten se rozšiřovat nesmí.
-- Hlídá to test.

alter table public.profiles
  add column if not exists is_admin boolean not null default false,
  add column if not exists status text not null default 'active'
    check (status in ('active', 'banned')),
  add column if not exists banned_at timestamptz,
  add column if not exists ban_reason text;

comment on column public.profiles.is_admin is
  'Nastavuje se JEN ručně v SQL. Nikdy k tomu nedělat RPC ani rozšiřovat GRANT '
  'na UPDATE — kdo si nastaví tenhle příznak, dostane fronty hlášení i bany.';

/** Je přihlášený admin? Bez SECURITY DEFINER by na to nedosáhl přes RLS. */
create or replace function private.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select coalesce((select p.is_admin from public.profiles p where p.id = auth.uid()), false);
$$;

create or replace function private.is_banned(p_user uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select coalesce((select p.status = 'banned' from public.profiles p where p.id = p_user), false);
$$;

-- ---------------------------------------------------------------------------
-- Vynucení banu v databázi, ne v aplikaci
-- ---------------------------------------------------------------------------
--
-- Kontrola se **nepíše do jednotlivých RPC**. Bylo by jich pět a šestá,
-- dopsaná za půl roku, by se na ni zapomněla. Trigger na zápisu drží ban i pro
-- kód, který o něm neví.

create or replace function private.reject_if_banned()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if private.is_banned(auth.uid()) then
    raise exception 'Účet je zablokovaný.' using errcode = '42501';
  end if;
  return new;
end;
$$;

drop trigger if exists drawings_reject_banned on public.drawings;
create trigger drawings_reject_banned
  before insert on public.drawings
  for each row execute function private.reject_if_banned();

drop trigger if exists guesses_reject_banned on public.guesses;
create trigger guesses_reject_banned
  before insert on public.guesses
  for each row execute function private.reject_if_banned();

drop trigger if exists reactions_reject_banned on public.reactions;
create trigger reactions_reject_banned
  before insert on public.reactions
  for each row execute function private.reject_if_banned();

drop trigger if exists concept_requests_reject_banned on public.concept_requests;
create trigger concept_requests_reject_banned
  before insert on public.concept_requests
  for each row execute function private.reject_if_banned();

-- ---------------------------------------------------------------------------
-- Kresby zablokovaného se přestanou nabízet
-- ---------------------------------------------------------------------------
--
-- Ban bez tohohle by nechal jeho kresby dál kolovat. Jinak je funkce shodná
-- s předchozí verzí — přibyla jediná podmínka.

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

-- ---------------------------------------------------------------------------
-- Záznam zásahů
-- ---------------------------------------------------------------------------
--
-- Při jednom majiteli to vypadá zbytečně. Ale ban bez stopy je věc, které se
-- za rok nedá věřit: nepůjde zjistit, kdo koho zablokoval a proč.

create table if not exists public.admin_actions (
  id          uuid primary key default gen_random_uuid(),
  admin_id    uuid not null references public.profiles (id) on delete set null,
  action      text not null,
  target_type text not null check (target_type in ('drawing', 'user', 'report')),
  target_id   uuid not null,
  note        text,
  created_at  timestamptz not null default now()
);

create index if not exists admin_actions_recent_idx on public.admin_actions (created_at desc);

alter table public.admin_actions enable row level security;
-- Žádná politika: čte se jen přes SECURITY DEFINER funkce pro admina.
revoke all on public.admin_actions from anon, authenticated;

create or replace function private.log_admin(
  p_action text, p_target_type text, p_target_id uuid, p_note text default null
)
returns void
language sql
volatile
security definer
set search_path = public, pg_temp
as $$
  insert into public.admin_actions (admin_id, action, target_type, target_id, note)
  values (auth.uid(), p_action, p_target_type, p_target_id, p_note);
$$;

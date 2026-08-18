-- Inkwit — základní schéma (krok A2)
--
-- Konvence: tabulky a sloupce snake_case, časy timestamptz v UTC.
-- Výčty jako text + CHECK, ne enum — enum se špatně mění a hodnoty jsou v docs/data-model.md.
--
-- RLS se zapíná v samostatné migraci (20260818190100_rls.sql). Tahle migrace
-- vytváří jen struktury; nic tu není přístupné, dokud nedoběhne ta druhá.

-- ---------------------------------------------------------------------------
-- Pomocné funkce
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Slovní zásoba: koncepty, ne překlady (neporušitelné pravidlo 4)
-- ---------------------------------------------------------------------------

create table public.concepts (
  id                uuid primary key default gen_random_uuid(),
  difficulty        smallint not null check (difficulty between 1 and 3),
  category          text not null,
  is_cross_language boolean not null default true,
  is_school_safe    boolean not null default false,  -- opt-in, ne opt-out
  status            text not null default 'active' check (status in ('active', 'retired')),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index concepts_pick_idx
  on public.concepts (status, difficulty)
  where status = 'active';

create trigger concepts_set_updated_at
  before update on public.concepts
  for each row execute function public.set_updated_at();

-- Co se ukáže kreslíři. Klient tohle NIKDY nečte přímo — viz komentář u RLS.
create table public.concept_locales (
  concept_id  uuid not null references public.concepts (id) on delete cascade,
  locale      text not null check (locale in ('cs', 'en')),
  prompt      text not null,
  hint        text,
  primary key (concept_id, locale)
);

-- Přijímané odpovědi. Oddělené od concept_locales záměrně: je to tajemství hry.
-- Kdo tohle přečte, má odpovědi na všechno.
create table public.concept_answers (
  concept_id  uuid not null references public.concepts (id) on delete cascade,
  locale      text not null check (locale in ('cs', 'en')),
  accepted    text[] not null check (array_length(accepted, 1) >= 1),
  primary key (concept_id, locale),
  foreign key (concept_id, locale)
    references public.concept_locales (concept_id, locale) on delete cascade
);

-- ---------------------------------------------------------------------------
-- Uživatel
-- ---------------------------------------------------------------------------

create table public.profiles (
  id              uuid primary key references auth.users (id) on delete cascade,
  display_name    text not null,
  locale_primary  text not null default 'cs' check (locale_primary in ('cs', 'en')),
  locale_guessing text[] not null default array['cs']::text[],
  level           integer not null default 1 check (level >= 1),
  xp              integer not null default 0 check (xp >= 0),
  skill_rating    real not null default 0,
  is_minor        boolean not null default false,
  tenant_id       uuid,                       -- FK se doplní níž (kruhová závislost)
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Trust score v samostatné tabulce, ne ve sloupcích profiles.
--
-- Pravidlo 7 říká, že se uživateli nikdy nezobrazuje. data-model.md navrhoval
-- "vystavit jen serveru přes RLS" — jenže RLS je řádková, ne sloupcová: nedokáže
-- skrýt sloupec v řádku, který uživatel jinak vidět smí. Column-level GRANT by to
-- uměl, ale pak klientu selže i obyčejný `select *`. Oddělená tabulka bez jediné
-- politiky je jediná varianta, kde se to nedá omylem odkrýt.
create table public.profile_trust (
  user_id     uuid primary key references public.profiles (id) on delete cascade,
  reliability real not null default 0.5 check (reliability between 0 and 1),
  trust_band  text not null default 'new' check (trust_band in ('new', 'verified', 'trusted')),
  updated_at  timestamptz not null default now()
);

create trigger profile_trust_set_updated_at
  before update on public.profile_trust
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- Tenanty (školy a firmy)
-- ---------------------------------------------------------------------------

create table public.tenants (
  id         uuid primary key default gen_random_uuid(),
  kind       text not null check (kind in ('school', 'company')),
  name       text not null,
  owner_id   uuid not null references public.profiles (id),
  plan       text not null default 'free' check (plan in ('free', 'paid', 'partner')),
  join_code  text not null unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger tenants_set_updated_at
  before update on public.tenants
  for each row execute function public.set_updated_at();

alter table public.profiles
  add constraint profiles_tenant_id_fkey
  foreign key (tenant_id) references public.tenants (id) on delete set null;

create index profiles_tenant_idx on public.profiles (tenant_id) where tenant_id is not null;

-- Tenant přihlášeného uživatele. SECURITY DEFINER, aby čtení profiles uvnitř
-- politik nad profiles nespustilo rekurzi RLS.
create or replace function public.current_tenant_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select tenant_id from public.profiles where id = auth.uid();
$$;

-- ---------------------------------------------------------------------------
-- Kresba a tahy (neporušitelné pravidlo 2)
-- ---------------------------------------------------------------------------

create table public.drawings (
  id            uuid primary key default gen_random_uuid(),
  author_id     uuid not null references public.profiles (id) on delete cascade,
  concept_id    uuid not null references public.concepts (id),
  source_locale text not null check (source_locale in ('cs', 'en')),
  tenant_id     uuid references public.tenants (id) on delete cascade, -- NULL = veřejná hra
  status        text not null default 'draft'
                check (status in ('draft', 'pending_review', 'live', 'archived', 'removed')),
  device_kind   text check (device_kind in ('mouse', 'touch', 'pen', 'unknown')),
  duration_ms   integer check (duration_ms >= 0),
  stroke_count  integer not null default 0 check (stroke_count >= 0),
  undo_count    integer not null default 0 check (undo_count >= 0),
  coverage      real check (coverage between 0 and 1),
  effort_score  real,
  guess_count   integer not null default 0 check (guess_count >= 0),
  solved_count  integer not null default 0 check (solved_count >= 0),
  thumbs_count  integer not null default 0 check (thumbs_count >= 0),
  created_at    timestamptz not null default now(),
  published_at  timestamptz,
  updated_at    timestamptz not null default now()
);

-- Distribuce: nejstarší neuhodnuté ve veřejné hře napřed (krok D1).
create index drawings_public_feed_idx
  on public.drawings (published_at)
  where status = 'live' and tenant_id is null;

create index drawings_tenant_feed_idx
  on public.drawings (tenant_id, published_at)
  where status = 'live' and tenant_id is not null;

create index drawings_author_idx on public.drawings (author_id, created_at desc);
create index drawings_concept_idx on public.drawings (concept_id);

create trigger drawings_set_updated_at
  before update on public.drawings
  for each row execute function public.set_updated_at();

-- Tahy jako vektory. NIKDY bitmapa (pravidlo 2).
--
-- points je PLOCHÉ pole [x,y,t, x,y,t, …], ne pole objektů:
--   x, y  souřadnice normalizované 0–1, zaokrouhlené na 4 desetinná místa
--   t     ms od začátku tahu
-- Ploché pole je na disku ~1,7× menší, protože jeden tah leží kolem prahu,
-- od kterého teprve začne TOAST komprimovat. Měření viz
-- _claude/memory/decisions/kodovani-bodu-tahu.md.
--
-- Tlak pera se neukládá záměrně — uniformní štětec kvůli férovosti zařízení.
create table public.drawing_strokes (
  drawing_id uuid not null references public.drawings (id) on delete cascade,
  seq        integer not null check (seq >= 0),
  author_id  uuid not null references public.profiles (id),  -- nutné pro atribuci v relay režimu
  tool       text not null check (tool in ('pen', 'brush', 'eraser')),
  color      text not null,
  width      real not null check (width > 0),
  points     jsonb not null
             check (jsonb_typeof(points) = 'array'
                    and jsonb_array_length(points) > 0
                    and jsonb_array_length(points) % 3 = 0),
  primary key (drawing_id, seq)
);

-- ---------------------------------------------------------------------------
-- Hádání a hodnocení
-- ---------------------------------------------------------------------------

create table public.guesses (
  id         uuid primary key default gen_random_uuid(),
  drawing_id uuid not null references public.drawings (id) on delete cascade,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  locale     text not null check (locale in ('cs', 'en')),
  attempt_no smallint not null check (attempt_no between 1 and 3),  -- čtvrtý pokus neexistuje
  text_raw   text not null,
  is_correct boolean not null default false,
  created_at timestamptz not null default now(),
  unique (drawing_id, user_id, attempt_no)
);

create index guesses_drawing_idx on public.guesses (drawing_id);
create index guesses_user_idx on public.guesses (user_id, created_at desc);

-- Palec: jeden na uživatele a den CELKEM, ne na kresbu. Vzácný hlas, ne lajk.
--
-- Denní limit se vynucuje unikátním indexem nad sloupcem `day`. Nejde použít
-- výraz nad created_at, protože `at time zone` je STABLE, ne IMMUTABLE, a do
-- indexu se nedostane. Sloupec s defaultem to řeší a limit drží databáze,
-- ne aplikace.
create table public.reactions (
  drawing_id uuid not null references public.drawings (id) on delete cascade,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  kind       text not null default 'thumb' check (kind in ('thumb')),
  day        date not null default (now() at time zone 'utc')::date,
  created_at timestamptz not null default now(),
  primary key (drawing_id, user_id)
);

create unique index reactions_one_per_day_idx on public.reactions (user_id, day);

create table public.reports (
  id          uuid primary key default gen_random_uuid(),
  drawing_id  uuid not null references public.drawings (id) on delete cascade,
  reporter_id uuid not null references public.profiles (id) on delete cascade,
  reason      text not null,
  status      text not null default 'open' check (status in ('open', 'resolved', 'dismissed')),
  resolved_by uuid references public.profiles (id),
  created_at  timestamptz not null default now(),
  unique (drawing_id, reporter_id)
);

create index reports_open_idx on public.reports (created_at) where status = 'open';

-- ---------------------------------------------------------------------------
-- Vyžádání kresby — nese retenční hypotézu fáze 0
-- ---------------------------------------------------------------------------

create table public.concept_requests (
  id           uuid primary key default gen_random_uuid(),
  concept_id   uuid not null references public.concepts (id) on delete cascade,
  requester_id uuid not null references public.profiles (id) on delete cascade,
  locale       text not null check (locale in ('cs', 'en')),
  status       text not null default 'open' check (status in ('open', 'fulfilled', 'expired')),
  fulfilled_by uuid references public.drawings (id) on delete set null,
  created_at   timestamptz not null default now(),
  expires_at   timestamptz not null,   -- povinné: otevřené žádosti se musí uklidit samy
  check (status <> 'fulfilled' or fulfilled_by is not null)
);

-- Jeden člověk nemá otevřenou dvě žádosti na tentýž koncept.
create unique index concept_requests_open_unique_idx
  on public.concept_requests (concept_id, requester_id)
  where status = 'open';

-- Prioritizace nabídky konceptů kreslíři (krok E2).
create index concept_requests_open_idx
  on public.concept_requests (concept_id, created_at)
  where status = 'open';

-- ---------------------------------------------------------------------------
-- Ekonomika a konfigurace (neporušitelné pravidlo 6)
-- ---------------------------------------------------------------------------

-- Odměny, prahy, surge, rate limity. NIKDY konstanty v kódu.
--
-- is_public rozhoduje, jestli klíč smí přečíst klient. Prahy trust score jsou
-- podle pravidla 7 neveřejné, odměny a limity zobrazované v UI veřejné být musí.
create table public.game_config (
  key        text primary key,
  value      jsonb not null,
  is_public  boolean not null default false,
  note       text,
  updated_at timestamptz not null default now()
);

create trigger game_config_set_updated_at
  before update on public.game_config
  for each row execute function public.set_updated_at();

-- Append-only. Body a kredity se nikdy nepřepisují, jen přičítá záznam —
-- jinak nedohledáš, kde se rozbil balanc. Vynuceno odebráním práv v RLS migraci.
create table public.ledger (
  id         bigint generated always as identity primary key,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  delta      integer not null,
  reason     text not null,
  ref_id     uuid,
  created_at timestamptz not null default now()
);

create index ledger_user_idx on public.ledger (user_id, created_at desc);

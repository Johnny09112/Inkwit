-- Inkwit — přihlášení pozvánkou (krok A5)
--
-- Fáze 0 je uzavřená skupina ~50 pozvaných, bez veřejné registrace. Není to
-- provozní detail, ale podmínka: automatická kontrola obsahu je až fáze 1,
-- takže veřejná hra by porušila neporušitelné pravidlo 8.
--
-- Vynucuje to trigger nad `auth.users`, ne aplikace. Kdo obejde přihlašovací
-- obrazovku a zavolá signup API přímo, narazí na tentýž zákaz.

-- ---------------------------------------------------------------------------
-- Pozvánky
-- ---------------------------------------------------------------------------

create table public.invites (
  code       text primary key,
  note       text,                    -- komu je určená, ať se to dá dohledat
  tenant_id  uuid references public.tenants (id) on delete cascade,
  max_uses   integer not null default 1 check (max_uses >= 1),
  used_count integer not null default 0 check (used_count >= 0),
  expires_at timestamptz,
  revoked_at timestamptz,
  created_at timestamptz not null default now(),
  check (used_count <= max_uses)
);

-- `tenant_id` je tu kvůli fázi 2: studentský účet nemá e-mail a vzniká přes kód
-- od učitele. Sloupec stojí nic a doplnit ho zpětně by znamenalo měnit zakládání
-- účtů, tedy nejcitlivější místo celého schématu.

comment on column public.invites.tenant_id is
  'NULL = pozvánka do veřejné hry. Vyplněné = účet rovnou vzniká uvnitř tenanta '
  '(fáze 2, žák nemá e-mail a vstupuje kódem od učitele).';

create table public.invite_redemptions (
  code        text not null references public.invites (code) on delete cascade,
  user_id     uuid not null references public.profiles (id) on delete cascade,
  redeemed_at timestamptz not null default now(),
  primary key (code, user_id)
);

alter table public.invites            enable row level security;
alter table public.invite_redemptions enable row level security;

-- Klient nesmí kódy číst ani vyjmenovávat — jinak si je zkusí uhodnout hromadně.
-- Ověření běží uvnitř triggeru, ne dotazem z prohlížeče.
revoke all on public.invites            from anon, authenticated;
revoke all on public.invite_redemptions from anon, authenticated;

-- ---------------------------------------------------------------------------
-- Generátor kódů
-- ---------------------------------------------------------------------------
--
-- Abeceda bez znaků, které si lidé pletou (0/O, 1/I/L). Kód se čte do telefonu.

create or replace function private.new_invite_code()
returns text
language sql
volatile
set search_path = public, pg_temp
as $$
  select 'INK-' || string_agg(
    substr('ABCDEFGHJKMNPQRSTUVWXYZ23456789',
           (floor(random() * 31) + 1)::int, 1), '')
  from generate_series(1, 6);
$$;

-- ---------------------------------------------------------------------------
-- Vynucení pozvánky při vzniku účtu
-- ---------------------------------------------------------------------------

create or replace function private.enforce_invite()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_required boolean;
  v_code     text;
  v_invite   public.invites%rowtype;
begin
  -- Únikový východ pro majitele (pravidlo 6: konfigurace, ne konstanta v kódu).
  -- Vypnout jen vědomě a na chvíli — s vypnutým se hra stává veřejnou.
  select coalesce((value)::boolean, true) into v_required
  from public.game_config where key = 'signup_requires_invite';

  if v_required is distinct from true then
    return new;
  end if;

  v_code := upper(trim(new.raw_user_meta_data ->> 'invite_code'));

  if v_code is null or v_code = '' then
    raise exception 'Registrace je jen na pozvánku.'
      using errcode = 'check_violation';
  end if;

  -- FOR UPDATE, aby dvě současné registrace nepřečerpaly max_uses.
  select * into v_invite from public.invites
  where code = v_code
  for update;

  if not found
     or v_invite.revoked_at is not null
     or (v_invite.expires_at is not null and v_invite.expires_at < now())
     or v_invite.used_count >= v_invite.max_uses then
    raise exception 'Pozvánka neplatí.'
      using errcode = 'check_violation';
  end if;

  update public.invites
  set used_count = used_count + 1
  where code = v_code;

  return new;
end;
$$;

create trigger on_auth_user_check_invite
  before insert on auth.users
  for each row execute function private.enforce_invite();

-- ---------------------------------------------------------------------------
-- Zakládání profilu — doplněno o tenant z pozvánky a o záznam o uplatnění
-- ---------------------------------------------------------------------------

create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_code   text;
  v_tenant uuid;
begin
  v_code := upper(trim(new.raw_user_meta_data ->> 'invite_code'));

  if v_code is not null and v_code <> '' then
    select tenant_id into v_tenant from public.invites where code = v_code;
  end if;

  insert into public.profiles (id, display_name, locale_primary, tenant_id)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'display_name', ''), 'Kreslíř'),
    coalesce(nullif(new.raw_user_meta_data ->> 'locale', ''), 'cs'),
    v_tenant
  );

  insert into public.profile_trust (user_id) values (new.id);

  if v_code is not null and v_code <> '' then
    insert into public.invite_redemptions (code, user_id)
    values (v_code, new.id)
    on conflict do nothing;
  end if;

  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Konfigurace
-- ---------------------------------------------------------------------------

insert into public.game_config (key, value, is_public, note) values
  ('signup_requires_invite', 'true'::jsonb, false,
   'Fáze 0 je uzavřená skupina (pravidlo 8 — klasifikátor obsahu je až fáze 1). '
   'Vypnutím se hra stává veřejnou; nedělat, dokud neběží automatická kontrola obsahu.')
on conflict (key) do nothing;

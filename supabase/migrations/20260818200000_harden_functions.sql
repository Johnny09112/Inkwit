-- Inkwit — doladění po security advisoru (krok A3)
--
-- Advisor po nasazení schématu nahlásil, že pomocné funkce se SECURITY DEFINER
-- jdou zavolat kýmkoliv přes /rest/v1/rpc/…. Není to určené jako API — jsou to
-- stavební kameny politik.
--
-- POZOR na první nápad, který nefunguje: prosté `revoke execute` je rozbije.
-- Výrazy v RLS politikách se vyhodnocují **právy dotazujícího se uživatele**,
-- ne vlastníka tabulky. Když roli `authenticated` odebereš EXECUTE, přestane
-- projít i politika, která funkci volá — a uživatel neuvidí nic. Ověřeno
-- testem, který na to spadl.
--
-- Správné řešení: přesunout funkce do schématu, které PostgREST nevystavuje.
-- Práva zůstanou, ale přes REST se na ně nedá dosáhnout.

create schema if not exists private;

-- USAGE ano (politiky funkce volají), ale nic víc.
grant usage on schema private to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Přesun pomocných funkcí do private
-- ---------------------------------------------------------------------------

create or replace function private.current_tenant_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select tenant_id from public.profiles where id = auth.uid();
$$;

create or replace function private.can_view_drawing(d_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.drawings d
    where d.id = d_id
      and (
        d.author_id = auth.uid()
        or (
          d.status = 'live'
          and (
            (d.tenant_id is null and private.current_tenant_id() is null)
            or d.tenant_id = private.current_tenant_id()
          )
        )
      )
  );
$$;

grant execute on function private.current_tenant_id()    to authenticated, service_role;
grant execute on function private.can_view_drawing(uuid) to authenticated, service_role;

-- Zakládání profilu při vzniku uživatele. Trigger, ne API.
create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into public.profiles (id, display_name, locale_primary)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'display_name', ''), 'Kreslíř'),
    coalesce(nullif(new.raw_user_meta_data ->> 'locale', ''), 'cs')
  );

  insert into public.profile_trust (user_id) values (new.id);

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function private.handle_new_user();

-- ---------------------------------------------------------------------------
-- Přepojení politik na private.*
-- ---------------------------------------------------------------------------

drop policy profiles_select_same_space on public.profiles;
create policy profiles_select_same_space on public.profiles
  for select to authenticated
  using (
    id = auth.uid()
    or tenant_id is not distinct from private.current_tenant_id()
  );

drop policy tenants_select_own on public.tenants;
create policy tenants_select_own on public.tenants
  for select to authenticated
  using (id = private.current_tenant_id() or owner_id = auth.uid());

drop policy drawings_insert_own on public.drawings;
create policy drawings_insert_own on public.drawings
  for insert to authenticated
  with check (
    author_id = auth.uid()
    and status = 'draft'
    and tenant_id is not distinct from private.current_tenant_id()
  );

drop policy strokes_select_visible on public.drawing_strokes;
create policy strokes_select_visible on public.drawing_strokes
  for select to authenticated
  using (private.can_view_drawing(drawing_id));

drop policy guesses_insert_own on public.guesses;
create policy guesses_insert_own on public.guesses
  for insert to authenticated
  with check (
    user_id = auth.uid()
    and is_correct = false
    and private.can_view_drawing(drawing_id)
  );

drop policy reactions_insert_own on public.reactions;
create policy reactions_insert_own on public.reactions
  for insert to authenticated
  with check (user_id = auth.uid() and private.can_view_drawing(drawing_id));

drop policy reports_insert_own on public.reports;
create policy reports_insert_own on public.reports
  for insert to authenticated
  with check (reporter_id = auth.uid() and private.can_view_drawing(drawing_id));

-- Pohled taky, jinak by držel odkaz na starou funkci.
drop view public.feed_drawings;
create view public.feed_drawings
with (security_invoker = false) as
  select
    d.id,
    d.author_id,
    p.display_name as author_name,
    d.source_locale,
    d.device_kind,
    d.guess_count,
    d.solved_count,
    d.thumbs_count,
    d.published_at
  from public.drawings d
  join public.profiles p on p.id = d.author_id
  where d.status = 'live'
    and (
      (d.tenant_id is null and private.current_tenant_id() is null)
      or d.tenant_id = private.current_tenant_id()
    );

revoke all on public.feed_drawings from anon;
grant select on public.feed_drawings to authenticated;

comment on view public.feed_drawings is
  'Feed cizích kreseb. SECURITY DEFINER záměrně — musí obejít RLS nad drawings, '
  'jinak by nikdy nic nevrátil. Bezpečnostní hranicí je WHERE a seznam sloupců. '
  'NIKDY sem nepřidávat concept_id ani signály detekce čmáranic. '
  'Hlídá to test v supabase/tests/rls.test.mjs.';

-- Staré veřejné verze už nikdo nepotřebuje.
drop function public.can_view_drawing(uuid);
drop function public.current_tenant_id();
drop function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Pevný search_path u triggerové funkce
-- ---------------------------------------------------------------------------
--
-- Bez něj může volající podstrčit vlastní schéma dřív v cestě a změnit tím,
-- co funkce doopravdy zavolá. EXECUTE se tady neodebírá — triggerové funkce
-- volá trigger, ne uživatel, ale odebrání práv by nic nezískalo a mohlo
-- překvapit.

alter function public.set_updated_at() set search_path = public, pg_temp;

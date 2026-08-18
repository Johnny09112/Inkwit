-- Inkwit — unikátní jméno v profilu
--
-- Jméno se ukazuje u kresby, v žebříčku a u vyžádání („Marek si vyžádal…"),
-- takže musí jednoznačně ukazovat na člověka. Dvě Jany v žebříčku jsou chyba,
-- ne detail.
--
-- Volí si ho uživatel při zakládání účtu. Unikátnost drží databáze — kontrola
-- v aplikaci by v závodě dvou současných registrací selhala.

-- ---------------------------------------------------------------------------
-- Tvar jména
-- ---------------------------------------------------------------------------
--
-- Diakritika povolená (je to česky cílený produkt), vícenásobné mezery ne,
-- okrajové mezery ne — jinak by šlo obsadit „Jana " vedle „Jana" a lidé by
-- si je nikdy nerozlišili.

alter table public.profiles
  add constraint profiles_display_name_shape check (
    char_length(display_name) between 3 and 24
    and display_name = btrim(display_name)
    and display_name !~ '\s\s'
    and display_name !~ '[[:cntrl:]]'
  );

-- Bez ohledu na velikost písmen: „jana" a „Jana" je tentýž člověk.
create unique index profiles_display_name_unique_idx
  on public.profiles (lower(display_name));

-- ---------------------------------------------------------------------------
-- Je jméno volné?
-- ---------------------------------------------------------------------------
--
-- Tohle je jediná pomocná funkce, která ve `public` být MÁ — klient ji volá
-- schválně, aby se člověk dozvěděl obsazené jméno dřív než po odeslání.
--
-- SECURITY DEFINER je potřeba: politika nad `profiles` ukazuje jen lidi ze
-- stejného prostoru, takže bez ní by jméno obsazené ve školním tenantu
-- vypadalo jako volné a registrace by pak spadla.
--
-- Vyzrazuje to existenci jména, ale jména jsou stejně veřejná — visí
-- v žebříčku i u kreseb.

create or replace function public.display_name_available(p_name text)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select not exists (
    select 1 from public.profiles
    where lower(display_name) = lower(btrim(p_name))
  );
$$;

grant execute on function public.display_name_available(text) to anon, authenticated;

-- ---------------------------------------------------------------------------
-- Zakládání účtu se jménem
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
  v_name   text;
begin
  v_code := upper(trim(new.raw_user_meta_data ->> 'invite_code'));

  if v_code is not null and v_code <> '' then
    select tenant_id into v_tenant from public.invites where code = v_code;
  end if;

  v_name := btrim(coalesce(new.raw_user_meta_data ->> 'display_name', ''));

  -- Účet založený mimo přihlašovací obrazovku (ručně majitelem) jméno nemá.
  -- Náhrada musí projít stejnou kontrolou tvaru i unikátnosti jako zvolené jméno.
  if v_name = '' then
    v_name := 'Kreslíř ' || upper(substr(replace(new.id::text, '-', ''), 1, 6));
  end if;

  insert into public.profiles (id, display_name, locale_primary, tenant_id)
  values (
    new.id,
    v_name,
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

comment on function private.handle_new_user() is
  'Zakládá profil při vzniku účtu. Když je jméno obsazené, unikátní index '
  'vyhodí 23505, celá registrace se odroluje a pozvánka se NEspotřebuje — '
  'trigger i vložení do auth.users jsou jedna transakce.';

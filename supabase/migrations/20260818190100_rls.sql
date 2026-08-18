-- Inkwit — RLS a přístupová práva (krok A3)
--
-- Vynucuje se tady, ne v aplikaci. Aplikační kontrola se dá obejít chybou, RLS ne.
--
-- Dvě věci, které nejsou samozřejmé a plynou z pravidel hry, ne z bezpečnosti:
--
--   1. Text konceptu je TAJEMSTVÍ. Kdo přečte `concept_locales.prompt` nebo
--      `concept_answers.accepted`, má odpovědi na všechno. Proto k nim klient
--      nemá přístup vůbec a kreslíř dostává svoje tři koncepty ze serveru.
--
--   2. `drawings.concept_id` je taky tajemství. RLS je řádková a sloupec skrýt
--      neumí, takže klient nečte tabulku `drawings` napřímo — feed jde přes
--      pohled `feed_drawings`, který concept_id neobsahuje. Bez toho by hádající
--      spároval dvě kresby stejného konceptu a druhou měl zadarmo.

-- ---------------------------------------------------------------------------
-- Pomocné funkce viditelnosti
-- ---------------------------------------------------------------------------

-- Smí přihlášený uživatel vidět tuhle kresbu? SECURITY DEFINER, aby se politiky
-- nad drawing_strokes nezacyklily s politikami nad drawings.
create or replace function public.can_view_drawing(d_id uuid)
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
            -- veřejná hra: kresba bez tenanta jen pro uživatele bez tenanta
            (d.tenant_id is null and public.current_tenant_id() is null)
            -- tenant: jen vlastní tenant, nikdy ven ani dovnitř (pravidlo 1)
            or d.tenant_id = public.current_tenant_id()
          )
        )
      )
  );
$$;

-- ---------------------------------------------------------------------------
-- Zapnout RLS všude
-- ---------------------------------------------------------------------------

alter table public.concepts         enable row level security;
alter table public.concept_locales  enable row level security;
alter table public.concept_answers  enable row level security;
alter table public.profiles         enable row level security;
alter table public.profile_trust    enable row level security;
alter table public.tenants          enable row level security;
alter table public.drawings         enable row level security;
alter table public.drawing_strokes  enable row level security;
alter table public.guesses          enable row level security;
alter table public.reactions        enable row level security;
alter table public.reports          enable row level security;
alter table public.concept_requests enable row level security;
alter table public.game_config      enable row level security;
alter table public.ledger           enable row level security;

-- ---------------------------------------------------------------------------
-- Tabulky, ke kterým klient nemá přístup vůbec
-- ---------------------------------------------------------------------------
--
-- Supabase přiděluje nově vzniklým tabulkám v public práva pro anon
-- a authenticated automaticky. Zapnutá RLS bez politik by je sice zastavila,
-- ale spoléhat se na jednu vrstvu je málo — proto se práva ještě odebírají.
-- Server jede přes service_role, který RLS obchází.

revoke all on public.concepts        from anon, authenticated;
revoke all on public.concept_locales from anon, authenticated;
revoke all on public.concept_answers from anon, authenticated;
revoke all on public.profile_trust   from anon, authenticated;

-- Žádné politiky = default deny. Je to záměr, ne opomenutí.

-- ---------------------------------------------------------------------------
-- profiles — vlastní profil a lidé ve stejném prostoru
-- ---------------------------------------------------------------------------

create policy profiles_select_same_space on public.profiles
  for select to authenticated
  using (
    id = auth.uid()
    or tenant_id is not distinct from public.current_tenant_id()
  );

create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

-- Tenanta si uživatel sám nepřepíše — vstup do tenanta jde přes join_code na serveru.
revoke update (tenant_id, level, xp, skill_rating, is_minor) on public.profiles
  from authenticated;

-- ---------------------------------------------------------------------------
-- tenants — jen ten vlastní
-- ---------------------------------------------------------------------------

create policy tenants_select_own on public.tenants
  for select to authenticated
  using (id = public.current_tenant_id() or owner_id = auth.uid());

-- ---------------------------------------------------------------------------
-- drawings — napřímo jen vlastní; cizí kresby výhradně přes feed_drawings
-- ---------------------------------------------------------------------------

create policy drawings_select_own on public.drawings
  for select to authenticated
  using (author_id = auth.uid());

create policy drawings_insert_own on public.drawings
  for insert to authenticated
  with check (
    author_id = auth.uid()
    and status = 'draft'
    and tenant_id is not distinct from public.current_tenant_id()
  );

-- Rozepsanou kresbu smí autor měnit, odeslanou už ne. Přechod do 'live'
-- dělá server po kontrole obsahu (pravidlo 8), ne klient.
create policy drawings_update_own_draft on public.drawings
  for update to authenticated
  using (author_id = auth.uid() and status = 'draft')
  with check (author_id = auth.uid() and status in ('draft', 'pending_review'));

revoke update (
  guess_count, solved_count, thumbs_count, effort_score, published_at, tenant_id
) on public.drawings from authenticated;

-- Feed. Bezpečnostní hranicí je WHERE v tomhle pohledu, protože běží s právy
-- vlastníka a RLS nad drawings tím pádem obchází. Každá změna tady je změna
-- bezpečnosti — číst opatrně.
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
      (d.tenant_id is null and public.current_tenant_id() is null)
      or d.tenant_id = public.current_tenant_id()
    );

-- Vědomě chybí: concept_id (odpověď), duration_ms, stroke_count, undo_count,
-- coverage, effort_score (signály detekce čmáranic — uživateli se neukazují).

revoke all on public.feed_drawings from anon;
grant select on public.feed_drawings to authenticated;

-- ---------------------------------------------------------------------------
-- drawing_strokes — vidí je ten, kdo smí vidět kresbu
-- ---------------------------------------------------------------------------

create policy strokes_select_visible on public.drawing_strokes
  for select to authenticated
  using (public.can_view_drawing(drawing_id));

create policy strokes_insert_own on public.drawing_strokes
  for insert to authenticated
  with check (
    author_id = auth.uid()
    and exists (
      select 1 from public.drawings d
      where d.id = drawing_id
        and d.author_id = auth.uid()
        and d.status = 'draft'
    )
  );

-- ---------------------------------------------------------------------------
-- guesses — vlastní tipy a nic víc
-- ---------------------------------------------------------------------------
--
-- Cizí tipy se číst nesmí: byl by to seznam nápověd. `is_correct` navíc plní
-- server, klient si výsledek neurčuje sám.

create policy guesses_select_own on public.guesses
  for select to authenticated
  using (user_id = auth.uid());

create policy guesses_insert_own on public.guesses
  for insert to authenticated
  with check (
    user_id = auth.uid()
    and is_correct = false
    and public.can_view_drawing(drawing_id)
  );

revoke update, delete on public.guesses from anon, authenticated;

-- ---------------------------------------------------------------------------
-- reactions — palec, jeden na den (index to drží nezávisle na politice)
-- ---------------------------------------------------------------------------

create policy reactions_select_own on public.reactions
  for select to authenticated
  using (user_id = auth.uid());

create policy reactions_insert_own on public.reactions
  for insert to authenticated
  with check (user_id = auth.uid() and public.can_view_drawing(drawing_id));

revoke update on public.reactions from anon, authenticated;

-- Palec zpět vzít lze; denní limit tím ale neobejdeš, `day` zůstává obsazený
-- jen do konce dne a nový záznam téhož dne narazí na unikátní index.
create policy reactions_delete_own on public.reactions
  for delete to authenticated
  using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- reports — nahlásit smí každý, vidí jen svoje
-- ---------------------------------------------------------------------------

create policy reports_select_own on public.reports
  for select to authenticated
  using (reporter_id = auth.uid());

create policy reports_insert_own on public.reports
  for insert to authenticated
  with check (reporter_id = auth.uid() and public.can_view_drawing(drawing_id));

revoke update, delete on public.reports from anon, authenticated;

-- ---------------------------------------------------------------------------
-- concept_requests — jen vlastní žádosti
-- ---------------------------------------------------------------------------
--
-- Cizí žádosti klient nečte. Nabídku „Marek čeká na trapas" skládá server —
-- klient by stejně neuměl concept_id přeložit na název, protože koncepty nečte.

create policy requests_select_own on public.concept_requests
  for select to authenticated
  using (requester_id = auth.uid());

create policy requests_insert_own on public.concept_requests
  for insert to authenticated
  with check (requester_id = auth.uid() and status = 'open');

create policy requests_delete_own on public.concept_requests
  for delete to authenticated
  using (requester_id = auth.uid() and status = 'open');

revoke update on public.concept_requests from anon, authenticated;

-- ---------------------------------------------------------------------------
-- game_config — jen veřejné klíče
-- ---------------------------------------------------------------------------
--
-- Prahy trust score se nezveřejňují (pravidlo 7), odměny zobrazené v UI ano.

create policy game_config_select_public on public.game_config
  for select to authenticated
  using (is_public);

revoke insert, update, delete on public.game_config from anon, authenticated;

-- ---------------------------------------------------------------------------
-- ledger — append-only, a to i pro server
-- ---------------------------------------------------------------------------

create policy ledger_select_own on public.ledger
  for select to authenticated
  using (user_id = auth.uid());

revoke insert, update, delete on public.ledger from anon, authenticated;

-- Přepis historie zablokovaný na úrovni tabulky, takže ani service_role
-- nepřepíše záznam omylem. Balanc se opravuje protizápisem, ne editací.
create rule ledger_no_update as on update to public.ledger do instead nothing;
create rule ledger_no_delete as on delete to public.ledger do instead nothing;

-- ---------------------------------------------------------------------------
-- Založení profilu při vzniku uživatele
-- ---------------------------------------------------------------------------
--
-- profile_trust musí vzniknout spolu s profilem, jinak by uživatel existoval
-- bez trust záznamu a server by musel řešit NULL větev na každém kroku.

create or replace function public.handle_new_user()
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

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

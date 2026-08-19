-- Inkwit — provoz a měření (blok F)
--
-- **Bez tohohle je celá fáze 0 k ničemu.** Ověřuje se jediná hypotéza —
-- budou lidé dobrovolně kreslit? — a bez čísel se nedá odpovědět.

-- ---------------------------------------------------------------------------
-- F4 — dvě skupiny pro test přehrání
-- ---------------------------------------------------------------------------
--
-- Jedna vidí u hádání tlačítko „přehrát", druhá ne. Přiřazení je náhodné při
-- vzniku účtu a **neměnné** — kdyby se skupina losovala při každém načtení,
-- neměřilo by se nic.

alter table public.profiles
  add column ab_playback boolean not null default true;

comment on column public.profiles.ab_playback is
  'Vidí tenhle uživatel tlačítko přehrání? Skupina se přiřazuje jednou při '
  'vzniku účtu a nemění se. Vyhodnocení: docs/roadmap.md, vedlejší měření fáze 0.';

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

  if v_name = '' then
    v_name := 'Kreslíř ' || upper(substr(replace(new.id::text, '-', ''), 1, 6));
  end if;

  insert into public.profiles (id, display_name, locale_primary, tenant_id, ab_playback)
  values (
    new.id,
    v_name,
    coalesce(nullif(new.raw_user_meta_data ->> 'locale', ''), 'cs'),
    v_tenant,
    random() < 0.5
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

-- Uživatel si svoji skupinu nepřepíše.
revoke update (ab_playback) on public.profiles from authenticated;

-- ---------------------------------------------------------------------------
-- Co o sobě uživatel potřebuje vědět
-- ---------------------------------------------------------------------------

create or replace function public.my_profile()
returns table (
  display_name text,
  locale       text,
  ab_playback  boolean,
  drawings     integer,
  guesses      integer,
  unread       integer
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    p.display_name,
    p.locale_primary,
    p.ab_playback,
    (select count(*)::int from public.drawings d where d.author_id = p.id and d.status <> 'removed'),
    (select count(*)::int from public.guesses g where g.user_id = p.id),
    (select count(*)::int from public.notifications n where n.user_id = p.id and n.read_at is null)
  from public.profiles p
  where p.id = auth.uid();
$$;

revoke execute on function public.my_profile() from public, anon;
grant execute on function public.my_profile() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- F1 — nahlášení
-- ---------------------------------------------------------------------------
--
-- Fáze 0 nemá automatický klasifikátor, proto je uzavřená (pravidlo 8).
-- Nahlášení řeší majitel ručně — na padesát pozvaných to stačí.

create or replace function public.report_drawing(p_drawing_id uuid, p_reason text)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Nahlásit může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  if not private.can_view_drawing(p_drawing_id) then
    raise exception 'Tuhle kresbu nahlásit nemůžeš.' using errcode = '42501';
  end if;

  insert into public.reports (drawing_id, reporter_id, reason)
  values (p_drawing_id, v_user, coalesce(nullif(btrim(p_reason), ''), 'nevhodný obsah'))
  on conflict (drawing_id, reporter_id) do nothing;

  return true;
end;
$$;

revoke execute on function public.report_drawing(uuid, text) from public, anon;
grant execute on function public.report_drawing(uuid, text) to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- F2 — denní žebříček
-- ---------------------------------------------------------------------------
--
-- Fáze 0 má jeden žebříček, ne tři. Ligy, odznaky a oddělené metriky jsou
-- nadstavba nad chováním, které se teprve ověřuje.

create or replace function public.daily_leaderboard()
returns table (
  rank         integer,
  display_name text,
  score        integer,
  is_you       boolean
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  with me as (select tenant_id from public.profiles where id = auth.uid()),
  scores as (
    select
      p.id,
      p.display_name,
      count(*) filter (where g.is_correct)::int as score
    from public.guesses g
    join public.profiles p on p.id = g.user_id
    where g.created_at >= (now() at time zone 'utc')::date
      and p.tenant_id is not distinct from (select tenant_id from me)
    group by p.id, p.display_name
  )
  select
    (row_number() over (order by score desc, display_name))::int,
    display_name,
    score,
    id = auth.uid()
  from scores
  order by score desc, display_name
  limit 30;   -- ligy po ~30 hráčích, viz docs/product.md
$$;

revoke execute on function public.daily_leaderboard() from public, anon;
grant execute on function public.daily_leaderboard() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- F3 — metriky pro majitele
-- ---------------------------------------------------------------------------
--
-- Pohledy jsou přístupné jen ze serveru (service_role). Fáze 0 nemá
-- administrátorské rozhraní — majitel je čte z Supabase studia, což je
-- levnější než ho stavět.

-- Zásoba: kolik živých kreseb ještě nikdo neuhodl. Metrika 2 z CLAUDE.md —
-- „když padá k nule, produkt umírá".
create view private.metrics_supply as
  select
    count(*) filter (where solved_count = 0)::int  as neuhodnutych,
    count(*)::int                                  as zivych,
    (select count(distinct user_id)::int from public.guesses
      where created_at >= now() - interval '7 days') as aktivnich_hadacu
  from public.drawings
  where status = 'live';

-- Drop-off v kreslení: kolik lidí plátno otevřelo a kolik odeslalo.
-- Klíčové číslo — proto je kreslení dvoukrokové.
create view private.metrics_funnel as
  select
    date_trunc('day', created_at)                              as den,
    count(*)::int                                              as zalozeno,
    count(*) filter (where status <> 'draft')::int             as odeslano,
    round(100.0 * count(*) filter (where status <> 'draft') / nullif(count(*), 0), 1) as procent,
    count(*) filter (where source = 'request')::int            as z_vyzadani,
    count(*) filter (where source = 'own')::int                as z_vlastni_vule
  from public.drawings
  group by 1 order by 1 desc;

-- Rozdělení doby kreslení a počtu tahů — z toho se kalibruje detekce čmáranic.
create view private.metrics_effort as
  select
    percentile_cont(0.1) within group (order by duration_ms)::int  as doba_p10,
    percentile_cont(0.5) within group (order by duration_ms)::int  as doba_median,
    percentile_cont(0.9) within group (order by duration_ms)::int  as doba_p90,
    percentile_cont(0.1) within group (order by stroke_count)::int as tahu_p10,
    percentile_cont(0.5) within group (order by stroke_count)::int as tahu_median,
    round(avg(coverage)::numeric, 3)                                as pokryti_prumer
  from public.drawings
  where status <> 'draft';

-- Návrat druhý den ke KRESLENÍ — kritérium postupu z fáze 0 (≥ 20 %).
create view private.metrics_return as
  with prvni as (
    select author_id, min(created_at::date) as den1 from public.drawings group by 1
  )
  select
    count(*)::int                                                  as kreslicich,
    count(*) filter (where exists (
      select 1 from public.drawings d
      where d.author_id = prvni.author_id
        and d.created_at::date = prvni.den1 + 1
    ))::int                                                        as vratilo_se_druhy_den
  from prvni;

-- Vedlejší měření: pomáhá tlačítko přehrání?
create view private.metrics_ab_playback as
  select
    p.ab_playback                                                  as ma_prehrani,
    count(distinct p.id)::int                                      as lidi,
    count(g.*)::int                                                as tipu,
    count(g.*) filter (where g.is_correct)::int                    as uhodnuto
  from public.profiles p
  left join public.guesses g on g.user_id = p.id
  group by 1;

comment on view private.metrics_supply is
  'Metriky fáze 0. Číst ze Supabase studia: select * from private.metrics_supply;';

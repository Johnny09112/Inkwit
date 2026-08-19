-- Inkwit — oprava: odebrání práv na sloupce nikdy nefungovalo
--
-- V migraci 20260818190100 stálo:
--
--   revoke update (tenant_id, level, xp, skill_rating, is_minor)
--     on public.profiles from authenticated;
--
-- **Nedělalo to nic.** Postgres má práva aditivní: kdo má UPDATE na celou
-- tabulku, má ho i na každý sloupec, a odebrání sloupcového práva, které nikdy
-- samostatně udělené nebylo, nemá co odebrat. Supabase přitom uděluje práva
-- na tabulku automaticky.
--
-- Dopad byl vážnější, než se zdá:
--
--   * `tenant_id` — uživatel se mohl **sám přesunout do školního tenantu**,
--     nebo z něj ven. To je přímé porušení neporušitelného pravidla 1, které
--     má izolaci škol držet na úrovni databáze.
--   * `level`, `xp`, `skill_rating` — kdokoli si mohl nastavit skóre.
--   * `is_minor` — příznak nezletilosti si mohl přepsat sám.
--
-- Nalezeno 2026-08-19 testem u nového sloupce `ab_playback`. Starší sloupce
-- test neměly, takže díra vydržela od prvního dne.
--
-- **Správný postup:** odebrat UPDATE na tabulce a udělit ho jen na sloupcích,
-- které uživatel měnit smí.

revoke update on public.profiles from anon, authenticated;
grant update (display_name, locale_primary, locale_guessing)
  on public.profiles to authenticated;

comment on table public.profiles is
  'POZOR na práva: UPDATE je udělený jen na vyjmenované sloupce. '
  'Nikdy nepsat "revoke update (sloupec)" — když má role právo na tabulku, '
  'nemá to co odebrat. Přidání sloupce, který má uživatel měnit, znamená '
  'rozšířit GRANT, ne odebírat.';

-- Stejná past u ostatních tabulek, kde se odebíraly sloupce.
revoke update on public.drawings from anon, authenticated;
-- Kresbu klient nemění vůbec — všechno jde přes RPC, které si počítá vlastní
-- čísla. Politika drawings_update_own_draft tím pádem nemá co povolit.
drop policy drawings_update_own_draft on public.drawings;

revoke update on public.notifications from anon, authenticated;
grant update (read_at) on public.notifications to authenticated;

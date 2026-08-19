---
name: revoke-na-sloupec-nefunguje
description: revoke update (sloupec) nedělá nic, když má role právo na celou tabulku — uživatel si mohl přepsat tenant_id a obejít izolaci školního tenantu
type: bug
status: resolved
created: 2026-08-19
updated: 2026-08-19
related: [tajemstvi-hry-v-schematu]
---

# Odebrání práva na sloupec nikdy nefungovalo

**Nalezeno 2026-08-19**, chyba byla ve schématu od prvního dne (migrace
20260818190100).

## Co bylo napsané

```sql
revoke update (tenant_id, level, xp, skill_rating, is_minor)
  on public.profiles from authenticated;
```

## Proč to nedělalo nic

**Práva v Postgresu jsou aditivní.** Kdo má `UPDATE` na celou tabulku, má ho
i na každý sloupec. Odebrání sloupcového práva, které nikdy samostatně udělené
nebylo, nemá co odebrat — příkaz projde bez chyby a nic nezmění. Supabase
přitom uděluje práva na tabulku novým tabulkám automaticky.

## Dopad

- **`tenant_id`** — uživatel se mohl sám přesunout do školního tenantu nebo
  z něj ven. To je přímé porušení **neporušitelného pravidla 1**, jehož celý
  smysl je, že izolaci drží databáze, ne aplikace.
- `level`, `xp`, `skill_rating` — kdokoli si mohl nastavit skóre.
- `is_minor` — příznak nezletilosti si mohl přepsat sám.

## Oprava

```sql
revoke update on public.profiles from anon, authenticated;
grant update (display_name, locale_primary, locale_guessing)
  on public.profiles to authenticated;
```

Tedy **odebrat na tabulce a udělit na sloupcích**, ne naopak.

## Proč to vydrželo tak dlouho

Testy kontrolovaly, co uživatel **vidí**, ne co může **zapsat**. Odhalilo se to
až u nového sloupce `ab_playback`, kde jsem si zápis otestoval — a zjistil, že
projde. Starší sloupce takový test neměly.

**Pravidlo pro příště: u každého sloupce, který uživatel měnit nesmí, musí být
test, že zápis neprojde.** Doplněno pro `tenant_id`, `xp`, `skill_rating`,
`is_minor` i `ab_playback`.

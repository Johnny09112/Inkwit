---
name: tajemstvi-hry-v-schematu
description: Text konceptu a drawings.concept_id jsou tajemství hry — klient je nečte vůbec; RLS je řádková, takže se tajné sloupce oddělují do vlastních tabulek a feed jde přes pohled
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
related: [supabase-free-plan-a-region]
---

# Co je v Inkwitu tajemství a jak se to drží

Vzniklo při psaní schématu (krok A2/A3) 2026-08-18. `docs/data-model.md` tohle
neřešil a bez toho by hra nefungovala — nešlo o bezpečnost, ale o pravidla hry.

## Tři tajemství

1. **`concept_locales.prompt`** je odpověď. Kdo přečte zadání, uhodne.
2. **`concept_answers.accepted`** je seznam všech přijímaných odpovědí. Kdo tohle
   přečte, má odpovědi na celou hru.
3. **`drawings.concept_id`** je taky odpověď, jen nepřímo: hádající spáruje dvě
   kresby stejného konceptu a druhou má zadarmo.

Důsledek: `concepts`, `concept_locales` i `concept_answers` jsou pro klienta
**zavřené úplně** (žádná politika + odebraná práva). Kreslíř dostává svoje tři
koncepty ze serveru, ne dotazem do tabulky.

## Proč se tajné sloupce oddělily do vlastních tabulek

**RLS je řádková, ne sloupcová.** Neumí skrýt sloupec v řádku, který uživatel
jinak vidět smí. Původní návrh v `data-model.md` říkal u `reliability`
a `trust_band` „přes RLS vystav jen serveru" — to technicky nejde.

Column-level `GRANT` by to uměl, ale má ošklivý vedlejšek: klientu pak selže
i obyčejné `select *`, což se ladí mizerně. Proto:

- `profile_trust` (reliability, trust_band) — oddělená tabulka, nula politik
- `concept_answers` (accepted) — oddělená od `concept_locales`

Tabulka bez jediné politiky je default deny. Nedá se to omylem odkrýt tím,
že někdo přidá sloupec.

## Feed jde přes pohled, ne přes tabulku

`drawings` klient čte jen svoje vlastní. Cizí kresby vidí přes pohled
`public.feed_drawings`, který **záměrně neobsahuje** `concept_id` ani signály
detekce čmáranic (`duration_ms`, `stroke_count`, `undo_count`, `coverage`,
`effort_score` — ty se uživateli neukazují).

**Pozor při úpravách:** pohled běží s právy vlastníka (`security_invoker = false`),
takže RLS nad `drawings` obchází. **Bezpečnostní hranicí je `WHERE` uvnitř toho
pohledu.** Kdo ho bude měnit, mění bezpečnost — ne jen výběr sloupců.

## Co drží databáze místo aplikace

Ověřeno testem `supabase/tests/rls.test.mjs` (22 kontrol, `npm run test:db`):
čtvrtý pokus o uhodnutí, druhý palec téhož dne, `is_correct` nastavené klientem,
tah přidaný k cizí kresbě, přepis `ledger` (i ze serveru — přes `do instead nothing`)
a izolace školního tenantu oběma směry.

**Denní limit palce** se drží unikátním indexem nad sloupcem `day` s defaultem.
Výraz nad `created_at` použít nešlo: `at time zone` je STABLE, ne IMMUTABLE,
a do indexu se nedostane.

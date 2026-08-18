# Inkwit

Asynchronní kreslicí a hádací hra. Web-first (PWA), dvojjazyčná CZ + EN od prvního dne.

> Pracovní název. Repozitář, DB a balíčky = `inkwit`. Branding a doména se řeší až před spuštěním.

Nakreslíš zadaný pojem, tvoje kresba jde do komunity a lidé ji hádají na tři pokusy ve svém
jazyce — nad hotovým obrázkem. Po uhodnutí si můžou přehrát, jak kresba vznikala, tah po tahu,
a sdílet to jako GIF. Není to real-time lobby hra ani hra pro dvojici — je to asynchronní
komunita kolem kreseb, které **zůstávají**.

## Stav

**Před fází 0.** Repo zatím obsahuje jen produktovou dokumentaci — žádný kód, žádné migrace.
Živý stav projektu je v `_claude/memory/context/project-context.md`.

## Kde je co

| Soubor | Obsah |
|---|---|
| `CLAUDE.md` | Závazná pravidla pro práci v repu — stack, konvence, **osm neporušitelných pravidel** |
| `docs/product.md` | Herní smyčka, bodování, trust score, moderace, anti-čmáranice, relay režim |
| `docs/data-model.md` | Schéma Postgres/Supabase, koncepty a jazykové varianty, stavy kresby, RLS |
| `docs/roadmap.md` | Rozsah MVP, fáze 0–3, monetizace, ekonomika, otevřené otázky |
| `docs/design-system.md` | Barevná paleta „Oves a oliva“, fonty, kontrastní pravidla (úvodní návrh) |
| `_claude/` | Dlouhodobá paměť projektu (rozhodnutí, patterny, bugy, živý kontext) |
| `licenses/` | Licence a atribuce použitých písem (SIL OFL 1.1) |

**Než začneš cokoli navrhovat, přečti neporušitelná pravidla v `CLAUDE.md`.**
Jsou to omezení architektury, ne featury — retrofit některých z nich znamená přepis datového modelu.

## Stack

Next.js (App Router) + TypeScript, PWA · Supabase (Postgres, Auth, Storage, Realtime) s RLS všude ·
Vercel · Stripe na webu (ne IAP) · `next-intl` nebo ekvivalent.

## Paměť

Projekt má dlouhodobou paměť v `_claude/`, verzovanou gitem. Index se generuje hookem
`.claude/hooks/reindex.js` na startu session. Ruční přegenerování:

```bash
node .claude/hooks/reindex.js
```

Pravidla paměti: `_claude/policies.md` (invarianty) a `_claude/BOOTSTRAP.md` (mechanika).

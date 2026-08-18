---
name: project-context
description: Živý stav projektu inkwit — fáze, milníky, aktuální focus
type: context
status: active
created: 2026-08-18
updated: 2026-08-18
---

# inkwit — živý kontext

> Statické věci (stack, konvence, zákony) jsou v projektovém CLAUDE.md. Tady jen DYNAMICKÉ — co se mění během vývoje. Přepisuj v místě, neapenduj.

## Aktuální stav

**Fáze: před fází 0.** Repo obsahuje jen dokumentaci, žádný kód, žádné migrace,
žádný Supabase projekt. Hotový je produktový návrh ve třech dokumentech
(`docs/product.md`, `docs/data-model.md`, `docs/roadmap.md`) + `CLAUDE.md`
s osmi neporušitelnými pravidly.

**2026-08-18:** zprovozněna dlouhodobá paměť (šablona VZOR nasazena do `_claude/`,
hook `reindex.js` v `.claude/hooks/`), repo inicializováno jako git.

## Aktuální focus

Nic se neimplementuje. Před startem fáze 0 čekají na rozhodnutí otevřené body níže.

## Otevřené body

### Rozpory v dokumentaci (nalezeno 2026-08-18, nerozhodnuto)

1. **Pravidlo 8 × rozsah fáze 0.** `CLAUDE.md` zakazuje veřejné zobrazení kresby
   před automatickou kontrolou obsahu, ale automatická kontrola je až fáze 1
   (`docs/roadmap.md`). Buď MVP poběží jako uzavřená skupina 50 pozvaných
   (a roadmapa to musí říct explicitně), nebo se automatická kontrola posune do
   fáze 0. Dokud se nerozhodne, fáze 0 se nedá naplánovat bez porušení pravidla.
2. **Relay ve školním tenantu × pravidlo 1.** `docs/product.md` doporučuje relay
   zpřístupnit i školám, ale sdílené plátno je stejný kanál mezi žáky jako volná
   textová zpráva — a relay má záměrně vypnutou detekci snahy i trust score.
   Není adresované, jak se ve školním relay brání kresleným obscénnostem.
3. **Surge × žebříček.** Surge zvedá odměnu za kreslení, takže dvě stejně dobré
   kresby dostanou různé skóre podle času vzniku. Není pay-to-win, ale ovlivňuje
   to žebříček. K rozhodnutí: dává surge body do žebříčku, nebo jen kredity mimo něj?

### Produktové otevřené otázky

Šest otázek je v `docs/roadmap.md`. Nejrizikovější je #1 — čím nahradit sdílenou
sérii z Draw Something. Je to jediná díra, kterou nejde zalepit později bez přepisu
motivační vrstvy.

### Před prvním kódem

- Založit Supabase projekt (placená akce → vyžaduje potvrzení majitele).
- Rozhodnout, jestli `game_config` vzniká už ve fázi 0 (pravidlo 6 říká, že
  balanc nesmí být konstanta v kódu — pak ano, i pro hvězdičky a palec).

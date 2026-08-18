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
hook `reindex.js` v `.claude/hooks/`), repo inicializováno jako git a napojeno na
GitHub (`Johnny09112/Inkwit`). Opraveno zadání hádání (hotový obrázek místo přehrání)
a uzavřen rozpor kolem pravidla 8.

## Aktuální focus

Nic se neimplementuje. Před startem fáze 0 čekají na rozhodnutí otevřené body níže.

## Otevřené body

### Vyřešeno 2026-08-18

- **Pravidlo 8 × rozsah fáze 0** → fáze 0 je uzavřená skupina ~50 pozvaných, veřejné
  otevření je podmíněné klasifikátorem. Viz [[faze-0-uzavrena-skupina]].
- **Přehrání kresby při hádání** → majitel opravil zápis v `docs/product.md`: hádá se
  nad **hotovým obrázkem**, přehrání je volitelné tlačítko a odměna po uhodnutí.
  Poměr obou variant se měří ve fázi 0. Viz [[hadani-nad-hotovym-obrazkem]].

### Otevřené rozpory (nalezeno 2026-08-18, nerozhodnuto)

1. **Relay ve školním tenantu × pravidlo 1.** `docs/product.md` doporučuje relay
   zpřístupnit i školám, ale sdílené plátno je stejný kanál mezi žáky jako volná
   textová zpráva — a relay má záměrně vypnutou detekci snahy i trust score.
   Není adresované, jak se ve školním relay brání kresleným obscénnostem.
   *Nespěchá — relay je fáze 3.*
2. **Surge × žebříček.** Surge zvedá odměnu za kreslení, takže dvě stejně dobré
   kresby dostanou různé skóre podle času vzniku. Není pay-to-win, ale ovlivňuje
   to žebříček. K rozhodnutí: dává surge body do žebříčku, nebo jen kredity mimo něj?
   *Nespěchá — surge je fáze 1.*

### Produktové otevřené otázky

Šest otázek je v `docs/roadmap.md`. Nejrizikovější je #1 — čím nahradit sdílenou
sérii z Draw Something. Je to jediná díra, kterou nejde zalepit později bez přepisu
motivační vrstvy.

### Před prvním kódem

- Založit Supabase projekt (placená akce → vyžaduje potvrzení majitele).
- Rozhodnout, jestli `game_config` vzniká už ve fázi 0 (pravidlo 6 říká, že
  balanc nesmí být konstanta v kódu — pak ano, i pro hvězdičky a palec).

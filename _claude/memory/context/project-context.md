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

**Fáze: před fází 0 — frontend skeleton existuje.** Repo obsahuje Next.js 15
aplikaci (App Router, TS strict, next-intl CZ+EN, `middleware.ts`) s implementací
všech 10 obrazovek z wireframů, zatím nad mock daty (`lib/mock.ts`). Žádné migrace,
žádný Supabase projekt, žádný backend. Rozsah fáze 0 se 2026-08-18 rozšířil
o notifikace autorovi a minimální vyžádání kresby — obojí nese retenční hypotézu.
Produktový návrh ve třech dokumentech (`docs/product.md`, `docs/data-model.md`,
`docs/roadmap.md`) + `CLAUDE.md` s osmi neporušitelnými pravidly.

**2026-08-18:** zprovozněna dlouhodobá paměť (šablona VZOR nasazena do `_claude/`,
hook `reindex.js` v `.claude/hooks/`), repo inicializováno jako git a napojeno na
GitHub (`Johnny09112/Inkwit`). Opraveno zadání hádání (hotový obrázek místo přehrání)
a uzavřen rozpor kolem pravidla 8.

**2026-08-18 (později):** zapsán design systém (`docs/design-system.md`, paleta
„Oves a oliva" + fonty, viz [[paleta-oves-a-oliva-a-fonty]]) a podle wireframů
z design projektu „Inkwit vizuální směr" (claude.ai/design) implementován frontend:
plátno s vektorovými tahy přes PointerEvents (uniformní štětec bez tlaku, časové
značky, typ zařízení), submit flow s kontrolním krokem jen pro podezřelé kresby
(`looksRushed` v `lib/strokes.ts`), hádání na tři pokusy, uhodnuto s přehráním,
prázdný feed (surge), výběr pojmu, moje kresby, žebříčky, profil s přepínačem
jazyka. Tři responzivní rozvržení plátna: mobil (karta pod plátnem), tablet
768–1279 (svislá lišta vpravo), desktop ≥1280 (plovoucí ostrůvek + lišta dole).
Build i typecheck čisté, flow ověřeno v prohlížeči v obou jazycích.

## Aktuální focus

Frontend skeleton stojí nad mock daty. Další krok je backend: Supabase projekt,
schéma podle `docs/data-model.md`, napojení místo `lib/mock.ts`.

## Otevřené body

### Vyřešeno 2026-08-18

- **Pravidlo 8 × rozsah fáze 0** → fáze 0 je uzavřená skupina ~50 pozvaných, veřejné
  otevření je podmíněné klasifikátorem. Viz [[faze-0-uzavrena-skupina]].
- **Přehrání kresby při hádání** → majitel opravil zápis v `docs/product.md`: hádá se
  nad **hotovým obrázkem**, přehrání je volitelné tlačítko a odměna po uhodnutí.
  Poměr obou variant se měří ve fázi 0. Viz [[hadani-nad-hotovym-obrazkem]].
- **Otevřená otázka #1 (náhrada sdílené série)** → sérii nenahrazujeme 1:1; retenci
  nese cizí akce nad tvojí kresbou. Viz [[retence-bez-sdilene-serie]].

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

### Před backendem

- Založit Supabase projekt (placená akce → vyžaduje potvrzení majitele).
- Rozhodnout, jestli `game_config` vzniká už ve fázi 0 (pravidlo 6 říká, že
  balanc nesmí být konstanta v kódu — pak ano, i pro hvězdičky a palec).

---
name: kolize-nazvu-tridy-v-globals
description: globals.css má jeden jmenný prostor a leží v něm mrtvé třídy z wireframů; nová třída se stejným názvem zdědí jejich pravidla a rozbije vzhled
type: pattern
status: active
created: 2026-08-19
updated: 2026-08-19
---

# Kolize názvu třídy v `globals.css`

**Příznak:** nové tlačítko se chová jinak než jeho sousedi, i když má stejné
předky a žádná zjevná pravidla navíc. V tomhle případě mělo `.thumb-btn`
zalomený popisek na dva řádky a chybějící pilulku.

**Příčina:** `styles/globals.css` má **jeden jmenný prostor** a leží v něm třídy
z wireframové etapy, které už nic nepoužívá. `.thumb-btn` tam byla od začátku
jako 36 × 36 čtvereček s ikonou. Nová komponenta si vzala stejný název
a zdědila `width`/`height`, které přebily výplň pilulky.

**Jak tomu předejít:** před zavedením názvu třídy si ho v `globals.css` najít.

```bash
grep -n "\.nazev-tridy" styles/globals.css
```

Když se najde a nikdo ji nepoužívá (`grep -rn "nazev-tridy" app components`),
je to mrtvý kód — smazat, ne obcházet.

**Lepší tvar pro stavy:** místo vlastní třídy na prvek stačí modifikátor
navěšený na rodiče, tedy `.guess-meta-actions .is-given`. Prvek pak zůstane
vzhledově totožný se sousedy a liší se jen tím, co má opravdu být jinak.

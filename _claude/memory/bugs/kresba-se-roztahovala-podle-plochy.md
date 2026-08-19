---
name: kresba-se-roztahovala-podle-plochy
description: Body se mapovaly na každou osu zvlášť, takže kresba měnila tvar podle plochy — v náhledu byla dvakrát širší než při kreslení; kresba si teď nese poměr a všude se do něj vepisuje
type: bug
status: resolved
created: 2026-08-20
updated: 2026-08-20
related: [kodovani-bodu-tahu, gesta-a-vyrez-platna]
---

# Kresba se roztahovala podle tvaru plochy

**Nalezeno 2026-08-20**, nahlásil majitel: „když se zvětšuje plátno, mění se
poměr plátna a obrázek se roztáhne".

## Bylo to širší, než zněla stížnost

Body tahů jsou poměrné souřadnice 0–1 a vykreslovaly se jako `x * šířka`,
`y * výška` — **každá osa zvlášť**. Jenže plátno má všude jiný tvar:

| kde | poměr š/v |
|---|---|
| kreslení s lištou | 0,68 |
| kreslení po rozbalení | 0,53 |
| hádání | 0,75 |
| náhled a detail | 1,00 |

Netýkalo se to tedy jen toho tlačítka. **Táž kresba byla v hádání o 29 % širší
než při kreslení a ve čtvercovém náhledu dvakrát tolik.** Změřeno na dvou stejně
dlouhých úsečkách: ve čtverci vyšla vodorovná 85,8 px proti svislé 42,1 px.

## Řešení: kresba si nese svůj tvar

Sloupec `drawings.aspect` a vykreslování přes `fitBox()` — obdélník daného tvaru
se vepíše do dostupné plochy a vystředí, jako `object-fit: contain`.

Po opravě jsou tytéž úsečky stejně dlouhé všude: 150,6 px v původním plátně,
98,4 px v hádací ploše, 42,1 px ve čtvercovém náhledu.

## Tři věci, které z toho plynou a nejsou zjevné

1. **Tvar se zamyká prvním tahem.** Do té doby sleduje prvek, takže kdo si
   plátno rozbalí předem, dostane celou plochu. Po zamknutí rozbalení mění
   velikost, ne tvar — ověřeno: plocha na polovinu, kresba zůstala čtvercová.
2. **Vstup se mapuje do vepsaného obdélníku**, ne do prvku, a ořezává se na
   0–1. Jinak by šlo kreslit do prázdného okraje a server by dostal souřadnice
   mimo rozsah.
3. **Tloušťka tahu se vztahuje k šířce kresby**, ne plochy. Jinak by tah
   v úzkém výřezu zesílil, i když kresba zůstala stejná.

## Zpětně to nešlo dopočítat

Poměr se z poměrných souřadnic odvodit nedá — informace se nikdy neukládala.
Dosavadní řádky dostaly **0,68** (telefon s lištou), což je odhad, ne fakt.
U testovacích dat fáze 0 přijatelné; nové kresby už poměr měří.

## Past při migraci

`create or replace function` **neumí změnit návratový typ**. `next_drawing()`
a `my_drawings()` dostávaly sloupec navíc, takže se musely nejdřív zahodit
(`drop function`) a práva nastavit znovu.

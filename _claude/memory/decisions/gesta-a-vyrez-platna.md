---
name: gesta-a-vyrez-platna
description: Jeden prst kreslí, dva přibližují a posouvají; přiblížení je jen zobrazení, body zůstávají v poměrných souřadnicích 0–1, matematika výřezu je v lib/canvasView.ts a má vlastní testy
type: decision
status: active
created: 2026-08-19
updated: 2026-08-19
related: [kodovani-bodu-tahu, predvolby-zarizeni-v-localstorage]
---

# Gesta na plátně a výřez

**Rozhodnuto 2026-08-19** poté, co majitel zkusil hru na telefonu.

Pár hodin předtím se ze stejné obrazovky odstraňovalo šipkové tlačítko, které
posun jen předstíralo (`panMode` vypínal kreslení a nic víc). Teď je funkce
udělaná doopravdy: **jeden prst kreslí, dva přibližují a posouvají výřez.**

## Přiblížení je jen zobrazení

Výřez je trojice `scale`, `tx`, `ty`. Body tahů se pořád ukládají v **poměrných
souřadnicích celého plátna (0–1)**, takže se nemění datový model, RPC ani
výpočet pokrytí plátna na serveru. Při záznamu se souřadnice převádí inverzí
výřezu, při kreslení se výřez nasadí jako transformace kontextu.

Dvě věci, které z toho plynou a nejsou vidět:

1. **Ořez posunu není kosmetika.** Drží viditelnou část uvnitř plátna, a tím
   zaručuje, že poměrné souřadnice nevypadnou z rozsahu 0–1. Bez něj by se dalo
   kreslit „mimo plátno" a server by dostal nesmyslné pokrytí.
2. **`renderStrokes` musí umět nečistit.** `clearRect` se řídí aktuální
   transformací, takže v posunutém výřezu smaže jen jeho část. Plátno si proto
   čistí samo v netransformovaném stavu — odtud parametr `options.clear`.

## Tloušťka štětce se dělí přiblížením

Štětec má pod prstem pořád stejnou tloušťku, takže v souřadnicích kresby je při
čtyřnásobném přiblížení čtvrtinový. Právě proto se přibližuje — kvůli detailům.

## Matematika je zvlášť a má testy

`lib/canvasView.ts` je čistá funkce bez DOM, `npm run test:view` ji ověřuje
(9 testů, vestavěný runner Node + odstraňování typů, **žádná nová závislost**).
Testuje se hlavně to, co se okem nepozná: že bod pod prsty zůstane po přiblížení
na místě, že převod tam a zpátky sedí i v posunutém výřezu a že rohy výřezu
nikdy nevypadnou z rozsahu 0–1.

`tsconfig.json` kvůli tomu má `allowImportingTsExtensions` — runner Node vyžaduje
v importu příponu `.ts`, kterou by tsc jinak odmítl.

## Zamčení kreslení během gesta

Druhý prst zahodí rozdělaný tah a zamkne kreslení, dokud nejsou **všechny** prsty
pryč. Bez toho by po každém přiblížení zůstala čárka od prvního prstu a zvednutí
jednoho prstu z gesta by tím druhým začalo kreslit.

## Návrat z přiblížení

Když je `scale > 1`, ukáže se v rohu plátna míra přiblížení a klepnutí vrátí celou
kresbu. Bez toho by se z přiblížení nedalo odejít — oddálit dvěma prsty jde, ale
trefit přesně 1,0 ne.

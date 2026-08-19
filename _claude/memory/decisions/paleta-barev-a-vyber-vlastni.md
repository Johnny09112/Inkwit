---
name: paleta-barev-a-vyber-vlastni
description: Vlastní paleta se ukládá do localStorage (23 barev + tlačítko přidat), nová barva se míchá v kruhu HSV, hex je v něm místo v panelu; na umístění se ptáme až když je paleta plná
type: decision
status: active
created: 2026-08-19
updated: 2026-08-19
related: [predvolby-zarizeni-v-localstorage, paleta-oves-a-oliva-a-fonty]
---

# Paleta barev a výběr vlastní barvy

**Rozhodnuto 2026-08-19** po zkoušce na telefonu — majiteli chyběly barvy.

## Co bylo špatně

„Moje paleta" **se nikam neukládala.** Byla to stavová proměnná komponenty
plněná z konstanty `FULL_PALETTE` v `lib/mock.ts`; barva přidaná hexem zmizela
se zavřením panelu. Název sliboval něco, co kód nedělal.

Ozubené kolečko u palety byla **dekorativní ikona bez obsluhy** — stejný případ
jako šipkové tlačítko na plátně.

## Rozhodnutí

1. **Paleta v `localStorage`**, ne v účtu. Stejné zdůvodnění jako u kreslicí
   ruky ([[predvolby-zarizeni-v-localstorage]]): sloupec v `profiles` by znamenal
   migraci, RPC, RLS a testy. Majitel to vzal s tím, že se to přenese do účtu,
   až se ukáže, že si lidi palety opravdu skládají.
   **Čtení úložišti nevěří** — zkažený obsah by jinak shodil celou obrazovku.
2. **23 barev + tlačítko přidat** = mřížka 8 × 3. Hex se z panelu odstranil.
3. **Hex je uvnitř výběru vlastní barvy**, vedle kruhu — tam je vidět, co za
   hodnotou stojí. V panelu to byl holý kód bez souvislosti.
4. **Na umístění se ptáme, teprve když je paleta plná.** Majitel navrhoval
   vybrat místo pokaždé; to by přidalo krok i tam, kde je volno. Volné místo se
   obsadí samo, plná paleta si vyžádá výběr barvy k nahrazení.
5. **Ozubené kolečko odstraněno** (2026-08-19, druhé kolo). Nejdřív z něj byl
   režim úprav s křížky, ale majitel ho po zkoušce nechtěl vůbec. **Důsledek:
   barvu nejde odebrat, jen nahradit** — a nahrazovat se dá teprve u plné palety.
   Až se ukáže, že to lidem vadí, vrátí se mazání jinou cestou.

## Kruh se kreslí jednou, jas je černý překryv

`RGB(h, s, v) = v · RGB(h, s, 1)`, takže černá vrstva s průhledností `1 − v`
přes kruh nakreslený při plném jasu dá **přesně** správnou barvu. Kruh se proto
nepřekresluje při každém pohybu posuvníku (240 × 240 × dpr pixelů po jednom).
Hlídá to test „jas škáluje barvu lineárně".

## Převody jsou zvlášť a mají testy

`lib/color.ts` je bez DOM, `npm run test:unit` ho ověřuje spolu s výřezem plátna
(19 testů celkem). Testuje se hlavně to, co se okem nepozná: hex tam a zpátky,
poloha tečky tam a zpátky, orientace kruhu (nula nahoře, po směru hodin) a to,
že prst mimo kruh se chová jako prst na okraji.

**Pozor na bílou a černou:** nemají odstín. Když se hex přepíše na `#FFFFFF`,
odstín se v kruhu **nepřepisuje**, jinak by tečka skočila na nulu a člověk by
přišel o rozdělanou barvu.

## Co zůstalo nedodělané

„Naposledy použité" se pořád neukládá — je to stav stránky a po načtení se vrátí
na výchozí osmičku z `lib/mock.ts`. Majitel to nežádal.

## Druhé kolo po zkoušce na telefonu (2026-08-19)

Tři chyby, které se ukázaly až na skutečném zařízení:

1. **Paleta vyjela mimo obrazovku.** Obal `.color-slot` s `aspect-ratio`, který
   držel křížek pro mazání, roztáhl stopy mřížky — výchozí `1fr` má minimální
   šířku `auto`, tedy minimum obsahu. Obal s křížky zmizel, stopy jsou
   `minmax(0, 1fr)` a mřížka dostala `align-items: start`, jinak se dlaždice
   roztáhne na výšku řádku a `aspect-ratio` nemá odkud vzít výšku.
   *Ověřeno na šířkách 320 až 1024: všude čtvercové a bez přesahu.*
2. **Na iPadu nešlo uložit.** Panel je s otevřeným kruhem přes 470 px vysoký,
   měl `max-height: none` a `overflow: visible`. Jakmile na iOS vyjela klávesnice
   (klepnutí do hexu), tlačítko Uložit skončilo pod ní **a nedalo se k němu
   dorolovat**. Teď má panel `max-height: calc(100dvh - 24px)` a `overflow-y: auto`.
   `dvh`, protože `vh` na iOS klávesnici neregistruje.
3. **Ukázka vybrané barvy byla moc malá** — 26 px, teď 44 px.

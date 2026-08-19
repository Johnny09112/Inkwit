---
name: knihovna-kreseb-a-mazani
description: Rozepsané kresby se z knihovny skrývají, ale řádek zůstává kvůli metrics_funnel; mazání vlastní kresby je měkké (status removed), detail nesmí ukázat počet pokusů
type: decision
status: active
created: 2026-08-19
updated: 2026-08-19
related: [tajemstvi-hry-v-schematu, predvolby-zarizeni-v-localstorage]
---

# Knihovna „Moje kresby" — rozepsané, mazání, detail

**Rozhodnuto 2026-08-19** poté, co majitel poslal náhled knihovny s prázdnými
dlaždicemi.

## Co byl ten prázdný obrázek

`my_drawings()` vracela každý řádek kromě `removed`, takže do mřížky spadly
i **rozepsané kresby** (`status = 'draft'`) — plátna založená `start_drawing()`,
od kterých autor odešel křížkem. Neměly jediný tah a mřížka je popsala
„čeká na 1. uhodnutí", což je dvakrát vedle: hádat je nikdo nemůže.

## Tři rozhodnutí

### 1. Drafty se skrývají, ale nemažou

`my_drawings()` teď filtruje `status not in ('draft', 'removed')`.

**Řádek musí zůstat.** `private.metrics_funnel` na něm měří drop-off mezi
„začal kreslit" a „odeslal" — kvůli tomu je krok C2 rozdělený na dvě RPC.
Úklid databáze by zabil jedno ze tří čísel, kvůli kterým se fáze 0 dělá.
`delete_drawing()` proto draft vědomě odmítne a hlídá to test.

Z toho plyne i podoba varování na plátně: dialog říká „neuloží se", ne
„zahodí se" — protože se opravdu nic nemaže, jen se to nikam nedostane.

### 2. Mazání kresby je měkké

`delete_drawing()` jen přepne `status` na `removed`. Tvrdý `delete` by kaskádou
vzal s sebou **cizí tipy** (historie jiných hráčů) a čísla, ze kterých se počítá
zásoba neuhodnutých kreseb — metrika 2 z `CLAUDE.md`. Kresba zmizí z knihovny
i z nabídky k hádání, protože `next_drawing()` bere jen `live`.

Podmínka `author_id = auth.uid()` je **uvnitř `update`**, ne v aplikaci — cizí
kresbu funkce neodstraní ani při podvrženém id.

### 3. Detail neukazuje počet pokusů

Majitel si vyžádal „počet pokusů o uhádnutí". To je přesně
`guess_count − solved_count`, tedy **kolikrát ho lidé neuhodli** — číslo, které
`docs/product.md` autorovi zakazuje a kvůli kterému krok C4 zavíral přímé čtení
tabulky. Po vysvětlení majitel 2026-08-19 zvolil **vynechat**.

Detail proto stojí jen na tom, co `my_drawings()` vydá: uhodlo, palce,
hvězdičky, datum. Druhá cesta k datům neexistuje — komponenta si nic nedotahuje.

## Co se přitom nezměnilo

Přehrání v detailu **není v A/B skupině**. Test z kroku F4 měří, jestli přehrání
pomáhá *hádajícímu*; nad vlastní kresbou nemá co měřit, takže ho vidí každý.

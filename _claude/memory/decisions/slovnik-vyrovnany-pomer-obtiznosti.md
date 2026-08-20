---
name: slovnik-vyrovnany-pomer-obtiznosti
description: Slovník má 300 pojmů ve vyrovnaném poměru 100/100/100, protože nabídka bere jeden pojem od každé obtížnosti a buckety se čerpají stejně rychle bez ohledu na svou velikost
type: decision
status: active
created: 2026-08-20
updated: 2026-08-20
related: [jak-tvorit-slovni-zasobu, tolerance-preklepu-uznavala-cizi-pojem]
---

# Slovník: vyrovnaný poměr obtížností, ne 50/33/17

Rozhodnuto 2026-08-20 při rozšiřování slovníku ze 120 na 300 pojmů.
Majitel schválil obojí — rozsah i změnu poměru.

## Co se změnilo

| | bylo (120) | je (300) |
|---|---|---|
| snadné ★ | 58 | **100** |
| střední ★★ | 40 | **100** |
| těžké ★★★ | 22 | **100** |

Kategorie: zvíře 61 · předmět 63 · příroda 35 · jídlo 32 · činnost 49 ·
abstraktní 60. Přijímaných tvarů: cs 983 · en 695.
Jen jednojazyčné: `zámek`, `trapas`, `štěstí`, `raketa`, `list`.

## Proč vyrovnaný poměr

Recept `jak-tvorit-slovni-zasobu.md` původně říkal „poměr nakloněný ke snadným,
zhruba 50/33/17", a zdůvodňoval to tím, že **nabídka tří konceptů je ventil pro
toho, kdo kreslit neumí** — kdyby byly obtížnosti rovnoměrné, v nabídce často
nebude nic snadného.

**Ten argument neplatí, protože ventil nedrží počet, ale struktura nabídky.**
`offer_concepts()` (`20260819000200_draw_flow.sql:33`) běží `for d in 1..3` a
z každé obtížnosti bere právě jeden pojem. Snadná možnost je v nabídce
**vždycky**, ať jich je v databázi 22 nebo 300.

Co počet naopak ovlivňuje: nabídka vylučuje jen to, co ten člověk už kreslil,
takže se **všechny tři buckety čerpají stejně rychle**. Při 58/40/22 dojdou
těžké 2,6× dřív než snadné — a přesně na těžkých svítil alarm v `/admin`
(zbývalo 16 nenakreslených z 22). Poměr nakloněný ke snadným je tedy návod, jak
si vyrobit alarm na těžkých pojmech.

## Stav po nasazení

Nenakreslených pojmů: **68 snadných · 73 středních · 94 těžkých**
(alarm v `/admin` svítí pod 15). Alarm zhasl.

## Co to nemění

- **Odměna podle obtížnosti zůstává** (těžká kresba 8 kreditů proti 2 za
  snadnou, viz [[kredity-a-odmeny]]). Vyrovnaný poměr není pay-to-win — nikdo
  si obtížnost nekupuje, dostane jednu od každé.
- **Obtížnosti se dál nesmí gatovat levelem** — viz [[levely-bez-gati-na-jadro]].

## Pro příští dávku

Recept v [[jak-tvorit-slovni-zasobu]] je přepsaný. Nová dávka se dělá po
kategoriích, validátor po každé dávce, a poměr se drží průběžně na 1:1:1.

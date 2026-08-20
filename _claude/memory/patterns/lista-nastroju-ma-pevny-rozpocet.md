---
name: lista-nastroju-ma-pevny-rozpocet
description: Mobilní lišta nástrojů má pevný rozpočet šířky; přidání čtvrtého tlačítka rozbilo posuvník, protože input[type=range] se jako flex položka nesmrskne pod svou minimální šířku
type: pattern
status: active
created: 2026-08-20
updated: 2026-08-20
---

# Lišta nástrojů má pevný rozpočet, a `input[type=range]` se nesmrskne

Sepsáno 2026-08-20 poté, co přidání tvarů rozbilo posuvník velikosti — na
majitelově telefonu zalezla značka velikosti pod tlačítko štětce.

## Dvě pasti, které to způsobily

### 1. `input[type=range]` má vlastní minimální šířku

Jako flex položka má `min-width: auto`, tedy velikost obsahu — a u posuvníku
je to **129 px** (změřeno). `flex: 1` ho pod tu hodnotu nedostane. Řádek proto
nepřeteče viditelně: přeteče **obsah uvnitř** a to, co je za posuvníkem, se
překryje se sousedem.

**Vždy `min-width: 0`** na flex položku, která má opravdu ustoupit.
Týká se to i `select`, `input[type=text]` a čehokoli s vnitřní minimální šířkou.

### 2. Ořezávání místo zalomení schová obsah

`.swatch-row-colors` mělo `overflow: hidden`. Na šířce 375 px končila **osmá
barva 41 px za ořezem** — nešlo na ni klepnout vůbec, a na širokém telefonu
se to nepoznalo. Ořez je horší než zalomení: zalomení je vidět, ořez ne.

## Rozpočet mobilní lišty

Karta má **dva řádky** a je to vědomé (třetí by ubral výšku plátnu).
Na šířce 375 px má řádek **293 px**. Ikonové tlačítko je 46 px, mezera 8 px.

| položek | šířka tlačítek | zbyde |
|---|---|---|
| 3 | 138 + 16 | 139 |
| 4 | 184 + 24 | **85** |

Osmdesát pět pixelů na posuvník i s vnitřním odsazením a značkami nestačí.
Proto se velikost přesunula do vyskakovacího panelu (`SizePicker`) a řádek
drží čtyři tlačítka: guma · velikost · štětec · tvary.

**Než do lišty přidáš pátou položku, spočítej rozpočet.** Vejde se do něj jen
tlačítko, ne tlačítko a posuvník.

## Jak to ověřit bez účtu

Kreslicí obrazovka je za přihlášením. Postup, který funguje:

1. `/playground` (viz [[vyvojova-obrazovka-playground]]) — má paletu, výběr
   tvaru i velikosti.
2. Pro měření layoutu vlož značky do stránky skriptem a změř
   `getBoundingClientRect()`. **Pozor: media queries se řídí viewportem**, ne
   šířkou vloženého obalu — na testování breakpointů se musí měnit velikost
   okna, jinak měříš nesmysl.

## A dvě pasti prostředí, které mě při tom zdržely

- **Service worker servíruje starý balíček** i ve vývoji. Komponenta v souboru
  je, v DOM není. Odregistrovat a smazat cache — viz
  [[service-worker-serviruje-stary-kod]].
- **`rm -rf .next` za běhu dev serveru** ho rozbije („Cannot find module
  ./vendor-chunks/…"). Nejdřív zastavit server, pak mazat — příbuzné
  [[next-cache-rozbita-buildem]].

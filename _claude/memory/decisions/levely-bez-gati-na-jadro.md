---
name: levely-bez-gati-na-jadro
description: Level roste z celkem vydělaných kreditů a odemyká jen kosmetiku; gatování hádání, obtížností a vyžádání pojmu padlo, protože každé z nich rozbíjí měření fáze 0 nebo pravidlo 3
type: decision
status: active
created: 2026-08-20
updated: 2026-08-20
related: [kredity-a-odmeny, retence-bez-sdilene-serie, paleta-barev-a-vyber-vlastni]
---

# Levely — a čtyři věci, které se gatovat nesmí

**Rozhodnuto 2026-08-20.** Majitel navrhl 30 levelů, kde by se postupně
odemykalo hádání (až po třech kresbách), obtížnosti, barvy, party a nástroje —
s tím, že levely by šlo přeskočit nákupem kreditů.

Záměr (progres jako důvod se vracet) zůstal. Čtyři části návrhu padly, každá
z jiného důvodu.

## 1. Hádání až po třech kresbách — zabíjí metriku 1

`CLAUDE.md`: *„Podíl týdně aktivních, kteří nakreslí aspoň jednu kresbu.
Cíl 15–25 %."* **Když se kreslení vynutí, to číslo je 100 % a neznamená nic.**
Fáze 0 se dělá právě proto, aby se zjistilo, jestli lidé kreslí dobrovolně.

## 2. Obtížnosti za levely + prodej levelů — pay-to-win

Těžký pojem vydělá 8 kreditů proti 2 za snadný. Koupený level je tedy **násobič
výdělku** a přes denní žebříček i výhoda — pravidlo 3 to zakazuje doslova
(*„žádné pokusy navíc, násobiče bodů, výhody v žebříčku"*).

Levely se proto **nedají koupit**. Prodávat se smí kosmetika, ne postup.

## 3. Vyžádání pojmu — nese hypotézu fáze 0

Vypadalo jako bezpečný kandidát: není to jádro, jde bez něj kreslit i hádat.
Jenže `docs/plan.md` u bloku E říká *„Tohle nese hlavní hypotézu fáze 0. Když se
bude škrtat, škrtá se jinde."*

**Odhalil to test**, ne úvaha — po zavedení zámku spadl existující test
„vyžádání pojmu projde". Zámek šel pryč a přibyl test, který hlídá, že tam
nevznikne znovu.

## 4. Přehrání kresby — pod ním běží A/B test

Krok F4 měří, jestli přehrání pomáhá hádajícímu (`profiles.ab_playback`).
Zámek levelem by měření rozbil.

## Co tedy levely dělají

Level roste z **celkem vydělaných** kreditů (prahy 0 / 10 / 25 / 50 / 100 / 175
v `game_config`). Ze zůstatku ne — utracení za kosmetiku by srazilo level a vzalo
odemčené funkce.

| level | odemyká |
|---|---|
| 1 | kreslení, hádání, všechny obtížnosti, 8 barev |
| 2 | celá základní paleta (15 barev) |
| 3 | míchání vlastních barev |
| 4–6 | zatím nic — party a nástroje neexistují |

**Třicet levelů se nezavedlo.** Reálná odemčení jsou dvě; dvacet prázdných levelů
je horší než žádné. Prahy jsou v konfiguraci, takže přidat další jde bez nasazení.

## Nákup míchání barev zrušen tentýž den

Zaveden ráno za 25 kreditů, odpoledne nahrazen levelem 3. Dvě soustavy na jednu
věc by si konkurovaly. Nikdo si ho nekoupil, takže se nic neztratilo.

**Důsledek:** kredity zase nemají za co utrácet a jsou palivem pro level.
Až přibude kosmetika (palety, sady barev), sink se vrátí — zůstatek i celkem
vydělané se počítají odděleně právě proto.

## Zpětný dopočet

Odměny se zapojily až týž den, takže 80 kreseb a 48 uhodnutých tipů nikdy nic
nevyneslo. Migrace je dopočítala zpětně (idempotentně přes unikátní index) —
jinak by byli všichni na levelu 1 a zavedení levelů by jim **vzalo funkce, které
už měli**. Po dopočtu: 133 / 71 / 53 vydělaných, tedy levely 5 / 4 / 4.

---
name: odkud-pokracovat
description: Předávka po vyčerpání kontextu 2026-08-20 — kde přesně pokračovat: slovní zásoba a dopracování systému levelů
type: context
status: active
created: 2026-08-20
updated: 2026-08-20
related: [levely-bez-gati-na-jadro, kredity-a-odmeny, jak-tvorit-slovni-zasobu]
---

# Odkud pokračovat

**Zapsáno 2026-08-20** na konci dlouhé session, těsně před vyčerpáním kontextu.
Majitel řekl: *„Až napíšu pokračujeme, chci abychom pokračovali ve slovech
a řešení jednotlivých levelů."*

Pořadí podle jeho zadání: **1. slova · 2. levely.**

---

## 1. Slova (slovní zásoba)

**Proč to hoří.** Alarm v `/admin` už svítí. Při **třech hráčích** je polovina
slovníku vyčerpaná; po rozeslání padesáti pozvánek to půjde rychle.

Stav k 2026-08-20:

| obtížnost | pojmů | ještě nenakreslených |
|---|---|---|
| snadné | 58 | 26 |
| střední | 40 | 13 |
| těžké | **22** | 16 |

**Těžkých je nejmíň a nová odměna k nim tlačí** (těžká kresba dá 8 kreditů proti
2 za snadnou). Doplňovat tedy hlavně střední a těžké.

**Kde a jak:**
- Zdroj: `supabase/seed/concepts.json` (120 pojmů, šest kategorií).
- **Recept je v paměti:** `patterns/jak-tvorit-slovni-zasobu.md` — kalibrace
  obtížnosti, co patří a nepatří do přijímaných tvarů, kritéria jednojazyčnosti,
  povinná kontrola validátorem.
- **Nedodělek z bloku B:** přijímané tvary CZ (437) a EN (268) nemají splněné
  kritérium „na vzorku zkusit, co lidé reálně napíšou". Kroky B2/B3 jsou pořád
  `[~]` v `docs/plan.md`.
- **Past na krátká slova:** do 4 znaků jen přesná shoda, 5–7 vzdálenost 1,
  8+ vzdálenost 2. Existuje 22 dvojic kratších než pět znaků lišících se jedním
  znakem (`pes`/`děs`, `slon`/`shon`, `výr`/`sýr`). Test to hlídá.
- **Admin má obrazovku „Pojmy, které nikdo neuhodl"** — to jsou podezřelá zadání
  nebo chybějící tvary, ne špatní kreslíři. Zatím prázdná (potřebuje ≥ 3 tipy).

---

## 2. Levely — co je hotové a co zbývá

Hotové a nasazené: level se počítá z **celkem vydělaných** kreditů, prahy
`level_thresholds` = `[0, 10, 25, 50, 100, 175]` v `game_config`.
Profil ukazuje level, zůstatek a pruh do dalšího.

**Reálná odemčení jsou zatím jen dvě:**

| level | odemyká | stav |
|---|---|---|
| 1 | kreslení, hádání, všechny obtížnosti, 8 barev | ano |
| 2 | celá základní paleta (15 barev) | ano |
| 3 | míchání vlastních barev | ano |
| 4 | — | **prázdný** |
| 5 | — | **prázdný** |
| 6 | — | **prázdný** |

### Co je potřeba dořešit

1. **Čím naplnit levely 4–6.** Majitel chtěl party s kamarády a další nástroje;
   ani jedno neexistuje. Bez obsahu jsou to prázdné levely a ty jsou horší než
   žádné.
2. **Kredity nemají sink.** Nákup míchání barev byl zrušen a nahrazen levelem,
   takže zůstatek jen roste. Zůstatek a celkem vydělané se počítají odděleně
   právě proto, aby se sink dal vrátit (palety, sady barev).
3. **Prahy nejsou kalibrované.** 0/10/25/50/100/175 je odhad. Po pozvánkách se
   uvidí, jak rychle lidé postupují.

### ČTYŘI VĚCI, KTERÉ SE GATOVAT NESMÍ

Tohle je nejdůležitější část předávky. Každá padla z jiného důvodu a **každá se
při další úvaze o levelech vrátí jako pokušení**:

1. **Hádání** (majitel chtěl „až po třech kresbách") — zabíjí **metriku 1**
   z `CLAUDE.md`. Vynucené kreslení dá 100 % a číslo přestane něco znamenat.
2. **Obtížnosti** — v kombinaci s prodejem levelů je to **pay-to-win**
   (pravidlo 3). Těžký pojem vydělá 4× víc.
3. **Vyžádání pojmu** — `docs/plan.md`, blok E: *„Tohle nese hlavní hypotézu
   fáze 0."* Odhalil to test, ne úvaha.
4. **Přehrání kresby** — běží pod ním A/B test kroku F4 (`profiles.ab_playback`).

**Levely se nedají koupit.** Prodávat se smí kosmetika, ne postup.

Podrobně: `decisions/levely-bez-gati-na-jadro.md` a `decisions/kredity-a-odmeny.md`.

---

## Co se v téhle session ještě udělalo

Kontrast podle AA · knihovna kreseb s detailem a mazáním · mobilní plátno
(dva řádky nástrojů) · gesta na plátně (prst kreslí, dva prsty zoom) · paleta
a kruh barev · logotyp a ikony z návrhu · obrazovka po uhodnutí · **strop bodů
platil třetinový** (oprava) · **kresba se roztahovala podle plochy** (oprava,
`drawings.aspect`) · správcovské rozhraní `/admin` (blok H) · kredity (blok I)
· levely.

Vše nasazené na produkci, 186 testů databáze + 26 unit testů prochází.

## Co zůstalo viset

- **Vlastní SMTP (krok G4)** — pořád nejdůležitější věc před rozesláním pozvánek.
- **Tři otevřená hlášení** v `/admin`, majitel je chtěl odbavit sám.
- **Dva testovací drafty** v databázi (`0e017896-…`, `84d0f630-…`) plus pár
  dalších z ověřování — kazí `metrics_funnel`, smazat před vyhodnocením.
- Kontrola kreslení na iPadu po opravě stropu bodů (nereprodukováno, jen opraveno).

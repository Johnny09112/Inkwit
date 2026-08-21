---
name: preskoceni-vracelo-tutez-kresbu
description: Tlačítko „Přeskočit" nedělalo nic — next_drawing() vybírá deterministicky a přeskočení se nikam nezapisovalo, takže druhé volání vrátilo tutéž kresbu
type: bug
status: resolved
created: 2026-08-20
updated: 2026-08-20
related: [kredity-a-odmeny]
---

# Přeskočení vracelo tutéž kresbu

Nalezeno 2026-08-20 při zavádění ceny za přeskočení. Majitel chtěl cenu proto,
aby lidé nepřeskakovali donekonečna — a ukázalo se, že **přeskočit vlastně
nešlo**.

## Kořen

Klient po klepnutí zavolal `next_drawing()` znovu. Ta funkce ale vybírá

```sql
order by d.solved_count, d.published_at
limit 1
```

tedy **deterministicky**, a z nabídky vylučuje jen kresby, na které už člověk
tipoval. Přeskočení se nikam nezapisovalo, takže druhé volání vrátilo tutéž
kresbu. Tlačítko bylo bez účinku.

**Cena tedy nebyla jen ekonomika.** Bez záznamu by neměla co omezovat.

## Oprava

Migrace `20260820200000_skip_drawing.sql`:

- `public.skips` (uživatel × kresba, primární klíč) — `next_drawing()` je vylučuje.
- `public.skip_drawing()` zapíše a případně strhne kredit.
- `public.skip_price()` řekne cenu **dopředu**, aby ji tlačítko mohlo napsat.
  Strhnout kredit a oznámit to až potom je ten druh překvapení, po kterém lidé
  přestanou tlačítkům věřit.
- **První přeskočení za den zdarma, další za kredit** (`game_config`). Bez
  volného přeskočení by nový hráč s nulou kreditů nemohl dál — a kdo nemůže
  dál, odejde.
- Je to zároveň **první sink kreditů** (bod `J4`). Do té doby zůstatek jen rostl.

## Co cena NEUHLÍDÁ

`next_drawing()` vylučuje každou kresbu, na kterou člověk **jakkoli tipoval**.
Napsat nesmysl a jít dál je proto zadarmo a cena přeskočení to nezmění.

Škoda není v ekonomice, ale v datech: nesmyslné tipy kazí obrazovku „Pojmy,
které nikdo neuhodl", ze které se kalibrují přijímané tvary. **Kdyby se to
začalo dít, řeší se to tam — ne zdražením přeskočení.** Majitel o tom ví.

## Past, na kterou jsem narazil při psaní testů

Odmítnuté volání nechá transakci v chybovém stavu a **každý další dotaz spadne
na `25P02`**, i když JavaScript tu výjimku chytil. Každý pokus, který má selhat,
musí být obalený `savepoint` / `rollback to savepoint`.

A jedna past mimo databázi: v JS `String.replace` znamená `$$` v náhradě jeden
dolar, takže skript, který generoval SQL, rozbil dollar-quoting funkce
(`as $$` → `as $`). Při generování SQL z JS používat funkci jako náhradu.

---
name: hvezdicky-a-graficke-hodnoty
description: Hvězdičky se kreslí včetně prázdných a jejich obrys musí být dost tmavý; medová výplň má proti ovesnému pozadí jen 1,61 : 1, takže tvar nese obrys, ne barva
type: pattern
status: active
created: 2026-08-19
updated: 2026-08-19
related: [paleta-oves-a-oliva-a-fonty]
---

# Hvězdičky: informaci nese obrys, ne výplň

`components/Stars.tsx` kreslí vždycky **tři** hvězdičky — plné i prázdné.
Bez prázdných není poznat, z kolika to je, a v tom je celý smysl grafického
zobrazení proti holému „2 hvězdičky".

## Měření, které rozhodlo o barvách

Proti ovesnému pozadí `#F3ECDF`:

| co | poměr |
|---|---|
| medová výplň `--accent` | **1,61 : 1** |
| obrys plné (`--accent-ink`) | 12,77 : 1 |
| obrys prázdné (`--text-muted`) | 4,04 : 1 |
| obrys plné vs. obrys prázdné | 3,16 : 1 |

**Medová sama o sobě není vidět.** Tvar proto nese tmavý obrys a barva jen
odlišuje stav. První verze měla prázdné hvězdičky s `--border-strong`, což je
1,7 : 1 — prakticky neviditelné, přitom právě ony nesou informaci.

Pro grafiku platí práh **3 : 1**, ne 4,5 jako pro text. Přesná hodnota je navíc
v `aria-label`, takže kdo barvy nerozliší, dostane ji slovem.

## Nový token

`--accent-ink` (= `--ink-900`) pro text a obrysy na medovém akcentu. Ovesná by
na žluté zmizela; text na palci po klepnutí má díky němu 7,93 : 1.

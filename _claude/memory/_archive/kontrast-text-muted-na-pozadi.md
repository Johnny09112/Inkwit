---
name: kontrast-text-muted-na-pozadi
description: Neaktivní navigace, tabbar a štítek zásoby používají --text-muted na --bg = 4.04:1, což je pod AA; design-system.md přesně před tímhle varoval
type: code-issue
status: resolved
created: 2026-08-18
updated: 2026-08-19
related: [paleta-oves-a-oliva-a-fonty]
---

# `--text-muted` na `--bg` neprochází AA (4.04 : 1)

**Nalezeno 2026-08-18** měřením v prohlížeči na `/cs` (produkční build, port 3100).
Není to odhad — kontrast dopočítán z `getComputedStyle` proti reálnému pozadí.

`rgb(122,114,102)` = `#7A7266` (`--text-muted`) na `rgb(243,236,223)` = `#F3ECDF`
(`--bg`) dává **4.04 : 1**. WCAG AA chce 4.5 : 1 pro běžný text.

**Dotčená místa (`styles/globals.css`):**

| Selektor | Text | Velikost |
|---|---|---|
| `.shell-nav a` | neaktivní položky navigace („Kreslit", „Moje", „Žebříčky") | 13 px |
| `.tabbar a span` | popisky spodní lišty na mobilu | 9 px |
| `.t-label` v hlavičce | „Zásoba 38" | 10 px |

Všechna tři jsou navíc **hluboko pod 18.7 px**, takže výjimka pro velký text neplatí.

**Tohle není objev, je to nedodržení vlastního dokumentu.** `docs/design-system.md`
říká doslova: *„`--text-muted` na `--bg` = 4.04. Na ovesném pozadí ho nepoužívej pro
běžný text — jen na `--surface` (4.63 ✓)."* Implementace ho použila přesně tam,
kde to dokument zakazuje.

**Návrh opravy:** pro tyhle tři případy použít `--text-secondary` (`#4A443C`),
který má na `--bg` poměr **8.2 : 1**. Vizuálně je tmavší, ale u 9px popisků
v tabbaru je to spíš přínos. Alternativa je ztmavit samotný `--text-muted`,
což ale zasáhne i místa, kde sedí na `--surface` a prochází.

**Ověřeno, že jinde problém není:** stejný audit na `/cs/draw` nehlásí nic —
tam štítky sedí na `--surface` nebo v plovoucích kartách.

---

## Vyřešeno 2026-08-19

Opraveno záměnou `--text-muted` → `--text-secondary` v selektorech, které sedí
na `--bg-app`. Změřeno v prohlížeči po opravě: **4.04 → 8.19**.

**Míst bylo víc, než tenhle záznam uváděl** — původní audit projel jen `/cs`.
Doauditované obrazovky přidaly: `.pick-requested` (`/pick`), `.filter-chip`
a `.mine-item-meta` (`/mine`), `.lb-league` (`/leaderboards`) a přes `.t-label`
i všechny popisky formulářů na `/login` a `/reset`.

`.t-label` se opravil na úrovni třídy, ne u jednotlivých použití — je to obecný
helper, který může přistát na jakémkoli pozadí, a `--text-muted` v něm byla
past pro každé další použití.

**Co problém NEMÁ:** `--text-muted` na `--surface-canvas` a `--surface-card`
prochází (4.63 : 1), takže `.input::placeholder`, `.auth-code-prefix`,
`.playback-time`, `.lb-rank` a `.settings-row-value` zůstaly beze změny.

**Jak se to ověřuje znovu:** skript v prohlížeči, který projde `body *`, vezme
`getComputedStyle().color` proti prvnímu neprůhlednému pozadí předka a porovná
s prahem 4.5 (3.0 pro velký text). Pouštěl se na `/guess`, `/mine`, `/pick`,
`/leaderboards` a `/profile` — všechny hlásí nula.

## Past v tom měřicím skriptu (2026-08-19)

První verze brala **jakékoli neprůhledné pozadí jako plnou barvu**, včetně
`rgba(43,38,31,0.03)`. Tlačítko `.btn-secondary` pak vyšlo na 1.56 : 1, ačkoli
po správném složení vrstev má 7.2 : 1.

Skript musí alfu skládat: jít po předcích, sbírat vrstvy, dokud nenarazí na
`alpha = 1`, a pak je složit odspodu (`a·barva + (1−a)·pozadí`).

Chyba vede k **falešným poplachům, ne k přehlédnutí** — poloprůhledné vrstvy
jsou v téhle paletě vždycky tmavý inkoust na světlém, takže naivní výpočet
poměr podhodnotí. Dřívější nulové výsledky proto platí i tak.

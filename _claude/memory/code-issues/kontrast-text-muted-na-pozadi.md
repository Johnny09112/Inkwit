---
name: kontrast-text-muted-na-pozadi
description: Neaktivní navigace, tabbar a štítek zásoby používají --text-muted na --bg = 4.04:1, což je pod AA; design-system.md přesně před tímhle varoval
type: code-issue
status: active
created: 2026-08-18
updated: 2026-08-18
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

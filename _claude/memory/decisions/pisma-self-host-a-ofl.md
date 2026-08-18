---
name: pisma-self-host-a-ofl
description: Písma se self-hostují přes next/font/google (build-time), za běhu nulový request na Google; OFL licence a atribuce leží v licenses/
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
related: [paleta-oves-a-oliva-a-fonty]
---

# Písma: self-host přes next/font, licence v repu

Uzavírá otevřenou otázku „načítání fontů" z [[paleta-oves-a-oliva-a-fonty]].

**Rozhodnutí:** zůstává `next/font/google`. Stahuje písma **při buildu** a servíruje
je z vlastní domény — za běhu nejde ani jeden request na Google. Ruční `next/font/local`
s woff2 binárkami, jak chtěl původní návrh, **není potřeba**: výsledek je z hlediska
GDPR i výkonu totožný, jen bez správy souborů v repu.

**Ověřeno 2026-08-18 měřením, ne předpokladem:** síťový log produkčního buildu
v prohlížeči — všechny requesty na vlastní origin, žádný na `fonts.googleapis.com`
ani `fonts.gstatic.com`.

## Právní část — dvě různé věci, snadno se pletou

1. **GDPR** řeší, kam teče IP adresa návštěvníka. Servírování z Google CDN je přesně
   to, co prohrálo u LG München I (20.01.2022, 3 O 17493/20). Self-host tenhle vektor
   ruší úplně. **Vyřešeno technicky, ne dokumentem.**
2. **Licence** řeší, že servírovat font z vlastní domény = redistribuce. OFL to dovoluje,
   ale žádá, aby licence a copyright šly s písmem. **Tohle byla skutečná mezera** —
   self-host běžel, licence v repu nebyly. Doplněno do `licenses/`.

Obě písma jsou **SIL OFL 1.1** (ověřeno stažením z primárních zdrojů):
Bricolage Grotesque (Copyright 2022 The Bricolage Grotesque Project Authors),
IBM Plex Sans + Mono (Copyright © 2017 IBM Corp.).

## Past do budoucna

**IBM Plex má vyhrazený název „Plex".** Dokud se nic neupravuje, netýká se nás to.
Jakmile by někdo sáhl po subsettingu kvůli velikosti, vzniká „modified version"
a upravená verze se nesmí jmenovat Plex. Kdo bude řešit velikost fontů, ať si
nejdřív přečte `licenses/README.md`.

**Subsety `latin` + `latin-ext` u všech tří rodin jsou povinné**, ne volitelné —
bez `latin-ext` chybí česká diakritika a padá pravidlo dvojjazyčnosti od prvního dne.

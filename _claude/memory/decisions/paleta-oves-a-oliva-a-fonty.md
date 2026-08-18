---
name: paleta-oves-a-oliva-a-fonty
description: Vizuální základ = paleta „Oves a oliva" + Bricolage Grotesque / IBM Plex Sans / IBM Plex Mono; úvodní návrh v docs/design-system.md, ne fix
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
related: []
---

# Paleta „Oves a oliva" a trojice fontů jako vizuální základ

**Kontext:** Majitel 2026-08-18 dodal hotový návrh barev a fontů z designové práce
mimo repo a chtěl ho zapsat jako závazný výchozí bod pro design. Explicitně to označil
za **úvodní návrh, který se dá měnit**, ne za zamčený systém.

**Rozhodnutí:** Vizuální základ je zapsaný v `docs/design-system.md` — teplý ovesný
podklad (`#F3ECDF`), plátno `#FFFCF5`, primární akce olivová `#52633A`, akcent jantar
`#E9B44C`, chyba `#B5462F`. Fonty: Bricolage Grotesque (nadpisy), IBM Plex Sans (text),
IBM Plex Mono (štítky, 11 px uppercase). Tokeny jsou pojmenované v dokumentu
(`--bg`, `--surface`, `--primary`, …), komponenty si hexy nesmí psát samy.

**Důvod:** Paleta je vědomě daleko od saturovaných modrofialových palet skribbl/Gartic
rodiny (viz „čemu se vyhnout" v `CLAUDE.md`). Všechny tři fonty pokrývají Latin Extended,
takže drží dvojjazyčnost CZ + EN od prvního dne.

**Co k tomu přidalo ověření (nebylo v zadání):** kontrast jsem přepočítal, tři
kombinace neprocházejí AA a jsou v dokumentu vedené jako omezení — tlumený text
`#7A7266` na ovesném pozadí (4.04), `--danger` na svém tintu (4.27) a hlavně
**okraje `#E0D5C1` / `#CFC1A6` mají 1.2–1.7:1**, tedy jsou dekorativní a nesmí
tvořit hranici inputu ani focus ring. Na akcentu smí být jen tmavý text.

**Alternativy:** Žádné se nezvažovaly — paleta přišla hotová. Otevřené zůstaly dvě
věci uvnitř návrhu: **načítání fontů** (výchozí návrh = self-host přes `next/font/local`,
jakmile majitel dodá woff2; do té doby Google Fonts) a **tmavý režim** (nerozhodnutý,
z této palety se neodvodí 1:1).

**Důsledky:**
- UI kit (komponenty, stavy, spacing, type scale) neexistuje a přijde až po návrhu
  obrazovek. Do té doby je zdrojem pravdy jen paleta + fonty.
- Barvy štětce na kreslicím plátně jsou **jiný problém** a tenhle systém je neřeší.
- Odkazy doplněny do `CLAUDE.md` („Kde je co") a `README.md`.

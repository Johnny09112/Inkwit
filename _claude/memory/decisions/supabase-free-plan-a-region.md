---
name: supabase-free-plan-a-region
description: Projekt Inkwit běží na free plánu v eu-west-1; free stačí na fázi 0, ale zálohy nejdou stáhnout a region se později nezmění
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
---

# Supabase: free plán stačí, region je otevřený

**Stav (ověřeno 2026-08-18 přes Management API):** projekt `Inkwit`,
ref `aqzrfftvsmkhkldovyfz`, region `eu-west-1` (Irsko), stav ACTIVE_HEALTHY.
Organizace `Johnny09112` je na **free plánu**.

## Free plán stačí na fázi 0 — ale tři věci je nutné znát

- **Dva aktivní projekty na účet.** Pozastavené se nepočítají. Aktivní jsou
  `Customer_finder` a `Inkwit`, tedy **kvóta je vyčerpaná**. Pozastavené:
  `mas-copilot`, `Johnny09112's Project`.
- **Projekt se po týdnu nízké aktivity sám pozastaví.** Stačí pár requestů denně.
  Během běžícího testu nehrozí; hrozí *mezi* fázemi. Obnovit jde do 90 dnů.
- **Zálohy nejdou na free plánu stáhnout.** Tohle je jediné, co může fázi 0 opravdu
  zabít: výstup testu je jediná věc, kvůli které se dělá. Řešení není upgrade, ale
  pravidelný `pg_dump` na vlastní disk.

Kvóty: 500 MB DB / projekt, **5 GB egress**, 1 GB storage, 50 000 MAU.

## Egress je užší než úložiště — a řídí ho kódování bodů

Odhad na kresbu: ~25 tahů × ~60 bodů = ~1 500 bodů. V jsonb jako `{"x":…,"y":…,"t":…}`
to je řádově **50–75 KB na kresbu**, protože se u každého bodu opakují klíče.

- Úložiště: 500 MB ≈ **6 500–10 000 kreseb**. Na fázi 0 (padesát lidí) dost.
- **Egress: 5 GB / měsíc ≈ 70 000 stažení kresby.** Každé hádání jedno je — a hádá
  se řádově víc, než kreslí. Tohle narazí dřív.

**Ploché pole `[x,y,t,x,y,t,…]` místo objektů zmenší obojí zhruba 3×.** Rozhodnout
před psaním schématu (krok A2), zpětně to znamená migraci dat.

## Region — rozhodnout dřív než vznikne první migrace

`eu-west-1` je Irsko. Pro česky cílený produkt je `eu-central-1` (Frankfurt) blíž,
zhruba o 20 ms na round trip. **Region se u existujícího projektu nemění** — přesun
znamená nový projekt a migraci dat.

Právně je to jedno, obojí je EU. Je to čistě latence. **Teď je projekt prázdný,
takže přesun stojí dvě minuty a nic. Za měsíc s daty už ne.**

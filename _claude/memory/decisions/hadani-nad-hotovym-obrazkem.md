---
name: hadani-nad-hotovym-obrazkem
description: Hádá se nad hotovým obrázkem; přehrání tah po tahu je volitelné tlačítko a odměna po uhodnutí, poměr se měří ve fázi 0
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
---

# Hádá se nad hotovým obrázkem, přehrání je volitelné

**Kontext:** `docs/product.md` původně tvrdil, že hádající vidí přehrání kresby tah
po tahu, **ne** finální obrázek, a označoval to za klíčový zážitek. Majitel to
2026-08-18 opravil: nebyl to jeho záměr.

**Rozhodnutí:**
- **Výchozí zobrazení = hotový obrázek.** Kresba se hádajícímu nevykresluje postupně.
- **Přehrání tah po tahu je volitelné tlačítko.** Hlavní role je až *po* uhodnutí —
  jako odměna a jako export do sdílitelného GIFu.
- **Co je lepší, rozhodne test ve fázi 0** na dvou skupinách (s tlačítkem / bez).

**Důvod — obě strany, protože ani jedna není zjevná:**
- *Pro přehrání:* statický obrázek uhodneš nebo neuhodneš a je to za dvě vteřiny.
  Přehrání dělá z hádání malý příběh a je to jediné, co drží hádání od mechanického
  odklikávání. Navíc je z něj sdílitelný GIF, tedy marketingový kanál zadarmo.
- *Proti:* čekání u každé jednotlivé kresby, které v broadcast modelu platíš stokrát
  za sezení. To je přesně ta daň, kterou asynchronní model nemá důvod platit.

Argumenty jsou vyrovnané, proto se to neřeší názorem, ale měřením. Sledovaná čísla:
počet uhodnutých kreseb na sezení a návrat druhý den.

**Důsledky:**
- Neruší to pravidlo 2 (vektorové tahy). Vektory jsou dál povinné — kvůli undo,
  rozlišení, GIFu a hlavně kvůli časovým značkám pro detekci čmáranic. Přehrání
  je jen jeden z důvodů, ne ten hlavní.
- Fáze 0 musí obě varianty umět a logovat, které skupině byla která podsunuta.
- Změna se promítla do `CLAUDE.md`, `docs/product.md`, `docs/roadmap.md`, `README.md`.

---
name: ctvercove-tlacitko-ve-flex-radku
description: aspect-ratio nevyrobí čtvercové tlačítko vedle roztaženého ve flex řádku — šířka se vyřeší dřív, než align-items stretch roztáhne výšku
type: pattern
status: active
created: 2026-08-19
updated: 2026-08-19
---

# Čtverec vedle roztaženého tlačítka nejde přes `aspect-ratio`

**Zadání:** v patce plátna má být „Smazat" jako čtvereček ve stejné výšce jako
„Odeslat kresbu", které vyplní zbytek řádku.

**Co nefunguje:**

```css
.draw-footer { display: flex; align-items: stretch; }
.draw-footer .icon-btn { width: auto; height: auto; aspect-ratio: 1; }
```

Naměřeno **22 × 55 px** místo 55 × 55. Ve flex řádku se hlavní rozměr (šířka)
vyřeší z obsahu **dřív**, než `align-items: stretch` dopočítá výšku, takže
`aspect-ratio` nemá z čeho šířku odvodit.

**Co funguje** — jedna proměnná pro obojí, takže se rozměry nemůžou rozejít:

```css
.draw-footer {
  --footer-control: 54px;
  display: flex;
  align-items: stretch;
}
.draw-footer .btn { flex: 1; height: var(--footer-control); padding-block: 0; }
.draw-footer .icon-btn { flex: none; width: var(--footer-control); height: var(--footer-control); }
```

Poznámka: `padding-block: 0` na tlačítku je nutné, jinak si výšku určuje
z odsazení a proměnnou ignoruje.

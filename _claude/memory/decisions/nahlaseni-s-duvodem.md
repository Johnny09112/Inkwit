---
name: nahlaseni-s-duvodem
description: Nahlášení kresby má dialog s kódem důvodu (scribble, mismatch, text, offensive, other + text); do teď se posílal natvrdo pořád stejný řetězec, takže hlášení byla k moderaci k ničemu
type: decision
status: active
created: 2026-08-19
updated: 2026-08-19
related: [faze-0-uzavrena-skupina]
---

# Nahlášení kresby s důvodem

**Rozhodnuto 2026-08-19** po zkoušce na telefonu. Majitel hlásil, že tlačítko
„Nahlásit" nefunguje.

## Nefungovalo, nebo mlčelo?

**Fungovalo.** V databázi byla v tu chvíli dvě hlášení, jedno z téhož večera.
Tlačítko ale jen zešedlo a pod řádkem akcí přibyla drobná věta — na telefonu si
toho nikdo nevšimne. **Chyba nebyla v zápisu, ale v tom, že akce nedala najevo,
že proběhla.**

Druhá, horší polovina: `reason` se posílal **natvrdo jako „nevhodný obsah"**
u každého hlášení. Zápis tedy vznikl, ale k moderaci byl k ničemu — nešlo
poznat, jestli jde o čmáranici, nebo o něco, co musí zmizet hned.

## Co teď

Dialog s pěti důvody: `scribble`, `mismatch`, `text`, `offensive`, `other`.
U „jiné" je pole na větu a bez ní se odeslat nedá.

**Ukládá se kód, ne přeložená věta.** Moderace se dělá ze Supabase studia
a nemá cenu tam mít půl hlášení česky a půl anglicky. U „jiné" jde text za
dvojtečku: `other: …`.

## Strop délky na serveru

Tímhle se do `reports.reason` **poprvé dostává text od uživatele** — sloupec je
`text` bez omezení a nic jiného ho nehlídal. `report_drawing()` proto ořezává na
300 znaků (200 z pole plus rezerva na prefix). Ořízne, neodmítne: hlášení je
lepší mít zkrácené než žádné. Hlídá to test.

## Co se přitom ukázalo o dialozích obecně

`.modal` neměl strop výšky ani rolování. U dialogu s textovým polem se na iOS
vždycky otevře klávesnice, takže by tlačítko „Odeslat" skončilo pod ní bez cesty
k němu — **přesně ta chyba, která na iPadu shodila ukládání barvy**. Teď má
`.modal` `max-height: calc(100dvh - 32px)` a `overflow-y: auto`, což pokrývá
i potvrzení odeslání kresby, detail kresby a odchod z plátna.

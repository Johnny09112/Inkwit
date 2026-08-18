# Inkwit — pracovní plán fáze 0

> **Tohle je živý dokument, ve kterém si dopisujeme.** Není to roadmapa (ta je
> v `roadmap.md`) ani rozhodnutí (ta jsou v `_claude/memory/decisions/`).
> Tady se drží **pořadí kroků a jejich stav** — aby se práce nerozjela do šířky.
>
> **Pravidlo: jeden krok = jeden commit = jedno ověření.** Krok se označí za
> hotový teprve když projde jeho kritérium přijetí, ne když je „napsaný".
> Když se ukáže, že krok je špatně navržený, změň ho **tady** a napiš proč.

**Stav k 2026-08-18:** hotové UI všech 10 obrazovek nad mock daty. Backend
neexistuje. Fáze 0 je uzavřená skupina ~50 pozvaných.

## Legenda

`[ ]` čeká · `[~]` rozpracováno · `[x]` hotovo a ověřeno · `[!]` blokováno

## Přehled bloků

| Blok | Co | Stav | Blokuje |
|---|---|---|---|
| **0** | Hotové UI nad mock daty | `[x]` | — |
| **A** | Backend základ — projekt, schéma, RLS, konfigurace, auth | `[~]` | vše ostatní |
| **B** | Obsah — koncepty a přijímané tvary CZ/EN | `[ ]` | D |
| **C** | Kreslení end-to-end | `[ ]` | D |
| **D** | Hádání end-to-end | `[ ]` | F |
| **E** | Retenční smyčka — vyžádání a notifikace | `[ ]` | — |
| **F** | Provoz a měření | `[ ]` | G |
| **G** | Nasazení a pozvánky | `[ ]` | — |

**Proč tohle pořadí.** A blokuje všechno, protože bez schématu se nedá uložit nic.
B běží nezávisle a je to obsahová práce, ne programování — může jet paralelně.
C před D, protože bez kreseb není co hádat. E až po D, protože vyžádání má smysl
teprve když existuje smyčka, do které vstupuje. F před G, protože nasadit
neměřitelnou verzi znamená prošvihnout jediný účel fáze 0.

---

## Blok A — Backend základ

**Účel:** aby existovalo kam ukládat a aby to bylo od začátku bezpečné.

- `[x] A1` **Supabase projekt založen** (2026-08-18) — `Inkwit`, ref
  `aqzrfftvsmkhkldovyfz`, organizace na **free plánu**, region `eu-west-1` (Irsko).
  **K rozhodnutí: region.** Free plán dovoluje dva aktivní projekty a oba jsou
  obsazené (`Customer_finder`, `Inkwit`). Detaily dopadů viz „Free plán" níž.
- `[ ] A2` **Schéma přes migrace.** Tabulky dle `data-model.md`: `concepts`,
  `concept_locales`, `profiles`, `drawings`, `drawing_strokes`, `guesses`,
  `reactions`, `reports`, `concept_requests`, `game_config`, `ledger`.
  *Kritérium:* migrace projde načisto na prázdné DB a `supabase db reset` je
  opakovatelný.
- `[ ] A3` **RLS na všech tabulkách.** Zvlášť: `profiles.reliability` a
  `trust_band` nesmí být čitelné klientem (pravidlo 7).
  *Kritérium:* test, který se přihlásí jako běžný uživatel a **neuvidí** cizí
  `reliability`, cizí rozepsané kresby ani cizí `ledger`. Ne proklikání — test.
- `[ ] A4` **`game_config` a čtení konfigurace.** Odměny, prahy, limity
  (pravidlo 6). *Kritérium:* změna hodnoty v DB se projeví bez deploye.
- `[ ] A5` **Auth pozvánkou + `profiles`.** Fáze 0 nemá veřejnou registraci.
  *Kritérium:* bez platné pozvánky účet nevznikne.

## Blok B — Obsah

**Účel:** bez přijímaných tvarů je hra v češtině nehratelná. Není to
programování, je to kurátorská práce — a je jí víc, než se zdá.

- `[ ] B1` **Sada konceptů pro fázi 0.** Odhad 80–150 konceptů, rozložených po
  obtížnosti 1–3. Označit `is_cross_language` (`zámek`, `trapas` = false).
- `[ ] B2` **Přijímané tvary CZ.** Pády, zdrobněliny, synonyma — `pes, psa, psi,
  pejsek, hafan, štěně`. *Kritérium:* na vzorku 20 konceptů zkusit, co lidi
  reálně napíšou, a doplnit chybějící tvary.
- `[ ] B3` **Přijímané tvary EN.**
- `[ ] B4` **Porovnávací funkce.** Normalizace diakritiky → lowercase → trim →
  shoda → Levenshtein ≤ 1–2 podle délky. *Kritérium:* testy včetně pastí na
  krátká slova (`pes`/`les`/`ves` se nesmí uhodnout navzájem).

## Blok C — Kreslení end-to-end

- `[ ] C1` **Nabídka tří konceptů ze serveru**, s předností vyžádaných (blok E).
- `[ ] C2` **Uložení kresby a tahů.** Klient posílá vektory, **server nevěří
  ničemu** — ani časům tahů. Body jako **ploché pole** `[x,y,t,…]` + encode/decode
  helper v `lib/strokes.ts` (zaokrouhlení na 4 des. místa už při záznamu je hotové).
  *Kritérium:* podvržený `duration_ms` z klienta nemá vliv na uložená data.
- `[ ] C3` **Odvozený náhled.** Bitmapa jen do cache, nikdy jako zdroj pravdy
  (pravidlo 2). Potřeba pro feed a „Moje kresby".
- `[ ] C4` **Moje kresby z reálných dat.** Autorovi se zobrazuje kolik lidí
  uhodlo, **nikdy počet neuhodnutí**.

## Blok D — Hádání end-to-end

- `[ ] D1` **Distribuce.** Které kresby dostane hádač. Ve fázi 0 stačí jednoduché
  a férové (nejstarší neuhodnuté první), bez trust score.
- `[ ] D2` **Serverová validace odpovědi.** Tři pokusy, jedno sezení na kresbu.
  *Kritérium:* čtvrtý pokus přes API neprojde.
- `[ ] D3` **Hvězdičky a palec.** Palec 1×/den **serverově** (pravidlo: vzácný
  hlas). *Kritérium:* druhý palec téhož dne přes API neprojde.
- `[ ] D4` **Přehrání tahů z uložených vektorů.** Tlačítko, ne výchozí zobrazení.

## Blok E — Retenční smyčka

**Tohle nese hlavní hypotézu fáze 0. Když se bude škrtat, škrtá se jinde.**

- `[ ] E1` **`concept_requests`** — tlačítko „chci vidět tenhle pojem", denní
  limit z `game_config`, `expires_at` povinné.
- `[ ] E2` **Přednost vyžádaných konceptů v nabídce kreslíři.** Bez tohohle je
  žádost přání do prázdna.
- `[ ] E3` **Notifikace oběma směry.** Žadateli, že je hotovo; **kreslíři, že
  splnil konkrétnímu člověku konkrétní přání.** Druhá polovina nese retenci —
  je to poslední věc, která smí padnout.
- `[ ] E4` **Notifikace „tvoji kresbu někdo uhodl / dal jí palec".**

## Blok F — Provoz a měření

- `[ ] F1` **Nahlášení a ruční review majitelem.** Fáze 0 nemá klasifikátor,
  proto je uzavřená (pravidlo 8).
- `[ ] F2` **Jeden denní žebříček.**
- `[ ] F3` **Logování metrik.** Zásoba `live` kreseb vzorkovaná v čase, „začal
  kreslit" **zvlášť od** „odeslal", odkud přišel impuls, rozdělení `duration_ms`
  a `stroke_count`.
- `[ ] F4` **A/B skupiny pro přehrání.** Jedna vidí jen obrázek, druhá má
  tlačítko „přehrát". Zaznamenat, kdo je v jaké skupině.

## Blok G — Nasazení a pozvánky

- `[ ] G1` **PWA** — service worker, offline shell, instalace.
- `[ ] G2` **Deploy na Vercel** + napojení na Supabase.
- `[ ] G3` **Pozvánkový tok** pro ~50 lidí.

---

## Co se nedělá ve fázi 0

Vědomě mimo rozsah, ať se to nevrátí zadními vrátky: odznaky a **koruna za
slovo**, ligy, komunity a sledování, uživatelská slovní zásoba, surge, trust
score, kategorie podle zařízení, platby, nativní aplikace, GIF export, tmavý
režim, relay režim.

## Rozhodnutí, která čekají na majitele

1. **Region Supabase projektu.** Inkwit vznikl v `eu-west-1` (Irsko). Pro česky
   cílený produkt je blíž `eu-central-1` (Frankfurt) — zhruba o 20 ms na round trip.
   **Region se u existujícího projektu nemění**; přesun = nový projekt a migrace.
   Teď je projekt prázdný, takže je to úkon na dvě minuty a zdarma. Za měsíc s daty
   už ne. Rozhodnout dřív, než vznikne první migrace.
2. **Tmavý režim** — nerozhodnuto, z palety se neodvodí 1:1. Do fáze 0 nepatří,
   ale ovlivní tokeny.
3. **Kolik neuhodnutí do archivace** a jak škáluje s obtížností (otázka #3
   v `roadmap.md`). Potřeba před D1.
4. ~~**Kódování bodů tahu.**~~ **Rozhodnuto 2026-08-18** (majitel to nechal na mně):
   zaokrouhlení na 4 desetinná místa při záznamu — *hotovo* — a ploché pole
   `[x,y,t,…]` při ukládání, zavede se s C2. Měření a zdůvodnění
   v `_claude/memory/decisions/kodovani-bodu-tahu.md`.

## Free plán — co z něj plyne

Organizace je na free plánu (ověřeno 2026-08-18). Pro fázi 0 to **stačí**, ale tři věci
je potřeba znát dopředu:

- **Dva aktivní projekty na účet, a oba jsou obsazené.** Pozastavené se nepočítají
  (`mas-copilot` a `Johnny09112's Project` jsou pozastavené). Další projekt =
  pozastavit něco, nebo platit.
- **Projekt se po týdnu nízké aktivity sám pozastaví.** Během běžícího testu s padesáti
  lidmi nehrozí; hrozí *mezi* fázemi. Obnovit jde do 90 dnů, data zůstávají.
- **Zálohy nejdou stáhnout.** Tohle je ta nepříjemná. Výstup fáze 0 je jediná věc,
  kvůli které se dělá — když se DB ztratí, ztratí se odpověď. Řešení je pravidelný
  `pg_dump` na vlastní disk, ne upgrade.

Kvóty free plánu: 500 MB DB na projekt, **5 GB egress**, 1 GB storage, 50 000 MAU.

## Log

Sem píšeme, co se změnilo v plánu a proč. Nejnovější nahoře.

- **2026-08-18** — plán založen. Blok 0 (UI nad mock daty) hotový z předchozí
  session. Dořešena koruna za slovo (fáze 1+, viz `_claude/memory/decisions/`).
  Blok A blokován rozhodnutím o Supabase projektu.

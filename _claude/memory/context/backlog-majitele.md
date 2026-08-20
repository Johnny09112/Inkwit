---
name: backlog-majitele
description: Dávka chyb a nápadů od majitele z 2026-08-20 pro MVP — zachyceno doslova, s tříděním a s tím, co je v rozporu s pravidly projektu
type: context
status: active
created: 2026-08-20
updated: 2026-08-20
related: [levely-bez-gati-na-jadro, odkud-pokracovat, slovnik-vyrovnany-pomer-obtiznosti]
---

# Backlog od majitele (dávka 1, 2026-08-20)

Majitel řekl: *„To je zatím vše, ještě jsou další, ale dávkujeme."* Tohle je
**dávka 1**. Očekávej další.

Kontext, který k tomu patří: **SMTP (G4) se odkládá** — „kódy rozdáváme
genericky". Nedořečené zůstalo, jestli to znamená nepersonalizovaně (jeden kód
na hlavu, pak je vše v pořádku), nebo jeden kód pro víc lidí (pak je potřeba
zvýšit `max_uses`, dnes je u všech 50 kódů `1`).

---

## Postup (2026-08-20 odpoledne)

Majitel zvolil pořadí **chyby → levné úpravy → meta-vrstva** a vyžádaná slova
nechal ve veřejné hře.

- **Hotovo:** všechny čtyři chyby · výchozí barvy · kovy u obtížností ·
  zámeček s vysvětlením · **cesta levely v profilu**.
- **Zbývá z vlny 3:** vlastní kreslený avatar (oslava postupu hotová).
- **Pak:** přeskočení za kredit (a s ním sink), denní výzva, dětský režim,
  výplň uzavřených tvarů, achievementy, metriky v žebříčcích.

## Chyby

| # | Co | Stav |
|---|---|---|
| 1 | Text „po uhodnutí" u výběru pojmu láme řádek; šipka pryč (stejně jen označuje) | opraveno |
| 2 | Přepínání Kreslit/Hádat/Moje/Žebříčky trvá extra dlouho | opraveno — chyběla `loading.tsx`, viz [[prepnuti-zalozky-zamrzlo-bez-hranice-nacitani]] |
| 3 | „Opět rozbitá paleta viz obrázek" | **nebyla to paleta, byl to posuvník** — viz [[lista-nastroju-ma-pevny-rozpocet]] |
| 4 | Vybrané barvy se přeskakují; prstenec je moc velký a usekává se | opraveno |

**Kořeny, které jsou jisté:**
- #4a: `app/[locale]/draw/page.tsx` — `pickColor` dělá
  `setRecent([c, ...r.filter(...)])`, takže vybraná barva skáče na začátek řady.
  Majitel chce **pevnou paletu**: barva zůstane, kde je, klik ji jen označí.
- #4b: `.swatch.is-active` má `outline` s `outline-offset: 2px`, ale rodič
  `.swatch-row-colors` má `overflow: hidden` — ten prstenec ořízne.
- #1: `pick-card-tags` drží `Badge` + text odměny v jednom řádku, na úzku se láme.

---

## Nápady — a co je u nich problém

### Bez problému, levné

- **Výchozí 8 barev** na standard jako u osmibarevných pastelek.
- **Barvy obtížností**: snadné bronz · střední stříbro · těžké zlato.
- **Zámeček u zamčených funkcí** + pop-up „otevře se na levelu X, progres v profilu".
  (`.icon-btn.is-locked` už existuje z tvarů.)
- **Přeskočit kresbu za −1 kredit.** Pozor: je to zároveň **první sink kreditů**
  (bod `J4`), takže řeší otevřený problém. Ale na levelu 1 s nulou kreditů se
  přeskočit nedá vůbec — potřebuje to promyslet.

### Meta-vrstva — `CLAUDE.md` říká „ne dřív, než je ověřeno, že lidé kreslí"

- Roadmapa levelů v profilu (graficky, piktogramy, prahy).
- Oslava postupu na level přes celou obrazovku (blur, girlandy, animace).
- Vlastní kreslený avatar + prstenec postupu + level v rohu.
- Achievementy (majitel chce řešit samostatně).
- Podrobnější metriky v žebříčcích (den/týden/měsíc/rok + statistiky u slov,
  přístupné z „Moje" po nakreslení).

Není to zákaz, je to pořadí. Majitel to může přebít, ale musí to vědět.

### Konflikty s rozhodnutími, která už padla

1. **„Vyžádaná slova až do party režimu."** `docs/plan.md`, blok E:
   *„Tohle nese hlavní hypotézu fáze 0."* Vyžádání je jediná věc, která ve fázi 0
   měří, jestli cizí akce vrací člověka **ke kreslení** — a to je otevřená
   otázka #1 v `roadmap.md`, označená jako *„nejvážnější díra návrhu"*.
   Vyndat ho z veřejné hry = fáze 0 přestane měřit to, kvůli čemu je.
2. **Přítlak na Apple Pencil.** `DrawingCanvas` má v komentáři:
   *„Uniformní štětec: tlak pera se záměrně nečte (férovost napříč zařízeními)."*
   Kdo má pero, dostane hezčí tah než kdo kreslí prstem.
3. **Dětský režim pro 3–5 let.** Naráží na pravidlo 8 (žádná kresba veřejně před
   automatickou kontrolou obsahu — klasifikátor neexistuje) a na otevřenou
   otázku #6 v `roadmap.md` (věková brána ve veřejné hře). Předškolák ve
   veřejném feedu nemoderovaných kreseb je jiná kategorie rizika než dospělý.
4. **Výplň (kbelík).** Majitel ví, že jsem řekl ne, a chce protinávrh.
   Odpověď: **výplň uzavřeného tvaru ano, kbelík na libovolné pixely ne** —
   viz `decisions/levely-bez-gati-na-jadro.md`.

### Zapsáno na později (majitel sám řekl „až bude vhodný čas")

- **Úvodní obrazovka / menu jako rozcestník** na víc druhů her (týmy, variace).
  Návrh nechá udělat Claude Design. **Explicitně požádal, ať si to zapíšu.**
- **Party režim** v uzavřené komunitě — tam patří vyžádání vlastního slova.
- **Platební brána** — „až časem".
- **Další nástroje** — tužka, víc štětců, fix.
- **Super-těžká denní výzva** — majitelův nápad: nakreslit jednu a uhodnout
  jednu, kombinace +15 kreditů. Pravidla mám navrhnout já.

---

## Co majitel chce, abych navrhl já

1. Co by pomohlo výplni.
2. Pravidla denní výzvy.
3. Další nápady k dětskému režimu.
4. Animace u oslavy levelu.

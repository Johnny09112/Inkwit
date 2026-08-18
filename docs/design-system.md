# Inkwit — design system

> **Stav: úvodní návrh (2026-08-18).** Držíme se ho, dokud ho vědomě nezměníme —
> ale fix to není. Když návrh obrazovky ukáže, že něco nefunguje, změň to tady
> a napiš proč. Doplňkové odstíny a nové role se přidávají sem, ne ad hoc do komponent.
>
> UI kit (komponenty, stavy, spacing, type scale) zatím **neexistuje** — dodá se,
> až budou navržené obrazovky. Do té doby jsou zdrojem pravdy jen barvy a fonty níž.

## Barevná paleta — „Oves a oliva"

Teplý ovesný podklad, olivová jako primární akce, jantarový akcent. Vědomě se drží
dál od saturovaných modrofialových palet skribbl/Gartic rodiny.

### Základ

| Role | Token | Hex |
|---|---|---|
| pozadí aplikace | `--bg` | `#F3ECDF` |
| plátno / karta | `--surface` | `#FFFCF5` |
| text | `--text` | `#2B261F` |
| primární akce | `--primary` | `#52633A` |
| primární akce, hover | `--primary-hover` | `#43522F` |
| akcent | `--accent` | `#E9B44C` |
| chybový stav | `--danger` | `#B5462F` |

### Doplňkové

| Role | Token | Hex |
|---|---|---|
| text sekundární | `--text-secondary` | `#4A443C` |
| text tlumený | `--text-muted` | `#7A7266` |
| okraj | `--border` | `#E0D5C1` |
| okraj silnější | `--border-strong` | `#CFC1A6` |
| tint akcentu | `--accent-tint` | `#FBEFD4` |
| tint olivové | `--primary-tint` | `#E7EADF` |
| tint chyby | `--danger-tint` | `#F6E0D9` |

### Pravidla použití

- **Plátno kresby je `--surface`, ne `--bg`.** Kresba musí sedět na nejsvětlejší ploše
  v celém rozhraní — je to obsah, kvůli kterému tu produkt je.
- **Akcent není akční barva.** `--accent` je pro zvýraznění (hvězdičky, odznaky,
  vyžádaná kresba), nikdy pro primární tlačítko. Primární akce je vždycky olivová.
- **Barva sama nikdy nenese význam.** Obtížnost, stav kresby ani chyba se nesmí
  poznat jen podle odstínu — vždy plus text, ikona nebo tvar.

### Kontrast (ověřeno výpočtem, WCAG 2.1)

Kombinace, které **procházejí AA pro běžný text** (≥ 4.5:1):

| Kombinace | Poměr |
|---|---|
| `--text` na `--bg` / `--surface` | 12.8 / 14.6 |
| `--text-secondary` na `--bg` / `--surface` | 8.2 / 9.4 |
| `--surface` na `--primary` / `--primary-hover` | 6.4 / 8.2 |
| `--primary` jako text na `--bg` / `--surface` | 5.6 / 6.4 |
| `--danger` jako text na `--bg` / `--surface` | 4.6 / 5.3 |
| `--text` na `--accent` | 7.9 |
| `--text` na `--accent-tint` | 13.1 |
| `--primary` na `--primary-tint` | 5.4 |

Tři místa, kde paleta **neprochází** a je potřeba to obejít:

1. **`--text-muted` na `--bg` = 4.04.** Na ovesném pozadí ho nepoužívej pro běžný text —
   jen na `--surface` (4.63 ✓), nebo od velikosti ≥ 18.7 px bold / 24 px regular,
   kde stačí 3:1.
2. **`--danger` na `--danger-tint` = 4.27.** Pro text v chybové plachetce použij `--text`;
   `--danger` tam nech jen na ikonu, okraj a nadpis ve velkém řezu.
3. **Okraje mají 1.2–1.7:1**, tedy hluboko pod 3:1, které WCAG 1.4.11 chce po hranicích
   ovládacích prvků. `--border` a `--border-strong` jsou proto **dekorativní** (dělicí
   linky, obrys karty). Hranice inputů, checkboxů a focus ring musí být tmavší —
   minimálně `--text-muted` (4.04 vs. `--bg` ✓), u focus ringu radši `--primary`.

Dvě věci z toho plynou natvrdo: **na `--accent` patří jen tmavý text** (`--surface`
na akcentu je 1.85, nečitelné), a **`--accent` jako plocha proti `--bg` má 1.61**,
takže jantarová plocha sama sebe od pozadí neodliší — potřebuje okraj nebo tmavý obsah.

### Tmavý režim

**Nerozhodnuto.** Paleta je navržená jako světlá a tmavá varianta se z ní odvodit
1:1 nedá (ovesná teplota v tmavém režimu zšedne). Řeší se s UI kitem, ne teď.

## Fonty

| Role | Font | Řezy |
|---|---|---|
| nadpisy | **Bricolage Grotesque** | 600, page title 800 |
| text | **IBM Plex Sans** | 400 / 500 / 600 |
| štítky | **IBM Plex Mono** | 11 px, uppercase |

- Všechny tři pokrývají **Latin Extended**; česká diakritika ověřena v ukázkách.
  Nový font se do systému nepřidá, dokud tohle neprojde — dvojjazyčnost CZ + EN
  je pravidlo od prvního dne.
- **Štítky (mono, 11 px, uppercase)** jsou pro popisky a metadata: obtížnost, počet
  uhodnutí, stav kresby. Doporučené `letter-spacing: 0.06em` — bez něj je uppercase
  mono na 11 px slitý.
- Type scale (velikosti nadpisů, řádkování, spacing) **není určená** — přijde s UI kitem.

### Načítání: nerozhodnuto

Fonty jsou zatím **linkované z Google Fonts**. Alternativa je self-host přes
`next/font/local`, k tomu je potřeba dodat binárky (woff2). Rozhodnout před fází 0:
self-host je jeden request navíc odbouraný, žádná třetí strana v render path a
lepší LCP na PWA, ale je to ruční správa souborů. Argument pro self-host je u tohoto
projektu silnější (PWA, offline-friendly), takže výchozí návrh je **self-host, jakmile
budou binárky** — do té doby Google Fonts.

## Co ještě chybí

- UI kit: komponenty, stavy (hover / focus / disabled / loading), spacing, type scale.
- Tmavý režim.
- Kreslicí plátno: barvy štětce a paleta pro kreslíře jsou **jiný problém** než UI barvy
  a tenhle dokument je neřeší.

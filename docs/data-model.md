# Inkwit — datový model

Postgres / Supabase. RLS zapnuté na všech tabulkách. Níže je návrh, ne finální migrace — sloupce doplň podle potřeby, ale **strukturu konceptů, tahů a tenantů neměň bez rozmyslu**, protože se špatně mění zpětně.

## Slovní zásoba: koncepty, ne překlady

Nejdůležitější rozhodnutí celého schématu. Slovo **není řetězec**, je to entita s jazykovými variantami.

```
concepts
  id
  difficulty          smallint  1..3
  category            text      zvíře / předmět / činnost / abstraktní / ...
  is_cross_language   boolean   false = jen pro jednojazyčné hry
  is_school_safe      boolean
  status              active | retired

concept_locales
  concept_id  → concepts
  locale      'cs' | 'en'
  prompt      text      co se ukáže kreslíři
  accepted    text[]    VŠECHNY přijímané tvary odpovědi
  hint        text      volitelné
  UNIQUE (concept_id, locale)
```

**Pravidla:**
- Kreslíř kreslí **koncept**. Hádající hádá ve **svém** jazyce. Nikdy se nepřekládá za běhu.
- `accepted` musí u češtiny pokrýt pády, zdrobněliny a synonyma: `pes, psa, psi, pejsek, hafan, štěně`. Bez toho je hra nehratelná.
- Porovnání odpovědi: normalizace diakritiky → lowercase → trim → shoda proti `accepted` → fallback Levenshtein ≤ 1–2 podle délky (překlepy).
- Koncepty bez čistého protějšku (`zámek` = castle i lock, `trapas`) → `is_cross_language = false`. Nepouštět je do cross-language her.
- `is_school_safe` je opt-in, ne opt-out.

## Kresba a tahy

```
drawings
  id
  author_id           → profiles
  concept_id          → concepts
  source_locale       'cs' | 'en'    v jakém jazyce byl prompt
  tenant_id           → tenants      NULL = veřejná hra
  status              draft | pending_review | live | archived | removed
  device_kind         mouse | touch | pen
  duration_ms         int
  stroke_count        int
  undo_count          int
  coverage            real           podíl plochy bounding boxu
  effort_score        real           odvozeno, viz product.md
  guess_count         int
  solved_count        int
  thumbs_count        int
  created_at          timestamptz
  published_at        timestamptz
```

```
drawing_strokes
  drawing_id  → drawings
  seq         int
  author_id   → profiles   -- u běžné kresby = autor; nutné pro atribuci v relay režimu
  tool        pen | brush | eraser
  color       text
  width       real
  points      jsonb    [{x, y, t, p}]  t = ms od začátku tahu, p = tlak 0..1
```

**Nikdy neukládat kresbu jako PNG.** Vektory dávají přehrání, undo, libovolné rozlišení, řádově menší úložiště a hlavně signály pro detekci čmáranic (bez `t` v bodech nemáš rytmus kreslení). Bitmapa se generuje jen jako odvozený náhled do cache.

Souřadnice normalizovat na 0..1 vůči plátnu, ne v pixelech — jinak se kresba z iPadu nezobrazí správně na mobilu.

## Hádání a hodnocení

```
guesses
  id
  drawing_id  → drawings
  user_id     → profiles
  locale      'cs' | 'en'
  attempt_no  1..3
  text_raw    text
  is_correct  boolean
  created_at  timestamptz
  UNIQUE (drawing_id, user_id, attempt_no)
```

```
reactions
  drawing_id, user_id, kind ('thumb'), created_at
  UNIQUE (drawing_id, user_id)
  -- limit 1 palec na uživatele a den se vynucuje serverově
```

```
reports
  drawing_id, reporter_id, reason, status, resolved_by, created_at
```

Jeden uživatel smí hádat každou kresbu **jen jednou** (max tři pokusy v rámci jednoho sezení). Vynucuj serverově, ne v UI.

## Vyžádání kresby

Nese hlavní retenční hypotézu (viz `docs/product.md`, sekce Retence), proto je v minimální verzi už ve fázi 0 — ne až s ekonomikou žádostí.

```
concept_requests
  id
  concept_id      → concepts
  requester_id    → profiles
  locale          'cs' | 'en'     v jakém jazyce chce žadatel hádat
  status          open | fulfilled | expired
  fulfilled_by    → drawings      NULL, dokud nikdo nenakreslil
  created_at      timestamptz
  expires_at      timestamptz
  UNIQUE (concept_id, requester_id) WHERE status = 'open'
```

**Pravidla:**
- **Otevřená žádost zvedá prioritu konceptu v nabídce tří konceptů kreslíři.** Nabídka není náhodná — vyžádané koncepty jdou dopředu. Bez tohohle je žádost jen přání do prázdna.
- **Notifikace jdou oběma směry.** Žadateli, že je hotovo; kreslíři, že splnil konkrétnímu člověku konkrétní přání. Druhá polovina je ta, která nese retenci — bez ní je to jen fronta úkolů.
- **Splní ji kterákoli kresba toho konceptu**, ne konkrétní kreslíř. Cílení je až fáze 1.
- **`expires_at` je povinné.** Otevřené žádosti se samy uklidí — jinak vzniká fronta, kterou musí někdo ručně čistit, což je přesně to, co si projekt nemůže dovolit.
- **Denní limit žádostí na uživatele** patří do `game_config`, ne do kódu. Bez limitu je to spam kanál.
- Veřejná hra jen. Uvnitř školního tenantu žádosti nejsou — koncepty tam volí učitel.

## Uživatel a trust

```
profiles
  id                → auth.users
  display_name
  locale_primary
  locale_guessing   text[]
  level, xp
  reliability       real     0..1, interní, NIKDY se nezobrazuje
  trust_band        new | verified | trusted
  skill_rating      real     ovlivňuje doporučování a žebříčky
  is_minor          boolean
  tenant_id         → tenants   NULL = veřejný uživatel
```

`reliability` a `trust_band` nesmí být čitelné klientem. Přes RLS je vystav jen serveru.

## Tenanty (školy a firmy)

```
tenants
  id
  kind          school | company
  name
  owner_id      → profiles
  plan          free | paid | partner    -- partner = ručně udělená volná licence
  join_code     text
```

**Izolace školního tenantu je tvrdá:**
- `drawings.tenant_id IS NOT NULL` → kresba se **nikdy** neobjeví ve veřejné distribuci a naopak.
- Uvnitř školního tenantu: žádné volné textové zprávy mezi žáky, žádné profily a sledování, žádné uživatelské slovníky, jen učitelem zvolené sady konceptů.
- Studentský účet nemá e-mail — vzniká přes `join_code` od učitele.
- Vynucuj to na úrovni **RLS politik**, ne aplikační logikou. Aplikační kontrola se dá obejít chybou; RLS ne.

## Ekonomika a konfigurace

```
game_config
  key      text primary key
  value    jsonb
  updated_at
```

Všechny odměny, prahy, surge koeficienty, počty neuhodnutí do archivace a rate limity žijí tady. **Nikdy jako konstanty v kódu** — jinak budeš ladit balanc v release cyklech místo v hodinách.

```
ledger
  user_id, delta, reason, ref_id, created_at
```

Append-only. Body a kredity nikdy nepřepisuj, vždy přičítej záznam — jinak nedohledáš, kde se rozbil balanc.

## Co logovat pro vyhodnocení testu

Bez tohohle se nedají přečíst metriky z CLAUDE.md:
- zásoba `live` kreseb s `solved_count < N`, vzorkovaná v čase
- událost „uživatel začal kreslit" zvlášť od „odeslal" (drop-off v kreslení je klíčové číslo)
- odkud přišel impuls ke kreslení: surge / vyžádání / vlastní iniciativa
- rozdělení `duration_ms` a `stroke_count` — z toho se kalibruje detekce čmáranic

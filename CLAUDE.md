# Inkwit

Asynchronní kreslicí a hádací hra. Web-first (PWA), dvojjazyčná CZ + EN od prvního dne.

> Pracovní název. Repozitář, DB a balíčky = `inkwit`. Branding a doména se řeší až před spuštěním — nepřejmenovávat kód kvůli marketingu.

## Co to je jednou větou

Nakreslíš zadaný pojem, tvoje kresba jde do komunity, lidé ji hádají na tři pokusy ve svém jazyce a hodnotí ji. Není to real-time lobby hra (skribbl, Gartic) ani hra pro dvojici (Draw Something) — je to **asynchronní komunita kolem kreseb, které zůstávají**.

## Povaha projektu

Cílem je **mít produkt na světě**; příjem je bonus, ne podmínka. Majitel na tom pracuje part-time vedle jiných projektů, takže **nejvzácnějším zdrojem je jeho čas, ne peníze.**

Praktický dopad na každé rozhodnutí: nenavrhuj nic, co vyžaduje pravidelnou lidskou obsluhu, a neoptimalizuj pro škálu, které produkt pravděpodobně nedosáhne. Když volíš mezi dvěma řešeními, vyhrává to s nižšími provozními nároky, ne to výkonnější.

## Neporušitelná pravidla

Tyhle věci nejsou feature, jsou to omezení architektury. Nikdy je neobcházej bez explicitního souhlasu majitele projektu.

1. **Školní tenant je tvrdě izolovaný.** Žádný veřejný obsah dovnitř ani ven, žádné volné textové zprávy mezi žáky, žádné profily ani sledování, žádné uživatelské slovníky. Student nemá e-mail, jen kód od učitele. Důvod: nezletilí, GDPR/COPPA/DSA. Retrofit by znamenal přepis datového modelu.
2. **Kresba se ukládá jako vektorové tahy, nikdy jako bitmapa.** Umožňuje to přehrání kresby (klíčová funkce), undo, libovolné rozlišení a drží to náklady na egress. Bitmapa se generuje až jako odvozený náhled.
3. **Žádné pay-to-win.** Placené ani vysloužené funkce nesmí ovlivnit férovost: žádné pokusy navíc, násobiče bodů, výhody v žebříčku.
4. **Slovní zásoba jsou koncepty, ne překlady.** Nikdy nepřekládej za běhu. Viz `docs/data-model.md`.
5. **Žádné reklamy.** Nikdy, ani ve free verzi. Monetizace jde přes firemní místnosti a prémiové funkce.
6. **Balanc odměn je serverová konfigurace, ne konstanty v kódu.** Musí jít měnit bez deploye.
7. **Trust score se uživateli nikdy nezobrazuje jako číslo** a prahy se nezveřejňují.
8. **Žádná kresba se nezobrazí veřejně před automatickou kontrolou obsahu.**

## Stack

- **Frontend:** Next.js (App Router), TypeScript, PWA. Kreslicí plátno přes `PointerEvent` — sjednotí myš, prst i pero a rovnou dá typ zařízení a tlak.
- **Backend:** Supabase (Postgres, Auth, Storage, Realtime), RLS zapnuté všude.
- **Hosting:** Vercel.
- **Platby:** Stripe na webu. **Ne** in-app purchases — nativní aplikace přijdou později a slouží k akvizici a notifikacím, ne k účtování.
- **i18n:** `next-intl` nebo ekvivalent. Žádné hardcoded stringy v komponentách.

## Konvence

- TypeScript strict. Žádné `any` bez komentáře proč.
- Databázové migrace přes Supabase migrations, nikdy ruční změny ve studiu.
- Názvy tabulek a sloupců `snake_case`, TS `camelCase`, mapování na hranici.
- Peníze v celých centech (`integer`), nikdy `float`.
- Časy v UTC, `timestamptz`.
- Každý zápis, který mění stav hry, prochází serverovou validací. Klientu se nevěří nic — ani časy tahů.

## Kde je co

- `docs/product.md` — herní smyčka, bodování, trust score, moderace, anti-čmáranice
- `docs/data-model.md` — schéma, koncepty a jazykové varianty, stavy kresby
- `docs/roadmap.md` — rozsah MVP, monetizace, metriky, otevřené otázky

## Metriky, podle kterých se rozhoduje

Pokud návrh funkce nezlepšuje jedno z těchto čísel, pravděpodobně do MVP nepatří:

1. **Podíl týdně aktivních, kteří nakreslí aspoň jednu kresbu.** Cíl 15–25 %.
2. **Zásoba neuhodnutých kreseb na jednoho aktivního hádače.** Když padá k nule, produkt umírá.
3. **Návrat ke kreslení druhý den.** Pod ~20 % neuchrání produkt žádná meta-vrstva.

## Čemu se vyhnout

- Nestav meta-vrstvu (odznaky, žebříčky, komunity, surge) dřív, než je ověřeno, že lidé dobrovolně kreslí.
- Nepřidávej real-time multiplayer do hlavní hry. Jediná plánovaná výjimka je **relay režim** pro firemní a školní tenanty ve fázi 3 — jako oddělený engine, ne jako mód veřejné hry. Do té doby o něm neuvažuj.
- Nepoužívej název ani vizuál blízký skribbl/Gartic rodině.
- Neposílej AI do role soudce kvality. Jen jako prvního hádače a detektor napsaného textu v obrázku.

## Paměť (long-term memory)

Tento projekt má dlouhodobou paměť v repu, ve složce `_claude\`. Je verzovaná gitem — patří sem projektová fakta, ne osobní preference (ty jdou do osobního vaultu).

**Na startu session** (po auto-injektovaném `auto-memory/MEMORY.md`):
1. Přečti `_claude\memory\INDEX.md` — katalog záznamů.
2. Přečti `_claude\memory\context\project-context.md` — živý stav.
3. Načti relevantní záznamy dle úkolu. Mechanika: `_claude\BOOTSTRAP.md`. Invarianty: `_claude\policies.md`.

**Zapiš OKAMŽITĚ (event-triggered, ne na „konec session" — ten nepoznáš) když:**
1. Učiníš architektonické rozhodnutí → `_claude\memory\decisions\`
2. Vyřešíš netriviální bug (root cause) → `_claude\memory\bugs\`
3. Objevíš projektovou konvenci / skrytou závislost / gotchu → `_claude\memory\patterns\`
4. Narazíš na chybu/varování/lint issue → `_claude\memory\code-issues\` (ihned; po opravě → `_archive\`)
5. Dokončíš milník / ucelený krok → přepiš `_claude\memory\context\project-context.md`
6. Dostaneš feedback „dělej / nedělej takhle" → `_claude\auto-memory\feedback\`

**Single source of truth:** pravidla paměti žijí v `_claude\policies.md` a `_claude\BOOTSTRAP.md`, ne tady. Tento blok je jen ukazatel + triggery.

**Routing:** *Platí to i pro jiné projekty?* Ano → osobní vault (`~\.claude\vault\`, mimo git). Ne → sem.

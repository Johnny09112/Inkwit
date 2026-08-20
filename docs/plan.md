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

## Nasazování migrací

Migrace do Supabase pouští Claude sám přes `npx supabase db push` — CLI má
přihlášení uložené z uživatelova `supabase login`. Po každém push se kontroluje
Supabase security advisor.

**Destruktivní migrace** (drop tabulky nebo sloupce, přetypování se ztrátou dat)
se ukazují uživateli PŘED spuštěním. Přidávání tabulek, indexů a politik jde rovnou.

Lokální ověření běží na PGlite (`npm run test:db`) — Docker není potřeba.

## Legenda

`[ ]` čeká · `[~]` rozpracováno · `[x]` hotovo a ověřeno · `[!]` blokováno

## Přehled bloků

| Blok | Co | Stav | Blokuje |
|---|---|---|---|
| **0** | Hotové UI nad mock daty | `[x]` | — |
| **A** | Backend základ — projekt, schéma, RLS, konfigurace, auth | `[x]` | — |
| **B** | Obsah — koncepty a přijímané tvary CZ/EN | `[x]` | — |
| **C** | Kreslení end-to-end | `[x]` | D |
| **D** | Hádání end-to-end | `[x]` | F |
| **E** | Retenční smyčka — vyžádání a notifikace | `[x]` | — |
| **F** | Provoz a měření | `[x]` | G |
| **G** | Nasazení a pozvánky | `[~]` | — |
| **H** | Správa: moderace, čísla, účty | `[x]` | — |

**Proč tohle pořadí.** A blokuje všechno, protože bez schématu se nedá uložit nic.
B běží nezávisle a je to obsahová práce, ne programování — může jet paralelně.
C před D, protože bez kreseb není co hádat. E až po D, protože vyžádání má smysl
teprve když existuje smyčka, do které vstupuje. F před G, protože nasadit
neměřitelnou verzi znamená prošvihnout jediný účel fáze 0.

**Blok H přibyl 2026-08-20** a obrací dřívější rozhodnutí u kroku F3 („fáze 0
administrátorské rozhraní nemá"). Platilo, dokud šlo o čtení čísel; neplatí pro
moderaci — nahlášení je akce uživatele, na kterou musí někdo odpovědět, a fronta,
kterou nikdo nevidí, je totéž jako žádná. V okamžiku rozhodnutí ležela
v `public.reports` tři neviděná hlášení.

---

## Blok A — Backend základ

**Účel:** aby existovalo kam ukládat a aby to bylo od začátku bezpečné.

- `[x] A1` **Supabase projekt založen** (2026-08-18) — `Inkwit`, ref
  `iticpkeqirjfwkelhrvl`, region **`eu-central-1`** (Frankfurt), free plán.
  První pokus vznikl omylem v `eu-west-1` a byl zahozen a založen znovu, dokud
  byl prázdný. Free plán dovoluje dva aktivní projekty a oba jsou obsazené
  (`Customer_finder`, `Inkwit`) — dopady viz „Free plán" níž.
- `[x] A2` **Schéma přes migrace.** 14 tabulek v `supabase/migrations/`.
  Přibyly oproti `data-model.md` dvě: `concept_answers` a `profile_trust` —
  obojí kvůli tomu, že RLS je řádková a sloupec skrýt neumí.
  *Ověřeno:* `npm run test:db` pouští migrace na prázdné DB.
- `[x] A3` **RLS na všech 14 tabulkách**, + pohled `feed_drawings`, který
  hádajícímu nepustí `concept_id`.
  *Ověřeno:* 22 testů v `supabase/tests/rls.test.mjs`, včetně izolace školního
  tenantu, denního limitu palce a čtvrtého pokusu o uhodnutí.
- `[x] A4` **`game_config`** — 14 klíčů, z toho 9 veřejných. Prahy trust score
  a koruny jsou neveřejné (pravidlo 7) přes sloupec `is_public`.
  *Zbývá ověřit:* že se změna hodnoty projeví bez deploye — až bude co číst (blok C).
- `[x] A5` **Auth pozvánkou.** Tabulky `invites` a `invite_redemptions`,
  trigger `private.enforce_invite()` nad `auth.users`. Vypínatelné klíčem
  `signup_requires_invite` v `game_config` — vypnout znamená zveřejnit hru,
  takže ne dřív, než běží klasifikátor obsahu.
  *Ověřeno:* 11 testů — bez kódu, vymyšlený, zrušený, prošlý i vyčerpaný kód
  účet nezaloží; platný ano a podruhé už ne. S účtem vzniká profil i trust záznam.

**Vygenerování pozvánek** (majitel nebo Claude přes `supabase db push` / SQL):

```sql
insert into public.invites (code, note)
select private.new_invite_code(), 'fáze 0 — tester ' || g
from generate_series(1, 50) g;
```

`invites.tenant_id` je připravené na fázi 2: žák nemá e-mail a vstupuje kódem
od učitele, takže účet rovnou vzniká uvnitř tenanta. Doplnit zpětně by znamenalo
sahat na zakládání účtů, což je nejcitlivější místo schématu.

## Blok B — Obsah

**Účel:** bez přijímaných tvarů je hra v češtině nehratelná. Není to
programování, je to kurátorská práce — a je jí víc, než se zdá.

- `[x] B1` **Sada konceptů — odsouhlaseno a nasazeno** (300 konceptů v databázi).
  300 pojmů v `supabase/seed/concepts.json`: **100 snadných, 100 středních,
  100 těžkých** v šesti kategoriích. Jen jednojazyčné: `zámek`, `trapas`,
  `štěstí`, `raketa`, `list`.

  **Proč vyrovnaný poměr, a ne 50/33/17 z první sady.** `offer_concepts()`
  nabízí jeden pojem od KAŽDÉ obtížnosti a vylučuje jen to, co ten člověk už
  kreslil. Buckety se tedy vyčerpávají stejně rychle bez ohledu na svou
  velikost — při 58/40/22 došly těžké 2,6× dřív než snadné a alarm v `/admin`
  svítil právě na nich. Ventil pro toho, kdo neumí kreslit, drží struktura
  nabídky, ne počet snadných pojmů.
- `[~] B2` **Přijímané tvary CZ** — 983 tvarů. Plné skloňování tam
  VĚDOMĚ není; spoléhá se na normalizaci a fuzzy shodu. *Zbývá kritérium:*
  na vzorku zkusit, co lidé reálně napíšou.
- `[~] B3` **Přijímané tvary EN** — 695 tvarů.
- `[x] B4` **Porovnávací funkce** — hotová, bez rozšíření Postgresu. Normalizace diakritiky → lowercase → trim →
  shoda → fuzzy pro překlepy.

  **Prahy fuzzy shody podle délky — podloženo daty, ne odhadem.** Kontrola sady
  našla **22 dvojic tvarů kratších než pět znaků, které se liší jediným znakem**
  a patří RŮZNÝM pojmům: `pes`/`děs`, `slon`/`shon`, `výr`/`sýr`, `dům`/`dub`,
  `klíč`/`klid`, `duha`/`duna`, anglicky `cat`/`bat`/`car`, `bear`/`pear`/`fear`,
  `sun`/`run`/`bun`, `book`/`boot`/`bolt`. Levenshtein ≤ 1 by je zaměnil.

  Platí: **do 4 znaků jen přesná shoda**, 5–7 znaků vzdálenost 1, 8+ vzdálenost 2.
  Prahy jsou v `game_config` (`fuzzy_exact_below`, `fuzzy_one_below`).

  *Kritérium splněno.* `check-concepts.mjs` projíždí všechny dvojice tvarů
  ze všech pojmů na skutečné prahy (ne jen krátká slova, jak to dělal do
  2026-08-20). Na nasazených 120 pojmech našel **jedenáct dvojic, které si hra
  pletla** — mimo jiné `sheep`/`sleep`, `mouse`/`house`, `clock`/`lock`.
  U těch tří stojí na obou stranách ZADÁNÍ, takže v datech se opravit nedaly.

  **Pojistka (migrace `20260820160000`):** tolerance překlepů se nepoužije na
  tip, který je PŘESNOU odpovědí jiného pojmu. Kdo napsal `sleep` na kresbu
  ovce, se nepřeklepl — napsal jiné slovo, které umí. Přesná shoda se svým
  pojmem má pořád přednost. Drží to normalizovaný rejstřík
  `private.answer_index`, který udržuje trigger nad `concept_answers`.
  Bez toho by každá další stovka pojmů přidávala další takové dvojice.

## Blok C — Kreslení end-to-end

- `[x] C0` **Supabase klient + přihlašovací obrazovka.** `@supabase/ssr`, session
  v middlewaru vedle next-intl, obrazovka `/login` v tokenech design systému,
  odhlášení v profilu.
  *Ověřeno:* všech 6 herních tras přesměruje nepřihlášeného na `/login`, jazyk
  i návratová cesta se zachovají (`/en/guess` → `/en/login?dal=/guess`).
  Trigger pozvánky se zapojí i do ostré registrační cesty — ověřeno proti
  Supabase, neplatný kód vrací HTTP 500 s errcode `23514` a účet nevznikne.

  **Potvrzování e-mailu je vypnuté** (rozhodnuto 2026-08-18). Bránou je pozvánka,
  ne schránka. Nastavení žije v `supabase/config.toml` a nasazuje se přes
  `npx supabase config push` — POZOR, ten soubor je zdroj pravdy a příští push
  přepíše změny udělané v dashboardu. Před veřejným spuštěním se potvrzování
  musí zapnout spolu s vlastním SMTP.

  **Jméno v profilu je unikátní** a volí si ho uživatel při registraci. Kontrola
  volnosti běží během psaní, unikátnost vynucuje databáze. Obsazené jméno
  pozvánku nespotřebuje — ověřeno testem i naostro.
- `[x] C1` **Nabídka tří konceptů ze serveru** — RPC `offer_concepts()`.
  Jeden koncept od každé obtížnosti, vyžádané mají přednost a je u nich vidět,
  kdo čeká. Uvnitř tenanta jen `is_school_safe` (pravidlo 1). Nenabízí, co už
  člověk kreslil; když dojdou, radši zopakuje než vrátí prázdno.
  *Ověřeno:* 5 testů.
- `[x] C2` **Uložení kresby a tahů** — RPC `start_drawing()` + `submit_drawing()`.
  **Dva kroky schválně:** dobu kreslení tak měří server mezi založením a odesláním,
  ne klient. Vedlejší efekt je přesně to, co chce krok F3 — událost „začal kreslit"
  oddělená od „odeslal", tedy měřitelný drop-off.
  Server počítá i počet tahů a pokrytí plátna z bounding boxu. Klientu zůstávají
  jen tahy, typ zařízení a počet undo (metadata, u kterých se ničemu nevěří).
  Stropy tahů a bodů jsou v `game_config`.
  *Ověřeno:* 11 testů, včetně toho, že přímý zápis do `drawings` je klientu
  odepřený — takže `duration_ms` nemá jak podvrhnout.

  **Zapojeno do aplikace 2026-08-19.** Výběr pojmu volá `offer_concepts()`,
  plátno si vyzvedne zadání přes `my_draft()` podle id kresby v URL — zadání
  tak neputuje v adrese ani v historii prohlížeče. Odeslání jde přes
  `submit_drawing()`, tahy se převádějí na ploché pole v `lib/strokes.ts`.
  *Ověřeno naostro v prohlížeči:* přihlášení → nabídka ze slovníku → nakreslení
  hvězdy → odeslání → kresba v databázi (5 tahů, zařízení pen, doba 38 s
  změřená serverem, body jako [0.5,0.15,0, 0.52,0.195,2, …]).
- `[x] C3` **Náhled kresby — a vědomá odchylka od původního zadání.**
  Plán počítal s bitmapou do cache. **Nedělá se, kreslí se z tahů v prohlížeči.**

  Důvod: bitmapa má smysl, když je stahování tahů drahé. Po zaokrouhlení
  souřadnic váží kresba ~11 kB po gzipu, takže mřížka dvaceti náhledů je
  ~220 kB a jedno hádání ~11 kB. Ukládat, generovat a servírovat obrázky by
  přidalo provozní vrstvu, kterou při téhle velikosti nic nevyžaduje — a
  `docs/roadmap.md` říká, že škálovací práci dopředu nedělat.

  **Kdy to přehodnotit:** až egress překročí ~2 GB měsíčně (40 % free plánu),
  nebo až přijde export GIFu a sdílení (fáze 1), kde je rastr potřeba tak jako tak.

  Komponenta `components/DrawingThumb.tsx` + RPC `strokes_for()`, který
  vydá tahy pro celou mřížku jedním dotazem.
- `[x] C4` **Moje kresby z reálných dat** — RPC `my_drawings()`.

  **Opraveno porušení pravidla, které bylo ve schématu od začátku:** politika
  `drawings_select_own` pouštěla autorovi celý řádek včetně `guess_count`.
  Stačilo odečíst `solved_count` a autor měl počet neuhodnutí, který se mu
  podle `docs/product.md` zobrazovat nemá. Přímé čtení tabulky je zavřené,
  data chodí funkcí, která `guess_count` vůbec nevrací.

  *Ověřeno:* 5 testů, včetně toho, že se `guess_count` v odpovědi nevyskytuje
  a že tabulku kreseb autor nepřečte napřímo.

## Blok D — Hádání end-to-end

- `[x] D1` **Distribuce** — RPC `next_drawing()`. Nejstarší neuhodnuté první,
  vlastní kresbu si nehádáš, přes hranici tenanta nikdy. Vrací i tahy, aby se
  kresba dala rovnou vykreslit.
- `[x] D2` **Serverová validace odpovědi** — RPC `submit_guess()`.
  Tři pokusy, jedno sezení na kresbu, počty udržuje trigger.
  **Chyba nalezená testem:** po uhodnutí šlo hádat dál a nafukovat počet tipů
  u cizí kresby — uhodnutím teď sezení končí.
  Odpověď se prozradí až po uhodnutí nebo vyčerpání pokusů.
- `[x] D2b` **Nápověda u nejtěžších pojmů.** Po prvním špatném tipu se vrátí
  první písmeno a délka odpovědi. **Počítá se ze zadání, nepíše ručně** — jinak
  tisíc pojmů znamená tisíc nápověd. Prahy jsou v `game_config`
  (`hint_after_attempt`, `hint_min_difficulty`), sloupec `guesses.hint_shown`
  a konfigurace už existují.
  *Kritérium:* nápověda se nedá získat dřív než po špatném tipu — server ji
  posílá až v odpovědi na něj, nikdy dopředu.
- `[x] D3` **Hvězdičky a palec** — RPC `give_thumb()`, hvězdičky podle pokusu
  (napoprvé tři, napotřetí jedna). Druhý palec téhož dne se odmítne bez chyby,
  limit drží unikátní index.
- `[x] D4` **Přehrání tahů** — `components/StrokePlayback.tsx`. Tlačítko, ne
  výchozí zobrazení. Rytmus se bere z časových značek u bodů, takže kde autor
  váhal, váhá i přehrání; mezery mezi tahy se doplňují pevnou pauzou, protože
  meziTahové časy se do plochého pole neukládají.

  **Hádání zapojeno do aplikace.** Obrazovka jede na `next_drawing()`,
  `submit_guess()` a `give_thumb()`. Prázdná zásoba je stav hry, ne chyba.
  *Ověřeno naostro se dvěma účty:* jeden nakreslil „hodiny", druhý tipl
  „kolotoč" (mimo), pak „hodiny" (uhodnuto na druhý pokus → dvě hvězdičky).
  V databázi oba tipy i s původním textem, počty udržel trigger.

## Blok E — Retenční smyčka

**Tohle nese hlavní hypotézu fáze 0. Když se bude škrtat, škrtá se jinde.**

- `[x] E1` **Vyžádání pojmu** — RPC `request_concept()`, denní limit z `game_config`,
  `expires_at` povinné (žádosti se uklidí samy).
- `[x] E2` **Přednost vyžádaných konceptů v nabídce** — v `offer_concepts()` od C1.
  Kresba si navíc pamatuje, že vznikla z vyžádání (`drawings.source`), jinak by
  nešlo vyhodnotit, jestli páka funguje.
- `[x] E3` **Upozornění oběma směry** — obojí ověřené testem. Žádost se při
  zveřejnění kresby uzavře sama.
- `[x] E4` **Upozornění „tvoji kresbu někdo uhodl / dal jí palec"** — triggery
  nad tipy a palci. Vlastní akce se neoznamuje.

## Blok F — Provoz a měření

- `[x] F1` **Nahlášení** — RPC `report_drawing()`. Ruční review dělá majitel
  ze Supabase studia; fáze 0 nemá klasifikátor, proto je uzavřená (pravidlo 8).
- `[x] F2` **Jeden denní žebříček** — RPC `daily_leaderboard()`, uhodnuté dnes,
  strop 30 hráčů. Tři žebříčky a ligy jsou nadstavba, ne fáze 0.
- `[x] F3` **Metriky** — pět pohledů ve schématu `private`, čte je majitel ze
  Supabase studia. Fáze 0 nemá administrátorské rozhraní; postavit ho by stálo
  víc než přečíst pět dotazů.

  `metrics_supply` (zásoba neuhodnutých — metrika 2), `metrics_funnel`
  (drop-off mezi „začal kreslit" a „odeslal" + odkud přišel impuls),
  `metrics_effort` (rozdělení doby a tahů pro kalibraci detekce čmáranic),
  `metrics_return` (návrat druhý den ke kreslení — kritérium postupu),
  `metrics_ab_playback`.

  **Zásoba se nevzorkuje do tabulky.** Jde dopočítat zpětně z časů tipů, takže
  žádný cron ani úklid navíc.
- `[x] F4` **A/B skupiny pro přehrání** — `profiles.ab_playback`, přiřazeno
  náhodně při vzniku účtu a neměnné. Tlačítko vidí jen jedna skupina.

## Blok G — Nasazení a pozvánky

- `[x] G1` **PWA** — manifest, ikona, service worker, offline stránka.
  Service worker je **vědomě konzervativní**: cachují se jen neměnné buildové
  soubory, všechno ostatní jde ze sítě. Agresivní cache by u hry postavené na
  čerstvých datech znamenala, že hráč uvidí kresbu, kterou už někdo uhodl,
  nebo starý stav pokusů. Ze Supabase se necachuje nic.
- `[x] G2` **Nasazeno na Vercel** — https://inkwit.vercel.app (2026-08-19).
  Proměnné prostředí nastavené, `site_url` v `supabase/config.toml` přepsáno
  na stálou adresu projektu a nasazeno.

  **Pozor na adresu:** Vercel dává každému nasazení vlastní URL s hashem
  (`inkwit-ck3xa2jvk-…`). Ta platí jen pro jeden build a je navíc za
  přihlašovací zdí Vercelu — do konfigurace patří stálá adresa projektu.

  *Ověřeno naostro na produkci:* registrace pozvánkou → nabídka pojmů ze
  slovníku → nakreslení → uložení. Kresba v databázi i s tahy.

  Postup:
  1. Naimportovat repo `Johnny09112/Inkwit` do Vercelu.
  2. Nastavit proměnné prostředí z `.env.example` (URL a publishable klíč —
     hodnoty jsou v lokálním `.env.local`). **Servisní klíč tam nepatří.**
  3. Po prvním nasazení přepsat `site_url` a `additional_redirect_urls`
     v `supabase/config.toml` na ostrou doménu a pustit
     `npx supabase config push`. Jinak by odkazy z e-mailů vedly na localhost.
  4. Ověřit, že jde appka nainstalovat na telefon (PWA potřebuje HTTPS,
     na Vercelu je automaticky).
- `[ ] G4` **Vlastní SMTP** — odstraní opakující se ruční práci se zapomenutými hesly.

  Vestavěný odesílatel Supabase má **2 zprávy za hodinu na všech plánech** a je
  určený jen ke zkoušení (viz „Odesílání pošty" níž). Placený Supabase to
  nevyřeší — dovolí jen upravit šablonu.

  **Postup:**
  1. Založit účet u poskytovatele. Bez vlastní domény funguje ověření jedné
     odesílací adresy (SendGrid single sender). S doménou je na výběr víc.
     *Přihlašovací údaje zadává majitel, Claude je nevidí.*
  2. V Supabase: **Authentication → Emails → SMTP Settings**, vyplnit host,
     port, uživatele, heslo a odesílací adresu.
  3. V `supabase/config.toml` odkomentovat blok `[auth.email.template.recovery]`
     a pustit `npx supabase config push`. Šablona je připravená
     v `supabase/templates/recovery.html`.

  **Jak ověřit, že to funguje — čtyři kroky, ne jeden:**
  1. **Zpráva dorazí.** Na `/login` kliknout „Zapomněl jsem heslo".
     *Pozor:* dokud běží vestavěný odesílatel, druhá zpráva ve stejné hodině
     nedorazí — a vypadá to jako chyba aplikace, ne jako limit.
  2. **Odkaz funguje ze stejného zařízení.** Nastavit nové heslo a přihlásit se jím.
  3. **Odkaz funguje z JINÉHO zařízení.** Tohle je vlastní test vlastní šablony:
     výchozí šablona posílá odkaz vázaný na prohlížeč (PKCE), vlastní posílá
     `token_hash`, který funguje odkudkoliv. Když druhé zařízení projde, je
     šablona skutečně aktivní.
  4. **Limit padl.** Požádat o obnovu třikrát během pěti minut ze tří různých
     účtů. S vestavěným odesílatelem třetí nedorazí, s vlastním ano.

  *Kritérium:* projdou všechny čtyři. Teprve pak se smí zapnout potvrzování
  e-mailu (`enable_confirmations`) — dřív by padesát registrací trvalo
  pětadvacet hodin.

- `[~] G3` **Pozvánky** — 50 kódů vygenerováno a předáno majiteli
  (`pozvanky-faze-0.txt`, mimo git). Rozeslání je na majiteli.

  Přehled o využití:
  ```sql
  select code, note, used_count, max_uses from public.invites order by note;
  ```

---

## Co se nedělá ve fázi 0

Vědomě mimo rozsah, ať se to nevrátí zadními vrátky: odznaky a **koruna za
slovo**, ligy, komunity a sledování, uživatelská slovní zásoba, surge, trust
score, kategorie podle zařízení, platby, nativní aplikace, GIF export, tmavý
režim, relay režim.

## Rozhodnutí, která čekají na majitele

1. **Tmavý režim** — nerozhodnuto, z palety se neodvodí 1:1. Do fáze 0 nepatří,
   ale ovlivní tokeny.
2. **Kolik neuhodnutí do archivace** a jak škáluje s obtížností (otázka #3
   v `roadmap.md`). Potřeba před D1.

Vyřešeno 2026-08-18:

3. ~~**Region Supabase projektu.**~~ Založeno znovu v `eu-central-1` (Frankfurt),
   dokud byl projekt prázdný. Region se u existujícího projektu nemění.
4. ~~**Kódování bodů tahu.**~~ **Rozhodnuto 2026-08-18** (majitel to nechal na mně):
   zaokrouhlení na 4 desetinná místa při záznamu — *hotovo* — a ploché pole
   `[x,y,t,…]` při ukládání, zavede se s C2. Měření a zdůvodnění
   v `_claude/memory/decisions/kodovani-bodu-tahu.md`.

## Odesílání pošty — placený Supabase to NEVYŘEŠÍ

Ověřeno v dokumentaci 2026-08-19. Vestavěný odesílatel Supabase:

- **2 zprávy za hodinu**, na všech plánech stejně
- **žádná záruka doručení ani dostupnosti**
- výslovně určený jen pro „zkoušení, testování šablon a hračky", ne pro provoz

**Placený plán mění jen jednu věc: dovolí upravit šablonu e-mailu.** Samotné
odesílání zůstává stejné. Kdo chce spolehlivou poštu, potřebuje **vlastní SMTP**,
a ten jde nastavit i na free plánu.

Důsledky pro fázi 0:

- Obnova hesla přes vestavěnou poštu funguje, ale při třech zapomenutých heslech
  v jedné hodině třetí člověk čeká.
- **Potvrzování e-mailu se zapnout nesmí**, dokud vlastní SMTP neběží — padesát
  registrací při dvou zprávách za hodinu je pětadvacet hodin.

Placený Supabase má pro tenhle projekt smysl z jiných důvodů: **stažitelné zálohy**
a **konec automatického pozastavování projektu**. Ne kvůli poště.

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

- **2026-08-20** — slovník rozšířen na **300 pojmů** ve vyrovnaném poměru
  100/100/100 (důvod u B1). Kontrola slovníku dostala skutečné prahy tolerance
  a našla jedenáct dvojic, které si hra pletla; opraveno pojistkou v
  `answer_matches`, ne v datech (B4).

- **2026-08-18** — plán založen. Blok 0 (UI nad mock daty) hotový z předchozí
  session. Dořešena koruna za slovo (fáze 1+, viz `_claude/memory/decisions/`).
  Blok A blokován rozhodnutím o Supabase projektu.

## Blok H — Správa

**Účel:** odpovědět na hlášení, vidět čísla bez studia a umět zasáhnout proti
účtu. Ne dashboard — čtyři otázky: běží to · je co hádat · docházejí slova ·
čeká něco na zásah.

- `[x] H1` **Role a stav účtu.** `profiles.is_admin`, `status`, `banned_at`,
  `ban_reason`. Chráněné tím, že `UPDATE` na `profiles` je udělený jen na
  vyjmenované sloupce — nový sloupec uživatel měnit nemůže.
  **Příznak správce se nastavuje jen ručně v SQL**, nikdy RPC.

  Ban vynucuje **trigger na zápisu** do `drawings`, `guesses`, `reactions`
  a `concept_requests`, ne kontrola v RPC. Bylo by jich pět a šestá, dopsaná za
  půl roku, by se na ni zapomněla. `next_drawing()` navíc přestane nabízet
  kresby zablokovaných.

  Zásahy se zapisují do `admin_actions`. Při jednom majiteli to vypadá zbytečně,
  ale ban bez stopy je věc, které se za rok nedá věřit.
  *Ověřeno:* 20 testů, z toho osm na to, že se k funkcím nedostane běžný uživatel.

- `[x] H2` **Moderace.** Fronta hlášení s náhledem kresby, důvodem a autorem;
  akce skrýt / planý poplach / zablokovat kreslíře. Přehled kreseb s filtry
  (live, removed, archived, reported, all). Seznam účtů s aktivitou, počtem
  hlášení proti nim a pásmem důvěry.

  **Školní tenant se vědomě nezahrnuje** — pravidlo 1 ho tvrdě izoluje a admin
  přes hranici tenanta by z toho udělal díru. Ve fázi 0 žádný neexistuje.

- `[x] H3` **Čísla.** Přehled dnes / 7 dní / celkem. Zásoba slov po
  obtížnostech s prahem 15 a alarmem „přidej slova". Pojmy, které nikdo neuhodl
  (podezřelá zadání, ne špatní kreslíři). Pět metrik z F3 čitelných pro správce
  a export do CSV se středníkem, ať to Excel v češtině nerozsype do sloupce.

**Co v bloku H NENÍ a proč.** Trvalé skrytí kresby je měkké (`removed`), ne
`delete` — cizí tipy a čísla zásoby musí zůstat. Odblokování účtu vrací jen
stav, kresby se samy nevrátí. Rozhraní je jednojazyčné: mluví k majiteli.

**Varování z roadmapy platí dál.** *„Denní ruční fronta projekt zabije dřív než
nedostatek uživatelů."* Pro padesát testerů je fronta v pořádku; pro veřejné
spuštění je podmínkou klasifikátor, ne tahle obrazovka.

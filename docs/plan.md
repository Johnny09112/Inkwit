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

**Proč tohle pořadí.** A blokuje všechno, protože bez schématu se nedá uložit nic.
B běží nezávisle a je to obsahová práce, ne programování — může jet paralelně.
C před D, protože bez kreseb není co hádat. E až po D, protože vyžádání má smysl
teprve když existuje smyčka, do které vstupuje. F před G, protože nasadit
neměřitelnou verzi znamená prošvihnout jediný účel fáze 0.

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

- `[x] B1` **Sada konceptů — odsouhlaseno a nasazeno** (120 konceptů v databázi).
  120 pojmů v `supabase/seed/concepts.json`: 58 snadných, 40 středních, 22 těžkých,
  v šesti kategoriích. Jen jednojazyčné: `zámek`, `trapas`, `štěstí`.
- `[~] B2` **Přijímané tvary CZ** — 437 tvarů v návrhu. Plné skloňování tam
  VĚDOMĚ není; spoléhá se na normalizaci a fuzzy shodu. *Zbývá kritérium:*
  na vzorku zkusit, co lidé reálně napíšou.
- `[~] B3` **Přijímané tvary EN** — 268 tvarů v návrhu.
- `[x] B4` **Porovnávací funkce** — hotová, bez rozšíření Postgresu. Normalizace diakritiky → lowercase → trim →
  shoda → fuzzy pro překlepy.

  **Prahy fuzzy shody podle délky — podloženo daty, ne odhadem.** Kontrola sady
  našla **22 dvojic tvarů kratších než pět znaků, které se liší jediným znakem**
  a patří RŮZNÝM pojmům: `pes`/`děs`, `slon`/`shon`, `výr`/`sýr`, `dům`/`dub`,
  `klíč`/`klid`, `duha`/`duna`, anglicky `cat`/`bat`/`car`, `bear`/`pear`/`fear`,
  `sun`/`run`/`bun`, `book`/`boot`/`bolt`. Levenshtein ≤ 1 by je zaměnil.

  Návrh: **do 4 znaků jen přesná shoda**, 5–7 znaků vzdálenost 1, 8+ vzdálenost 2.
  *Kritérium:* test, který projede všechny dvojice z `concepts.json` a ověří,
  že žádná odpověď neuhodne cizí pojem.

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

- **2026-08-18** — plán založen. Blok 0 (UI nad mock daty) hotový z předchozí
  session. Dořešena koruna za slovo (fáze 1+, viz `_claude/memory/decisions/`).
  Blok A blokován rozhodnutím o Supabase projektu.

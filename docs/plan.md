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
| **B** | Obsah — koncepty a přijímané tvary CZ/EN | `[~]` | D |
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

- `[~] B1` **Sada konceptů — návrh hotový, čeká na projetí majitelem.**
  120 pojmů v `supabase/seed/concepts.json`: 58 snadných, 40 středních, 22 těžkých,
  v šesti kategoriích. Jen jednojazyčné: `zámek`, `trapas`, `štěstí`.
- `[~] B2` **Přijímané tvary CZ** — 437 tvarů v návrhu. Plné skloňování tam
  VĚDOMĚ není; spoléhá se na normalizaci a fuzzy shodu. *Zbývá kritérium:*
  na vzorku zkusit, co lidé reálně napíšou.
- `[~] B3` **Přijímané tvary EN** — 268 tvarů v návrhu.
- `[ ] B4` **Porovnávací funkce.** Normalizace diakritiky → lowercase → trim →
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
- `[ ] D2b` **Nápověda u nejtěžších pojmů.** Po prvním špatném tipu se vrátí
  první písmeno a délka odpovědi. **Počítá se ze zadání, nepíše ručně** — jinak
  tisíc pojmů znamená tisíc nápověd. Prahy jsou v `game_config`
  (`hint_after_attempt`, `hint_min_difficulty`), sloupec `guesses.hint_shown`
  a konfigurace už existují.
  *Kritérium:* nápověda se nedá získat dřív než po špatném tipu — server ji
  posílá až v odpovědi na něj, nikdy dopředu.
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

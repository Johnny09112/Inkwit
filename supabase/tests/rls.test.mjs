/**
 * Test schématu a RLS — kritérium přijetí kroků A2 a A3 z docs/plan.md.
 *
 * Běží proti Postgresu v paměti (PGlite), takže nepotřebuje Docker ani síť
 * a dá se spustit kdykoliv: `npm run test:db`.
 *
 * Co se tu NEtestuje: `supabase db push` proti ostrému projektu. PGlite je
 * skutečný Postgres, ale ne skutečný Supabase — role a schéma `auth` se tu
 * napodobují jen v rozsahu, který migrace potřebují.
 */

import { PGlite } from "@electric-sql/pglite";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const MIGRATIONS = path.join(HERE, "..", "migrations");

/** Minimální náhrada Supabase: role, schéma auth a auth.uid(). */
const SUPABASE_STUB = `
create role anon;
create role authenticated;
create role service_role;

create schema if not exists auth;
create table auth.users (
  id                 uuid primary key default gen_random_uuid(),
  email              text,
  raw_user_meta_data jsonb default '{}'::jsonb,
  created_at         timestamptz default now()
);
create or replace function auth.uid() returns uuid
  language sql stable as
  $$ select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid $$;

grant usage on schema public to anon, authenticated, service_role;
alter default privileges in schema public
  grant all on tables to anon, authenticated, service_role;
`;

const ALICE = "11111111-1111-1111-1111-111111111111"; // veřejný hráč
const BOB = "22222222-2222-2222-2222-222222222222"; // veřejný hráč, autor kreseb
const PUPIL = "33333333-3333-3333-3333-333333333333"; // žák ve školním tenantu
const SCHOOL = "44444444-4444-4444-4444-444444444444";
const CONCEPT = "55555555-5555-5555-5555-555555555555";
const LIVE = "66666666-6666-6666-6666-666666666666";
const DRAFT = "77777777-7777-7777-7777-777777777777";

const SEED = `
-- Od kroku A5 nevznikne účet bez platné pozvánky, takže i testovací uživatelé
-- musí projít stejnou cestou jako skuteční.
insert into public.invites (code, note, max_uses) values ('INK-SEED', 'testovací data', 10);

insert into auth.users (id, raw_user_meta_data) values
  ('${ALICE}', '{"display_name":"Alice","invite_code":"INK-SEED"}'),
  ('${BOB}',   '{"display_name":"Bob","invite_code":"INK-SEED"}'),
  ('${PUPIL}', '{"display_name":"Žák","invite_code":"INK-SEED"}');

insert into public.tenants (id, kind, name, owner_id, join_code)
  values ('${SCHOOL}', 'school', 'ZŠ Testov', '${BOB}', 'ABC123');
update public.profiles set tenant_id = '${SCHOOL}' where id = '${PUPIL}';

insert into public.concepts (id, slug, difficulty, category) values ('${CONCEPT}', 'testovaci-pojem', 1, 'zvire');
insert into public.concept_locales values ('${CONCEPT}', 'cs', 'chobotnice', null);
insert into public.concept_answers values ('${CONCEPT}', 'cs', array['chobotnice','chobotnici']);

insert into public.drawings (id, author_id, concept_id, source_locale, status, published_at) values
  ('${LIVE}',  '${BOB}', '${CONCEPT}', 'cs', 'live',  now()),
  ('${DRAFT}', '${BOB}', '${CONCEPT}', 'cs', 'draft', null);

insert into public.drawing_strokes values
  ('${LIVE}', 0, '${BOB}', 'brush', '#2B261F', 14, '[0.1,0.2,0]'::jsonb);

insert into public.ledger (user_id, delta, reason) values ('${BOB}', 10, 'test');
`;

let passed = 0;
let failed = 0;

function report(ok, name, detail = "") {
  console.log(`  ${ok ? "✓" : "✗"} ${name}${ok || !detail ? "" : `   → ${detail}`}`);
  ok ? passed++ : failed++;
}

async function main() {
  const db = await PGlite.create();
  await db.exec(SUPABASE_STUB);

  console.log("Migrace na prázdné databázi (kritérium A2):\n");
  for (const file of fs.readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql")).sort()) {
    try {
      await db.exec(fs.readFileSync(path.join(MIGRATIONS, file), "utf8"));
      report(true, file);
    } catch (e) {
      report(false, file, e.message.split("\n")[0]);
      console.log("\nMigrace neprošly, zbytek testu nemá smysl.");
      process.exit(1);
    }
  }

  await db.exec(SEED);

  // Každá tabulka musí mít zapnutou RLS. Bez výjimky.
  const rls = (
    await db.query(`select relname, relrowsecurity from pg_class c
      join pg_namespace n on n.oid = c.relnamespace
      where n.nspname = 'public' and c.relkind = 'r'`)
  ).rows;
  const withoutRls = rls.filter((r) => !r.relrowsecurity).map((r) => r.relname);
  console.log("");
  report(withoutRls.length === 0, `RLS zapnutá na všech ${rls.length} tabulkách`, withoutRls.join(", "));

  /** Spustí dotaz jako přihlášený uživatel a vrátí počet řádků nebo 'ERROR'. */
  async function asUser(userId, sql) {
    await db.exec("begin");
    try {
      await db.exec(
        `set local role authenticated; select set_config('request.jwt.claim.sub', '${userId}', true);`,
      );
      const r = await db.query(sql);
      return r.rows.length ? (r.rows[0].n ?? r.rows.length) : 0;
    } catch {
      return "ERROR";
    } finally {
      await db.exec("rollback");
    }
  }

  const count = (sql) => `select count(*)::int n from ${sql}`;

  console.log("\nAlice nevidí, co vidět nesmí:\n");
  report((await asUser(ALICE, count(`public.profile_trust where user_id='${BOB}'`))) === "ERROR",
    "cizí trust score (pravidlo 7)");
  report((await asUser(ALICE, count(`public.drawings where id='${DRAFT}'`))) === "ERROR",
    "cizí rozepsanou kresbu (tabulka je zavřená úplně)");
  report((await asUser(ALICE, count(`public.ledger where user_id='${BOB}'`))) === 0,
    "cizí ledger");
  report((await asUser(ALICE, count("public.concepts"))) === "ERROR",
    "koncepty");
  report((await asUser(ALICE, count("public.concept_locales"))) === "ERROR",
    "zadání konceptu — jinak zná odpověď");
  report((await asUser(ALICE, count("public.concept_answers"))) === "ERROR",
    "přijímané odpovědi — jinak zná všechny odpovědi");
  report((await asUser(ALICE, count(`public.drawings where id='${LIVE}'`))) === "ERROR",
    "concept_id ani u živé kresby — jinak spáruje dvě kresby téhož konceptu");
  report((await asUser(ALICE, count("public.game_config where key='trust_band_trusted_at'"))) === 0,
    "neveřejné prahy konfigurace (pravidlo 7)");

  console.log("\nAlice naopak vidět musí:\n");
  report((await asUser(ALICE, count("public.feed_drawings"))) === 1, "živou kresbu ve feedu");
  report((await asUser(ALICE, count("public.drawing_strokes"))) === 1, "tahy živé kresby");
  report((await asUser(ALICE, count("public.game_config where is_public"))) > 0, "veřejné klíče konfigurace");

  console.log("\nIzolace školního tenantu (pravidlo 1):\n");
  report((await asUser(PUPIL, count("public.feed_drawings"))) === 0,
    "žák nevidí veřejnou kresbu");
  report((await asUser(BOB, count(`public.profiles where id='${PUPIL}'`))) === 0,
    "veřejný hráč nevidí profil žáka");

  console.log("\nLimity drží databáze, ne aplikace:\n");
  async function mustFail(name, sql) {
    await db.exec("begin");
    let threw = false;
    try {
      await db.exec(
        `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
      );
      await db.exec(sql);
    } catch {
      threw = true;
    }
    await db.exec("rollback");
    report(threw, name);
  }

  await mustFail("čtvrtý pokus o uhodnutí neprojde",
    `insert into public.guesses (drawing_id,user_id,locale,attempt_no,text_raw)
     values ('${LIVE}','${ALICE}','cs',4,'x')`);
  await mustFail("druhý palec téhož dne neprojde",
    `insert into public.reactions (drawing_id,user_id) values ('${LIVE}','${ALICE}');
     insert into public.reactions (drawing_id,user_id) values ('${DRAFT}','${ALICE}')`);
  await mustFail("klient si nenastaví is_correct sám",
    `insert into public.guesses (drawing_id,user_id,locale,attempt_no,text_raw,is_correct)
     values ('${LIVE}','${ALICE}','cs',1,'chobotnice',true)`);
  await mustFail("tah nejde přidat k cizí kresbě",
    `insert into public.drawing_strokes values ('${LIVE}',9,'${ALICE}','brush','#000',1,'[0,0,0]'::jsonb)`);

  console.log("\nPohled feed_drawings nesmí prozradit tajemství:\n");
  const FEED_ALLOWED = new Set([
    "id", "author_id", "author_name", "source_locale",
    "device_kind", "guess_count", "solved_count", "thumbs_count", "published_at",
  ]);
  const feedCols = (
    await db.query(`select column_name from information_schema.columns
      where table_schema = 'public' and table_name = 'feed_drawings'`)
  ).rows.map((r) => r.column_name);
  const forbidden = feedCols.filter((c) => !FEED_ALLOWED.has(c));
  report(forbidden.length === 0,
    "pohled nevrací žádný sloupec mimo povolený seznam",
    `navíc: ${forbidden.join(", ")}`);

  // Pomocné funkce nesmí být ve schématu `public`, protože to PostgREST
  // vystavuje jako /rest/v1/rpc/…. Volat je přímo v SQL naopak MUSÍ jít —
  // politiky je volají právy dotazujícího se uživatele. Samotnou nedostupnost
  // přes REST tady ověřit nejde, PGlite žádné REST nemá; ověřuje se to,
  // co ji zaručuje: umístění mimo public.
  console.log("\nPomocné funkce jsou schované mimo veřejné API:\n");
  const helpers = (
    await db.query(`select n.nspname, p.proname from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where p.proname in ('current_tenant_id', 'can_view_drawing', 'handle_new_user')`)
  ).rows;
  const inPublic = helpers.filter((h) => h.nspname === "public").map((h) => h.proname);
  report(helpers.length === 3, "všechny tři pomocné funkce existují", `nalezeno ${helpers.length}`);
  report(inPublic.length === 0, "žádná z nich není ve schématu public", inPublic.join(", "));

  console.log("\nÚčet nevznikne bez platné pozvánky (kritérium A5):\n");

  /** Zkusí založit uživatele se zadanými metadaty. Vrací true, když prošel. */
  async function trySignup(meta) {
    await db.exec("begin");
    let created = false;
    try {
      await db.query(`insert into auth.users (raw_user_meta_data) values ($1)`, [meta]);
      created = true;
    } catch {
      created = false;
    }
    await db.exec("rollback");
    return created;
  }

  await db.exec(`
    insert into public.invites (code, note, max_uses) values ('INK-PLATNA', 'test', 1);
    insert into public.invites (code, note, revoked_at) values ('INK-ZRUSENA', 'test', now());
    insert into public.invites (code, note, expires_at) values ('INK-PROSLA', 'test', now() - interval '1 day');
    insert into public.invites (code, note, max_uses, used_count) values ('INK-VYCERPANA', 'test', 1, 1);
  `);

  report(!(await trySignup(JSON.stringify({}))), "bez kódu účet nevznikne");
  report(!(await trySignup(JSON.stringify({ invite_code: "INK-NEEXISTUJE" }))), "s vymyšleným kódem nevznikne");
  report(!(await trySignup(JSON.stringify({ invite_code: "INK-ZRUSENA" }))), "se zrušenou pozvánkou nevznikne");
  report(!(await trySignup(JSON.stringify({ invite_code: "INK-PROSLA" }))), "s prošlou pozvánkou nevznikne");
  report(!(await trySignup(JSON.stringify({ invite_code: "INK-VYCERPANA" }))), "s vyčerpanou pozvánkou nevznikne");
  report(await trySignup(JSON.stringify({ invite_code: "INK-PLATNA" })), "s platnou pozvánkou vznikne");
  report(await trySignup(JSON.stringify({ invite_code: "ink-platna" })), "kód není citlivý na velikost písmen");

  // Pozvánka se po použití spotřebuje a podruhé neprojde.
  await db.exec("begin");
  await db.query(`insert into auth.users (raw_user_meta_data) values ($1)`, [
    JSON.stringify({ invite_code: "INK-PLATNA", display_name: "Nováček" }),
  ]);
  // Savepoint: očekávaná chyba jinak zablokuje celou transakci a další
  // dotazy by spadly na 25P02 místo aby něco ověřily.
  await db.exec("savepoint second_use");
  let secondUse = true;
  try {
    await db.query(`insert into auth.users (raw_user_meta_data) values ($1)`, [
      JSON.stringify({ invite_code: "INK-PLATNA" }),
    ]);
  } catch {
    secondUse = false;
  }
  await db.exec("rollback to savepoint second_use");
  const newProfile = (
    await db.query(`select count(*)::int n from public.profiles where display_name = 'Nováček'`)
  ).rows[0].n;
  const newTrust = (
    await db.query(`select count(*)::int n from public.profile_trust t
      join public.profiles p on p.id = t.user_id where p.display_name = 'Nováček'`)
  ).rows[0].n;
  await db.exec("rollback");
  report(!secondUse, "jednorázová pozvánka podruhé neprojde");
  report(newProfile === 1, "s účtem vznikne profil");
  report(newTrust === 1, "s profilem vznikne i záznam trust score");

  report((await asUser(ALICE, count("public.invites"))) === "ERROR",
    "klient nemůže vyjmenovat pozvánky");

  console.log("\nJméno v profilu je unikátní:\n");

  await db.exec(`insert into public.invites (code, note, max_uses) values ('INK-JMENA', 'test', 5);`);

  /** Založí uživatele se jménem. Vrací true, když prošel. */
  async function signupAs(name, code = "INK-JMENA") {
    await db.exec("savepoint s");
    try {
      await db.query(`insert into auth.users (raw_user_meta_data) values ($1)`, [
        JSON.stringify({ display_name: name, invite_code: code }),
      ]);
      return true;
    } catch {
      await db.exec("rollback to savepoint s");
      return false;
    }
  }

  await db.exec("begin");
  report(await signupAs("Marek Novák"), "jméno s mezerou a diakritikou projde");
  report(!(await signupAs("marek novák")), "totéž jméno jinou velikostí písmen neprojde");
  report(!(await signupAs("ab")), "kratší než tři znaky neprojde");
  // Okrajové mezery se ořežou, ne odmítnou — zkopírovaná mezera navíc není
  // chyba uživatele. Uloženo je pak čisté jméno.
  report(await signupAs("  Jitka  "), "jméno s okrajovými mezerami se ořízne, ne odmítne");
  const trimmed = (
    await db.query(`select count(*)::int n from public.profiles where display_name = 'Jitka'`)
  ).rows[0].n;
  report(trimmed === 1, "uložené jméno je bez okrajových mezer");

  // Kontrola tvaru ale musí držet i proti přímému zápisu do tabulky.
  await db.exec("savepoint shape");
  let shapeHeld = false;
  try {
    await db.query(`update public.profiles set display_name = ' Jitka ' where display_name = 'Jitka'`);
  } catch {
    shapeHeld = true;
  }
  await db.exec("rollback to savepoint shape");
  report(shapeHeld, "přímý zápis neoříznutého jména neprojde");
  report(!(await signupAs("Jana    K")), "jméno s vícenásobnou mezerou neprojde");
  report(await signupAs("Jana K"), "normální jméno projde");

  // Klíčové: když jméno spadne, registrace se odroluje CELÁ. Pozvánka se
  // nesmí spotřebovat — jinak by člověk přišel o kód kvůli obsazenému jménu.
  const usedBefore = (
    await db.query(`select used_count from public.invites where code = 'INK-JMENA'`)
  ).rows[0].used_count;
  await signupAs("Jana K");
  const usedAfter = (
    await db.query(`select used_count from public.invites where code = 'INK-JMENA'`)
  ).rows[0].used_count;
  report(usedBefore === usedAfter, "obsazené jméno nespotřebuje pozvánku", `${usedBefore} → ${usedAfter}`);

  // Účet bez zvoleného jména (zakládaný ručně) dostane náhradu, která projde.
  await db.exec(`insert into auth.users (raw_user_meta_data) values ('{"invite_code":"INK-JMENA"}'::jsonb)`);
  const fallback = (
    await db.query(`select count(*)::int n from public.profiles where display_name like 'Kreslíř %'`)
  ).rows[0].n;
  report(fallback === 1, "účet bez jména dostane náhradní, které projde kontrolou");

  const avail = await db.query(`select public.display_name_available('Jana K') a,
                                       public.display_name_available('Nikdo Takový') b`);
  report(avail.rows[0].a === false && avail.rows[0].b === true,
    "kontrola volného jména odpovídá správně");
  await db.exec("rollback");

  console.log("\nNabídka tří konceptů (kritérium C1):\n");

  /** Spustí dotaz jako uživatel a vrátí řádky. */
  async function rowsAs(userId, sql) {
    await db.exec("begin");
    try {
      await db.exec(
        `set local role authenticated; select set_config('request.jwt.claim.sub', '${userId}', true);`,
      );
      return (await db.query(sql)).rows;
    } finally {
      await db.exec("rollback");
    }
  }

  const offer = await rowsAs(ALICE, "select * from public.offer_concepts()");
  report(offer.length === 3, "nabídne přesně tři koncepty", `dostal ${offer.length}`);
  report(
    JSON.stringify(offer.map((r) => r.difficulty)) === "[1,2,3]",
    "od každé obtížnosti jeden — volba je ventil pro toho, kdo neumí kreslit",
    offer.map((r) => r.difficulty).join(","),
  );
  report(offer.every((r) => r.prompt && r.prompt.length > 0), "každý koncept má zadání v jazyce hráče");

  // Vyžádaný koncept má přednost — jinak je vyžádání přání do prázdna.
  await db.exec("begin");
  await db.exec(`
    insert into public.concept_requests (concept_id, requester_id, locale, expires_at)
    select id, '${BOB}', 'cs', now() + interval '7 days'
    from public.concepts where slug = 'kolotoc';
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${ALICE}', true);
  `);
  const withReq = (await db.query("select * from public.offer_concepts()")).rows;
  await db.exec("rollback");
  const requested = withReq.find((r) => r.requested_by !== null);
  report(!!requested, "vyžádaný koncept se dostane do nabídky přednostně");
  report(requested?.requested_by === "Bob", "u vyžádaného je vidět, kdo čeká", String(requested?.requested_by));

  console.log("\nUložení kresby (kritérium C2):\n");

  // Id konceptu si zjišťujeme jako server. Jako hráč to nejde — a je to
  // správně, tabulka konceptů je pro klienta zavřená.
  const conceptPes = (await db.query(`select id from public.concepts where slug = 'pes'`)).rows[0].id;
  const conceptKocka = (await db.query(`select id from public.concepts where slug = 'kocka'`)).rows[0].id;

  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );

  const draftId = (await db.query(`select public.start_drawing('${conceptPes}') as id`)).rows[0].id;
  report(!!draftId, "start_drawing založí rozepsanou kresbu");

  // Ověřovací čtení dělá server — hráč do tabulky kreseb nevidí (krok C4).
  await db.exec("reset role");
  const draftStatus = (
    await db.query(`select status from public.drawings where id = '${draftId}'`)
  ).rows[0].status;
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  report(draftStatus === "draft", "rozepsaná kresba má stav draft", draftStatus);

  // Klient posílá jen tahy — žádné duration_ms, stroke_count ani coverage.
  const strokes = JSON.stringify([
    { tool: "brush", color: "#2B261F", width: 14, points: [0.2, 0.2, 0, 0.6, 0.5, 10] },
    { tool: "brush", color: "#B5462F", width: 8, points: [0.3, 0.3, 0, 0.4, 0.4, 20] },
  ]);
  await db.query(`select public.submit_drawing('${draftId}', 'pen', 3, $1::jsonb, 0.75)`, [strokes]);

  await db.exec("reset role");
  const saved = (
    await db.query(`select status, stroke_count, coverage, device_kind, undo_count,
                           duration_ms, published_at is not null as publikovano
                    from public.drawings where id = '${draftId}'`)
  ).rows[0];
  report(saved.status === "live", "po odeslání je kresba živá", saved.status);

  // Bez poměru se kresba u ostatních roztáhne na tvar jejich obrazovky.
  const tvar = (
    await db.query(`select aspect from public.drawings where id = '${draftId}'`)
  ).rows[0].aspect;
  report(Math.abs(tvar - 0.75) < 1e-6, "poměr plátna se uložil", String(tvar));

  // Strop bodů se počítal třikrát menší, než říká konfigurace: `v_points` už
  // jsou body, ale výraz je znovu násobil třemi. Na 120Hz tabletu se dala
  // hranice potkat a odeslání skončilo obecným „nepovedlo se".
  {
    const strop = (
      await db.query(
        `select (value)::int v from public.game_config where key = 'max_points_per_drawing'`,
      )
    ).rows[0].v;
    /** Jeden tah s daným počtem bodů: ploché pole [x,y,t,…]. */
    const tahSBody = (n) => {
      const pole = [];
      for (let i = 0; i < n; i++) pole.push(0.5, 0.5, i);
      return JSON.stringify([{ tool: "brush", color: "#2B261F", width: 8, points: pole }]);
    };
    // Savepoint, ne begin/rollback: tenhle kód běží uvnitř už otevřené
    // transakce a vnořený rollback by zrušil i práci předchozích kroků.
    const zkusOdeslat = async (bodu) => {
      await db.exec("savepoint strop");
      try {
        const id = (await db.query(`select public.start_drawing('${conceptPes}') id`)).rows[0].id;
        await db.query(`select public.submit_drawing('${id}', 'touch', 0, $1::jsonb, 0.68)`, [
          tahSBody(bodu),
        ]);
        return "ok";
      } catch (e) {
        return e.message.includes("mnoho bodů") ? "odmítnuto" : `jiná chyba: ${e.message}`;
      } finally {
        await db.exec("rollback to savepoint strop");
      }
    };

    report(
      (await zkusOdeslat(strop - 10)) === "ok",
      `kresba těsně pod stropem projde (${strop - 10} bodů)`,
    );
    report(
      (await zkusOdeslat(strop + 10)) === "odmítnuto",
      `kresba nad stropem se odmítne (${strop + 10} bodů)`,
    );
    // Jádro opravy: třetina stropu je pořád hluboko v povoleném pásmu.
    report(
      (await zkusOdeslat(Math.floor(strop / 3) + 100)) === "ok",
      "třetina stropu se už neodmítá — tam byla ta chyba",
    );
  }
  report(saved.stroke_count === 2, "počet tahů spočítal server", String(saved.stroke_count));
  report(
    Math.abs(saved.coverage - 0.12) < 0.001,
    "pokrytí plátna spočítal server z bounding boxu",
    String(saved.coverage),
  );
  report(saved.device_kind === "pen", "typ zařízení uložen");
  report(saved.duration_ms !== null && saved.duration_ms >= 0, "dobu kreslení změřil server");

  const savedStrokes = (
    await db.query(`select count(*)::int n from public.drawing_strokes where drawing_id = '${draftId}'`)
  ).rows[0].n;
  report(savedStrokes === 2, "tahy se uložily", String(savedStrokes));
  await db.exec("rollback");

  // Kritérium C2 doslova: klient nemá jak podvrhnout duration_ms, protože
  // do tabulky vůbec nesmí zapsat.
  await db.exec("begin");
  let directInsert = false;
  try {
    await db.exec(
      `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
    );
    await db.exec(`insert into public.drawings (author_id, concept_id, source_locale, duration_ms)
                   select '${ALICE}', id, 'cs', 999999 from public.concepts where slug = 'pes'`);
  } catch {
    directInsert = true;
  }
  await db.exec("rollback");
  report(directInsert, "klient nezapíše kresbu napřímo, takže nepodvrhne ani dobu kreslení");

  async function submitFails(name, strokesJson) {
    await db.exec("begin");
    let threw = false;
    try {
      await db.exec(
        `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
      );
      const id = (await db.query(`select public.start_drawing('${conceptKocka}') as id`)).rows[0].id;
      await db.query(`select public.submit_drawing('${id}', 'mouse', 0, $1::jsonb, 0.68)`, [strokesJson]);
    } catch {
      threw = true;
    }
    await db.exec("rollback");
    report(threw, name);
  }

  await submitFails("kresba bez tahů neprojde", "[]");
  await submitFails(
    "tah s poškozenými body neprojde",
    JSON.stringify([{ tool: "brush", color: "#000", width: 5, points: [0.1, 0.2] }]),
  );

  console.log("\nPorovnávání odpovědí (kritérium B4):\n");

  const match = async (slug, text) =>
    (
      await db.query(
        `select private.answer_matches(c.id, 'cs', $1) as ok
         from public.concepts c where c.slug = $2`,
        [text, slug],
      )
    ).rows[0].ok;

  report(await match("pes", "pes"), "přesná shoda");
  report(await match("pes", "  PES  "), "velikost písmen a mezery nerozhodují");
  report(await match("pes", "pejsek"), "zdrobnělina z přijímaných tvarů");
  report(await match("chobotnice", "chobotnice"), "dlouhé slovo přesně");
  report(await match("chobotnice", "chobotnica"), "překlep v dlouhém slově projde");
  report(await match("presypaci-hodiny", "presypaci hodiny"), "bez diakritiky projde");
  report(await match("kolotoc", "kolotoč"), "s diakritikou projde taky");

  // Tohle je ta past, kvůli které existují prahy podle délky.
  report(!(await match("pes", "děs")), "„děs“ NEuhodne psa — krátká slova jen přesně");
  report(!(await match("slon", "shon")), "„shon“ NEuhodne slona");
  report(!(await match("syr", "výr")), "„výr“ NEuhodne sýr");
  report(!(await match("dum", "dub")), "„dub“ NEuhodne dům");
  report(!(await match("pes", "kočka")), "úplně jiné slovo neprojde");
  report(!(await match("pes", "")), "prázdný tip neprojde");

  console.log("\nHádání (kroky D1–D3):\n");

  const bobDrawing = LIVE;

  // D1 — komu se kresba nabídne
  const aliceFeed = await rowsAs(ALICE, "select * from public.next_drawing()");
  report(aliceFeed.length === 1, "hádač dostane kresbu", `${aliceFeed.length}`);
  report(aliceFeed[0]?.author_name === "Bob", "vidí, kdo ji nakreslil");
  report(
    Array.isArray(aliceFeed[0]?.strokes) && aliceFeed[0].strokes.length === 1,
    "kresba přijde i s tahy, aby šla vykreslit",
  );
  const bobFeed = await rowsAs(BOB, "select * from public.next_drawing()");
  report(bobFeed.length === 0, "autor svou vlastní kresbu k hádání nedostane");

  // D2 — tipy
  async function guess(user, text, drawing = bobDrawing) {
    const r = await db.query(
      `select * from public.submit_guess('${drawing}', $1)`,
      [text],
    );
    return r.rows[0];
  }

  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const g1 = await guess(ALICE, "kočka");
  report(g1.correct === false && g1.attempt_no === 1, "špatný tip se započítá jako pokus");
  report(g1.attempts_left === 2, "zbývají dva pokusy", String(g1.attempts_left));
  report(g1.solution === null, "odpověď se po prvním tipu neprozradí");

  const g2 = await guess(ALICE, "chobotnice");
  report(g2.correct === true, "správný tip je uznaný");
  report(g2.solution === "chobotnice", "po uhodnutí se odpověď ukáže");
  report(g2.stars === 2, "hvězdičky podle pokusu (napodruhé → dvě)", String(g2.stars));

  // Očekávaná výjimka by jinak zablokovala celou transakci.
  await db.exec("savepoint g4");
  let fourth = false;
  try {
    await guess(ALICE, "cokoliv");
  } catch {
    fourth = true;
  }
  await db.exec("rollback to savepoint g4");
  report(fourth, "po uhodnutí už další tip neprojde");

  await db.exec("reset role");
  const counts = (
    await db.query(`select guess_count, solved_count from public.drawings where id = '${bobDrawing}'`)
  ).rows[0];
  report(counts.guess_count === 2 && counts.solved_count === 1,
    "počty na kresbě udržel trigger", `${counts.guess_count}/${counts.solved_count}`);
  await db.exec("rollback");

  // D2b — nápověda u nejtěžších pojmů
  await db.exec("begin");
  await db.exec(`
    insert into public.drawings (id, author_id, concept_id, source_locale, status, published_at)
    select '99999999-9999-9999-9999-999999999999', '${BOB}', id, 'cs', 'live', now()
    from public.concepts where slug = 'nostalgie';
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${ALICE}', true);
  `);
  const hard = await guess(ALICE, "nic", "99999999-9999-9999-9999-999999999999");
  // „nostalgie" má devět písmen: první ukázané + osm teček.
  report(hard.hint === "N········", "u těžkého pojmu přijde po chybě nápověda", String(hard.hint));
  await db.exec("rollback");

  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const easy = await guess(ALICE, "nic");
  report(easy.hint === null, "u snadného pojmu nápověda nepřijde — bylo by to luštění");
  await db.exec("rollback");

  // D3 — palec
  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const t1 = (await db.query(`select public.give_thumb('${bobDrawing}') as ok`)).rows[0].ok;
  const t2 = (await db.query(`select public.give_thumb('${bobDrawing}') as ok`)).rows[0].ok;
  report(t1 === true, "palec projde");
  report(t2 === false, "druhý palec téhož dne se odmítne bez chyby");
  await db.exec("reset role");
  const thumbs = (
    await db.query(`select thumbs_count from public.drawings where id = '${bobDrawing}'`)
  ).rows[0].thumbs_count;
  report(thumbs === 1, "počet palců udržel trigger", String(thumbs));
  await db.exec("rollback");

  console.log("\nMoje kresby neprozradí počet neuhodnutí (kritérium C4):\n");

  await db.exec("begin");
  await db.exec(`
    insert into public.guesses (drawing_id, user_id, locale, attempt_no, text_raw, is_correct)
    values ('${LIVE}', '${ALICE}', 'cs', 2, 'chobotnice', true);
    -- Až po vložení tipu — počty teď udržuje trigger a přepsal by je.
    update public.drawings set guess_count = 17, solved_count = 4, thumbs_count = 2
    where id = '${LIVE}';
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${BOB}', true);
  `);
  const mine = (await db.query("select * from public.my_drawings()")).rows;
  const cols = mine.length ? Object.keys(mine[0]) : [];
  await db.exec("rollback");

  report(mine.length >= 1, "autor vidí své kresby", `${mine.length}`);
  report(
    !cols.includes("guess_count"),
    "guess_count se nevrací — jinak by autor odečtením zjistil počet neuhodnutí",
    cols.join(", "),
  );
  report(
    mine.some((r) => r.solved_count === 4),
    "počet lidí, kteří uhodli, autor vidí",
  );
  report(
    mine.some((r) => r.stars === 2),
    "hvězdičky odpovídají nejlepšímu pokusu (uhodnuto na druhý → dvě)",
    mine.map((r) => r.stars).join(","),
  );

  // Tabulku kreseb autor napřímo nečte — tím se pravidlo nedá obejít.
  report(
    (await asUser(BOB, count(`public.drawings where id='${LIVE}'`))) === "ERROR",
    "autor nepřečte tabulku kreseb napřímo",
  );

  console.log("\nKnihovna kreseb — rozepsané ven, mazání jen vlastní:\n");

  // Rozepsaná kresba dělala v mřížce prázdnou dlaždici s popiskem
  // „čeká na 1. uhodnutí". Nemá tahy a hádat ji nikdo nemůže.
  await db.exec("begin");
  await db.exec(`
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${BOB}', true);
  `);
  const libraryIds = (await db.query("select drawing_id from public.my_drawings()")).rows.map(
    (r) => r.drawing_id,
  );
  await db.exec("rollback");
  report(
    !libraryIds.includes(DRAFT),
    "rozepsaná kresba se v knihovně neukazuje",
    libraryIds.join(", "),
  );

  // Řádek draftu ale musí zůstat — metrics_funnel na něm měří drop-off
  // „začal kreslit → neodeslal", což je jedno ze tří čísel fáze 0.
  await db.exec("begin");
  await db.exec(`
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${BOB}', true);
  `);
  const draftKept = (await db.query(`select public.delete_drawing('${DRAFT}') ok`)).rows[0].ok;
  await db.exec("rollback");
  const draftStillThere = (
    await db.query(`select status from public.drawings where id = '${DRAFT}'`)
  ).rows[0].status;
  report(
    draftKept === false && draftStillThere === "draft",
    "rozepsanou kresbu smazat nejde — drží drop-off pro metrics_funnel",
    `vráceno ${draftKept}, status ${draftStillThere}`,
  );

  // Cizí kresbu autorovi nikdo neodstraní. Podmínka je uvnitř update.
  await db.exec("begin");
  await db.exec(`
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${ALICE}', true);
  `);
  const foreign = (await db.query(`select public.delete_drawing('${LIVE}') ok`)).rows[0].ok;
  // Roli je potřeba vrátit — `authenticated` tabulku kreseb nepřečte (to je
  // právě ta ochrana z C4), takže by kontrolní select spadl na 42501.
  await db.exec("reset role");
  const foreignStatus = (
    await db.query(`select status from public.drawings where id = '${LIVE}'`)
  ).rows[0].status;
  await db.exec("rollback");
  report(
    foreign === false && foreignStatus === "live",
    "cizí kresbu smazat nejde",
    `vráceno ${foreign}, status ${foreignStatus}`,
  );

  // Vlastní ano — měkce, aby cizí tipy a čísla zásoby zůstala.
  await db.exec("begin");
  // Cizí tip, který smazání musí přežít. Tvrdý `delete` by ho vzal s sebou
  // kaskádou a s ním i podklad pro zásobu neuhodnutých (metrika 2).
  await db.exec(`
    insert into public.guesses (drawing_id, user_id, locale, attempt_no, text_raw, is_correct)
    values ('${LIVE}', '${ALICE}', 'cs', 1, 'medúza', false);
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${BOB}', true);
  `);
  const removed = (await db.query(`select public.delete_drawing('${LIVE}') ok`)).rows[0].ok;
  const afterDelete = (await db.query("select drawing_id from public.my_drawings()")).rows.map(
    (r) => r.drawing_id,
  );
  await db.exec("reset role");
  const rowSurvives = (
    await db.query(`select status from public.drawings where id = '${LIVE}'`)
  ).rows[0].status;
  const guessesSurvive = (
    await db.query(`select count(*)::int n from public.guesses where drawing_id = '${LIVE}'`)
  ).rows[0].n;
  await db.exec("rollback");
  report(removed === true, "vlastní kresbu autor smaže");
  report(
    !afterDelete.includes(LIVE),
    "smazaná kresba zmizí z knihovny",
    afterDelete.join(", "),
  );
  report(
    rowSurvives === "removed" && guessesSurvive > 0,
    "mazání je měkké — cizí tipy a čísla zásoby zůstanou",
    `status ${rowSurvives}, tipů ${guessesSurvive}`,
  );

  console.log("\nVyžádání a upozornění (blok E):\n");

  const conceptZaba = (await db.query(`select id from public.concepts where slug = 'zaba'`)).rows[0].id;

  // E4 — cizí akce nad mojí kresbou mi dá vědět, vlastní ne.
  await db.exec("begin");
  await db.exec(`
    set local role authenticated;
    select set_config('request.jwt.claim.sub', '${ALICE}', true);
  `);
  await db.query(`select public.submit_guess('${LIVE}', 'chobotnice')`);
  await db.query(`select public.give_thumb('${LIVE}')`);
  await db.exec("reset role");
  const forBob = (
    await db.query(`select kind from public.notifications where user_id = '${BOB}' order by kind`)
  ).rows.map((r) => r.kind);
  report(forBob.includes("guessed"), "autor se dozví, že ho někdo uhodl", forBob.join(","));
  report(forBob.includes("thumbed"), "autor se dozví o palci");
  const forAlice = (
    await db.query(`select count(*)::int n from public.notifications where user_id = '${ALICE}'`)
  ).rows[0].n;
  report(forAlice === 0, "hádač si sám sobě upozornění neposílá", String(forAlice));
  await db.exec("rollback");

  // E3 — splněné vyžádání dá vědět OBĚMA stranám. Ta druhá nese retenci.
  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const asked = (await db.query(`select public.request_concept('${conceptZaba}') as ok`)).rows[0].ok;
  report(asked === true, "vyžádání pojmu projde");

  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${BOB}', true);`,
  );
  const rd = (await db.query(`select public.start_drawing('${conceptZaba}') as id`)).rows[0].id;
  await db.exec("reset role");
  const src = (await db.query(`select source from public.drawings where id = '${rd}'`)).rows[0].source;
  report(src === "request", "kresba si pamatuje, že vznikla z vyžádání", src);

  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${BOB}', true);`,
  );
  await db.query(
    `select public.submit_drawing('${rd}', 'mouse', 0, '[{"tool":"brush","color":"#000","width":5,"points":[0.1,0.1,0,0.4,0.4,50]}]'::jsonb, 0.68)`,
  );
  await db.exec("reset role");

  const reqNotif = (
    await db.query(`select user_id, kind from public.notifications
                    where kind in ('request_filled','request_served')`)
  ).rows;
  report(
    reqNotif.some((r) => r.user_id === ALICE && r.kind === "request_filled"),
    "žadatel se dozví, že je jeho pojem nakreslený",
  );
  report(
    reqNotif.some((r) => r.user_id === BOB && r.kind === "request_served"),
    "kreslíř se dozví, že splnil konkrétnímu člověku přání — tohle nese retenci",
  );
  const reqStatus = (
    await db.query(`select status from public.concept_requests where concept_id = '${conceptZaba}'`)
  ).rows[0].status;
  report(reqStatus === "fulfilled", "žádost se uzavře", reqStatus);
  await db.exec("rollback");

  // Denní limit žádostí
  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const slugs = ["pes", "kocka", "ryba", "ptak", "slon"];
  const results = [];
  for (const s of slugs) {
    await db.exec("reset role");
    const cid = (await db.query(`select id from public.concepts where slug = '${s}'`)).rows[0].id;
    await db.exec(
      `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
    );
    results.push((await db.query(`select public.request_concept('${cid}') as ok`)).rows[0].ok);
  }
  await db.exec("rollback");
  report(
    results.filter(Boolean).length === 3 && results[3] === false,
    "denní limit žádostí drží — bez něj je vyžádání spam kanál",
    results.join(","),
  );

  console.log("\nProvoz a měření (blok F):\n");

  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const rep1 = (
    await db.query(`select public.report_drawing('${LIVE}', 'test') as ok`)
  ).rows[0].ok;
  report(rep1 === true, "nahlášení projde");

  // Poměr musí dojít i k hádajícímu, jinak ho vykreslí do tvaru své obrazovky.
  const feed = (await db.query("select * from public.next_drawing()")).rows[0];
  report(
    feed && typeof feed.aspect === "number" && feed.aspect > 0,
    "hádající dostane poměr kresby",
    feed ? String(feed.aspect) : "prázdný feed",
  );

  // Důvod je poprvé text od uživatele („jiné" v dialogu), takže potřebuje strop.
  // Hlásí BOB, ne ALICE — dvojice kresba+člověk je unikátní a Alicino hlášení
  // už existuje, takže by se druhý pokus zahodil a test by prošel naprázdno.
  await db.exec("savepoint duvod");
  await db.exec(`select set_config('request.jwt.claim.sub', '${BOB}', true);`);
  const dlouhy = (
    await db.query(`select public.report_drawing('${LIVE}', $1) as ok`, ["y".repeat(5000)])
  ).rows[0].ok;
  await db.exec("reset role");
  const orezany = (
    await db.query(
      `select reason from public.reports where drawing_id = '${LIVE}' and reporter_id = '${BOB}'`,
    )
  ).rows[0].reason;
  await db.exec("rollback to savepoint duvod");
  report(
    dlouhy === true && orezany.length === 300,
    "dlouhý důvod se ořízne na 300 znaků, ne odmítne",
    `vráceno ${dlouhy}, uloženo ${orezany.length} znaků`,
  );

  const lb = (await db.query("select * from public.daily_leaderboard()")).rows;
  report(Array.isArray(lb), "denní žebříček se načte");

  const prof = (await db.query("select * from public.my_profile()")).rows[0];
  report(typeof prof.ab_playback === "boolean", "uživatel má přiřazenou skupinu testu přehrání");

  await db.exec("rollback");

  // Sloupce, které si uživatel měnit NESMÍ. Dřív je „chránil" revoke na
  // sloupec, který ale nic nedělal, když má role právo na celou tabulku
  // (viz migrace 20260819080000). Nejzávažnější byl tenant_id — šlo se
  // tím sám přesunout do školního tenantu, tedy obejít pravidlo 1.
  async function cannotWrite(column, value) {
    await db.exec("begin");
    let denied = false;
    try {
      await db.exec(
        `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
      );
      await db.exec(`update public.profiles set ${column} = ${value} where id = '${ALICE}'`);
    } catch {
      denied = true;
    }
    await db.exec("rollback");
    report(denied, `uživatel si nepřepíše ${column}`);
  }

  await cannotWrite("ab_playback", "true");
  await cannotWrite("tenant_id", `'${SCHOOL}'`);
  await cannotWrite("xp", "99999");
  await cannotWrite("skill_rating", "99");
  await cannotWrite("is_minor", "false");

  // Co měnit smí, měnit musí jít.
  await db.exec("begin");
  let nameOk = false;
  try {
    await db.exec(
      `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
    );
    await db.exec(`update public.profiles set display_name = 'Alice Nová' where id = '${ALICE}'`);
    nameOk = true;
  } catch {
    nameOk = false;
  }
  await db.exec("rollback");
  report(nameOk, "vlastní jméno si změnit může");

  const views = (
    await db.query(`select count(*)::int n from pg_views where schemaname = 'private'`)
  ).rows[0].n;
  report(views === 5, "metriky existují jako pohledy pro majitele", String(views));

  console.log("\nKredity (blok I):\n");

  {
    // Celý běh v jedné transakci, na konci se vrátí — produkční data se nemění.
    await db.exec("begin");
    await db.exec(
      `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
    );

    const kresba = (await db.query(`select public.start_drawing('${conceptPes}') id`)).rows[0].id;
    const tah = JSON.stringify([
      { tool: "brush", color: "#2B261F", width: 8, points: [0.2, 0.2, 0, 0.6, 0.6, 40] },
    ]);
    await db.query(`select public.submit_drawing('${kresba}', 'touch', 0, $1::jsonb, 0.68)`, [tah]);

    // conceptPes je snadný pojem → základ 1.
    const poKresbe = (await db.query("select public.my_credits() c")).rows[0].c;
    report(poKresbe === 1, "za odeslání kresby se připsal základ", `${poKresbe}`);

    // Uhodne ji někdo jiný: hádač dostane 1, autor bonus podle obtížnosti.
    await db.exec(`select set_config('request.jwt.claim.sub', '${BOB}', true);`);
    await db.query(`select * from public.submit_guess('${kresba}', 'pes')`);
    const hadac = (await db.query("select public.my_credits() c")).rows[0].c;
    await db.exec(`select set_config('request.jwt.claim.sub', '${ALICE}', true);`);
    const autor = (await db.query("select public.my_credits() c")).rows[0].c;
    report(hadac >= 1, "za uhodnutí se připsal kredit hádači", `${hadac}`);
    report(autor === 2, "autor dostal bonus za první uhodnutí (1 + 1)", `${autor}`);

    // Druhé uhodnutí bonus NEZOPAKUJE — jinak by populární kresba platila pořád.
    await db.exec("reset role");
    await db.exec(`insert into auth.users (id, raw_user_meta_data) values
      ('99999999-9999-9999-9999-999999999999', '{"display_name":"Cyril","invite_code":"INK-SEED"}')`);
    await db.exec(
      `set local role authenticated; select set_config('request.jwt.claim.sub', '99999999-9999-9999-9999-999999999999', true);`,
    );
    await db.query(`select * from public.submit_guess('${kresba}', 'pes')`);
    await db.exec(`select set_config('request.jwt.claim.sub', '${ALICE}', true);`);
    const poDruhem = (await db.query("select public.my_credits() c")).rows[0].c;
    report(poDruhem === autor, "druhé uhodnutí bonus nezopakuje", `${autor} → ${poDruhem}`);

    // Nákup: bez kreditů se odmítne.
    let chudy = "prošlo";
    await db.exec("savepoint nakup");
    try {
      await db.query("select public.buy_color_mixer()");
    } catch (e) {
      chudy = e.message.includes("Nedostatek") ? "odmítnuto" : `jinak: ${e.message}`;
    }
    await db.exec("rollback to savepoint nakup");
    report(chudy === "odmítnuto", "bez kreditů se míchání barev nekoupí");

    // S kredity projde a odečte se cena z konfigurace.
    await db.exec("reset role");
    await db.exec(`insert into public.ledger (user_id, delta, reason) values ('${ALICE}', 100, 'test')`);
    await db.exec(
      `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
    );
    const pred = (await db.query("select public.my_credits() c")).rows[0].c;
    await db.query("select public.buy_color_mixer()");
    const po = (await db.query("select public.my_credits() c")).rows[0].c;
    const profil = (await db.query("select * from public.my_profile()")).rows[0];
    report(pred - po === 25, "nákup odečte cenu z konfigurace", `${pred} → ${po}`);
    report(profil.has_color_mixer === true, "odemčení se propíše do profilu");

    await db.query("select public.buy_color_mixer()");
    const poDruhemNakupu = (await db.query("select public.my_credits() c")).rows[0].c;
    report(poDruhemNakupu === po, "druhý nákup se neúčtuje", `${po} → ${poDruhemNakupu}`);

    // Uživatel si odemčení nenastaví sám.
    let podvod = "prošlo";
    await db.exec("savepoint podvrh");
    try {
      await db.exec(`update public.profiles set has_color_mixer = true where id = '${BOB}'`);
    } catch {
      podvod = "odmítnuto";
    }
    await db.exec("rollback to savepoint podvrh");
    report(podvod === "odmítnuto", "uživatel si odemčení nenastaví sám");

    await db.exec("rollback");
  }
  console.log("\nSprávcovské rozhraní (blok H):\n");

  // Nejdůležitější test celého bloku: běžný uživatel se k tomu nedostane.
  for (const volani of [
    "public.admin_reports()",
    "public.admin_drawings()",
    "public.admin_users()",
    "public.admin_overview()",
    "public.admin_supply()",
    "public.admin_log()",
    `public.admin_set_user_status('${BOB}', 'banned')`,
    `public.admin_set_drawing_status('${LIVE}', 'removed')`,
  ]) {
    report(
      (await asUser(ALICE, `select * from ${volani}`)) === "ERROR",
      `běžný uživatel nesmí ${volani.split("(")[0].replace("public.", "")}`,
    );
  }

  // Příznak správce si nesmí nastavit sám — sloupcová práva to musí utnout.
  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  let povysilSe = false;
  try {
    await db.exec(`update public.profiles set is_admin = true where id = '${ALICE}'`);
    povysilSe = true;
  } catch {
    povysilSe = false;
  }
  await db.exec("rollback");
  report(!povysilSe, "uživatel si nenastaví is_admin — jinak si vezme celou moderaci");

  // Totéž pro odblokování sebe sama.
  await db.exec("begin");
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  let odblokovalSe = false;
  try {
    await db.exec(`update public.profiles set status = 'active' where id = '${ALICE}'`);
    odblokovalSe = true;
  } catch {
    odblokovalSe = false;
  }
  await db.exec("rollback");
  report(!odblokovalSe, "uživatel si nepřepíše stav účtu — jinak by ban nic neznamenal");

  // S rolí správce už funkce chodí.
  await db.exec("begin");
  await db.exec(`update public.profiles set is_admin = true where id = '${ALICE}'`);
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const hlaseni = (await db.query("select * from public.admin_reports('all')")).rows;
  const prehled = (await db.query("select * from public.admin_overview()")).rows;
  const zasoba = (await db.query("select * from public.admin_supply()")).rows;
  const metrika = (await db.query("select public.admin_metrics('supply') as m")).rows[0].m;
  report(Array.isArray(hlaseni), "správce vidí frontu hlášení", `${hlaseni.length}`);
  report(prehled.length === 3, "přehled má tři období", prehled.map((r) => r.obdobi).join(", "));
  report(zasoba.length > 0, "zásoba slov se spočítá", `${zasoba.length} obtížností`);
  report(Array.isArray(metrika), "metriky z F3 jsou pro správce čitelné");

  // Neznámý název metriky se nesmí dostat do dotazu.
  // Výjimka uvnitř transakce ji zruší celou, takže test musí mít savepoint.
  let injektaz = "prošlo";
  await db.exec("savepoint injektaz");
  try {
    await db.query(`select public.admin_metrics('supply; drop table public.profiles')`);
  } catch {
    injektaz = "odmítnuto";
  }
  await db.exec("rollback to savepoint injektaz");
  report(injektaz === "odmítnuto", "název metriky mimo výčet se odmítne");

  // Uzavření hlášení. Naostro se neklikalo — jsou to majitelova data.
  // Hlášení ze začátku testu žilo ve vrácené transakci, takže si tu vyrobíme
  // vlastní; jinak by se uzavíralo prázdno a test by prošel naprázdno.
  await db.query(`select public.report_drawing('${LIVE}', 'scribble')`);
  const otevrene = (await db.query("select * from public.admin_reports('open')")).rows;
  const zavreno = otevrene.length > 0
    ? (await db.query(`select public.admin_resolve_report('${otevrene[0].report_id}', 'dismissed') ok`)).rows[0].ok
    : null;
  const poZavreni = (await db.query("select * from public.admin_reports('open')")).rows;
  report(
    zavreno === true && poZavreni.length === otevrene.length - 1,
    "uzavřené hlášení zmizí z fronty",
    `${otevrene.length} → ${poZavreni.length}`,
  );

  // Neznámý stav hlášení se odmítne, ať ve frontě nevznikne třetí kategorie.
  let stav = "prošlo";
  await db.exec("savepoint stavhlaseni");
  try {
    await db.query(`select public.admin_resolve_report('${otevrene[0].report_id}', 'smazano')`);
  } catch {
    stav = "odmítnuto";
  }
  await db.exec("rollback to savepoint stavhlaseni");
  report(stav === "odmítnuto", "neznámý stav hlášení se odmítne");

  // Ban drží databáze, ne aplikace — trigger na zápisu.
  await db.exec("reset role");
  await db.query(`select public.admin_set_user_status('${BOB}', 'banned', 'test')`);
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${BOB}', true);`,
  );
  let banFunguje = false;
  await db.exec("savepoint ban");
  try {
    await db.query(`select public.start_drawing('${conceptPes}')`);
  } catch (e) {
    banFunguje = e.message.includes("zablokovaný");
  }
  await db.exec("rollback to savepoint ban");
  report(banFunguje, "zablokovaný účet nezaloží kresbu — drží to trigger, ne RPC");

  // A jeho kresby přestanou kolovat.
  await db.exec(
    `set local role authenticated; select set_config('request.jwt.claim.sub', '${ALICE}', true);`,
  );
  const feedPoBanu = (await db.query("select * from public.next_drawing()")).rows;
  report(feedPoBanu.length === 0, "kresby zablokovaného se přestanou nabízet");

  // Zásah se zapsal.
  const log = (await db.query("select * from public.admin_log()")).rows;
  report(log.some((r) => r.action === "user_banned"), "zásah správce je v záznamu");
  await db.exec("rollback");

  console.log("\nLedger je append-only, ale nebrání smazání účtu:\n");

  // Append-only drží odebrané právo, ne pravidlo. Pravidlo by rozbilo kaskádu
  // z cizích klíčů a účet by pak nešel smazat vůbec (viz migrace
  // 20260818230000). Ověřuje se obojí — ochrana i to, že mazání jde.
  for (const role of ["authenticated", "service_role"]) {
    await db.exec("begin");
    let denied = false;
    try {
      await db.exec(`set local role ${role}`);
      await db.exec(`update public.ledger set delta = 999 where user_id = '${BOB}'`);
    } catch {
      denied = true;
    }
    await db.exec("rollback");
    report(denied, `role ${role} nepřepíše ledger`);
  }

  // Uživatel se smaže i když po sobě něco nechal. Předtím tenhle test prošel
  // s prázdným účtem a přehlédl, že `drawing_strokes.author_id` blokoval
  // kaskádu — viz migrace 20260819020000.
  await db.exec("begin");
  await db.exec(`insert into public.ledger (user_id, delta, reason) values ('${ALICE}', 5, 'test')`);
  await db.exec(`
    insert into public.drawings (id, author_id, concept_id, source_locale, status)
    values ('88888888-8888-8888-8888-888888888888', '${ALICE}', '${CONCEPT}', 'cs', 'live');
    insert into public.drawing_strokes values
      ('88888888-8888-8888-8888-888888888888', 0, '${ALICE}', 'brush', '#000', 5, '[0.1,0.1,0]'::jsonb);
    insert into public.guesses (drawing_id, user_id, locale, attempt_no, text_raw)
    values ('66666666-6666-6666-6666-666666666666', '${ALICE}', 'cs', 1, 'pokus');
  `);
  let deleted = false;
  let deleteError = "";
  try {
    await db.query(`delete from auth.users where id = '${ALICE}'`);
    deleted = true;
  } catch (e) {
    deleteError = e.message.split("\n")[0];
  }
  const leftovers = deleted
    ? (await db.query(`select count(*)::int n from public.profiles where id = '${ALICE}'`)).rows[0].n
    : -1;
  await db.exec("rollback");
  report(deleted, "účet jde smazat i se záznamy v ledgeru (GDPR)", deleteError);
  report(leftovers === 0, "po smazání účtu nezůstane profil");

  console.log(`\n${passed} prošlo, ${failed} selhalo`);
  await db.close();
  process.exit(failed ? 1 : 0);
}

main();

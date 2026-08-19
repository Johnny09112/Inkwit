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
  report((await asUser(ALICE, count(`public.drawings where id='${DRAFT}'`))) === 0,
    "cizí rozepsanou kresbu");
  report((await asUser(ALICE, count(`public.ledger where user_id='${BOB}'`))) === 0,
    "cizí ledger");
  report((await asUser(ALICE, count("public.concepts"))) === "ERROR",
    "koncepty");
  report((await asUser(ALICE, count("public.concept_locales"))) === "ERROR",
    "zadání konceptu — jinak zná odpověď");
  report((await asUser(ALICE, count("public.concept_answers"))) === "ERROR",
    "přijímané odpovědi — jinak zná všechny odpovědi");
  report((await asUser(ALICE, count(`public.drawings where id='${LIVE}'`))) === 0,
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

  const draftStatus = (
    await db.query(`select status from public.drawings where id = '${draftId}'`)
  ).rows[0].status;
  report(draftStatus === "draft", "rozepsaná kresba má stav draft", draftStatus);

  // Klient posílá jen tahy — žádné duration_ms, stroke_count ani coverage.
  const strokes = JSON.stringify([
    { tool: "brush", color: "#2B261F", width: 14, points: [0.2, 0.2, 0, 0.6, 0.5, 10] },
    { tool: "brush", color: "#B5462F", width: 8, points: [0.3, 0.3, 0, 0.4, 0.4, 20] },
  ]);
  await db.query(`select public.submit_drawing('${draftId}', 'pen', 3, $1::jsonb)`, [strokes]);

  const saved = (
    await db.query(`select status, stroke_count, coverage, device_kind, undo_count,
                           duration_ms, published_at is not null as publikovano
                    from public.drawings where id = '${draftId}'`)
  ).rows[0];
  report(saved.status === "live", "po odeslání je kresba živá", saved.status);
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
      await db.query(`select public.submit_drawing('${id}', 'mouse', 0, $1::jsonb)`, [strokesJson]);
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

  await db.exec("begin");
  await db.exec(`insert into public.ledger (user_id, delta, reason) values ('${ALICE}', 5, 'test')`);
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

/**
 * Kontrola a nasazení slovní zásoby.
 *
 *   node supabase/seed/check-concepts.mjs          — jen zkontroluje a vypíše statistiku
 *   node supabase/seed/check-concepts.mjs --sql    — vypíše SQL na stdout
 *
 * Nejdůležitější kontrola je ta na dvojznačnost: když je stejný tvar přijímaný
 * u dvou konceptů, hráč napíše správnou odpověď a hra ji vyhodnotí jako špatnou
 * u toho druhého. Okem se to v sedmisetpoložkovém seznamu nenajde.
 */

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const data = JSON.parse(fs.readFileSync(path.join(HERE, "concepts.json"), "utf8"));
const concepts = data.concepts;

const CATEGORIES = ["zvire", "predmet", "priroda", "jidlo", "cinnost", "abstraktni"];
const LOCALES = ["cs", "en"];

/** Stejná normalizace, jakou bude dělat porovnávání odpovědí (krok B4). */
const norm = (s) =>
  s.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase().trim().replace(/\s+/g, " ");

const problems = [];
const warnings = [];

// --- základní tvar záznamů ---
const ids = new Set();
for (const c of concepts) {
  const at = `${c.id}`;
  if (ids.has(c.id)) problems.push(`${at}: duplicitní id`);
  ids.add(c.id);
  if (![1, 2, 3].includes(c.difficulty)) problems.push(`${at}: obtížnost mimo 1–3`);
  if (!CATEGORIES.includes(c.category)) problems.push(`${at}: neznámá kategorie „${c.category}"`);

  for (const loc of LOCALES) {
    const l = c[loc];
    if (!l?.prompt) { problems.push(`${at}/${loc}: chybí zadání`); continue; }
    if (!l.accepted?.length) { problems.push(`${at}/${loc}: prázdný seznam odpovědí`); continue; }
    if (!l.accepted.some((a) => norm(a) === norm(l.prompt))) {
      problems.push(`${at}/${loc}: zadání „${l.prompt}" není mezi přijímanými odpověďmi`);
    }
    const seen = new Set();
    for (const a of l.accepted) {
      if (seen.has(norm(a))) warnings.push(`${at}/${loc}: „${a}" je v seznamu dvakrát`);
      seen.add(norm(a));
    }
  }
}

// --- dvojznačnost napříč koncepty ---
for (const loc of LOCALES) {
  const owner = new Map();
  for (const c of concepts) {
    for (const a of c[loc]?.accepted ?? []) {
      const k = norm(a);
      if (owner.has(k) && owner.get(k) !== c.id) {
        problems.push(`${loc}: „${a}" přijímá ${owner.get(k)} i ${c.id} — hráč nemůže uhodnout správně`);
      } else {
        owner.set(k, c.id);
      }
    }
  }
}

// --- past na překlepovou toleranci ---
//
// Prahy musí sedět s private.answer_matches (migrace 20260819040000_matching.sql)
// a s game_config: pod FUZZY_EXACT znaků přesná shoda, pod FUZZY_ONE vzdálenost 1,
// od té délky 2. Strop se řídí délkou SPRÁVNÉ odpovědi, ne délkou tipu.
//
// Od migrace 20260820160000 tyhle dvojice hru nerozbíjejí: tip, který je
// PŘESNOU odpovědí jiného pojmu, se přes toleranci neuzná. Zůstává to ale
// upozornění — dvě slova na vzdálenost jednoho znaku jsou v sadě typicky
// znamení, že jeden z tvarů je zbytečný, a je levnější ho vyhodit.

const FUZZY_EXACT = 5;
const FUZZY_ONE = 8;
const allowance = (n) => (n.length < FUZZY_EXACT ? 0 : n.length < FUZZY_ONE ? 1 : 2);

/** Levenshtein se stropem — stejná sémantika jako private.edit_distance. */
const editDistance = (a, b, max) => {
  if (Math.abs(a.length - b.length) > max) return max + 1;
  let prev = Array.from({ length: b.length + 1 }, (_, i) => i);
  for (let i = 1; i <= a.length; i++) {
    const cur = new Array(b.length + 1);
    cur[0] = i;
    let best = i;
    for (let j = 1; j <= b.length; j++) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      cur[j] = Math.min(cur[j - 1] + 1, prev[j] + 1, prev[j - 1] + cost);
      if (cur[j] < best) best = cur[j];
    }
    if (best > max) return max + 1;
    prev = cur;
  }
  return prev[b.length];
};

let shortPairs = 0;
for (const loc of LOCALES) {
  const forms = [];
  for (const c of concepts)
    for (const a of c[loc]?.accepted ?? []) forms.push({ n: norm(a), raw: a, id: c.id });

  for (let i = 0; i < forms.length; i++)
    for (let j = i + 1; j < forms.length; j++) {
      const x = forms[i];
      const y = forms[j];
      if (x.id === y.id) continue;
      const max = Math.max(allowance(x.n), allowance(y.n));
      if (max === 0) {
        // Bezpečná zóna: jen doklad pro práh, když se liší jediným znakem.
        if (x.n.length === y.n.length && editDistance(x.n, y.n, 1) === 1) shortPairs++;
        continue;
      }
      const d = editDistance(x.n, y.n, max);
      if (d === 0) continue; // shodné tvary hlásí kontrola dvojznačnosti
      if (d <= allowance(x.n) || d <= allowance(y.n)) {
        warnings.push(
          `${loc}: „${x.raw}" (${x.id}) a „${y.raw}" (${y.id}) jsou na vzdálenost ${d} — pojistku to projde, ale je to blízko`,
        );
      }
    }
}

// --- výpis ---
const byDiff = [1, 2, 3].map((d) => concepts.filter((c) => c.difficulty === d).length);
const byCat = CATEGORIES.map((k) => `${k} ${concepts.filter((c) => c.category === k).length}`);
const noCross = concepts.filter((c) => !c.crossLanguage);
const notSafe = concepts.filter((c) => !c.schoolSafe);
const forms = LOCALES.map((l) => concepts.reduce((n, c) => n + (c[l]?.accepted?.length ?? 0), 0));

if (!process.argv.includes("--sql")) {
  console.log(`Konceptů: ${concepts.length}`);
  console.log(`Obtížnost:  ★ ${byDiff[0]}  ★★ ${byDiff[1]}  ★★★ ${byDiff[2]}`);
  console.log(`Kategorie:  ${byCat.join(" · ")}`);
  console.log(`Přijímaných tvarů: cs ${forms[0]} · en ${forms[1]}`);
  console.log(`Krátkých dvojic na jeden znak (proto přesná shoda do ${FUZZY_EXACT - 1} znaků): ${shortPairs}`);
  console.log(`Jen jednojazyčné: ${noCross.map((c) => c.id).join(", ") || "žádné"}`);
  console.log(`Ne pro školy: ${notSafe.map((c) => c.id).join(", ") || "žádné"}`);
  console.log("");
  if (warnings.length) {
    console.log(`Upozornění (${warnings.length}):`);
    for (const w of warnings) console.log("  ! " + w);
    console.log("");
  }
  if (problems.length) {
    console.log(`CHYBY (${problems.length}):`);
    for (const p of problems) console.log("  ✗ " + p);
    process.exit(1);
  }
  console.log("Bez chyb.");
  process.exit(0);
}

if (problems.length) {
  console.error("Nelze generovat SQL, data mají chyby. Spusť bez --sql.");
  process.exit(1);
}

const q = (s) => "'" + s.replace(/'/g, "''") + "'";
const arr = (a) => "array[" + a.map(q).join(", ") + "]::text[]";

const out = [
  "-- Generováno z supabase/seed/concepts.json příkazem",
  "--   node supabase/seed/check-concepts.mjs --sql > supabase/migrations/<ts>_seed_concepts.sql",
  "-- Needituj ručně. Klíčem je slug, takže opakované nasazení je bezpečné.",
  "",
];

for (const c of concepts) {
  out.push(
    `insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)`,
    `values (${q(c.id)}, ${c.difficulty}, ${q(c.category)}, ${c.crossLanguage}, ${c.schoolSafe})`,
    `on conflict (slug) do update set difficulty = excluded.difficulty,`,
    `  category = excluded.category, is_cross_language = excluded.is_cross_language,`,
    `  is_school_safe = excluded.is_school_safe;`,
  );
  for (const loc of LOCALES) {
    const l = c[loc];
    out.push(
      `insert into public.concept_locales (concept_id, locale, prompt)`,
      `select id, ${q(loc)}, ${q(l.prompt)} from public.concepts where slug = ${q(c.id)}`,
      `on conflict (concept_id, locale) do update set prompt = excluded.prompt;`,
      `insert into public.concept_answers (concept_id, locale, accepted)`,
      `select id, ${q(loc)}, ${arr(l.accepted)} from public.concepts where slug = ${q(c.id)}`,
      `on conflict (concept_id, locale) do update set accepted = excluded.accepted;`,
    );
  }
  out.push("");
}

console.log(out.join("\n"));

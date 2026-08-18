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

// --- past na krátká slova a Levenshtein ---
for (const loc of LOCALES) {
  const shorts = [];
  for (const c of concepts) for (const a of c[loc]?.accepted ?? []) {
    const n = norm(a);
    if (n.length <= 4) shorts.push({ n, id: c.id });
  }
  for (let i = 0; i < shorts.length; i++)
    for (let j = i + 1; j < shorts.length; j++) {
      if (shorts[i].id === shorts[j].id) continue;
      const [a, b] = [shorts[i].n, shorts[j].n];
      if (a.length === b.length) {
        let diff = 0;
        for (let k = 0; k < a.length; k++) if (a[k] !== b[k]) diff++;
        if (diff === 1) {
          warnings.push(`${loc}: „${a}" (${shorts[i].id}) a „${b}" (${shorts[j].id}) se liší jedním znakem — fuzzy shoda je smí splést`);
        }
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
const out = ["-- Generováno z supabase/seed/concepts.json — needituj ručně.", "begin;", ""];
for (const c of concepts) {
  out.push(
    `insert into public.concepts (id, difficulty, category, is_cross_language, is_school_safe)`,
    `values (gen_random_uuid(), ${c.difficulty}, ${q(c.category)}, ${c.crossLanguage}, ${c.schoolSafe})`,
    `on conflict do nothing;`,
    ``,
  );
}
out.push("commit;");
console.log(out.join("\n"));

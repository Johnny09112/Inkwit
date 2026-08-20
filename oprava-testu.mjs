import fs from "node:fs";

const p = "supabase/tests/rls.test.mjs";
let s = fs.readFileSync(p, "utf8");

const od = s.indexOf("    // Nákup: bez kreditů se odmítne.");
const doKonce = s.indexOf("    await db.exec(\"rollback\");\n  }\n\n  console.log(\"\nSprávcovské rozhraní");
if (od < 0 || doKonce < 0) throw new Error("hranice nenalezeny");

const nahrada = `    // Level roste z CELKEM vydělaných, ne ze zůstatku.
    await db.exec("reset role");
    await db.exec(\`insert into public.ledger (user_id, delta, reason) values ('\${ALICE}', 60, 'test')\`);
    await db.exec(
      \`set local role authenticated; select set_config('request.jwt.claim.sub', '\${ALICE}', true);\`,
    );
    const p1 = (await db.query("select * from public.my_profile()")).rows[0];
    // Prahy 0/10/25/50/100/175 → 62 vydělaných je level 4.
    report(p1.level === 4, "level se počítá z vydělaných kreditů", \`\${p1.lifetime} → level \${p1.level}\`);
    report(p1.next_level_at === 100, "profil hlásí, kolik chce další level", \`\${p1.next_level_at}\`);

    // Utracení level NESNÍŽÍ — jinak by nákup kosmetiky brал odemčené funkce.
    await db.exec("reset role");
    await db.exec(\`insert into public.ledger (user_id, delta, reason) values ('\${ALICE}', -50, 'test-utrata')\`);
    await db.exec(
      \`set local role authenticated; select set_config('request.jwt.claim.sub', '\${ALICE}', true);\`,
    );
    const p2 = (await db.query("select * from public.my_profile()")).rows[0];
    report(
      p2.level === p1.level && p2.credits < p1.credits,
      "utracení sníží zůstatek, ale ne level",
      \`level \${p1.level} → \${p2.level}, zůstatek \${p1.credits} → \${p2.credits}\`,
    );

    // Vyžádání pojmu se NEGATUJE — nese hlavní hypotézu fáze 0.
    let vyzadani = "odmítnuto";
    await db.exec("savepoint vyzadani");
    try {
      await db.query(\`select public.request_concept('\${conceptZaba}')\`);
      vyzadani = "prošlo";
    } catch {
      vyzadani = "odmítnuto";
    }
    await db.exec("rollback to savepoint vyzadani");
    report(vyzadani === "prošlo", "vyžádání pojmu není za levelem — nese hypotézu fáze 0");

`;

s = s.slice(0, od) + nahrada + s.slice(doKonce);
fs.writeFileSync(p, s);
console.log("testy levelů vloženy");

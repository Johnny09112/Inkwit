/**
 * Test pojistky „jméno se nesmí shodovat s heslem": `npm run test:unit`.
 *
 * Vzniklo z reálného případu — heslo účtu skončilo v poli pro jméno a uložilo
 * se jako veřejná přezdívka. Testuje se hlavně to, co pojistka NESMÍ chytit:
 * falešný poplach na registraci je horší než ta nehoda, protože ho uvidí každý.
 */

import assert from "node:assert/strict";
import { test } from "node:test";
import { nameMatchesPassword } from "./auth.ts";

test("shodné jméno a heslo se pozná", () => {
  assert.ok(nameMatchesPassword("G73rvwKg", "G73rvwKg"));
});

test("mezera navíc z vloženého hesla pojistku neošálí", () => {
  assert.ok(nameMatchesPassword("  G73rvwKg ", "G73rvwKg"));
  assert.ok(nameMatchesPassword("G73rvwKg", " G73rvwKg  "));
});

test("velikost písmen nerozhoduje", () => {
  assert.ok(nameMatchesPassword("g73rvwkg", "G73rvwKg"));
});

test("běžná přezdívka projde, i když vypadá jako heslo", () => {
  // Tohle je ten důležitý směr. „Johnny09112" je skutečná přezdívka majitele
  // a heuristika „vypadá to jako heslo" by ji zablokovala.
  assert.ok(!nameMatchesPassword("Johnny09112", "uplne-jine-heslo"));
  assert.ok(!nameMatchesPassword("Šáša", "Šáša123"));
});

test("prázdné pole není shoda", () => {
  // Během psaní je jedno z polí chvíli prázdné a hláška by blikala.
  assert.ok(!nameMatchesPassword("", ""));
  assert.ok(!nameMatchesPassword("Ada", ""));
  assert.ok(!nameMatchesPassword("", "heslo"));
  assert.ok(!nameMatchesPassword("   ", "   "));
});

test("částečná shoda se neblokuje", () => {
  assert.ok(!nameMatchesPassword("G73rvwK", "G73rvwKg"));
  assert.ok(!nameMatchesPassword("G73rvwKgx", "G73rvwKg"));
});

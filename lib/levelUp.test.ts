/**
 * Test toho, KDY se oslava levelu ukáže: `npm run test:unit`.
 *
 * Vzhled se ověřuje v prohlížeči, ale tahle logika je ta, která může tiše
 * selhat — buď gratulace nepřijde vůbec, nebo přijde nezaslouženě. Obojí je
 * horší než mít ji ošklivou.
 */

import assert from "node:assert/strict";
import { test } from "node:test";
import { unlocksAtLevel, unlocksBetween } from "./unlocks.ts";

const CFG = { paletteFullLevel: 2, mixerLevel: 3, shapesLevel: 4 };

/** Náhrada localStorage — prefs.ts sahá na `window`, v testu žádné není. */
function stubWindow() {
  const store = new Map<string, string>();
  (globalThis as { window?: unknown }).window = {
    localStorage: {
      getItem: (k: string) => (store.has(k) ? store.get(k)! : null),
      setItem: (k: string, v: string) => void store.set(k, v),
    },
  };
  return store;
}

test("první načtení negratuluje — nový účet level 1 nepřekročil", async () => {
  stubWindow();
  const { takeLevelUp } = await import("./prefs.ts");
  assert.equal(takeLevelUp(1), null);
});

test("posun o patro se ohlásí právě jednou", async () => {
  stubWindow();
  const { takeLevelUp } = await import("./prefs.ts");
  takeLevelUp(1);
  assert.deepEqual(takeLevelUp(2), { from: 1, to: 2 });
  // Druhé načtení téhož levelu už neslaví — jinak by gratulace naskakovala
  // při každém otevření obrazovky.
  assert.equal(takeLevelUp(2), null);
});

test("skok o dvě patra se ohlásí jako jeden posun", async () => {
  stubWindow();
  const { takeLevelUp } = await import("./prefs.ts");
  takeLevelUp(1);
  assert.deepEqual(takeLevelUp(3), { from: 1, to: 3 });
});

test("pokles levelu negratuluje", async () => {
  stubWindow();
  const { takeLevelUp } = await import("./prefs.ts");
  takeLevelUp(3);
  assert.equal(takeLevelUp(2), null);
});

test("výčet odemčení bere všechna přeskočená patra", () => {
  // Kdo skočí z jedničky na trojku, musí dostat paletu I míchání barev.
  assert.deepEqual(
    unlocksBetween(1, 3, CFG).map((u) => u.key),
    ["palette", "mixer"],
  );
});

test("výčet nezahrnuje patro, ze kterého se odchází", () => {
  assert.deepEqual(unlocksBetween(2, 3, CFG).map((u) => u.key), ["mixer"]);
});

test("patro bez odemčení vrátí prázdno, ne výjimku", () => {
  assert.deepEqual(unlocksAtLevel(5, CFG), []);
  assert.deepEqual(unlocksBetween(4, 5, CFG), []);
});

test("jádro hry sedí na levelu 1 a nikde jinde", () => {
  // Připomínka: kreslení, hádání ani obtížnosti se nesmí gatovat.
  assert.deepEqual(unlocksAtLevel(1, CFG), ["core"]);
});

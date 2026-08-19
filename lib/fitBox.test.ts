/**
 * Test vepsání kresby do plochy: `npm run test:unit`.
 *
 * Tohle je oprava toho, že se kresba roztahovala — poměrné souřadnice se
 * mapovaly na každou osu zvlášť, takže kruh nakreslený na vysokém plátně byl
 * v hádání ovál. Testuje se to, co se okem pozná až na hotové kresbě.
 */

import assert from "node:assert/strict";
import { test } from "node:test";
import { fitBox } from "./strokes.ts";

const near = (a: number, b: number, kde: string) =>
  assert.ok(Math.abs(a - b) < 1e-9, `${kde}: ${a} vs ${b}`);

test("bez zadaného tvaru se použije celá plocha", () => {
  const b = fitBox(300, 500);
  assert.deepEqual(b, { x: 0, y: 0, width: 300, height: 500 });
});

test("vysoká kresba v široké ploše se omezí výškou a vystředí vodorovně", () => {
  // Kresba 0,5 (vysoká) do plochy 400×200.
  const b = fitBox(400, 200, 0.5);
  near(b.height, 200, "výška vyplní");
  near(b.width, 100, "šířka dopočítána z tvaru");
  near(b.x, 150, "vystředěno vodorovně");
  near(b.y, 0, "svisle na doraz");
});

test("široká kresba ve vysoké ploše se omezí šířkou a vystředí svisle", () => {
  const b = fitBox(200, 400, 2);
  near(b.width, 200, "šířka vyplní");
  near(b.height, 100, "výška dopočítána");
  near(b.y, 150, "vystředěno svisle");
  near(b.x, 0, "vodorovně na doraz");
});

test("tvar kresby zůstane zachovaný bez ohledu na tvar plochy", () => {
  const tvar = 0.68;
  for (const [w, h] of [[351, 515], [351, 662], [351, 468], [300, 300], [900, 200]]) {
    const b = fitBox(w, h, tvar);
    near(b.width / b.height, tvar, `plocha ${w}×${h}`);
    assert.ok(b.width <= w + 1e-9 && b.height <= h + 1e-9, `vejde se do ${w}×${h}`);
  }
});

test("shodný tvar plochy i kresby vyplní všechno beze zbytku", () => {
  const b = fitBox(351, 515, 351 / 515);
  near(b.width, 351, "šířka");
  near(b.height, 515, "výška");
  near(b.x, 0, "bez okraje");
  near(b.y, 0, "bez okraje");
});

test("nesmyslný tvar spadne na celou plochu, ne na NaN", () => {
  for (const spatny of [0, -1, Number.NaN, Number.POSITIVE_INFINITY]) {
    const b = fitBox(300, 500, spatny);
    assert.deepEqual(b, { x: 0, y: 0, width: 300, height: 500 }, `tvar ${spatny}`);
  }
});

test("kruh zůstane kruhem: stejná vzdálenost v obou osách", () => {
  // Dva body vzdálené o 0,2 vodorovně a 0,2 svisle musí být po vepsání
  // vzdálené stejně — právě tohle dřív neplatilo.
  const b = fitBox(351, 662, 0.68);
  const dx = 0.2 * b.width;
  const dy = 0.2 * b.height;
  near(dx / dy, 0.68, "poměr os odpovídá tvaru kresby");

  // A táž kresba v jinak tvarované ploše má tentýž poměr os.
  const b2 = fitBox(200, 200, 0.68);
  near((0.2 * b2.width) / (0.2 * b2.height), 0.68, "jiná plocha, stejný poměr");
});

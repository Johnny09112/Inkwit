/**
 * Test převodů barev: `npm run test:unit`.
 *
 * Hlídá to, co se okem nepozná — že barva vybraná v kruhu je opravdu ta, která
 * se uloží do palety, a že se tečka vrátí tam, odkud se táhla.
 */

import assert from "node:assert/strict";
import { test } from "node:test";
import {
  hexToHsv,
  hexToRgb,
  hsToWheel,
  hsvToHex,
  hsvToRgb,
  normalizeHue,
  rgbToHex,
  rgbToHsv,
  wheelToHs,
} from "./color.ts";

test("známé barvy sedí na doraz", () => {
  assert.equal(hsvToHex({ h: 0, s: 1, v: 1 }), "#FF0000");
  assert.equal(hsvToHex({ h: 120, s: 1, v: 1 }), "#00FF00");
  assert.equal(hsvToHex({ h: 240, s: 1, v: 1 }), "#0000FF");
  assert.equal(hsvToHex({ h: 0, s: 0, v: 1 }), "#FFFFFF");
  assert.equal(hsvToHex({ h: 210, s: 0.5, v: 0 }), "#000000");
});

test("odstín se točí dokola", () => {
  assert.equal(normalizeHue(370), 10);
  assert.equal(normalizeHue(-10), 350);
  assert.equal(hsvToHex({ h: 360, s: 1, v: 1 }), hsvToHex({ h: 0, s: 1, v: 1 }));
});

test("hex tam a zpátky se trefí přesně", () => {
  for (const hex of ["#2B261F", "#B5462F", "#E9B44C", "#52633A", "#3C6E8F", "#C4A484", "#FFFCF5"]) {
    const hsv = hexToHsv(hex);
    assert.ok(hsv, `${hex} se nepodařilo přečíst`);
    assert.equal(hsvToHex(hsv), hex, `${hex} se převodem změnil`);
  }
});

test("rgb tam a zpátky se trefí pro celou paletu", () => {
  for (const hex of ["#000000", "#FFFFFF", "#7F7F7F", "#8A5A8F", "#7BA3B8"]) {
    const rgb = hexToRgb(hex);
    assert.ok(rgb);
    assert.equal(rgbToHex(hsvToRgb(rgbToHsv(rgb))), hex);
  }
});

test("nesmyslný hex vrátí null, ne výjimku — píše ho člověk", () => {
  for (const bad of ["", "#12345", "xyzxyz", "#1234567", "  ", "##FF0000"]) {
    assert.equal(hexToRgb(bad), null, `${JSON.stringify(bad)} měl být odmítnut`);
  }
  assert.deepEqual(hexToRgb("  #b5462f  "), { r: 181, g: 70, b: 47 }, "mezery a malá písmena projdou");
});

test("kruh: střed je bez sytosti, okraj je plná", () => {
  const center = { x: 100, y: 100 };
  assert.equal(wheelToHs(center, center, 100).s, 0);
  assert.equal(wheelToHs({ x: 200, y: 100 }, center, 100).s, 1);
});

test("kruh: nula je nahoře a odstín roste po směru hodin", () => {
  const center = { x: 100, y: 100 };
  const r = 100;
  const near = (a: number, b: number, kde: string) =>
    assert.ok(Math.abs(a - b) < 1e-9, `${kde}: ${a} vs ${b}`);
  near(wheelToHs({ x: 100, y: 0 }, center, r).h, 0, "nahoře");
  near(wheelToHs({ x: 200, y: 100 }, center, r).h, 90, "vpravo");
  near(wheelToHs({ x: 100, y: 200 }, center, r).h, 180, "dole");
  near(wheelToHs({ x: 0, y: 100 }, center, r).h, 270, "vlevo");
});

test("prst mimo kruh se chová jako prst na okraji", () => {
  const center = { x: 100, y: 100 };
  const daleko = wheelToHs({ x: 900, y: 100 }, center, 100);
  assert.equal(daleko.s, 1, "sytost se ořízne");
  assert.equal(daleko.h, 90, "odstín zůstane");
});

test("poloha tečky tam a zpátky se trefí", () => {
  const center = { x: 120, y: 120 };
  const r = 110;
  for (const hs of [
    { h: 0, s: 1 },
    { h: 47, s: 0.3 },
    { h: 200, s: 0.75 },
    { h: 359, s: 0.05 },
  ]) {
    const point = hsToWheel(hs, center, r);
    const back = wheelToHs(point, center, r);
    assert.ok(Math.abs(back.h - hs.h) < 1e-6, `odstín ${hs.h} vs ${back.h}`);
    assert.ok(Math.abs(back.s - hs.s) < 1e-6, `sytost ${hs.s} vs ${back.s}`);
  }
});

test("jas škáluje barvu lineárně — na tom stojí ztmavení kruhu překryvem", () => {
  // Kruh se kreslí jednou při plném jasu a ztmavuje se černou vrstvou
  // s průhledností 1 − jas. Platí to jen proto, že v HSV je jas násobek.
  const plny = hsvToRgb({ h: 210, s: 0.6, v: 1 });
  const pulka = hsvToRgb({ h: 210, s: 0.6, v: 0.5 });
  assert.ok(Math.abs(pulka.r - plny.r / 2) <= 1, `r ${pulka.r} vs ${plny.r / 2}`);
  assert.ok(Math.abs(pulka.g - plny.g / 2) <= 1, `g ${pulka.g} vs ${plny.g / 2}`);
  assert.ok(Math.abs(pulka.b - plny.b / 2) <= 1, `b ${pulka.b} vs ${plny.b / 2}`);
});

/**
 * Test matematiky výřezu plátna: `npm run test:view`.
 *
 * Běží na vestavěném test runneru Node a jeho odstraňování typů — žádná
 * další závislost. Kreslení samotné se testuje proklikáním; tohle hlídá to,
 * co se okem neuvidí: že bod pod prstem sedí i po přiblížení a posunu.
 */

import assert from "node:assert/strict";
import { test } from "node:test";
import {
  IDENTITY,
  MAX_SCALE,
  clampView,
  pinchStep,
  spanOf,
  toCanvasPoint,
  toScreenPoint,
  zoomAround,
  type View,
} from "./canvasView.ts";

const W = 350;
const H = 500;

const near = (a: number, b: number, msg: string, eps = 1e-9) =>
  assert.ok(Math.abs(a - b) < eps, `${msg}: ${a} vs ${b}`);

test("bez přiblížení je převod souřadnic pouhé dělení rozměrem", () => {
  const p = toCanvasPoint(IDENTITY, { x: 175, y: 250 }, W, H);
  near(p.x, 0.5, "střed vodorovně");
  near(p.y, 0.5, "střed svisle");
});

test("přiblížení nechá bod pod prstem na místě", () => {
  const anchor = { x: 120, y: 400 };
  const before = toCanvasPoint(IDENTITY, anchor, W, H);
  const view = zoomAround(IDENTITY, anchor, 3, W, H);
  const after = toCanvasPoint(view, anchor, W, H);
  near(after.x, before.x, "kotva vodorovně", 1e-9);
  near(after.y, before.y, "kotva svisle", 1e-9);
});

test("převod tam a zpátky se trefí i v posunutém výřezu", () => {
  const view = zoomAround(IDENTITY, { x: 300, y: 90 }, 4, W, H);
  for (const local of [
    { x: 10, y: 10 },
    { x: 175, y: 250 },
    { x: 349, y: 499 },
  ]) {
    const canvas = toCanvasPoint(view, local, W, H);
    const back = toScreenPoint(view, canvas, W, H);
    near(back.x, local.x, "zpět vodorovně", 1e-6);
    near(back.y, local.y, "zpět svisle", 1e-6);
  }
});

test("v přiblíženém výřezu zůstanou poměrné souřadnice v rozsahu 0–1", () => {
  // Projede rohy výřezu při různém přiblížení a posunu. Kdyby se ořez posunu
  // rozbil, body by vyjely mimo plátno a server by dostal nesmysl.
  for (const scale of [1, 1.7, 3, MAX_SCALE]) {
    for (const anchor of [
      { x: 0, y: 0 },
      { x: W, y: H },
      { x: W / 2, y: 0 },
      { x: 0, y: H },
    ]) {
      const view = zoomAround(IDENTITY, anchor, scale, W, H);
      for (const corner of [
        { x: 0, y: 0 },
        { x: W, y: 0 },
        { x: 0, y: H },
        { x: W, y: H },
      ]) {
        const p = toCanvasPoint(view, corner, W, H);
        assert.ok(
          p.x >= -1e-9 && p.x <= 1 + 1e-9 && p.y >= -1e-9 && p.y <= 1 + 1e-9,
          `roh mimo plátno při scale ${scale}: ${JSON.stringify(p)}`,
        );
      }
    }
  }
});

test("oddálení pod celou kresbu se nedá — a posun se vrátí na nulu", () => {
  const zoomed = zoomAround(IDENTITY, { x: 300, y: 400 }, 5, W, H);
  assert.ok(zoomed.tx < 0, "přiblížený výřez je posunutý");
  const out = zoomAround(zoomed, { x: 300, y: 400 }, 0.01, W, H);
  assert.equal(out.scale, 1, "nejde pod celou kresbu");
  near(out.tx, 0, "posun zpět na nulu");
  near(out.ty, 0, "posun zpět na nulu");
});

test("přiblížení se nepřetáhne přes horní mez", () => {
  const view = zoomAround(IDENTITY, { x: 10, y: 10 }, 100, W, H);
  assert.equal(view.scale, MAX_SCALE);
});

test("gesto dvěma prsty přibližuje i posouvá zároveň", () => {
  const a1 = { x: 100, y: 200 };
  const b1 = { x: 200, y: 200 };
  // Prsty se od sebe vzdálí na dvojnásobek a celé gesto se posune doleva.
  const a2 = { x: 50, y: 200 };
  const b2 = { x: 250, y: 200 };

  const view = pinchStep(IDENTITY, spanOf(a1, b1), spanOf(a2, b2), W, H);
  near(view.scale, 2, "vzdálenost prstů zdvojnásobila přiblížení");

  // Bod kresby, který byl mezi prsty, musí zůstat mezi prsty.
  const before = toCanvasPoint(IDENTITY, spanOf(a1, b1).mid, W, H);
  const after = toCanvasPoint(view, spanOf(a2, b2).mid, W, H);
  near(after.x, before.x, "střed gesta drží", 1e-9);
  near(after.y, before.y, "střed gesta drží", 1e-9);
});

test("posun dvěma prsty bez změny vzdálenosti nemění přiblížení", () => {
  const start = zoomAround(IDENTITY, { x: 175, y: 250 }, 4, W, H);
  const a1 = { x: 100, y: 200 };
  const b1 = { x: 200, y: 300 };
  const a2 = { x: 120, y: 210 };
  const b2 = { x: 220, y: 310 };

  const view = pinchStep(start, spanOf(a1, b1), spanOf(a2, b2), W, H);
  near(view.scale, start.scale, "přiblížení beze změny");
  near(view.tx, start.tx + 20, "posun vodorovně o 20 px", 1e-9);
  near(view.ty, start.ty + 10, "posun svisle o 10 px", 1e-9);
});

test("ořez drží výřez v plátně i po hrubém posunu", () => {
  const view: View = clampView({ scale: 2, tx: 500, ty: -5000 }, W, H);
  assert.equal(view.tx, 0, "doprava přes okraj nejde");
  assert.equal(view.ty, H * (1 - 2), "dolů jen po spodní okraj");
});

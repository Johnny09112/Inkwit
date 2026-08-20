/**
 * Test tvarů jako nástroje: `npm run test:unit`.
 *
 * Tvar je obyčejný tah o dvou bodech — pravidlo 2 („kresba jen jako vektorové
 * tahy") tím zůstává v platnosti. Testuje se to, co by se jinak projevilo až
 * na cizí kresbě: že tvar přežije cestu na server a zpátky, a že kresba
 * složená jen z tvarů neprojde jako čmáranice.
 */

import assert from "node:assert/strict";
import { test } from "node:test";
import {
  SHAPE_TOOLS,
  isShapeTool,
  looksRushed,
  strokeFromPayload,
  strokeToPayload,
  type Stroke,
  type Tool,
} from "./strokes.ts";

const tah = (tool: Tool, startedAt: number, points: number[][]): Stroke => ({
  tool,
  color: "#2B261F",
  size: 8,
  device: "mouse",
  startedAt,
  points: points.map(([x, y, t]) => ({ x, y, t })),
});

test("tvary jsou právě čára, obdélník a elipsa", () => {
  assert.deepEqual([...SHAPE_TOOLS], ["line", "rect", "ellipse"]);
  for (const s of SHAPE_TOOLS) assert.ok(isShapeTool(s), s);
  assert.ok(!isShapeTool("brush"));
  assert.ok(!isShapeTool("eraser"));
});

test("tvar přežije cestu na server a zpátky", () => {
  const p = strokeToPayload(tah("ellipse", 1000, [[0.1, 0.2, 0], [0.7, 0.9, 120]]));
  assert.equal(p.tool, "ellipse");
  assert.deepEqual(p.points, [0.1, 0.2, 0, 0.7, 0.9, 120]);

  const zpet = strokeFromPayload({ ...p, width: p.width });
  assert.equal(zpet.tool, "ellipse");
  assert.equal(zpet.points.length, 2);
  assert.deepEqual(zpet.points[1], { x: 0.7, y: 0.9, t: 120 });
});

test("neznámý nástroj ze serveru spadne zpátky na štětec", () => {
  // Server ho nepustí (CHECK constraint + submit_drawing), ale klient se na to
  // nesmí spolehnout — jeden divný řádek nesmí shodit celou kresbu.
  const zpet = strokeFromPayload({ tool: "kbelik", color: "#000", width: 4, points: [0, 0, 0] });
  assert.equal(zpet.tool, "brush");
});

test("kresba složená z tvarů není čmáranice", () => {
  // Do 2026-08-20 se počítaly jen tahy štětcem, takže kresba ze tří tvarů
  // vypadala jako prázdné plátno a vždycky spustila kontrolní krok.
  const strokes = [
    tah("rect", 0, [[0.1, 0.1, 0], [0.5, 0.5, 100]]),
    tah("ellipse", 3000, [[0.2, 0.2, 0], [0.6, 0.6, 100]]),
    tah("line", 6000, [[0.3, 0.3, 0], [0.9, 0.9, 100]]),
    tah("line", 9000, [[0.4, 0.1, 0], [0.9, 0.2, 3000]]),
  ];
  assert.ok(!looksRushed(strokes));
});

test("guma se do počtu tahů nepočítá", () => {
  const strokes = [
    tah("brush", 0, [[0.1, 0.1, 0], [0.5, 0.5, 100]]),
    tah("eraser", 4000, [[0.2, 0.2, 0], [0.3, 0.3, 100]]),
    tah("eraser", 8000, [[0.2, 0.2, 0], [0.3, 0.3, 3000]]),
  ];
  assert.ok(looksRushed(strokes), "jeden tah štětcem a dvě gumy je pořád málo");
});

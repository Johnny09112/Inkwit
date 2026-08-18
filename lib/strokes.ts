/**
 * Vektorové tahy — neporušitelné pravidlo 2: kresba se ukládá jako vektory
 * s časovými značkami bodů, nikdy jako bitmapa. Tohle je klientská část;
 * serverová validace přijde s backendem.
 */

/** Bod tahu: souřadnice normalizované 0–1 vůči plátnu, čas v ms od začátku tahu. */
export interface StrokePoint {
  x: number;
  y: number;
  t: number;
}

export type Tool = "brush" | "eraser";

/** Typ zařízení z PointerEvent.pointerType — metadata od prvního dne. */
export type DeviceType = "mouse" | "touch" | "pen" | "unknown";

export interface Stroke {
  tool: Tool;
  color: string;
  /** Velikost stopy v px vztažená k šířce 390 px; při vykreslení se škáluje. */
  size: number;
  device: DeviceType;
  /** Unix ms začátku tahu — pro detekci čmáranic (rychlost, pauzy). */
  startedAt: number;
  points: StrokePoint[];
}

/** Referenční šířka, ke které se vztahuje velikost stopy. */
export const BASE_WIDTH = 390;

export function deviceTypeFrom(pointerType: string): DeviceType {
  if (pointerType === "mouse" || pointerType === "touch" || pointerType === "pen") {
    return pointerType;
  }
  return "unknown";
}

/** Překreslí všechny tahy. Uniformní štětec — bez tlaku pera (férovost). */
export function renderStrokes(
  ctx: CanvasRenderingContext2D,
  strokes: readonly Stroke[],
  width: number,
  height: number,
): void {
  ctx.clearRect(0, 0, width, height);
  const scale = width / BASE_WIDTH;

  for (const stroke of strokes) {
    if (stroke.points.length === 0) continue;
    ctx.globalCompositeOperation =
      stroke.tool === "eraser" ? "destination-out" : "source-over";
    ctx.strokeStyle = stroke.color;
    ctx.lineWidth = stroke.size * scale;
    ctx.lineCap = "round";
    ctx.lineJoin = "round";
    ctx.beginPath();
    const [first, ...rest] = stroke.points;
    ctx.moveTo(first.x * width, first.y * height);
    if (rest.length === 0) {
      // Tečka — čára nulové délky se s lineCap: round vykreslí jako kruh
      ctx.lineTo(first.x * width + 0.01, first.y * height);
    }
    for (const p of rest) {
      ctx.lineTo(p.x * width, p.y * height);
    }
    ctx.stroke();
  }
  ctx.globalCompositeOperation = "source-over";
}

/** Celková doba kreslení v ms — hrubý vstup pro anti-čmáranice heuristiku. */
export function drawingDurationMs(strokes: readonly Stroke[]): number {
  if (strokes.length === 0) return 0;
  const first = strokes[0];
  const last = strokes[strokes.length - 1];
  const lastPoint = last.points[last.points.length - 1];
  return last.startedAt + (lastPoint?.t ?? 0) - first.startedAt;
}

/**
 * Klientská heuristika „vypadá to narychlo" — jen pro rozhodnutí, jestli
 * ukázat kontrolní krok před odesláním. Skutečná detekce čmáranic je
 * serverová záležitost. Kalibrovat přísně: krok uvidí i poctiví kreslíři.
 */
export function looksRushed(strokes: readonly Stroke[]): boolean {
  if (strokes.length === 0) return true;
  const drawn = strokes.filter((s) => s.tool === "brush");
  return drawn.length < 3 || drawingDurationMs(strokes) < 8000;
}

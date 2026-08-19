/**
 * Vektorové tahy — neporušitelné pravidlo 2: kresba se ukládá jako vektory
 * s časovými značkami bodů, nikdy jako bitmapa. Tohle je klientská část;
 * serverová validace přijde s backendem.
 */

/**
 * Přesnost souřadnic: 4 desetinná místa. Souřadnice jsou normalizované 0–1,
 * takže 1/10 000 plátna je i na 4K displeji ~0,2 px — pod pixel. Vyšší přesnost
 * nenese informaci, jen bajty: plná plovoucí přesnost je na drátě 2,8× dražší.
 */
export const COORD_DECIMALS = 4;

const COORD_FACTOR = 10 ** COORD_DECIMALS;

/** Zaokrouhlí normalizovanou souřadnici na COORD_DECIMALS míst. */
export function roundCoord(v: number): number {
  return Math.round(v * COORD_FACTOR) / COORD_FACTOR;
}

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
  /**
   * Plátno si při přiblížení čistí samo — `clearRect` se totiž řídí aktuální
   * transformací, takže by při posunutém výřezu smazalo jen jeho část.
   */
  options?: { clear?: boolean },
): void {
  if (options?.clear !== false) ctx.clearRect(0, 0, width, height);
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

/**
 * Převod tahů do tvaru, ve kterém se posílají na server.
 *
 * Body jdou jako **ploché pole** `[x, y, t, x, y, t, …]`, ne jako objekty.
 * Na drátě je to po gzipu drobnost, ale na disku zhruba 1,7× méně — jeden tah
 * leží kolem prahu, od kterého teprve začne Postgres komprimovat, a pod ním
 * se neukládá komprimovaně nic. Měření viz `_claude/memory/decisions/`.
 */
export function strokeToPayload(stroke: Stroke) {
  const points: number[] = [];
  for (const p of stroke.points) {
    points.push(p.x, p.y, p.t);
  }
  return {
    tool: stroke.tool,
    color: stroke.color,
    width: stroke.size,
    points,
  };
}

export function strokesToPayload(strokes: readonly Stroke[]) {
  return strokes.map(strokeToPayload);
}

/** Opačný směr — z plochého pole zpátky na tahy (přehrání, „Moje kresby"). */
export function strokeFromPayload(row: {
  tool: string;
  color: string;
  width: number;
  points: number[];
}): Stroke {
  const points: StrokePoint[] = [];
  for (let i = 0; i + 2 < row.points.length; i += 3) {
    points.push({ x: row.points[i], y: row.points[i + 1], t: row.points[i + 2] });
  }
  return {
    tool: row.tool === "eraser" ? "eraser" : "brush",
    color: row.color,
    size: row.width,
    device: "unknown",
    startedAt: 0,
    points,
  };
}

/**
 * Typ zařízení pro celou kresbu. Bere se nejčastější napříč tahy — kdo
 * začne myší a dokreslí perem, patří k peru, ne k „unknown".
 */
export function dominantDevice(strokes: readonly Stroke[]): DeviceType {
  const tally = new Map<DeviceType, number>();
  for (const s of strokes) tally.set(s.device, (tally.get(s.device) ?? 0) + 1);
  let best: DeviceType = "unknown";
  let bestN = -1;
  for (const [d, n] of tally) if (n > bestN) { best = d; bestN = n; }
  return best;
}

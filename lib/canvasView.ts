/**
 * Výřez kreslicího plátna — přiblížení a posun.
 *
 * Je to čistá matematika bez DOM, aby se dala otestovat: převod souřadnic je
 * přesně to místo, kde se dá udělat chyba, která se projeví až tím, že lidem
 * kresba sedí o kus vedle. Plátno v `components/draw/DrawingCanvas.tsx` jen
 * navěšuje prsty na tyhle funkce.
 *
 * **Přiblížení je jen zobrazení.** Body tahů se pořád ukládají v poměrných
 * souřadnicích celého plátna (0–1), takže se datový model ani server nemění.
 */

export interface View {
  /** Přiblížení; 1 = celá kresba. */
  scale: number;
  /** Posun výřezu v CSS pixelech. Nula nebo záporné číslo. */
  tx: number;
  ty: number;
}

export interface Point {
  x: number;
  y: number;
}

export const MIN_SCALE = 1;
export const MAX_SCALE = 8;

export const IDENTITY: View = { scale: 1, tx: 0, ty: 0 };

const clamp = (n: number, lo: number, hi: number) => Math.min(hi, Math.max(lo, n));

/**
 * Udrží výřez uvnitř plátna.
 *
 * Není to jen kosmetika: díky tomu je viditelná část vždycky podmnožinou
 * plátna, takže poměrné souřadnice bodů nemůžou vypadnout z rozsahu 0–1.
 */
export function clampView(view: View, width: number, height: number): View {
  const scale = clamp(view.scale, MIN_SCALE, MAX_SCALE);
  return {
    scale,
    tx: clamp(view.tx, width * (1 - scale), 0),
    ty: clamp(view.ty, height * (1 - scale), 0),
  };
}

/**
 * Přiblíží kolem pevného bodu — to, co je pod prsty (nebo kurzorem), tam
 * zůstane. Bez toho by se kresba při přibližování utíkala do rohu.
 */
export function zoomAround(
  view: View,
  anchor: Point,
  factor: number,
  width: number,
  height: number,
): View {
  const scale = clamp(view.scale * factor, MIN_SCALE, MAX_SCALE);
  // Skutečný poměr po oříznutí na meze — jinak by se na krajích posouvalo,
  // i když se přiblížení už nemění.
  const applied = scale / view.scale;
  return clampView(
    {
      scale,
      tx: anchor.x - (anchor.x - view.tx) * applied,
      ty: anchor.y - (anchor.y - view.ty) * applied,
    },
    width,
    height,
  );
}

/** Jeden krok gesta dvěma prsty: změna vzdálenosti přibližuje, posun středu posouvá. */
export function pinchStep(
  view: View,
  prev: { dist: number; mid: Point },
  next: { dist: number; mid: Point },
  width: number,
  height: number,
): View {
  const scale = clamp(view.scale * (next.dist / prev.dist), MIN_SCALE, MAX_SCALE);
  const applied = scale / view.scale;
  return clampView(
    {
      scale,
      tx: next.mid.x - (prev.mid.x - view.tx) * applied,
      ty: next.mid.y - (prev.mid.y - view.ty) * applied,
    },
    width,
    height,
  );
}

/** Bod na obrazovce (v CSS pixelech vůči plátnu) na poměrné souřadnice kresby. */
export function toCanvasPoint(
  view: View,
  local: Point,
  width: number,
  height: number,
): Point {
  return {
    x: (local.x - view.tx) / view.scale / width,
    y: (local.y - view.ty) / view.scale / height,
  };
}

/** Opačný směr — kde na obrazovce leží bod kresby. Používá se jen v testech. */
export function toScreenPoint(
  view: View,
  canvas: Point,
  width: number,
  height: number,
): Point {
  return {
    x: canvas.x * width * view.scale + view.tx,
    y: canvas.y * height * view.scale + view.ty,
  };
}

/** Vzdálenost a střed dvou prstů. */
export function spanOf(a: Point, b: Point): { dist: number; mid: Point } {
  return {
    dist: Math.hypot(a.x - b.x, a.y - b.y),
    mid: { x: (a.x + b.x) / 2, y: (a.y + b.y) / 2 },
  };
}

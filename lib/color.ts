/**
 * Převody barev pro výběr vlastní barvy.
 *
 * Zvlášť a bez DOM, protože kruh barev pracuje s HSV, paleta s hexem a jedno
 * se musí trefit do druhého. Chyba v převodu se pozná až tím, že vybraná barva
 * nesedí s tečkou v kruhu — což je přesně to, co se okem hledá špatně.
 * Testy: `npm run test:unit`.
 */

export interface Hsv {
  /** Odstín ve stupních 0–360. */
  h: number;
  /** Sytost 0–1. */
  s: number;
  /** Jas 0–1. */
  v: number;
}

export interface Rgb {
  r: number;
  g: number;
  b: number;
}

const clamp = (n: number, lo: number, hi: number) => Math.min(hi, Math.max(lo, n));

/** Odstín se točí dokola — 370° je 10°, −10° je 350°. */
export const normalizeHue = (h: number) => ((h % 360) + 360) % 360;

export function hsvToRgb({ h, s, v }: Hsv): Rgb {
  const hue = normalizeHue(h) / 60;
  const sat = clamp(s, 0, 1);
  const val = clamp(v, 0, 1);

  const c = val * sat;
  const x = c * (1 - Math.abs((hue % 2) - 1));
  const m = val - c;

  const [r, g, b] =
    hue < 1 ? [c, x, 0]
    : hue < 2 ? [x, c, 0]
    : hue < 3 ? [0, c, x]
    : hue < 4 ? [0, x, c]
    : hue < 5 ? [x, 0, c]
    : [c, 0, x];

  return {
    r: Math.round((r + m) * 255),
    g: Math.round((g + m) * 255),
    b: Math.round((b + m) * 255),
  };
}

export function rgbToHsv({ r, g, b }: Rgb): Hsv {
  const rn = r / 255;
  const gn = g / 255;
  const bn = b / 255;
  const max = Math.max(rn, gn, bn);
  const min = Math.min(rn, gn, bn);
  const d = max - min;

  let h = 0;
  if (d !== 0) {
    if (max === rn) h = ((gn - bn) / d) % 6;
    else if (max === gn) h = (bn - rn) / d + 2;
    else h = (rn - gn) / d + 4;
    h *= 60;
  }

  return { h: normalizeHue(h), s: max === 0 ? 0 : d / max, v: max };
}

/** Vrátí `null` místo výjimky — vstup chodí z pole, do kterého člověk píše. */
export function hexToRgb(hex: string): Rgb | null {
  const clean = hex.trim().replace(/^#/, "");
  if (!/^[0-9a-fA-F]{6}$/.test(clean)) return null;
  return {
    r: parseInt(clean.slice(0, 2), 16),
    g: parseInt(clean.slice(2, 4), 16),
    b: parseInt(clean.slice(4, 6), 16),
  };
}

export function rgbToHex({ r, g, b }: Rgb): string {
  const part = (n: number) => clamp(Math.round(n), 0, 255).toString(16).padStart(2, "0");
  return `#${part(r)}${part(g)}${part(b)}`.toUpperCase();
}

export const hsvToHex = (hsv: Hsv): string => rgbToHex(hsvToRgb(hsv));

export function hexToHsv(hex: string): Hsv | null {
  const rgb = hexToRgb(hex);
  return rgb ? rgbToHsv(rgb) : null;
}

/**
 * Poloha bodu v kruhu barev → odstín a sytost.
 *
 * Střed je bílá, okraj plná sytost, úhel je odstín. Sytost se ořezává na 1,
 * takže tažení mimo kruh se chová jako tažení po jeho okraji — jinak by prst,
 * který vyjede ven, bod ztratil.
 */
export function wheelToHs(
  point: { x: number; y: number },
  center: { x: number; y: number },
  radius: number,
): { h: number; s: number } {
  const dx = point.x - center.x;
  const dy = point.y - center.y;
  // Nula nahoře a po směru hodin — tak je kruh nakreslený.
  const angle = normalizeHue((Math.atan2(dy, dx) * 180) / Math.PI + 90);
  return { h: angle, s: radius === 0 ? 0 : clamp(Math.hypot(dx, dy) / radius, 0, 1) };
}

/** Opačný směr — kam v kruhu patří tečka pro daný odstín a sytost. */
export function hsToWheel(
  hs: { h: number; s: number },
  center: { x: number; y: number },
  radius: number,
): { x: number; y: number } {
  const rad = ((normalizeHue(hs.h) - 90) * Math.PI) / 180;
  const dist = clamp(hs.s, 0, 1) * radius;
  return { x: center.x + Math.cos(rad) * dist, y: center.y + Math.sin(rad) * dist };
}

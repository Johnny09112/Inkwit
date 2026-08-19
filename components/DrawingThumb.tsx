"use client";

import { useEffect, useRef } from "react";
import { renderStrokes, type Stroke } from "@/lib/strokes";

/**
 * Náhled kresby.
 *
 * Kreslí se z tahů v prohlížeči, ne z uložené bitmapy. Vektory jsou zdroj
 * pravdy (pravidlo 2) a při velikostech fáze 0 je kresba z nich levnější než
 * ukládat a servírovat obrázky — zdůvodnění u kroku C3 v `docs/plan.md`.
 */
export function DrawingThumb({
  strokes,
  label,
}: {
  strokes: readonly Stroke[] | undefined;
  label: string;
}) {
  const ref = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = ref.current;
    const ctx = canvas?.getContext("2d");
    if (!canvas || !ctx || !strokes) return;
    const rect = canvas.getBoundingClientRect();
    const dpr = window.devicePixelRatio || 1;
    canvas.width = Math.max(1, Math.round(rect.width * dpr));
    canvas.height = Math.max(1, Math.round(rect.height * dpr));
    renderStrokes(ctx, strokes, canvas.width, canvas.height);
  }, [strokes]);

  if (!strokes) return <div className="hatch thumb" aria-hidden="true" />;

  return (
    <canvas ref={ref} className="thumb" role="img" aria-label={label} />
  );
}

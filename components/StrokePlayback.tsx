"use client";

import { useEffect, useRef, useState } from "react";
import { renderStrokes, type Stroke } from "@/lib/strokes";

/**
 * Přehrání kresby tah po tahu (krok D4).
 *
 * **Není to výchozí zobrazení při hádání** — hádá se nad hotovým obrázkem.
 * Přehrání je tlačítko a odměna po uhodnutí (`docs/product.md`).
 *
 * Časy jsou uložené u bodů, takže rytmus odpovídá skutečnému kreslení:
 * kde autor váhal, váhá i přehrání. Mezery mezi tahy se doplňují pevnou
 * pauzou — meziTahové časy se do plochého pole neukládají.
 */

const GAP_MS = 220;
const MIN_STROKE_MS = 120;

export function StrokePlayback({
  strokes,
  playing,
  onEnd,
  aspect,
}: {
  strokes: readonly Stroke[];
  playing: boolean;
  onEnd?: () => void;
  /** Tvar kresby. Bez něj se roztáhne na tvar plochy, do které se kreslí. */
  aspect?: number;
}) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [progress, setProgress] = useState(1);

  // Časová osa: kdy který tah začíná a jak dlouho trvá.
  const timeline = strokes.map((s) => {
    const last = s.points[s.points.length - 1];
    return Math.max(MIN_STROKE_MS, last ? last.t : MIN_STROKE_MS);
  });
  const total = timeline.reduce((n, d) => n + d + GAP_MS, 0);

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext("2d");
    if (!canvas || !ctx) return;

    const rect = canvas.getBoundingClientRect();
    const dpr = window.devicePixelRatio || 1;
    canvas.width = Math.max(1, Math.round(rect.width * dpr));
    canvas.height = Math.max(1, Math.round(rect.height * dpr));

    if (!playing) {
      renderStrokes(ctx, strokes, canvas.width, canvas.height, { aspect });
      setProgress(1);
      return;
    }

    let raf = 0;
    const started = performance.now();

    const frame = () => {
      const elapsed = performance.now() - started;
      setProgress(Math.min(1, elapsed / total));

      // Kolik z každého tahu je v tuhle chvíli vidět
      const shown: Stroke[] = [];
      let cursor = 0;
      for (let i = 0; i < strokes.length; i++) {
        const dur = timeline[i];
        if (elapsed >= cursor + dur) {
          shown.push(strokes[i]);
        } else if (elapsed > cursor) {
          const ratio = (elapsed - cursor) / dur;
          const n = Math.max(2, Math.ceil(strokes[i].points.length * ratio));
          shown.push({ ...strokes[i], points: strokes[i].points.slice(0, n) });
          break;
        } else {
          break;
        }
        cursor += dur + GAP_MS;
      }

      renderStrokes(ctx, shown, canvas.width, canvas.height, { aspect });

      if (elapsed < total) {
        raf = requestAnimationFrame(frame);
      } else {
        onEnd?.();
      }
    };

    raf = requestAnimationFrame(frame);
    return () => cancelAnimationFrame(raf);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [playing, strokes, aspect]);

  return (
    <>
      <canvas ref={canvasRef} className="playback-canvas" />
      {playing && (
        <div className="playback-bar" aria-hidden="true">
          <div className="playback-bar-fill" style={{ width: `${progress * 100}%` }} />
        </div>
      )}
    </>
  );
}

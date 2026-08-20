"use client";

import { useEffect, useRef } from "react";
import { CircleUserRound } from "lucide-react";
import { renderStrokes, type Stroke } from "@/lib/strokes";

/**
 * Profilový obrázek: vlastní kresba, kolem něj postup do dalšího levelu
 * a v rohu aktuální level.
 *
 * Kreslí se **z tahů**, ne z uložené bitmapy — stejně jako náhledy kreseb
 * (pravidlo 2). Avatar je čtvercový, takže poměr stran je vždycky 1 a nemusí
 * se ukládat.
 *
 * Prstenec postupu je `conic-gradient`, ne SVG: je to jedna vlastnost, jde
 * animovat a nepřidává do stromu další prvek.
 */

interface AvatarProps {
  strokes: readonly Stroke[] | null;
  level: number;
  /** Postup v pásmu levelu, 0–100. Prstenec bez něj nedává smysl. */
  progress: number;
  /** Popisek pro čtečku — jméno hráče. */
  label: string;
  size?: number;
  onClick?: () => void;
}

export function Avatar({ strokes, level, progress, label, size = 72, onClick }: AvatarProps) {
  const ref = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = ref.current;
    const ctx = canvas?.getContext("2d");
    if (!canvas || !ctx || !strokes) return;
    const rect = canvas.getBoundingClientRect();
    const dpr = window.devicePixelRatio || 1;
    canvas.width = Math.max(1, Math.round(rect.width * dpr));
    canvas.height = Math.max(1, Math.round(rect.height * dpr));
    renderStrokes(ctx, strokes, canvas.width, canvas.height, { aspect: 1 });
  }, [strokes, size]);

  const kruh = (
    <>
      <span
        className="avatar-ring"
        aria-hidden="true"
        style={{ ["--progress" as string]: `${Math.min(100, Math.max(0, progress))}%` }}
      />
      <span className="avatar-face">
        {strokes ? (
          <canvas ref={ref} className="avatar-canvas" role="img" aria-label={label} />
        ) : (
          <CircleUserRound size={Math.round(size * 0.5)} aria-hidden="true" />
        )}
      </span>
      <span className="avatar-level" aria-hidden="true">
        {level}
      </span>
    </>
  );

  if (!onClick) {
    return (
      <span className="avatar" style={{ width: size, height: size }}>
        {kruh}
      </span>
    );
  }

  return (
    <button
      type="button"
      className="avatar avatar-button"
      style={{ width: size, height: size }}
      onClick={onClick}
      aria-label={label}
    >
      {kruh}
    </button>
  );
}

"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import {
  BASE_WIDTH,
  deviceTypeFrom,
  renderStrokes,
  roundCoord,
  type Stroke,
  type StrokePoint,
  type Tool,
} from "@/lib/strokes";
import {
  IDENTITY,
  clampView,
  pinchStep,
  spanOf,
  toCanvasPoint,
  zoomAround,
  type View,
} from "@/lib/canvasView";

/**
 * Kreslicí plátno nad PointerEvents — sjednocuje myš, prst i pero a dává
 * typ zařízení. Tahy jsou vektory s časovými značkami (pravidlo 2).
 * Uniformní štětec: tlak pera se záměrně nečte (férovost napříč zařízeními).
 *
 * **Gesta:** jeden prst kreslí, dva prsty přibližují a posouvají výřez.
 * Přiblížení je čistě zobrazovací věc — body se pořád ukládají v poměrných
 * souřadnicích celého plátna, takže se datový model ani server nemění.
 */

interface DrawingCanvasProps {
  strokes: readonly Stroke[];
  tool: Tool;
  color: string;
  size: number;
  /** Náhled a potvrzovací krok: kreslení vypnuté. */
  inputDisabled?: boolean;
  onStrokeEnd: (stroke: Stroke) => void;
}

export function DrawingCanvas({
  strokes,
  tool,
  color,
  size,
  inputDisabled = false,
  onStrokeEnd,
}: DrawingCanvasProps) {
  const t = useTranslations("draw");
  const format = useFormatter();
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const activeStroke = useRef<Stroke | null>(null);
  const strokeStartTime = useRef(0);

  const [view, setView] = useState<View>(IDENTITY);
  // Gesta běží mimo React — zápis stavu na každý pohyb prstu by překresloval
  // celou stránku, ne jen plátno.
  const viewRef = useRef(view);
  viewRef.current = view;

  /** Prsty na plátně, v CSS pixelech vůči jeho levému hornímu rohu. */
  const pointers = useRef(new Map<number, { x: number; y: number }>());
  const pinch = useRef<{ dist: number; mid: { x: number; y: number } } | null>(null);
  /**
   * Jakmile se plátna dotkne druhý prst, kreslení se do zvednutí všech prstů
   * zamkne. Bez toho by zvednutí jednoho prstu z gesta nechalo druhý kreslit.
   */
  const gestureLock = useRef(false);

  const redraw = useCallback(() => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext("2d");
    if (!canvas || !ctx) return;
    const dpr = window.devicePixelRatio || 1;
    const cssWidth = canvas.width / dpr;
    const cssHeight = canvas.height / dpr;
    const { scale, tx, ty } = viewRef.current;

    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.setTransform(dpr * scale, 0, 0, dpr * scale, dpr * tx, dpr * ty);

    const live = activeStroke.current;
    renderStrokes(ctx, live ? [...strokes, live] : strokes, cssWidth, cssHeight, {
      clear: false,
    });
    ctx.setTransform(1, 0, 0, 1, 0, 0);
  }, [strokes]);

  // Rozměry podle kontejneru + devicePixelRatio
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const parent = canvas.parentElement;
    if (!parent) return;

    const resize = () => {
      const rect = parent.getBoundingClientRect();
      const dpr = window.devicePixelRatio || 1;
      canvas.width = Math.max(1, Math.round(rect.width * dpr));
      canvas.height = Math.max(1, Math.round(rect.height * dpr));
      // Po změně rozměrů může být dosavadní posun mimo — třeba po otočení
      // telefonu na šířku.
      setView((v) => {
        const fixed = clampView(v, rect.width, rect.height);
        // Stejná hodnota => stejný objekt, jinak by každé hlášení ResizeObserveru
        // vyvolalo překreslení celé stránky.
        return fixed.scale === v.scale && fixed.tx === v.tx && fixed.ty === v.ty ? v : fixed;
      });
      redraw();
    };

    resize();
    const observer = new ResizeObserver(resize);
    observer.observe(parent);
    return () => observer.disconnect();
  }, [redraw]);

  useEffect(() => {
    redraw();
  }, [redraw, view]);

  const localPoint = (e: React.PointerEvent<HTMLCanvasElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    return { x: e.clientX - rect.left, y: e.clientY - rect.top };
  };

  /** Bod pod prstem v poměrných souřadnicích plátna, přes inverzi výřezu. */
  const pointFromEvent = (e: React.PointerEvent<HTMLCanvasElement>): StrokePoint => {
    const rect = e.currentTarget.getBoundingClientRect();
    const p = toCanvasPoint(viewRef.current, localPoint(e), rect.width, rect.height);
    // Zaokrouhlení až tady, při záznamu — ztracenou přesnost už nikdy nepotřebujeme
    // a plná plovoucí přesnost je na drátě 2,8× dražší (viz memory/decisions).
    return {
      x: roundCoord(p.x),
      y: roundCoord(p.y),
      t: Math.round(performance.now() - strokeStartTime.current),
    };
  };

  const twoFingers = () => {
    const [a, b] = [...pointers.current.values()];
    return spanOf(a, b);
  };

  const handlePointerDown = (e: React.PointerEvent<HTMLCanvasElement>) => {
    if (inputDisabled) return;

    // `isPrimary` je podle specifikace první prst gesta — v tu chvíli žádný
    // jiný na plátně být nemůže. Cokoli, co v evidenci zbylo, je tedy zapomenutý
    // prst po nedoručeném `pointerup` (na iOS se to stává u dlaně nebo když
    // systém dotyk sebere). Bez tohoto úklidu by takový zbytek napořád zamkl
    // kreslení: každý další dotyk by vypadal jako druhý prst, tedy gesto.
    if (e.isPrimary) {
      pointers.current.clear();
      pinch.current = null;
      gestureLock.current = false;
    }

    e.currentTarget.setPointerCapture(e.pointerId);
    pointers.current.set(e.pointerId, localPoint(e));

    if (pointers.current.size >= 2) {
      // Druhý prst znamená gesto, ne kresbu. Rozdělaný tah se zahodí —
      // jinak by po každém přiblížení zůstala čárka od prvního prstu.
      activeStroke.current = null;
      gestureLock.current = true;
      if (pointers.current.size === 2) pinch.current = twoFingers();
      redraw();
      return;
    }

    if (gestureLock.current) return;

    strokeStartTime.current = performance.now();
    activeStroke.current = {
      tool,
      color,
      // Velikost vztažená k referenční šířce, aby tahy seděly na všech displejích.
      // Dělí se i přiblížením: štětec má pod prstem pořád stejnou tloušťku,
      // takže přiblížení je cesta ke kreslení detailů.
      size: (size * BASE_WIDTH) / (e.currentTarget.getBoundingClientRect().width * viewRef.current.scale),
      device: deviceTypeFrom(e.pointerType),
      startedAt: Date.now(),
      points: [pointFromEvent(e)],
    };
    redraw();
  };

  const handlePointerMove = (e: React.PointerEvent<HTMLCanvasElement>) => {
    if (!pointers.current.has(e.pointerId)) return;
    pointers.current.set(e.pointerId, localPoint(e));

    if (pointers.current.size >= 2) {
      const prev = pinch.current;
      if (!prev) return;
      const now = twoFingers();
      const rect = e.currentTarget.getBoundingClientRect();
      const next = pinchStep(viewRef.current, prev, now, rect.width, rect.height);
      pinch.current = now;
      viewRef.current = next;
      setView(next);
      return;
    }

    const stroke = activeStroke.current;
    if (!stroke) return;
    stroke.points.push(pointFromEvent(e));
    redraw();
  };

  const releasePointer = (e: React.PointerEvent<HTMLCanvasElement>) => {
    pointers.current.delete(e.pointerId);
    if (pointers.current.size < 2) pinch.current = null;
    if (pointers.current.size > 0) return;

    // Až když je plátno volné, smí se zase kreslit.
    gestureLock.current = false;
    const stroke = activeStroke.current;
    if (!stroke) return;
    activeStroke.current = null;
    onStrokeEnd(stroke);
  };

  // Trackpad posílá gesto přiblížení jako kolečko s Ctrl. React ho navěsit
  // nestačí — výchozí posluchač je pasivní a `preventDefault` by neprošel.
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const onWheel = (e: WheelEvent) => {
      if (!e.ctrlKey && !e.metaKey) return;
      e.preventDefault();
      const rect = canvas.getBoundingClientRect();
      const anchor = { x: e.clientX - rect.left, y: e.clientY - rect.top };
      const next = zoomAround(
        viewRef.current,
        anchor,
        Math.exp(-e.deltaY / 200),
        rect.width,
        rect.height,
      );
      viewRef.current = next;
      setView(next);
    };

    canvas.addEventListener("wheel", onWheel, { passive: false });
    return () => canvas.removeEventListener("wheel", onWheel);
  }, []);

  return (
    <>
      <canvas
        ref={canvasRef}
        onPointerDown={handlePointerDown}
        onPointerMove={handlePointerMove}
        onPointerUp={releasePointer}
        onPointerCancel={releasePointer}
        // Když prohlížeč zachycení sebere (přepnutí okna, systémové gesto),
        // `pointerup` už nepřijde. Bez tohohle by prst zůstal v evidenci.
        onLostPointerCapture={releasePointer}
      />
      {view.scale > 1.01 && (
        <button
          type="button"
          className="canvas-zoom"
          aria-label={t("tools.resetZoom")}
          onClick={() => setView(IDENTITY)}
        >
          {format.number(view.scale, { maximumFractionDigits: 1 })}×
        </button>
      )}
    </>
  );
}

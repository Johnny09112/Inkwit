"use client";

import { useCallback, useEffect, useRef } from "react";
import {
  BASE_WIDTH,
  deviceTypeFrom,
  renderStrokes,
  roundCoord,
  type Stroke,
  type StrokePoint,
  type Tool,
} from "@/lib/strokes";

/**
 * Kreslicí plátno nad PointerEvents — sjednocuje myš, prst i pero a dává
 * typ zařízení. Tahy jsou vektory s časovými značkami (pravidlo 2).
 * Uniformní štětec: tlak pera se záměrně nečte (férovost napříč zařízeními).
 */

interface DrawingCanvasProps {
  strokes: readonly Stroke[];
  tool: Tool;
  color: string;
  size: number;
  /** „Posun" a náhled: kreslení vypnuté. */
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
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const activeStroke = useRef<Stroke | null>(null);
  const strokeStartTime = useRef(0);

  const redraw = useCallback(() => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext("2d");
    if (!canvas || !ctx) return;
    const live = activeStroke.current;
    renderStrokes(
      ctx,
      live ? [...strokes, live] : strokes,
      canvas.width,
      canvas.height,
    );
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
      redraw();
    };

    resize();
    const observer = new ResizeObserver(resize);
    observer.observe(parent);
    return () => observer.disconnect();
  }, [redraw]);

  useEffect(() => {
    redraw();
  }, [redraw]);

  const pointFromEvent = (e: React.PointerEvent<HTMLCanvasElement>): StrokePoint => {
    const rect = e.currentTarget.getBoundingClientRect();
    // Zaokrouhlení až tady, při záznamu — ztracenou přesnost už nikdy nepotřebujeme
    // a plná plovoucí přesnost je na drátě 2,8× dražší (viz memory/decisions).
    return {
      x: roundCoord((e.clientX - rect.left) / rect.width),
      y: roundCoord((e.clientY - rect.top) / rect.height),
      t: Math.round(performance.now() - strokeStartTime.current),
    };
  };

  const handlePointerDown = (e: React.PointerEvent<HTMLCanvasElement>) => {
    if (inputDisabled || !e.isPrimary) return;
    e.currentTarget.setPointerCapture(e.pointerId);
    strokeStartTime.current = performance.now();
    activeStroke.current = {
      tool,
      color,
      // Velikost vztažená k referenční šířce, aby tahy seděly na všech displejích
      size: (size * BASE_WIDTH) / e.currentTarget.getBoundingClientRect().width,
      device: deviceTypeFrom(e.pointerType),
      startedAt: Date.now(),
      points: [pointFromEvent(e)],
    };
    redraw();
  };

  const handlePointerMove = (e: React.PointerEvent<HTMLCanvasElement>) => {
    const stroke = activeStroke.current;
    if (!stroke) return;
    stroke.points.push(pointFromEvent(e));
    redraw();
  };

  const finishStroke = () => {
    const stroke = activeStroke.current;
    if (!stroke) return;
    activeStroke.current = null;
    onStrokeEnd(stroke);
  };

  return (
    <canvas
      ref={canvasRef}
      onPointerDown={handlePointerDown}
      onPointerMove={handlePointerMove}
      onPointerUp={finishStroke}
      onPointerCancel={finishStroke}
    />
  );
}

"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { Check, ChevronLeft } from "lucide-react";
import { Button } from "@/components/ui";
import {
  hexToHsv,
  hsToWheel,
  hsvToHex,
  hsvToRgb,
  wheelToHs,
  type Hsv,
} from "@/lib/color";

/**
 * Výběr vlastní barvy — kruh odstínů se sytostí od středu, pod ním jas
 * a pole pro hex.
 *
 * **Kruh se kreslí jen jednou, při plném jasu.** Ztmavuje ho černá vrstva
 * s průhledností 1 − jas, což je přesné: v HSV je jas násobek barvy, takže
 * černá přes ni dá přesně tutéž hodnotu. Ušetří to překreslování při každém
 * pohybu posuvníku. Hlídá to test v `lib/color.test.ts`.
 */

/** Vnitřní rozlišení kruhu v CSS pixelech; na displej se dotáhne přes dpr. */
const WHEEL_SIZE = 240;

function paintWheel(canvas: HTMLCanvasElement) {
  const dpr = window.devicePixelRatio || 1;
  const px = Math.round(WHEEL_SIZE * dpr);
  canvas.width = px;
  canvas.height = px;

  const ctx = canvas.getContext("2d");
  if (!ctx) return;

  const image = ctx.createImageData(px, px);
  const data = image.data;
  const radius = px / 2;

  for (let y = 0; y < px; y++) {
    for (let x = 0; x < px; x++) {
      const i = (y * px + x) * 4;
      const { h, s } = wheelToHs({ x: x + 0.5, y: y + 0.5 }, { x: radius, y: radius }, radius);
      const dist = Math.hypot(x + 0.5 - radius, y + 0.5 - radius);
      if (dist > radius) {
        data[i + 3] = 0;
        continue;
      }
      const { r, g, b } = hsvToRgb({ h, s, v: 1 });
      data[i] = r;
      data[i + 1] = g;
      data[i + 2] = b;
      // Změkčení okraje, ať kruh nemá zubatou hranu.
      data[i + 3] = Math.round(255 * Math.min(1, radius - dist));
    }
  }
  ctx.putImageData(image, 0, 0);
}

interface ColorWheelProps {
  /** Barva, se kterou se výběr otevře. */
  initial: string;
  /** Hlášku o plné paletě posílá rodič — ví, kolik je volných míst. */
  note?: string;
  onCancel: () => void;
  onConfirm: (color: string) => void;
}

export function ColorWheel({ initial, note, onCancel, onConfirm }: ColorWheelProps) {
  const t = useTranslations("draw.colors");
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const areaRef = useRef<HTMLDivElement>(null);

  const [hsv, setHsv] = useState<Hsv>(() => hexToHsv(initial) ?? { h: 0, s: 0, v: 1 });
  // Hex se drží zvlášť: během psaní bývá rozepsaný a nesmí přepisovat kruh.
  const [hexDraft, setHexDraft] = useState(() => initial.replace("#", "").toUpperCase());

  const color = hsvToHex(hsv);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (canvas) paintWheel(canvas);
  }, []);

  useEffect(() => {
    setHexDraft(color.replace("#", ""));
  }, [color]);

  const pickFromPointer = useCallback((clientX: number, clientY: number) => {
    const area = areaRef.current;
    if (!area) return;
    const rect = area.getBoundingClientRect();
    const radius = rect.width / 2;
    const { h, s } = wheelToHs(
      { x: clientX - rect.left, y: clientY - rect.top },
      { x: radius, y: radius },
      radius,
    );
    setHsv((prev) => ({ ...prev, h, s }));
  }, []);

  const handlePointerDown = (e: React.PointerEvent<HTMLDivElement>) => {
    e.currentTarget.setPointerCapture(e.pointerId);
    pickFromPointer(e.clientX, e.clientY);
  };

  const handlePointerMove = (e: React.PointerEvent<HTMLDivElement>) => {
    if (!e.currentTarget.hasPointerCapture(e.pointerId)) return;
    pickFromPointer(e.clientX, e.clientY);
  };

  const applyHex = (raw: string) => {
    setHexDraft(raw);
    const parsed = hexToHsv(`#${raw}`);
    // Bílá a černá nemají odstín — kdyby se přepsal, skočila by tečka do kruhu
    // na nulu a člověk by přišel o rozdělaný odstín.
    if (parsed) {
      setHsv((prev) => ({
        h: parsed.s === 0 ? prev.h : parsed.h,
        s: parsed.s,
        v: parsed.v,
      }));
    }
  };

  const dot = hsToWheel({ h: hsv.h, s: hsv.s }, { x: 50, y: 50 }, 50);

  return (
    <div className="wheel">
      <div className="color-sheet-head">
        <button
          type="button"
          className="icon-btn icon-btn-plain"
          style={{ width: 30, height: 30 }}
          aria-label={t("back")}
          onClick={onCancel}
        >
          <ChevronLeft size={18} />
        </button>
        <span className="color-sheet-title">{t("pickerTitle")}</span>
        <span className="wheel-preview" style={{ background: color }} aria-hidden="true" />
      </div>

      {note && <p className="wheel-note">{note}</p>}

      <div
        ref={areaRef}
        className="wheel-area"
        style={{ width: WHEEL_SIZE, height: WHEEL_SIZE }}
        onPointerDown={handlePointerDown}
        onPointerMove={handlePointerMove}
      >
        <canvas ref={canvasRef} className="wheel-canvas" />
        {/* Ztmavení podle jasu — viz poznámka nahoře. */}
        <span className="wheel-shade" style={{ opacity: 1 - hsv.v }} aria-hidden="true" />
        <span
          className="wheel-dot"
          style={{ left: `${dot.x}%`, top: `${dot.y}%`, background: color }}
          aria-hidden="true"
        />
      </div>

      <label className="wheel-slider">
        <span className="t-label-sm">{t("brightness")}</span>
        <input
          type="range"
          className="size-slider"
          min={0}
          max={100}
          value={Math.round(hsv.v * 100)}
          aria-label={t("brightness")}
          onChange={(e) => setHsv((prev) => ({ ...prev, v: Number(e.target.value) / 100 }))}
        />
      </label>

      <div className="hex-row">
        <label className="hex-field">
          <span aria-hidden>#</span>
          <input
            value={hexDraft}
            maxLength={6}
            inputMode="text"
            autoCapitalize="characters"
            autoCorrect="off"
            spellCheck={false}
            aria-label={t("hex")}
            onChange={(e) => applyHex(e.target.value.replace(/[^0-9a-fA-F]/g, "").toUpperCase())}
          />
        </label>
        <Button size="lg" onClick={() => onConfirm(color)}>
          <Check size={18} aria-hidden="true" /> {t("save")}
        </Button>
      </div>
    </div>
  );
}

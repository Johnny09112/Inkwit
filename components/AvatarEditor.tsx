"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { Brush, Eraser, Loader2, Undo2 } from "lucide-react";
import { DrawingCanvas } from "@/components/draw/DrawingCanvas";
import { Button } from "@/components/ui";
import { BASE_COLORS } from "@/lib/mock";
import type { Stroke, Tool } from "@/lib/strokes";

/**
 * Kreslení avatara — **stejné plátno jako u kreseb**, jen čtvercové.
 *
 * Nemá vlastní kreslicí kód: `DrawingCanvas` už řeší gesta, zapomenuté prsty,
 * poměrné souřadnice i dlouhý stisk na iOS. Druhé plátno by ty pasti muselo
 * obejít znovu a jedna z nich by se zapomněla.
 *
 * Nástroje jsou schválně jen štětec a guma. Avatar je ikona o průměru 72 px —
 * paleta a tvary by tu byly rozhodování navíc bez viditelného rozdílu.
 * (Server přesto tvary hlídá levelem, kdyby je někdo poslal ručně.)
 */

interface AvatarEditorProps {
  /** Rozkreslený avatar, když už nějaký je. */
  initial: readonly Stroke[] | null;
  busy?: boolean;
  error?: string | null;
  onCancel: () => void;
  onSave: (strokes: readonly Stroke[]) => void;
  onClear: () => void;
}

export function AvatarEditor({
  initial,
  busy = false,
  error,
  onCancel,
  onSave,
  onClear,
}: AvatarEditorProps) {
  const t = useTranslations("avatar");
  const tDraw = useTranslations("draw");
  const [strokes, setStrokes] = useState<Stroke[]>([...(initial ?? [])]);
  const [tool, setTool] = useState<Tool>("brush");
  const [color, setColor] = useState(BASE_COLORS[0]);
  const [size, setSize] = useState(10);

  return (
    <div className="modal-backdrop" onClick={busy ? undefined : onCancel}>
      <div
        className="modal avatar-modal"
        role="dialog"
        aria-modal="true"
        aria-label={t("title")}
        onClick={(e) => e.stopPropagation()}
      >
        <h2 className="modal-title">{t("title")}</h2>
        <p className="t-secondary">{t("lede")}</p>

        {/* Čtvercová plocha — avatar je kolečko, obdélníkové plátno by se
            do něj muselo ořezávat a člověk by kreslil naslepo. */}
        <div className="avatar-canvas-wrap">
          <DrawingCanvas
            strokes={strokes}
            tool={tool}
            color={color}
            size={size}
            onStrokeEnd={(s) => setStrokes((prev) => [...prev, s])}
          />
        </div>

        <div className="avatar-tools">
          <button
            type="button"
            className={`icon-btn${tool === "brush" ? " is-active" : ""}`}
            aria-label={tDraw("tools.brush")}
            aria-pressed={tool === "brush"}
            onClick={() => setTool("brush")}
          >
            <Brush size={18} />
          </button>
          <button
            type="button"
            className={`icon-btn${tool === "eraser" ? " is-active" : ""}`}
            aria-label={tDraw("tools.eraser")}
            aria-pressed={tool === "eraser"}
            onClick={() => setTool("eraser")}
          >
            <Eraser size={18} />
          </button>
          <button
            type="button"
            className="icon-btn"
            aria-label={tDraw("tools.undo")}
            disabled={strokes.length === 0}
            onClick={() => setStrokes((prev) => prev.slice(0, -1))}
          >
            <Undo2 size={18} />
          </button>
          <input
            type="range"
            className="size-slider"
            min={4}
            max={24}
            value={size}
            aria-label={tDraw("tools.size")}
            onChange={(e) => setSize(Number(e.target.value))}
          />
        </div>

        <div className="avatar-colors">
          {BASE_COLORS.map((c) => (
            <button
              key={c}
              type="button"
              className={`swatch${c === color && tool === "brush" ? " is-active" : ""}`}
              style={{ background: c }}
              aria-label={c}
              onClick={() => {
                setColor(c);
                setTool("brush");
              }}
            />
          ))}
        </div>

        {error && (
          <p className="auth-note auth-note-error" role="alert">
            {error}
          </p>
        )}

        <div className="modal-actions">
          <Button size="lg" disabled={busy || strokes.length === 0} onClick={() => onSave(strokes)}>
            {busy && <Loader2 size={16} className="spin" aria-hidden="true" />} {t("save")}
          </Button>
          <Button variant="secondary" size="lg" disabled={busy} onClick={onCancel}>
            {t("cancel")}
          </Button>
        </div>

        {initial && initial.length > 0 && (
          <button type="button" className="btn btn-ghost btn-sm" disabled={busy} onClick={onClear}>
            {t("remove")}
          </button>
        )}
      </div>
    </div>
  );
}

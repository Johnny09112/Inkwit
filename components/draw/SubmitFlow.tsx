"use client";

import { useEffect, useRef } from "react";
import { useTranslations } from "next-intl";
import { Badge, Button } from "@/components/ui";
import { renderStrokes, type Stroke } from "@/lib/strokes";

/**
 * Odeslání (wireframe 2): kontrolní krok „vypadá to narychlo" a potvrzení
 * po odeslání. Modální okno nad plátnem — plátno zůstává vidět za překryvem.
 * Kontrolní krok se zobrazuje jen podezřelým kresbám (looksRushed).
 */

interface SubmitFlowProps {
  step: "confirm" | "done";
  strokes: readonly Stroke[];
  credit: number;
  onBack: () => void;
  onConfirm: () => void;
  onDrawNext: () => void;
  onGoGuess: () => void;
}

function StrokePreview({ strokes }: { strokes: readonly Stroke[] }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext("2d");
    if (!canvas || !ctx) return;
    const rect = canvas.getBoundingClientRect();
    const dpr = window.devicePixelRatio || 1;
    canvas.width = Math.max(1, Math.round(rect.width * dpr));
    canvas.height = Math.max(1, Math.round(rect.height * dpr));
    renderStrokes(ctx, strokes, canvas.width, canvas.height);
  }, [strokes]);

  return (
    <canvas
      ref={canvasRef}
      style={{ position: "absolute", inset: 0, width: "100%", height: "100%" }}
    />
  );
}

export function SubmitFlow({
  step,
  strokes,
  credit,
  onBack,
  onConfirm,
  onDrawNext,
  onGoGuess,
}: SubmitFlowProps) {
  const t = useTranslations("submit");

  return (
    <div className="modal-backdrop" onClick={step === "confirm" ? onBack : undefined}>
      <div className="modal" onClick={(e) => e.stopPropagation()} role="dialog">
        {step === "confirm" ? (
          <>
            <Badge tone="accent">{t("chip")}</Badge>
            <h2 className="modal-title">{t("title")}</h2>
            <div className="hatch" style={{ position: "relative", overflow: "hidden" }}>
              <StrokePreview strokes={strokes} />
              {strokes.length === 0 && (
                <span className="t-label">{t("preview")}</span>
              )}
            </div>
            <p className="t-secondary" style={{ fontSize: "var(--text-body-sm)" }}>
              {t("note")}
            </p>
            <div className="modal-actions">
              <Button size="lg" onClick={onConfirm}>
                {t("confirm")}
              </Button>
              <Button variant="secondary" size="lg" onClick={onBack}>
                {t("back")}
              </Button>
            </div>
          </>
        ) : (
          <>
            <span className="t-label">{t("doneStep")}</span>
            <h2 className="modal-title">{t("doneTitle")}</h2>
            <p className="t-secondary" style={{ fontSize: "var(--text-body-sm)" }}>
              {t("doneNote")}
            </p>
            <div style={{ display: "flex", gap: 8 }}>
              <Badge tone="success">{t("creditChip", { n: credit })}</Badge>
            </div>
            <div className="modal-actions">
              <Button size="lg" onClick={onDrawNext}>
                {t("drawNext")}
              </Button>
              <Button variant="secondary" size="lg" onClick={onGoGuess}>
                {t("goGuess")}
              </Button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

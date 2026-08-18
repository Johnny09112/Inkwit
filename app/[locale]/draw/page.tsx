"use client";

import { use, useMemo, useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import {
  Brush,
  Eraser,
  Eye,
  Move,
  Palette,
  Send,
  Trash2,
  Undo2,
  X,
  CircleUserRound,
} from "lucide-react";
import { Link, useRouter } from "@/i18n/navigation";
import { Badge, Button } from "@/components/ui";
import { DrawingCanvas } from "@/components/draw/DrawingCanvas";
import { ColorSheet } from "@/components/draw/ColorSheet";
import { SubmitFlow } from "@/components/draw/SubmitFlow";
import { conceptById, RECENT_COLORS } from "@/lib/mock";
import { looksRushed, type Stroke, type Tool } from "@/lib/strokes";

/**
 * Plátno (wireframe 1 + 1b). Tři rozvržení:
 * mobil = karta nástrojů pod plátnem, tablet = svislá lišta u pravé ruky,
 * desktop = plovoucí ostrůvek s pojmem nahoře a lišta nástrojů dole.
 */

type Mode = "draw" | "confirm" | "done";

export default function DrawPage({
  searchParams,
}: {
  searchParams: Promise<{ concept?: string }>;
}) {
  const { concept: conceptParam } = use(searchParams);
  const concept = conceptById(conceptParam ?? "octopus");
  const locale = useLocale() as "cs" | "en";
  const t = useTranslations("draw");
  const tCommon = useTranslations("common");
  const tDifficulty = useTranslations("difficulty");
  const tNav = useTranslations("nav");
  const router = useRouter();

  const [strokes, setStrokes] = useState<Stroke[]>([]);
  // Historie pro undo — snapshoty polí tahů (smazání všeho je taky krok zpět)
  const [history, setHistory] = useState<Stroke[][]>([]);
  const [tool, setTool] = useState<Tool>("brush");
  const [panMode, setPanMode] = useState(false);
  const [color, setColor] = useState(RECENT_COLORS[0]);
  const [size, setSize] = useState(14);
  const [recent, setRecent] = useState<string[]>([...RECENT_COLORS]);
  const [sheetOpen, setSheetOpen] = useState(false);
  const [previewMode, setPreviewMode] = useState(false);
  const [mode, setMode] = useState<Mode>("draw");

  const pushHistory = () => setHistory((h) => [...h.slice(-49), strokes]);

  const addStroke = (stroke: Stroke) => {
    pushHistory();
    setStrokes((s) => [...s, stroke]);
  };

  const undo = () => {
    setHistory((h) => {
      if (h.length === 0) return h;
      setStrokes(h[h.length - 1]);
      return h.slice(0, -1);
    });
  };

  const clearAll = () => {
    if (strokes.length === 0) return;
    pushHistory();
    setStrokes([]);
  };

  const pickColor = (c: string) => {
    setColor(c);
    setTool("brush");
    setPanMode(false);
    setRecent((r) => [c, ...r.filter((x) => x !== c)].slice(0, 8));
  };

  const selectTool = (next: Tool) => {
    setTool(next);
    setPanMode(false);
  };

  const startSubmit = () => {
    // Kontrolní krok jen když kresba vypadá narychlo — tření proti
    // čmáranicím nemají platit poctiví kreslíři (poznámka u wireframu 2)
    setMode(looksRushed(strokes) ? "confirm" : "done");
  };

  const difficultyBadge = (
    <Badge tone="accent">{tDifficulty(String(concept.difficulty))}</Badge>
  );

  const toolButtons = (iconSize: number) => (
    <>
      <button
        type="button"
        className={`icon-btn${tool === "brush" && !panMode ? " is-active" : ""}`}
        aria-label={t("tools.brush")}
        aria-pressed={tool === "brush" && !panMode}
        onClick={() => selectTool("brush")}
      >
        <Brush size={iconSize} />
      </button>
      <button
        type="button"
        className={`icon-btn${tool === "eraser" && !panMode ? " is-active" : ""}`}
        aria-label={t("tools.eraser")}
        aria-pressed={tool === "eraser" && !panMode}
        onClick={() => selectTool("eraser")}
      >
        <Eraser size={iconSize} />
      </button>
      <button
        type="button"
        className="icon-btn"
        aria-label={t("tools.undo")}
        disabled={history.length === 0}
        onClick={undo}
      >
        <Undo2 size={iconSize} />
      </button>
      <button
        type="button"
        className={`icon-btn${panMode ? " is-active" : ""}`}
        aria-label={t("tools.move")}
        aria-pressed={panMode}
        onClick={() => setPanMode((p) => !p)}
      >
        <Move size={iconSize} />
      </button>
    </>
  );

  const trashButton = (iconSize: number) => (
    <button
      type="button"
      className="icon-btn icon-btn-danger"
      aria-label={t("tools.clear")}
      disabled={strokes.length === 0}
      onClick={clearAll}
    >
      <Trash2 size={iconSize} />
    </button>
  );

  const swatches = (colors: readonly string[], sizePx?: number) =>
    colors.map((c) => (
      <button
        key={c}
        type="button"
        className={`swatch${c === color && tool === "brush" ? " is-active" : ""}`}
        style={sizePx ? { background: c, width: sizePx, height: sizePx } : { background: c }}
        aria-label={c}
        onClick={() => pickColor(c)}
      />
    ));

  const paletteButton = (
    <button
      type="button"
      className="swatch swatch-add"
      aria-label={t("tools.palette")}
      onClick={() => setSheetOpen(true)}
    >
      <Palette size={15} />
    </button>
  );

  const sizeSlider = (
    <input
      type="range"
      min={2}
      max={28}
      value={size}
      className="size-slider"
      aria-label={t("tools.size")}
      onChange={(e) => setSize(Number(e.target.value))}
    />
  );

  const canvas = (
    <div className="draw-canvas-wrap">
      <DrawingCanvas
        strokes={strokes}
        tool={tool}
        color={color}
        size={size}
        inputDisabled={panMode || mode !== "draw"}
        onStrokeEnd={addStroke}
      />
      {strokes.length === 0 && (
        <div className="draw-canvas-hint t-label">{t("canvasHint")}</div>
      )}

      {/* Desktop: plovoucí ostrůvek s pojmem + lišta dole (wireframe 1 desktop) */}
      <div className="only-desktop">
        <div className="float-pill draw-float-concept">
          <span className="draw-concept-name">{concept.name[locale]}</span>
          {difficultyBadge}
          <span className="float-pill-divider" />
          <Link
            href="/guess"
            aria-label={tCommon("close")}
            style={{ color: "var(--text-secondary)", display: "inline-flex" }}
          >
            <X size={20} />
          </Link>
        </div>
        <div className="draw-float-bottom">
          <div className="draw-float-sizebar">
            <span
              style={{
                width: size,
                height: size,
                borderRadius: 999,
                background: color,
                flex: "none",
              }}
            />
            {sizeSlider}
            <span className="playback-time">{t("sizePx", { n: size })}</span>
          </div>
          <div className="draw-float-toolbar">
            {toolButtons(24)}
            {trashButton(24)}
            <span className="float-pill-divider" style={{ height: 40 }} />
            <div style={{ display: "flex", gap: 10 }}>
              {swatches(recent.slice(0, 6), 34)}
              {paletteButton}
            </div>
            <span className="float-pill-divider" style={{ height: 40 }} />
            <Button size="lg" onClick={startSubmit}>
              <Send size={20} /> {t("sendShort")}
            </Button>
          </div>
        </div>
      </div>

      {/* Tablet: svislá lišta u pravé ruky + velikost dole (wireframe 1 tablet) */}
      <div className="only-tablet">
        <div className="float-pill draw-float-concept">
          <span className="draw-concept-name">{concept.name[locale]}</span>
          {difficultyBadge}
          <span className="float-pill-divider" />
          <Link
            href="/guess"
            aria-label={tCommon("close")}
            style={{ color: "var(--text-secondary)", display: "inline-flex" }}
          >
            <X size={19} />
          </Link>
        </div>
        <div className="draw-rail">
          {toolButtons(22)}
          <div className="draw-toolcard-divider" />
          <div className="draw-rail-swatches">{swatches(recent.slice(0, 6))}</div>
          {paletteButton}
          <div className="draw-toolcard-divider" />
          {trashButton(22)}
        </div>
        <div className="draw-float-bottom">
          <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
            <div className="draw-float-sizebar">
              <span
                style={{
                  width: 16,
                  height: 16,
                  borderRadius: 999,
                  background: color,
                  flex: "none",
                }}
              />
              {sizeSlider}
              <span className="playback-time">{t("sizePx", { n: size })}</span>
            </div>
            <Button size="lg" onClick={startSubmit}>
              <Send size={19} /> {t("sendShort")}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );

  return (
    <div className="draw-screen">
      {/* Mobil: hlavička s pojmem mezi křížkem a profilem (wireframe 1) */}
      <div className="only-mobile">
        <div className="draw-head">
          <Link
            href="/guess"
            aria-label={tCommon("close")}
            className="icon-btn icon-btn-plain"
            style={{ width: 34, height: 34 }}
          >
            <X size={20} />
          </Link>
          <div className="draw-concept">
            <span className="draw-concept-name">{concept.name[locale]}</span>
            {difficultyBadge}
          </div>
          <Link
            href="/profile"
            aria-label={tNav("profile")}
            className="icon-btn icon-btn-plain"
            style={{ width: 34, height: 34 }}
          >
            <CircleUserRound size={22} />
          </Link>
        </div>
      </div>

      {canvas}

      {/* Mobil: karta nástrojů + odeslání (skrytá v náhledu) */}
      <div className="only-mobile">
        {!previewMode && (
          <div className="draw-toolcard">
            <div className="swatch-row">
              <div className="swatch-row-colors">{swatches(recent)}</div>
              {paletteButton}
            </div>
            <div className="draw-toolcard-divider" />
            <div className="tool-row">
              {toolButtons(20)}
              <span className="spacer" />
              {trashButton(20)}
            </div>
            <div className="size-row">
              <span className="size-dot-min" />
              {sizeSlider}
              <span className="size-dot-max" />
            </div>
          </div>
        )}
        <div className="draw-footer">
          <Button size="lg" onClick={startSubmit}>
            {t("send")}
          </Button>
          <button
            type="button"
            className={`icon-btn${previewMode ? " is-active" : ""}`}
            style={{ width: 48, height: 48 }}
            aria-label={t("tools.preview")}
            aria-pressed={previewMode}
            onClick={() => setPreviewMode((p) => !p)}
          >
            <Eye size={20} />
          </button>
        </div>
      </div>

      {sheetOpen && (
        <ColorSheet
          recent={recent}
          activeColor={color}
          onPick={pickColor}
          onClose={() => setSheetOpen(false)}
        />
      )}

      {mode !== "draw" && (
        <SubmitFlow
          step={mode}
          strokes={strokes}
          credit={concept.credit}
          onBack={() => setMode("draw")}
          onConfirm={() => setMode("done")}
          onDrawNext={() => router.push("/pick")}
          onGoGuess={() => router.push("/guess")}
        />
      )}
    </div>
  );
}

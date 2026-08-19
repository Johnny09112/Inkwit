"use client";

import { use, useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import {
  Brush,
  Eraser,
  Eye,
  Move,
  Palette,
  Send,
  Trash2,
  TriangleAlert,
  Undo2,
  X,
  CircleUserRound,
} from "lucide-react";
import { Link, useRouter } from "@/i18n/navigation";
import { Badge, Button } from "@/components/ui";
import { DrawingCanvas } from "@/components/draw/DrawingCanvas";
import { ColorSheet } from "@/components/draw/ColorSheet";
import { SubmitFlow } from "@/components/draw/SubmitFlow";
import { fetchDraft, submitDrawing, type Draft } from "@/lib/game";
import { RECENT_COLORS } from "@/lib/mock";
import { looksRushed, type Stroke, type Tool } from "@/lib/strokes";
import { useHand } from "@/lib/prefs";
import { Loader2 } from "lucide-react";

/**
 * Plátno (wireframe 1 + 1b). Tři rozvržení:
 * mobil = karta nástrojů pod plátnem, tablet = svislá lišta u pravé ruky,
 * desktop = plovoucí ostrůvek s pojmem nahoře a lišta nástrojů dole.
 */

type Mode = "draw" | "confirm" | "done";

export default function DrawPage({
  searchParams,
}: {
  searchParams: Promise<{ d?: string }>;
}) {
  // V URL je id rozepsané kresby, ne zadání — odpověď by se jinak válela
  // v historii prohlížeče. Zadání si vyzvedne autor podle id.
  const { d: drawingId } = use(searchParams);
  const [draft, setDraft] = useState<Draft | null>(null);
  const [loadError, setLoadError] = useState(false);
  const t = useTranslations("draw");
  const tCommon = useTranslations("common");
  const tDifficulty = useTranslations("difficulty");
  const tNav = useTranslations("nav");
  const router = useRouter();
  // Svislá lišta na tabletu patří ke kreslicí ruce — leváci přes ni jinak kreslí.
  const hand = useHand();

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
  const [undoCount, setUndoCount] = useState(0);
  const [confirmClear, setConfirmClear] = useState(false);
  const [sending, setSending] = useState(false);
  const [sendError, setSendError] = useState<string | null>(null);

  useEffect(() => {
    if (!drawingId) {
      setLoadError(true);
      return;
    }
    let alive = true;
    fetchDraft(drawingId)
      .then((d) => alive && (d ? setDraft(d) : setLoadError(true)))
      .catch(() => alive && setLoadError(true));
    return () => {
      alive = false;
    };
  }, [drawingId]);

  const pushHistory = () => setHistory((h) => [...h.slice(-49), strokes]);

  const addStroke = (stroke: Stroke) => {
    setConfirmClear(false);
    pushHistory();
    setStrokes((s) => [...s, stroke]);
  };

  const undo = () => {
    // Počet vrácení je jeden ze signálů snahy — server ho nedopočítá,
    // je to událost v prohlížeči.
    setUndoCount((n) => n + 1);
    setHistory((h) => {
      if (h.length === 0) return h;
      setStrokes(h[h.length - 1]);
      return h.slice(0, -1);
    });
  };

  const clearAll = () => {
    setConfirmClear(false);
    if (strokes.length === 0) return;
    pushHistory();
    setStrokes([]);
  };

  // Rozmyšlená otázka se po chvíli sama zavře — a nesmí přežít do dalšího tahu.
  useEffect(() => {
    if (!confirmClear) return;
    const timer = setTimeout(() => setConfirmClear(false), 4000);
    return () => clearTimeout(timer);
  }, [confirmClear]);

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

  /** Odeslání na server. Doba kreslení a pokrytí plátna se počítají tam. */
  async function send() {
    if (!drawingId || sending) return;
    setSending(true);
    setSendError(null);
    try {
      await submitDrawing(drawingId, strokes, undoCount);
      setMode("done");
    } catch {
      setSendError(t("sendFailed"));
    } finally {
      setSending(false);
    }
  }

  const startSubmit = () => {
    // Kontrolní krok jen když kresba vypadá narychlo — tření proti
    // čmáranicím nemají platit poctiví kreslíři (poznámka u wireframu 2)
    if (looksRushed(strokes)) {
      setMode("confirm");
      return;
    }
    void send();
  };

  const difficultyBadge = (
    <Badge tone="accent">{tDifficulty(String(draft?.difficulty ?? 1))}</Badge>
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

  // Smazání je jediná nevratná-vypadající akce na plátně a sedí v rohu, kam
  // dopadá palec. Druhé klepnutí ji potvrdí, po chvíli se ptaní zase zruší —
  // ať nezůstane obrazovka v natrženém stavu, když od ní člověk odejde.
  const trashButton = (iconSize: number) => (
    <button
      type="button"
      className={`icon-btn icon-btn-danger${confirmClear ? " is-confirming" : ""}`}
      aria-label={confirmClear ? t("tools.clearConfirm") : t("tools.clear")}
      title={confirmClear ? t("tools.clearConfirm") : t("tools.clear")}
      disabled={strokes.length === 0}
      onClick={() => (confirmClear ? clearAll() : setConfirmClear(true))}
    >
      {confirmClear ? <TriangleAlert size={iconSize} /> : <Trash2 size={iconSize} />}
    </button>
  );

  /** Oddělení nebezpečného tlačítka od sousedů — proti mis-tapům na dotyku. */
  const trashSeparator = <span className="tool-sep" aria-hidden="true" />;

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
          <span className="draw-concept-name">{draft?.prompt ?? ""}</span>
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
            {trashSeparator}
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
          <span className="draw-concept-name">{draft?.prompt ?? ""}</span>
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
        <div className={`draw-rail draw-rail-${hand}`}>
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

  // Bez zadání není co kreslit. Nejčastější důvod je otevření odkazu na cizí
  // nebo už odeslanou kresbu — obojí server odmítne vrátit.
  if (loadError) {
    return (
      <div className="draw-screen draw-screen-message">
        <p className="auth-note auth-note-error">{t("draftMissing")}</p>
        <Link href="/pick" className="btn btn-primary">
          {t("pickAnother")}
        </Link>
      </div>
    );
  }

  if (!draft) {
    return (
      <div className="draw-screen draw-screen-message">
        <p className="pick-loading">
          <Loader2 size={18} className="spin" aria-hidden="true" /> {t("loading")}
        </p>
      </div>
    );
  }

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
            <span className="draw-concept-name">{draft?.prompt ?? ""}</span>
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
              {paletteButton}
              <div className="swatch-row-colors">{swatches(recent)}</div>
            </div>
            <div className="draw-toolcard-divider" />
            <div className="tool-row">
              {toolButtons(20)}
              <span className="spacer" />
              {trashSeparator}
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
          credit={draft?.difficulty ?? 1}
          busy={sending}
          error={sendError}
          onBack={() => setMode("draw")}
          onConfirm={send}
          onDrawNext={() => router.push("/pick")}
          onGoGuess={() => router.push("/guess")}
        />
      )}
    </div>
  );
}

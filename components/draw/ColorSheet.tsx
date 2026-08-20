"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { ChevronDown, Plus, X } from "lucide-react";
import { Button } from "@/components/ui";
import { ColorWheel } from "@/components/draw/ColorWheel";
import { PALETTE_MAX, usePalette } from "@/lib/prefs";

/**
 * Rozbalené barvy (wireframe 1b): naposledy použité a vlastní paleta.
 *
 * **Hex se sem nepíše.** Patří k výběru vlastní barvy, kde je vedle kruhu
 * vidět, co za hodnotou je — tady by to byl jen holý kód bez souvislosti.
 *
 * Paleta se ukládá do prohlížeče (`lib/prefs.ts`). Do doby, než tohle vzniklo,
 * byla „Moje paleta" konstanta a přidaná barva zmizela se zavřením panelu.
 */

interface ColorSheetProps {
  recent: readonly string[];
  activeColor: string;
  onPick: (color: string) => void;
  onClose: () => void;
  /** Level hráče a odemykací hranice. Míchání je kosmetika za postup, ne za peníze. */
  level?: number;
  mixerLevel?: number;
  paletteFullLevel?: number;
}

/** Co panel zrovna dělá: vybírá barvu, míchá novou, uklízí, nebo hledá místo. */
type Mode =
  | { kind: "pick" }
  | { kind: "wheel" }
  | { kind: "locked" }
  | { kind: "place"; color: string };

export function ColorSheet({
  recent,
  activeColor,
  onPick,
  onClose,
  level = 99,
  mixerLevel = 3,
  paletteFullLevel = 2,
}: ColorSheetProps) {
  const t = useTranslations("draw.colors");
  const [palette, savePalette] = usePalette();
  const [mode, setMode] = useState<Mode>({ kind: "pick" });

  const isFull = palette.length >= PALETTE_MAX;

  /**
   * Nová barva jde do prvního volného místa sama. Ptát se na umístění pokaždé
   * by přidalo krok i tam, kde je volno — na výběr místa se ptáme, teprve když
   * je paleta plná a je opravdu co obětovat.
   */
  const confirmColor = (color: string) => {
    if (palette.includes(color)) {
      onPick(color);
      onClose();
      return;
    }
    if (isFull) {
      setMode({ kind: "place", color });
      return;
    }
    savePalette([...palette, color]);
    onPick(color);
    onClose();
  };

  const placeAt = (index: number, color: string) => {
    const next = [...palette];
    next[index] = color;
    savePalette(next);
    onPick(color);
    onClose();
  };

  const swatch = (color: string, key: string) => (
    <button
      key={key}
      type="button"
      className={`swatch${color.toLowerCase() === activeColor.toLowerCase() ? " is-active" : ""}`}
      style={{ background: color }}
      aria-label={color}
      onClick={() => {
        onPick(color);
        onClose();
      }}
    />
  );

  if (mode.kind === "locked") {
    return (
      <>
        <div className="sheet-backdrop" onClick={onClose} />
        <div className="color-sheet" role="dialog" aria-label={t("lockedTitle")}>
          <div className="color-sheet-head">
            <span className="color-sheet-title">{t("lockedTitle")}</span>
            <button
              type="button"
              className="icon-btn icon-btn-plain"
              style={{ width: 30, height: 30 }}
              aria-label={t("close")}
              onClick={onClose}
            >
              <ChevronDown size={18} />
            </button>
          </div>
          <p className="t-secondary" style={{ fontSize: "var(--text-body-sm)" }}>
            {t("lockedLede", { level: mixerLevel })}
          </p>
          <div className="modal-actions">
            <Button size="lg" onClick={() => setMode({ kind: "pick" })}>
              {t("lockedBack")}
            </Button>
          </div>
        </div>
      </>
    );
  }

  if (mode.kind === "wheel") {
    return (
      <>
        <div className="sheet-backdrop" onClick={onClose} />
        <div className="color-sheet" role="dialog" aria-label={t("pickerTitle")}>
          <ColorWheel
            initial={activeColor}
            note={isFull ? t("fullNote", { n: PALETTE_MAX }) : undefined}
            onCancel={() => setMode({ kind: "pick" })}
            onConfirm={confirmColor}
          />
        </div>
      </>
    );
  }

  const placing = mode.kind === "place" ? mode.color : null;
  // Pod odemykacím levelem je vidět jen prvních osm barev — zbytek přijde
  // s postupem. Je to kosmetika, na férovost hry to vliv nemá.
  const viditelne = level >= paletteFullLevel ? palette : palette.slice(0, 8);

  return (
    <>
      <div className="sheet-backdrop" onClick={onClose} />
      <div className="color-sheet" role="dialog" aria-label={t("title")}>
        <div className="color-sheet-head">
          <span className="color-sheet-title">{t("title")}</span>
          <button
            type="button"
            className="icon-btn icon-btn-plain"
            style={{ width: 30, height: 30 }}
            aria-label={t("close")}
            onClick={onClose}
          >
            <ChevronDown size={18} />
          </button>
        </div>

        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          <span className="t-label-sm">{t("recent")}</span>
          <div style={{ display: "flex", gap: 10 }}>
            {recent.slice(0, 6).map((c) => swatch(c, `recent-${c}`))}
          </div>
        </div>

        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          <span className="t-label-sm">{t("mine")}</span>

          {placing && (
            <p className="wheel-note">
              <span className="wheel-preview" style={{ background: placing }} aria-hidden="true" />
              {t("placePrompt")}
            </p>
          )}

          <div className="color-grid">
            {viditelne.map((c, i) =>
              placing ? (
                <button
                  key={`slot-${i}`}
                  type="button"
                  className="swatch"
                  style={{ background: c }}
                  aria-label={t("placeHere", { color: c })}
                  onClick={() => placeAt(i, placing)}
                />
              ) : (
                swatch(c, `palette-${i}-${c}`)
              ),
            )}

            <button
              type="button"
              className="swatch swatch-add"
              aria-label={placing ? t("cancel") : t("add")}
              onClick={() =>
                setMode(
                  placing
                    ? { kind: "pick" }
                    : level >= mixerLevel
                      ? { kind: "wheel" }
                      : { kind: "locked" },
                )
              }
            >
              {placing ? <X size={14} /> : <Plus size={14} />}
            </button>
          </div>
        </div>
      </div>
    </>
  );
}

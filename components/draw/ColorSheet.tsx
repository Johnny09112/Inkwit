"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { ChevronDown, Plus, Settings2, X } from "lucide-react";
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
}

/** Co panel zrovna dělá: vybírá barvu, míchá novou, uklízí, nebo hledá místo. */
type Mode =
  | { kind: "pick" }
  | { kind: "wheel" }
  | { kind: "edit" }
  | { kind: "place"; color: string };

export function ColorSheet({ recent, activeColor, onPick, onClose }: ColorSheetProps) {
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

  const removeAt = (index: number) => {
    const next = palette.filter((_, i) => i !== index);
    // Prázdná paleta by se při dalším načtení stejně vrátila na výchozí,
    // takže se poslední barva nedá odebrat.
    if (next.length === 0) return;
    savePalette(next);
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
  const editing = mode.kind === "edit";

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
          <div className="color-sheet-head">
            <span className="t-label-sm">{t("mine")}</span>
            <button
              type="button"
              className={`icon-btn icon-btn-plain${editing ? " is-active" : ""}`}
              style={{ width: 30, height: 30 }}
              aria-label={editing ? t("editDone") : t("edit")}
              aria-pressed={editing}
              disabled={placing !== null}
              onClick={() => setMode(editing ? { kind: "pick" } : { kind: "edit" })}
            >
              <Settings2 size={15} />
            </button>
          </div>

          {placing && (
            <p className="wheel-note">
              <span className="wheel-preview" style={{ background: placing }} aria-hidden="true" />
              {t("placePrompt")}
            </p>
          )}

          <div className="color-grid">
            {palette.map((c, i) => (
              <span key={`slot-${i}-${c}`} className="color-slot">
                {placing ? (
                  <button
                    type="button"
                    className="swatch"
                    style={{ background: c }}
                    aria-label={t("placeHere", { color: c })}
                    onClick={() => placeAt(i, placing)}
                  />
                ) : (
                  swatch(c, `palette-${c}`)
                )}
                {editing && palette.length > 1 && (
                  <button
                    type="button"
                    className="color-remove"
                    aria-label={t("remove", { color: c })}
                    onClick={() => removeAt(i)}
                  >
                    <X size={11} />
                  </button>
                )}
              </span>
            ))}

            {!editing && (
              <button
                type="button"
                className="swatch swatch-add"
                aria-label={placing ? t("cancel") : t("add")}
                onClick={() =>
                  placing ? setMode({ kind: "pick" }) : setMode({ kind: "wheel" })
                }
              >
                {placing ? <X size={14} /> : <Plus size={14} />}
              </button>
            )}
          </div>
        </div>
      </div>
    </>
  );
}

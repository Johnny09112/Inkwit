"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { Check, ChevronDown, Plus, Settings2 } from "lucide-react";
import { FULL_PALETTE } from "@/lib/mock";

/**
 * Rozbalené barvy (wireframe 1b): naposledy použité, vlastní paleta,
 * vložení hexu. Bottom sheet na mobilu, stejný obsah v popoveru jinde.
 */

interface ColorSheetProps {
  recent: readonly string[];
  activeColor: string;
  onPick: (color: string) => void;
  onClose: () => void;
}

const HEX_RE = /^[0-9a-fA-F]{6}$/;

export function ColorSheet({ recent, activeColor, onPick, onClose }: ColorSheetProps) {
  const t = useTranslations("draw.colors");
  const [palette, setPalette] = useState<string[]>([...FULL_PALETTE]);
  const [hex, setHex] = useState(activeColor.replace("#", ""));

  const hexValid = HEX_RE.test(hex);

  const applyHex = () => {
    if (!hexValid) return;
    const color = `#${hex.toUpperCase()}`;
    if (!palette.includes(color)) {
      setPalette((p) => [...p, color]);
    }
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
            aria-label={t("title")}
            onClick={onClose}
          >
            <ChevronDown size={18} />
          </button>
        </div>

        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
            {t("recent")}
          </span>
          <div style={{ display: "flex", gap: 10 }}>
            {recent.slice(0, 6).map((c) => swatch(c, `recent-${c}`))}
          </div>
        </div>

        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          <div className="color-sheet-head">
            <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
              {t("mine")}
            </span>
            <Settings2 size={15} aria-label={t("edit")} color="var(--text-secondary)" />
          </div>
          <div className="color-grid">
            {palette.map((c) => swatch(c, `palette-${c}`))}
            <button
              type="button"
              className="swatch swatch-add"
              aria-label={t("add")}
              onClick={applyHex}
            >
              <Plus size={14} />
            </button>
          </div>
        </div>

        <div className="hex-row">
          <label className="hex-field">
            <span aria-hidden>#</span>
            <input
              value={hex}
              maxLength={6}
              aria-label={t("hex")}
              onChange={(e) => setHex(e.target.value.replace(/[^0-9a-fA-F]/g, ""))}
              onKeyDown={(e) => {
                if (e.key === "Enter") applyHex();
              }}
            />
          </label>
          <button
            type="button"
            className="icon-btn is-active"
            aria-label={t("apply")}
            disabled={!hexValid}
            onClick={applyHex}
          >
            <Check size={20} />
          </button>
        </div>
      </div>
    </>
  );
}

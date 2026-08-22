"use client";

import { notFound } from "next/navigation";
import { useState } from "react";
import { ColorSheet } from "@/components/draw/ColorSheet";
import { DrawingCanvas } from "@/components/draw/DrawingCanvas";
import { ShapePicker } from "@/components/draw/ShapePicker";
import { SizePicker } from "@/components/draw/SizePicker";
import { BASE_COLORS } from "@/lib/mock";
import type { Stroke, Tool } from "@/lib/strokes";

/**
 * Vývojová obrazovka pro kreslicí komponenty. **Není součástí hry.**
 *
 * Důvod: plátno i panel barev žijí za přihlášením, takže se v prohlížeči
 * nedají prohlédnout bez účtu. Tohle je pustí nasucho, bez serveru a bez
 * jediného zápisu do databáze — takže se dá zkoušet rozvržení na šířkách
 * telefonu i tabletu, aniž by v měření fáze 0 přibyl testovací účet.
 *
 * Chráněná dvakrát: stránka se v produkci tváří jako neexistující a middleware
 * ji pouští bez přihlášení jen ve vývoji.
 */
export default function PlaygroundPage() {
  if (process.env.NODE_ENV !== "development") notFound();

  const [strokes, setStrokes] = useState<Stroke[]>([]);
  const [tool, setTool] = useState<Tool>("brush");
  const [color, setColor] = useState(BASE_COLORS[0]);
  const [size, setSize] = useState(14);
  const [filled, setFilled] = useState(false);
  const [recent, setRecent] = useState<string[]>([...BASE_COLORS]);
  const [sheetOpen, setSheetOpen] = useState(false);

  return (
    <div className="draw-screen">
      <div className="draw-head">
        <span className="draw-concept-name">playground</span>
        <button type="button" className="btn btn-secondary btn-sm" onClick={() => setSheetOpen(true)}>
          barvy
        </button>
        <button type="button" className="btn btn-secondary btn-sm" onClick={() => setStrokes([])}>
          smazat
        </button>
        <button
          type="button"
          className="btn btn-secondary btn-sm"
          onClick={() => setTool(tool === "brush" ? "eraser" : "brush")}
        >
          {tool}
        </button>
        {/* Tvary jsou v samotné hře za levelem 4; tady bez zámku, ať jdou
            prohlédnout bez účtu. */}
        <ShapePicker
          tool={tool}
          onPick={setTool}
          iconSize={20}
          filled={filled}
          onFilledChange={setFilled}
        />
        <SizePicker
          size={size}
          max={28}
          previewColor={tool === "eraser" ? "var(--border-strong)" : color}
          slider={
            <input
              type="range"
              className="size-slider"
              min={2}
              max={28}
              value={size}
              aria-label="velikost"
              onChange={(e) => setSize(Number(e.target.value))}
            />
          }
        />
      </div>

      {/* Pevná paleta ve stejném obalu jako na kreslicí obrazovce — včetně
          `overflow: hidden`, protože právě ten usekával prstenec u vybrané
          barvy. Bez toho by se tady chyba nedala reprodukovat. */}
      <div className="draw-toolcard">
        <div className="swatch-row">
          <div className="swatch-row-colors">
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
        </div>
      </div>

      <div className="draw-canvas-wrap">
        <DrawingCanvas
          strokes={strokes}
          tool={tool}
          color={color}
          size={size}
          filled={filled}
          onStrokeEnd={(s) => setStrokes((prev) => [...prev, s])}
        />
      </div>

      <div className="draw-footer">
        <span className="playback-time">
          {strokes.length} tahů · {color}
        </span>
      </div>

      {sheetOpen && (
        <ColorSheet
          recent={recent}
          activeColor={color}
          onPick={(c) => {
            setColor(c);
            setRecent((r) => [c, ...r.filter((x) => x !== c)].slice(0, 8));
          }}
          onClose={() => setSheetOpen(false)}
        />
      )}
    </div>
  );
}

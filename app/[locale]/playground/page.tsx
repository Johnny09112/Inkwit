"use client";

import { notFound } from "next/navigation";
import { useState } from "react";
import { ColorSheet } from "@/components/draw/ColorSheet";
import { DrawingCanvas } from "@/components/draw/DrawingCanvas";
import { RECENT_COLORS } from "@/lib/mock";
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
  const [color, setColor] = useState(RECENT_COLORS[0]);
  const [size, setSize] = useState(14);
  const [recent, setRecent] = useState<string[]>([...RECENT_COLORS]);
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
        <input
          type="range"
          min={2}
          max={28}
          value={size}
          aria-label="velikost"
          onChange={(e) => setSize(Number(e.target.value))}
        />
      </div>

      <div className="draw-canvas-wrap">
        <DrawingCanvas
          strokes={strokes}
          tool={tool}
          color={color}
          size={size}
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

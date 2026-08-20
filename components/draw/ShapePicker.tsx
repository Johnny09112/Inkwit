"use client";

import { useEffect, useLayoutEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { Circle, Lock, Minus, Shapes, Square } from "lucide-react";
import { SHAPE_TOOLS, type ShapeTool, type Tool } from "@/lib/strokes";

/**
 * Výběr tvaru — jedno tlačítko, které otevře tři možnosti.
 *
 * Proč ne tři tlačítka vedle sebe: lišta má na mobilu dva řádky a v jednom z nich
 * sedí posuvník velikosti. Tři ikony navíc by ho zmáčkly na nepoužitelnou šířku.
 *
 * Proč ne cyklení jedním tlačítkem: kdo chce elipsu, klikal by na čáru
 * a obdélník. U tří možností to ještě jde, ale je to zbytečné klepání.
 *
 * Pod odemykacím levelem se tlačítko ukazuje zamčené, ne skryté — jinak by
 * nebylo poznat, že je na co se těšit. Skutečný zámek je na serveru
 * (`submit_drawing`), tohle je pohodlí.
 */

const IKONY: Record<ShapeTool, typeof Minus> = {
  line: Minus,
  rect: Square,
  ellipse: Circle,
};

interface ShapePickerProps {
  /** Aktivní nástroj plátna — podle něj se pozná, jestli je skupina vybraná. */
  tool: Tool;
  onPick: (tool: ShapeTool) => void;
  /** Zamčeno pod levelem; číslo se ukáže v popisku. */
  locked?: boolean;
  lockLevel?: number;
  iconSize?: number;
  /** Rail na tabletu je svislý — nabídka se otevírá do strany, ne nahoru. */
  side?: boolean;
}

export function ShapePicker({
  tool,
  onPick,
  locked = false,
  lockLevel = 4,
  iconSize = 20,
  side = false,
}: ShapePickerProps) {
  const t = useTranslations("draw");
  const [open, setOpen] = useState(false);
  const wrap = useRef<HTMLDivElement>(null);
  const menu = useRef<HTMLDivElement>(null);
  const [posledni, setPosledni] = useState<ShapeTool>("line");
  const [dolu, setDolu] = useState(false);

  const aktivni = (SHAPE_TOOLS as readonly string[]).includes(tool);
  const Ikona = aktivni ? IKONY[tool as ShapeTool] : Shapes;

  /**
   * Nabídka se otevírá nad tlačítkem, protože lišta je skoro vždycky dole.
   * Když nad ním místo není, překlopí se pod. Bez toho by nabídka u lišty
   * nahoře vyjela mimo obrazovku a nedalo by se na ni dosáhnout.
   */
  useLayoutEffect(() => {
    if (!open) { setDolu(false); return; }
    const r = menu.current?.getBoundingClientRect();
    if (r && r.top < 0) setDolu(true);
  }, [open]);

  // Klepnutí mimo nabídku ji zavře. Bez toho zůstane viset přes plátno
  // a další tah do ní spadne.
  useEffect(() => {
    if (!open) return;
    const zavri = (e: PointerEvent) => {
      if (!wrap.current?.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("pointerdown", zavri);
    return () => document.removeEventListener("pointerdown", zavri);
  }, [open]);

  if (locked) {
    return (
      <button
        type="button"
        className="icon-btn is-locked"
        aria-label={t("tools.shapesLocked", { level: lockLevel })}
        title={t("tools.shapesLocked", { level: lockLevel })}
        disabled
      >
        <Lock size={iconSize} />
      </button>
    );
  }

  return (
    <div className="shape-picker" ref={wrap}>
      <button
        type="button"
        className={`icon-btn${aktivni ? " is-active" : ""}`}
        aria-label={t("tools.shapes")}
        aria-pressed={aktivni}
        aria-expanded={open}
        onClick={() => {
          // Když skupina ještě není vybraná, první klepnutí ji rovnou zapne
          // na naposledy použitý tvar — jinak by kreslení stálo dvě klepnutí.
          if (!aktivni) onPick(posledni);
          setOpen((o) => !o);
        }}
      >
        <Ikona size={iconSize} />
      </button>
      {open && (
        <div
          ref={menu}
          className={`shape-menu${side ? " shape-menu-side" : ""}${dolu ? " shape-menu-down" : ""}`}
          role="group"
        >
          {SHAPE_TOOLS.map((s) => {
            const I = IKONY[s];
            return (
              <button
                key={s}
                type="button"
                className={`icon-btn${tool === s ? " is-active" : ""}`}
                aria-label={t(`tools.${s}`)}
                title={t(`tools.${s}`)}
                aria-pressed={tool === s}
                onClick={() => {
                  setPosledni(s);
                  onPick(s);
                  setOpen(false);
                }}
              >
                <I size={iconSize} />
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}

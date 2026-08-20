"use client";

import { useRef, useState, type ReactNode } from "react";
import { useTranslations } from "next-intl";
import { useDismissOnOutside, useFlipWhenNoRoom } from "@/lib/popover";

/**
 * Velikost stopy ve vyskakovacím panelu.
 *
 * **Proč není posuvník rovnou v liště.** Byl — dokud v řádku nepřibyla čtvrtá
 * položka (tvary). Čtyři tlačítka po 46 px a posuvník se do mobilního řádku
 * nevejdou: na šířce 360 px zbylo na posuvník 52 px a na 320 px dvanáct.
 * Změřeno 2026-08-20. Panel to řeší, aniž by karta narostla o třetí řádek —
 * dva řádky byly vědomá úspora výšky pro plátno.
 *
 * Na tlačítku je vidět skutečná tloušťka, takže se pro přečtení velikosti
 * panel otevírat nemusí.
 */

interface SizePickerProps {
  size: number;
  /** Největší hodnota posuvníku — podle ní se škáluje náhled na tlačítku. */
  max: number;
  /** Barva náhledu. Guma se ukazuje šedě, ne aktuální barvou. */
  previewColor: string;
  /** Posuvník dodává volající, ať je jeho podoba na jednom místě. */
  slider: ReactNode;
}

export function SizePicker({ size, max, previewColor, slider }: SizePickerProps) {
  const t = useTranslations("draw");
  const [open, setOpen] = useState(false);
  const [down, setDown] = useState(false);
  const wrap = useRef<HTMLDivElement>(null);
  const menu = useRef<HTMLDivElement>(null);

  useFlipWhenNoRoom(open, menu, setDown);
  useDismissOnOutside(open, wrap, () => setOpen(false));

  // Na tlačítku se stopa zmenší, ať se do něj vejde i největší velikost.
  const nahled = Math.max(4, Math.round((size / max) * 22));

  return (
    <div className="tool-popover" ref={wrap}>
      <button
        type="button"
        className={`icon-btn${open ? " is-active" : ""}`}
        aria-label={t("tools.size")}
        aria-expanded={open}
        onClick={() => setOpen((o) => !o)}
      >
        <span
          className="size-preview-dot"
          aria-hidden="true"
          style={{ width: nahled, height: nahled, background: previewColor }}
        />
      </button>
      {open && (
        <div ref={menu} className={`tool-menu size-menu${down ? " tool-menu-down" : ""}`}>
          <span className="size-dot-min" aria-hidden="true" />
          {slider}
          <span className="size-dot-max" aria-hidden="true" />
        </div>
      )}
    </div>
  );
}

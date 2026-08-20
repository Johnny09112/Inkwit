"use client";

import { useEffect, useLayoutEffect, type RefObject } from "react";

/**
 * Zavře vyskakovací panel klepnutím mimo něj.
 *
 * Bez toho zůstane panel viset přes plátno a další tah spadne do něj.
 * Poslouchá se `pointerdown`, ne `click` — na dotyku se klepnutí do plátna
 * jako `click` nemusí vůbec objevit.
 */
export function useDismissOnOutside(
  open: boolean,
  wrap: RefObject<HTMLElement | null>,
  onClose: () => void,
): void {
  useEffect(() => {
    if (!open) return;
    const zavri = (e: PointerEvent) => {
      if (!wrap.current?.contains(e.target as Node)) onClose();
    };
    document.addEventListener("pointerdown", zavri);
    return () => document.removeEventListener("pointerdown", zavri);
  }, [open, wrap, onClose]);
}

/**
 * Panel se otevírá nad tlačítkem, protože lišta nástrojů je skoro vždycky
 * dole. Když nad ním místo není, překlopí se pod — jinak by vyjel mimo
 * obrazovku a nedalo by se na něj dosáhnout.
 *
 * Vrací `true`, když se má překlopit dolů.
 */
export function useFlipWhenNoRoom(
  open: boolean,
  menu: RefObject<HTMLElement | null>,
  setDown: (v: boolean) => void,
): void {
  useLayoutEffect(() => {
    if (!open) {
      setDown(false);
      return;
    }
    const r = menu.current?.getBoundingClientRect();
    if (r && r.top < 0) setDown(true);
    // setDown je stabilní setter ze useState; závislost na něm by jen šuměla.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, menu]);
}

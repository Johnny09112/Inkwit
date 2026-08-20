"use client";

import { useEffect, useState } from "react";

/**
 * Předvolby vzhledu, které patří zařízení, ne účtu.
 *
 * Vědomě v `localStorage`, ne v `profiles`: kreslicí ruka je vlastnost toho,
 * jak člověk drží konkrétní tablet, a sloupec v databázi by znamenal migraci,
 * RPC a test kvůli tomu, na které straně visí lišta. Když se ukáže, že to lidi
 * přenastavují na každém zařízení znovu, přesune se to do profilu.
 */

const HAND_KEY = "inkwit.hand";

export type Hand = "right" | "left";

export function readHand(): Hand {
  if (typeof window === "undefined") return "right";
  return window.localStorage.getItem(HAND_KEY) === "left" ? "left" : "right";
}

export function writeHand(hand: Hand) {
  window.localStorage.setItem(HAND_KEY, hand);
  window.dispatchEvent(new CustomEvent(HAND_KEY));
}

/**
 * Čte se až po připojení komponenty — na serveru localStorage není a rozdíl
 * mezi serverovým a klientským výstupem by React ohlásil jako chybu hydratace.
 * Do prvního renderu je proto vždycky pravá ruka.
 */
export function useHand(): Hand {
  const [hand, setHand] = useState<Hand>("right");

  useEffect(() => {
    const sync = () => setHand(readHand());
    sync();
    // Vlastní událost drží obrazovky v souladu ve stejné záložce,
    // `storage` mezi záložkami.
    window.addEventListener(HAND_KEY, sync);
    window.addEventListener("storage", sync);
    return () => {
      window.removeEventListener(HAND_KEY, sync);
      window.removeEventListener("storage", sync);
    };
  }, []);

  return hand;
}

const PALETTE_KEY = "inkwit.palette";

/**
 * Kolik vlastních barev se do palety vejde. Mřížka má 8 × 3 = 24 míst
 * a poslední drží tlačítko „přidat", takže barev je o jednu míň.
 */
export const PALETTE_MAX = 23;

/** Výchozí paleta, dokud si ji člověk nezmění. */
export const DEFAULT_PALETTE = [
  "#2B261F",
  "#6D6A64",
  "#FFFCF5",
  "#B5462F",
  "#C9756B",
  "#E9B44C",
  "#E4C98A",
  "#52633A",
  "#7E8F5F",
  "#3C6E8F",
  "#7BA3B8",
  "#8A5A8F",
  "#B892BC",
  "#8A6A4A",
  "#C4A484",
] as const;

const isHex = (v: unknown): v is string => typeof v === "string" && /^#[0-9A-F]{6}$/i.test(v);

export function readPalette(): string[] {
  if (typeof window === "undefined") return [...DEFAULT_PALETTE];
  try {
    const raw = window.localStorage.getItem(PALETTE_KEY);
    if (!raw) return [...DEFAULT_PALETTE];
    const parsed: unknown = JSON.parse(raw);
    // Obsah úložiště se dá přepsat z konzole, takže se mu nevěří — ze zkažené
    // palety by jinak spadla celá kreslicí obrazovka.
    if (!Array.isArray(parsed)) return [...DEFAULT_PALETTE];
    const colors = parsed.filter(isHex).map((c) => c.toUpperCase()).slice(0, PALETTE_MAX);
    return colors.length > 0 ? colors : [...DEFAULT_PALETTE];
  } catch {
    return [...DEFAULT_PALETTE];
  }
}

export function writePalette(colors: readonly string[]) {
  window.localStorage.setItem(PALETTE_KEY, JSON.stringify(colors.slice(0, PALETTE_MAX)));
  window.dispatchEvent(new CustomEvent(PALETTE_KEY));
}

/** Stejná pravidla hydratace jako u `useHand` — na serveru se čte výchozí paleta. */
export function usePalette(): [string[], (colors: readonly string[]) => void] {
  const [palette, setPalette] = useState<string[]>([...DEFAULT_PALETTE]);

  useEffect(() => {
    const sync = () => setPalette(readPalette());
    sync();
    window.addEventListener(PALETTE_KEY, sync);
    window.addEventListener("storage", sync);
    return () => {
      window.removeEventListener(PALETTE_KEY, sync);
      window.removeEventListener("storage", sync);
    };
  }, []);

  return [palette, writePalette];
}

/* ---------------------------------------------------------------------------
   Poslední viděný level
   ---------------------------------------------------------------------------
   Level roste na serveru, ale posun se hráč často dozví až později: bonus za
   uhodnutí připíše cizí tip ve chvíli, kdy je člověk jinde nebo vůbec v
   aplikaci není. Proto se nesleduje „právě proběhla akce", ale rozdíl proti
   tomu, co člověk naposledy viděl — gratulace ho pak zastihne při nejbližším
   otevření.

   Je to vlastnost zařízení, ne účtu: na druhém telefonu se oslava ukáže znovu
   a to je v pořádku. Sloupec v databázi kvůli tomu nestojí za migraci. */

const LEVEL_SEEN_KEY = "inkwit.levelSeen";

export interface LevelUp {
  from: number;
  to: number;
}

/**
 * Zapíše aktuální level a vrátí posun, jestli k němu došlo.
 *
 * **Poprvé nevrací nic** — jinak by nový účet dostal gratulaci k levelu 1,
 * který nikdy nepřekročil.
 */
export function takeLevelUp(level: number): LevelUp | null {
  if (typeof window === "undefined" || !Number.isFinite(level)) return null;

  const raw = window.localStorage.getItem(LEVEL_SEEN_KEY);
  const seen = raw === null ? null : Number.parseInt(raw, 10);

  if (seen === null || !Number.isFinite(seen)) {
    window.localStorage.setItem(LEVEL_SEEN_KEY, String(level));
    return null;
  }

  if (level <= seen) return null;

  window.localStorage.setItem(LEVEL_SEEN_KEY, String(level));
  return { from: seen, to: level };
}

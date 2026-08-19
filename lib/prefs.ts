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

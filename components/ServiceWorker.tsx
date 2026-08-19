"use client";

import { useEffect } from "react";

/**
 * Registrace service workeru. Až v prohlížeči a až po načtení — registrace
 * během startu by soutěžila o pásmo s tím, co uživatel chce vidět.
 */
export function ServiceWorker() {
  useEffect(() => {
    if (!("serviceWorker" in navigator)) return;
    const id = setTimeout(() => {
      navigator.serviceWorker.register("/sw.js").catch(() => {
        // Bez service workeru appka funguje dál, jen nejde nainstalovat.
      });
    }, 1200);
    return () => clearTimeout(id);
  }, []);
  return null;
}

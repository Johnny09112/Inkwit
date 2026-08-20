"use client";

import { useTranslations } from "next-intl";
import { AppShell } from "@/components/shell/AppShell";

/**
 * Kostra obrazovky pro `loading.tsx`.
 *
 * **Není to kosmetika, je to oprava zamrzlé navigace.** Bez hranice načítání
 * drží App Router starou obrazovku, dokud nemá payload té nové — klepneš na
 * záložku a 0,5 až 2 vteřiny se nestane vůbec nic, pak to skočí. Změřeno
 * z popisu majitele 2026-08-20.
 *
 * `loading.tsx` dá Nextu Suspense hranici, o kterou se může opřít: přepnutí
 * se potvrdí okamžitě a mezitím je vidět kostra. Vedlejší zisk je, že Next
 * umí tuhle hranici i přednačíst.
 *
 * Lištu si kreslí sama, protože `AppShell` sedí uvnitř jednotlivých stránek,
 * ne v layoutu — bez toho by při přepínání mizela navigace.
 */

interface ScreenSkeletonProps {
  /** Jmenný prostor překladů obrazovky. Každý z nich má klíč `title`. */
  ns: "pick" | "guess" | "mine" | "leaderboards" | "profile";
  /** Kolik obdélníků naznačit. Odpovídá tomu, co na obrazovce obvykle je. */
  rows?: number;
}

export function ScreenSkeleton({ ns, rows = 3 }: ScreenSkeletonProps) {
  const t = useTranslations(ns);
  const tCommon = useTranslations("common");

  return (
    <AppShell title={t("title")}>
      {/* Čtečce stačí jedna věta. Obdélníky jsou dekorace a hlásit je jako
          obsah by bylo horší než mlčet. */}
      <p className="visually-hidden" role="status">
        {tCommon("loading")}
      </p>
      <div className="skeleton-list" aria-hidden="true">
        {Array.from({ length: rows }, (_, i) => (
          <div key={i} className="skeleton-card" />
        ))}
      </div>
    </AppShell>
  );
}

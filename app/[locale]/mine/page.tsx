"use client";

import { useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { AppShell } from "@/components/shell/AppShell";
import { MY_COUNTS, MY_DRAWINGS, conceptById } from "@/lib/mock";

/**
 * Moje kresby (wireframe 7): autorovi se zobrazuje jen počet uhodnutí,
 * nikdy počet neuhodnutí. „Čeká na 1. uhodnutí" je notifikační háček.
 */

type Filter = "all" | "solved" | "waiting";

export default function MinePage() {
  const locale = useLocale() as "cs" | "en";
  const t = useTranslations("mine");
  const [filter, setFilter] = useState<Filter>("all");

  const items = MY_DRAWINGS.filter((d) => {
    if (filter === "solved") return d.solvedByCount > 0;
    if (filter === "waiting") return d.solvedByCount === 0;
    return true;
  });

  const filters: { key: Filter; label: string }[] = [
    { key: "all", label: t("filters.all", { n: MY_COUNTS.all }) },
    { key: "solved", label: t("filters.solved", { n: MY_COUNTS.solved }) },
    { key: "waiting", label: t("filters.waiting", { n: MY_COUNTS.waiting }) },
  ];

  return (
    <AppShell title={t("title")}>
      <div className="filter-chips">
        {filters.map((f) => (
          <button
            key={f.key}
            type="button"
            className="filter-chip"
            aria-pressed={filter === f.key}
            onClick={() => setFilter(f.key)}
          >
            {f.label}
          </button>
        ))}
      </div>
      <div className="mine-grid">
        {items.map((d) => {
          const concept = conceptById(d.conceptId);
          const meta =
            d.solvedByCount === 0
              ? t("waiting")
              : [
                  t("guessed", { count: d.solvedByCount }),
                  "★".repeat(d.stars),
                  d.thumbs > 0 ? t("thumbs", { count: d.thumbs }) : null,
                ]
                  .filter(Boolean)
                  .join(" · ");
          return (
            <div key={d.id} className="mine-item">
              <div className="hatch" />
              <div>
                <div className="mine-item-name">{concept.name[locale]}</div>
                <div className="mine-item-meta">{meta}</div>
              </div>
            </div>
          );
        })}
      </div>
    </AppShell>
  );
}

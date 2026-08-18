"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { Users } from "lucide-react";
import { AppShell } from "@/components/shell/AppShell";
import { LEADERBOARDS, LEAGUE } from "@/lib/mock";

/**
 * Žebříčky (wireframe 8): tři oddělené metriky (hvězdičky a palce jsou
 * v konfliktu), ligy po ~30 hráčích místo jednoho globálního žebříčku.
 */

type Tab = "guesser" | "drawer" | "popularity";

export default function LeaderboardsPage() {
  const t = useTranslations("leaderboards");
  const [tab, setTab] = useState<Tab>("guesser");

  const tabs: Tab[] = ["guesser", "drawer", "popularity"];
  const rows = LEADERBOARDS[tab];

  return (
    <AppShell title={t("title")}>
      <div className="lb-tabs" role="tablist">
        {tabs.map((key) => (
          <button
            key={key}
            type="button"
            role="tab"
            className="lb-tab"
            aria-pressed={tab === key}
            aria-selected={tab === key}
            onClick={() => setTab(key)}
          >
            {t(`tabs.${key}`)}
          </button>
        ))}
      </div>
      <div className="lb-league">
        <Users size={15} />
        <span className="t-label-sm">
          {t("league", {
            league: LEAGUE.league,
            players: LEAGUE.players,
            days: LEAGUE.endsInDays,
          })}
        </span>
      </div>
      <div className="lb-table">
        {rows.map((row) => (
          <div key={row.rank} className={`lb-row${row.isYou ? " is-you" : ""}`}>
            <span className="lb-rank">{row.rank}</span>
            <span className="lb-avatar" />
            <span className="lb-name">{row.isYou ? t("you") : row.name}</span>
            <span className="lb-score">{row.score}</span>
          </div>
        ))}
      </div>
    </AppShell>
  );
}

"use client";

import { Loader2, Trophy } from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { AppShell } from "@/components/shell/AppShell";
import { fetchLeaderboard, type LeaderboardRow } from "@/lib/game";

/**
 * Žebříček (wireframe 8).
 *
 * Fáze 0 má **jeden** denní žebříček, ne tři. Oddělené metriky, ligy a odznaky
 * jsou meta-vrstva nad chováním, které se teprve ověřuje (`docs/roadmap.md`).
 * Strop 30 hráčů odpovídá zamýšlené velikosti ligy.
 */
export default function LeaderboardsPage() {
  const t = useTranslations("leaderboards");
  const [rows, setRows] = useState<LeaderboardRow[] | null>(null);
  const [error, setError] = useState(false);

  useEffect(() => {
    fetchLeaderboard()
      .then(setRows)
      .catch(() => setError(true));
  }, []);

  return (
    <AppShell title={t("title")}>
      <div className="lb-league">
        <Trophy size={15} />
        <span className="t-label-sm">{t("today")}</span>
      </div>

      {error && <p className="auth-note auth-note-error">{t("loadFailed")}</p>}

      {!rows && !error && (
        <p className="pick-loading">
          <Loader2 size={18} className="spin" aria-hidden="true" /> {t("loading")}
        </p>
      )}

      {rows && rows.length === 0 && <p className="t-secondary">{t("empty")}</p>}

      {rows && rows.length > 0 && (
        <div className="lb-table">
          {rows.map((r) => (
            <div key={r.rank} className={`lb-row${r.isYou ? " is-you" : ""}`}>
              <span className="lb-rank">{r.rank}</span>
              <span className="lb-avatar" />
              <span className="lb-name">{r.isYou ? t("you") : r.displayName}</span>
              <span className="lb-score">{r.score}</span>
            </div>
          ))}
        </div>
      )}
    </AppShell>
  );
}

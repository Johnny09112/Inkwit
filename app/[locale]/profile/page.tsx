"use client";

import { useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import {
  Award,
  Bell,
  ChevronRight,
  Eye,
  Flame,
  Languages,
  Settings,
  Shield,
  ThumbsUp,
} from "lucide-react";
import { Link, usePathname, useRouter } from "@/i18n/navigation";
import { AppShell } from "@/components/shell/AppShell";
import { Card } from "@/components/ui";
import { PROFILE } from "@/lib/mock";

/**
 * Profil (wireframe 9): jazyk hádání je tady, ne v hlavičce.
 * Trust score se nezobrazuje nikde a v žádné podobě (pravidlo 7).
 */

const EARNED_BADGES = [Award, Flame, Eye, ThumbsUp];

export default function ProfilePage() {
  const t = useTranslations("profile");
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();
  const [notifications, setNotifications] = useState(true);

  const emptyCount = PROFILE.badgesTotal - PROFILE.badgesEarned - 4;

  const switchLocale = () => {
    router.replace(pathname, { locale: locale === "cs" ? "en" : "cs" });
  };

  return (
    <AppShell
      title={t("title")}
      headerAction={
        <Link
          href="/profile"
          aria-label={t("settings")}
          className="icon-btn icon-btn-plain"
          style={{ width: 34, height: 34 }}
        >
          <Settings size={20} />
        </Link>
      }
    >
      <Card elevated={false} className="profile-card">
        <span className="profile-avatar" />
        <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
          <span className="profile-name">{PROFILE.name}</span>
          <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
            {t("meta", {
              level: PROFILE.level,
              drawings: PROFILE.drawings,
              guesses: PROFILE.guesses,
            })}
          </span>
        </div>
      </Card>

      <div style={{ paddingTop: 14 }}>
        <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
          {t("badges", {
            earned: PROFILE.badgesEarned,
            total: PROFILE.badgesTotal,
          })}
        </span>
      </div>
      <div className="badges-grid">
        {EARNED_BADGES.map((Icon, i) => (
          <div key={`earned-${i}`} className="badge-tile">
            <Icon size={22} />
          </div>
        ))}
        {Array.from({ length: Math.max(4, emptyCount) }, (_, i) => (
          <div key={`empty-${i}`} className="badge-tile is-empty" />
        ))}
      </div>

      <div className="settings-list">
        <button type="button" className="settings-row" onClick={switchLocale}>
          <Languages size={18} />
          <span className="settings-row-label">{t("language")}</span>
          <span className="settings-row-value">{locale.toUpperCase()}</span>
          <ChevronRight size={16} />
        </button>
        <div className="settings-row">
          <Bell size={18} />
          <span className="settings-row-label">{t("notifications")}</span>
          <button
            type="button"
            className="toggle"
            role="switch"
            aria-checked={notifications}
            aria-label={t("notifications")}
            onClick={() => setNotifications((n) => !n)}
          >
            <span className="toggle-knob" />
          </button>
        </div>
        <div className="settings-row">
          <Shield size={18} />
          <span className="settings-row-label">{t("account")}</span>
          <ChevronRight size={16} />
        </div>
      </div>
    </AppShell>
  );
}

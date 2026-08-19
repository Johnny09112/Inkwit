"use client";

import { Bell, Hand, Languages, Loader2, ThumbsUp, Trophy } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { SignOutRow } from "@/components/auth/SignOutRow";
import { AppShell } from "@/components/shell/AppShell";
import { usePathname, useRouter } from "@/i18n/navigation";
import {
  fetchNotifications,
  fetchProfile,
  markNotificationsRead,
  type Notification,
  type Profile,
} from "@/lib/game";

/**
 * Profil (wireframe 9) a schránka upozornění.
 *
 * Upozornění tu nejsou jako doplněk — **nesou hlavní retenční hypotézu fáze 0**
 * (`_claude/memory/decisions/retence-bez-sdilene-serie.md`). „Tvoji chobotnici
 * uhodli 4 lidé" je ta rychlá emoční odměna, kterou `docs/product.md` označuje
 * za povinnou.
 */
export default function ProfilePage() {
  const t = useTranslations("profile");
  const tNotif = useTranslations("notifications");
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();

  const [profile, setProfile] = useState<Profile | null>(null);
  const [items, setItems] = useState<Notification[] | null>(null);

  useEffect(() => {
    fetchProfile().then(setProfile).catch(() => setProfile(null));
    fetchNotifications()
      .then((n) => {
        setItems(n);
        if (n.some((x) => !x.readAt)) void markNotificationsRead();
      })
      .catch(() => setItems([]));
  }, []);

  function line(n: Notification): string {
    const who = n.actorName ?? tNotif("someone");
    const what = n.prompt ?? tNotif("yourDrawing");
    switch (n.kind) {
      case "guessed":
        return tNotif("guessed", { name: who, concept: what });
      case "thumbed":
        return tNotif("thumbed", { name: who });
      case "request_filled":
        return tNotif("requestFilled", { name: who, concept: what });
      case "request_served":
        return tNotif("requestServed", { name: who, concept: what });
    }
  }

  const icon = (kind: Notification["kind"]) =>
    kind === "thumbed" ? <ThumbsUp size={16} /> : kind === "guessed" ? <Trophy size={16} /> : <Hand size={16} />;

  return (
    <AppShell title={t("title")}>
      <div className="card profile-card">
        <div className="profile-avatar" />
        <div>
          <div className="profile-name">{profile?.displayName ?? "…"}</div>
          <div className="t-label" style={{ textTransform: "none" }}>
            {profile
              ? t("counts", { drawings: profile.drawings, guesses: profile.guesses })
              : ""}
          </div>
        </div>
      </div>

      <section className="notif-section">
        <span className="lbl">
          <Bell size={12} style={{ verticalAlign: "-1px" }} /> {t("notifications")}
        </span>

        {!items && (
          <p className="pick-loading">
            <Loader2 size={16} className="spin" aria-hidden="true" /> {tNotif("loading")}
          </p>
        )}

        {items && items.length === 0 && <p className="t-secondary">{tNotif("empty")}</p>}

        {items && items.length > 0 && (
          <ul className="notif-list">
            {items.map((n) => (
              <li key={n.id} className={`notif${n.readAt ? "" : " is-new"}`}>
                <span className="notif-icon">{icon(n.kind)}</span>
                <span>{line(n)}</span>
              </li>
            ))}
          </ul>
        )}
      </section>

      <div className="settings-list">
        <button
          type="button"
          className="settings-row"
          onClick={() => router.replace(pathname, { locale: locale === "cs" ? "en" : "cs" })}
        >
          <Languages size={18} />
          <span className="settings-row-label">{t("language")}</span>
          <span className="settings-row-value">{locale.toUpperCase()}</span>
        </button>
        <SignOutRow />
      </div>
    </AppShell>
  );
}

"use client";

import { Bell, Hand, Languages, Loader2, PenTool, ShieldCheck, ThumbsUp, Trophy } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { SignOutRow } from "@/components/auth/SignOutRow";
import { LevelRoadmap } from "@/components/LevelRoadmap";
import { AppShell } from "@/components/shell/AppShell";
import { Link, usePathname, useRouter } from "@/i18n/navigation";
import {
  fetchNotifications,
  fetchProfile,
  fetchRewards,
  markNotificationsRead,
  type Notification,
  type Profile,
} from "@/lib/game";
import { amIAdmin } from "@/lib/admin";
import { useHand, writeHand } from "@/lib/prefs";

/**
 * Profil (wireframe 9) a schránka upozornění.
 *
 * Upozornění tu nejsou jako doplněk — **nesou hlavní retenční hypotézu fáze 0**
 * (`_claude/memory/decisions/retence-bez-sdilene-serie.md`). „Tvoji chobotnici
 * uhodli 4 lidé" je ta rychlá emoční odměna, kterou `docs/product.md` označuje
 * za povinnou.
 */
/**
 * Kolik procent pásma aktuálního levelu má člověk za sebou.
 * Bez pásma by pruh porovnával celkové kredity s prahem dalšího levelu
 * a byl by skoro plný pořád.
 */
function bandProgress(lifetime: number, level: number, thresholds: number[]): number {
  const od = thresholds[level - 1] ?? 0;
  const do_ = thresholds[level];
  if (do_ === undefined || do_ <= od) return 100;
  return Math.min(100, Math.max(0, Math.round(((lifetime - od) / (do_ - od)) * 100)));
}

export default function ProfilePage() {
  const t = useTranslations("profile");
  const tNotif = useTranslations("notifications");
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();
  const hand = useHand();
  // Odkaz na správu vidí jen správce. Je to jen skrytí odkazu — oprávnění
  // si hlídá každá serverová funkce sama, adresu by šlo uhodnout.
  const [admin, setAdmin] = useState(false);

  const [profile, setProfile] = useState<Profile | null>(null);
  const [items, setItems] = useState<Notification[] | null>(null);
  /**
   * Prahy a odemykací levely. Roadmapa je čte ze serveru, ne z konstant —
   * balanc je serverová konfigurace (pravidlo 6) a natvrdo napsaná roadmapa
   * by po první změně balancu lhala.
   */
  const [economy, setEconomy] = useState<Awaited<ReturnType<typeof fetchRewards>> | null>(null);

  useEffect(() => {
    fetchProfile().then(setProfile).catch(() => setProfile(null));
    fetchRewards().then(setEconomy).catch(() => setEconomy(null));
    amIAdmin().then(setAdmin);
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
          {profile && (
            <div className="profile-level">
              <span className="profile-level-badge">
                {t("level", { n: profile.level })}
              </span>
              <span className="profile-credits">{t("credits", { n: profile.credits })}</span>
            </div>
          )}
        </div>
      </div>

      {profile && economy && profile.nextLevelAt !== null && (
        <div className="level-progress">
          <div className="level-progress-bar">
            {/* Postup se počítá UVNITŘ pásma levelu, ne z celkových kreditů.
                Do 2026-08-20 to byl podíl `lifetime / nextLevelAt`, takže na
                18 kreditech z pásma 10–25 ukazoval pruh 72 % místo 53 % —
                pořád skoro plný, ať byl člověk kdekoli. */}
            <div
              className="level-progress-fill"
              style={{ width: `${bandProgress(profile.lifetime, profile.level, economy.thresholds)}%` }}
            />
          </div>
          <span className="t-label-sm">
            {t("toNextLevel", { n: profile.nextLevelAt - profile.lifetime })}
          </span>
        </div>
      )}

      {profile && economy && (
        <LevelRoadmap
          level={profile.level}
          lifetime={profile.lifetime}
          thresholds={economy.thresholds}
          paletteFullLevel={economy.paletteFullLevel}
          mixerLevel={economy.mixerLevel}
          shapesLevel={economy.shapesLevel}
        />
      )}

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
        <button
          type="button"
          className="settings-row"
          onClick={() => writeHand(hand === "left" ? "right" : "left")}
        >
          <PenTool size={18} />
          <span className="settings-row-label">{t("handedness")}</span>
          <span className="settings-row-value">
            {hand === "left" ? t("handLeft") : t("handRight")}
          </span>
        </button>
        {admin && (
          <Link href="/admin" className="settings-row">
            <ShieldCheck size={18} />
            <span className="settings-row-label">Správa</span>
          </Link>
        )}
        <SignOutRow />
      </div>
    </AppShell>
  );
}

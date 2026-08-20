"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { Palette, Pencil, Pipette, Shapes, Sparkles } from "lucide-react";
import { Button } from "@/components/ui";
import { fetchRewards } from "@/lib/game";
import { takeLevelUp, type LevelUp as LevelUpEvent } from "@/lib/prefs";
import { unlocksBetween, type UnlockConfig, type UnlockKey } from "@/lib/unlocks";

/**
 * Oslava postupu na další level.
 *
 * **Kdy vyskočí.** Ne po konkrétní akci, ale při každém načtení profilu, které
 * ukáže vyšší level, než jaký člověk naposledy viděl. Důvod: bonus za uhodnutí
 * připíše cizí tip ve chvíli, kdy je autor jinde. Kdyby se oslava vázala na
 * akci, tenhle — nejhezčí — posun by se nikdy neukázal.
 *
 * Konfigurace se stahuje **až ve chvíli, kdy je co slavit**. Obrazovky, které
 * gratulaci hostí, tím neplatí request navíc při každém otevření.
 */

const IKONY: Record<UnlockKey, typeof Pencil> = {
  core: Pencil,
  palette: Palette,
  mixer: Pipette,
  shapes: Shapes,
};

/** Girlandy. Deterministické, ať se při překreslení nepřeskládají. */
const GIRLANDY = Array.from({ length: 14 }, (_, i) => ({
  left: 4 + ((i * 97) % 92),
  delay: (i * 61) % 420,
  duration: 900 + ((i * 53) % 400),
  drift: ((i * 37) % 60) - 30,
  tone: ["a", "b", "c", "d"][i % 4],
}));

export function LevelUpGate({ level }: { level?: number | null }) {
  const [event, setEvent] = useState<LevelUpEvent | null>(null);
  const [cfg, setCfg] = useState<UnlockConfig | null>(null);

  useEffect(() => {
    if (typeof level !== "number") return;
    const posun = takeLevelUp(level);
    if (!posun) return;
    setEvent(posun);
    // Když se konfigurace nenačte, gratulace pořád dává smysl — jen bez výčtu.
    fetchRewards().then(setCfg).catch(() => setCfg(null));
  }, [level]);

  if (!event) return null;
  return <LevelUpCelebration event={event} cfg={cfg} onClose={() => setEvent(null)} />;
}

export function LevelUpCelebration({
  event,
  cfg,
  onClose,
}: {
  event: LevelUpEvent;
  cfg: UnlockConfig | null;
  onClose: () => void;
}) {
  const t = useTranslations("levelUp");
  const nove = cfg ? unlocksBetween(event.from, event.to, cfg) : [];

  return (
    <div className="levelup" role="dialog" aria-modal="true" aria-label={t("title", { n: event.to })} onClick={onClose}>
      <div className="levelup-confetti" aria-hidden="true">
        {GIRLANDY.map((g, i) => (
          <span
            key={i}
            className={`levelup-flake tone-${g.tone}`}
            style={{
              left: `${g.left}%`,
              animationDelay: `${g.delay}ms`,
              animationDuration: `${g.duration}ms`,
              // Vlastní posun do strany — bez něj padá všechno svisle jako déšť.
              ["--drift" as string]: `${g.drift}px`,
            }}
          />
        ))}
      </div>

      <div className="levelup-card" onClick={(e) => e.stopPropagation()}>
        <span className="levelup-medal" aria-hidden="true">
          <span className="levelup-medal-n">{event.to}</span>
          <Sparkles className="levelup-medal-spark" size={18} />
        </span>

        <p className="levelup-kicker">{t("kicker")}</p>
        <h2 className="levelup-title">{t("title", { n: event.to })}</h2>

        {nove.length > 0 && (
          <>
            <p className="levelup-lede">{t("opened")}</p>
            <ul className="levelup-unlocks">
              {nove.map((u) => {
                const Ikona = IKONY[u.key];
                return (
                  <li key={u.key}>
                    <Ikona size={17} aria-hidden="true" />
                    <span>{t(`unlocks.${u.key}`)}</span>
                  </li>
                );
              })}
            </ul>
          </>
        )}

        {cfg && nove.length === 0 && <p className="levelup-lede">{t("nothingYet")}</p>}

        <Button size="lg" onClick={onClose}>
          {t("ok")}
        </Button>
      </div>
    </div>
  );
}

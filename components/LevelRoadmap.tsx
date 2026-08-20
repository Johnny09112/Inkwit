"use client";

import { Check, Lock, Palette, Pencil, Pipette, Shapes } from "lucide-react";
import { useTranslations } from "next-intl";
import { allUnlocks, type UnlockKey } from "@/lib/unlocks";

/**
 * Cesta levely — co je otevřené, co přijde a za kolik.
 *
 * **Čte z konfigurace, ne z konstant v kódu.** Prahy i to, na kterém levelu se
 * co odemyká, žijí v `game_config` (pravidlo 6: balanc je serverová
 * konfigurace, ne konstanty). Kdyby se roadmapa napsala natvrdo, po první
 * změně balancu by lhala — a lhoucí roadmapa je horší než žádná.
 *
 * Když má nějaký level práh, ale nic se na něm neodemyká, **řekne se to**.
 * Prázdný level je horší než žádný (viz `decisions/levely-bez-gati-na-jadro.md`)
 * a tohle je jediné místo, kde je to vidět na první pohled.
 *
 * Barvy uzlů schválně NEJSOU bronz/stříbro/zlato — ty patří obtížnostem
 * a znamenaly by tu něco jiného.
 */

const IKONY: Record<UnlockKey, typeof Pencil> = {
  core: Pencil,
  palette: Palette,
  mixer: Pipette,
  shapes: Shapes,
};

interface LevelRoadmapProps {
  /** Aktuální level hráče. */
  level: number;
  /** Celkem vydělané kredity — z nich se počítá postup. */
  lifetime: number;
  /** Prahy z `game_config`; index 0 = level 1. */
  thresholds: number[];
  paletteFullLevel: number;
  mixerLevel: number;
  shapesLevel: number;
}

export function LevelRoadmap({
  level,
  lifetime,
  thresholds,
  paletteFullLevel,
  mixerLevel,
  shapesLevel,
}: LevelRoadmapProps) {
  const t = useTranslations("roadmap");

  if (thresholds.length === 0) return null;

  // Seznam je sdílený s oslavou postupu — dva seznamy by se rozešly a hráč
  // by dostal gratulaci k něčemu, co v roadmapě nestojí.
  const odemceni = allUnlocks({ paletteFullLevel, mixerLevel, shapesLevel });

  return (
    <section className="roadmap">
      <span className="lbl">{t("title")}</span>
      <ol className="roadmap-list">
        {thresholds.map((prah, i) => {
          const n = i + 1;
          const stav = n < level ? "is-done" : n === level ? "is-current" : "is-locked";
          const zde = odemceni.filter((u) => u.level === n);
          // Kolik chybí do DALŠÍHO patra, ne do tohohle — na aktuální level
          // už člověk dosáhl, takže rozdíl proti jeho prahu je nula.
          const dalsiPrah = thresholds[i + 1];
          const zbyva = dalsiPrah === undefined ? 0 : Math.max(0, dalsiPrah - lifetime);

          return (
            <li key={n} className={`roadmap-step ${stav}`}>
              <span className="roadmap-node" aria-hidden="true">
                {stav === "is-done" ? <Check size={15} /> : stav === "is-locked" ? <Lock size={14} /> : n}
              </span>

              <div className="roadmap-body">
                <div className="roadmap-head">
                  <span className="roadmap-level">{t("level", { n })}</span>
                  <span className="roadmap-cost">
                    {prah === 0 ? t("fromStart") : t("cost", { n: prah })}
                  </span>
                </div>

                {zde.length === 0 && <p className="roadmap-empty">{t("empty")}</p>}

                {zde.map((u) => {
                  const Ikona = IKONY[u.key];
                  return (
                    <p key={u.key} className="roadmap-unlock">
                      <Ikona size={15} aria-hidden="true" />
                      <span>{t(`unlocks.${u.key}`)}</span>
                    </p>
                  );
                })}

                {stav === "is-current" && zbyva > 0 && (
                  <span className="roadmap-remaining">{t("remaining", { n: zbyva })}</span>
                )}
              </div>
            </li>
          );
        })}
      </ol>
      <p className="roadmap-note">{t("note")}</p>
    </section>
  );
}

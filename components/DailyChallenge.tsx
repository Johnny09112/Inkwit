"use client";

import { Check, Circle, Lightbulb, Pencil } from "lucide-react";
import { useTranslations } from "next-intl";
import { Badge, difficultyTone } from "@/components/ui";
import type { DailyChallenge as Stav } from "@/lib/game";

/**
 * Denní výzva: nakresli jednu těžkou a uhodni jednu těžkou, tentýž den.
 *
 * **Výzva je obtížnost, ne konkrétní slovo.** Společný pojem dne by zněl
 * lákavě, ale prozradil by odpověď všem hádajícím — zadání konceptu je
 * tajemství hry. Takhle zůstane rituál i tajemství.
 *
 * Karta neukazuje, KTERÝ pojem to má být. Jen že má být těžký.
 */

interface DailyChallengeProps {
  stav: Stav;
}

export function DailyChallenge({ stav }: DailyChallengeProps) {
  const t = useTranslations("daily");
  const tDifficulty = useTranslations("difficulty");
  const hotovo = stav.awarded;

  const ukol = (splneno: boolean, Ikona: typeof Pencil, text: string) => (
    <li className={splneno ? "is-done" : undefined}>
      <span className="daily-mark" aria-hidden="true">
        {splneno ? <Check size={14} /> : <Circle size={9} />}
      </span>
      <Ikona size={15} aria-hidden="true" />
      <span>{text}</span>
    </li>
  );

  return (
    <section className={`daily${hotovo ? " is-done" : ""}`} aria-label={t("title")}>
      <div className="daily-head">
        <span className="lbl">{t("title")}</span>
        <Badge tone={difficultyTone(stav.difficulty)}>
          {tDifficulty(String(stav.difficulty))}
        </Badge>
      </div>

      <ul className="daily-tasks">
        {ukol(stav.drawn, Pencil, t("draw"))}
        {ukol(stav.guessed, Lightbulb, t("guess"))}
      </ul>

      <p className="daily-prize">
        {hotovo ? t("done", { n: stav.bonus }) : t("prize", { n: stav.bonus })}
      </p>
    </section>
  );
}

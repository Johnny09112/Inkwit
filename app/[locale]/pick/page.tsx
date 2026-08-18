"use client";

import { useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { ChevronRight, Hand } from "lucide-react";
import { useRouter } from "@/i18n/navigation";
import { AppShell } from "@/components/shell/AppShell";
import { Button } from "@/components/ui";
import { CONCEPTS, REQUESTS, conceptById } from "@/lib/mock";

/**
 * Výběr pojmu (wireframe 6): tři obtížnosti jako ventil pro slabé
 * kreslíře, vyžádaný pojem od konkrétního člověka jako silnější motivace.
 */

export default function PickPage() {
  const locale = useLocale() as "cs" | "en";
  const t = useTranslations("pick");
  const tCommon = useTranslations("common");
  const tDifficulty = useTranslations("difficulty");
  const router = useRouter();

  const offer = CONCEPTS.slice(0, 3);
  const [selected, setSelected] = useState(offer[0].id);
  const request = REQUESTS[0];

  return (
    <AppShell title={t("title")}>
      <div className="pick-list">
        {offer.map((concept) => (
          <button
            key={concept.id}
            type="button"
            className="pick-card"
            aria-pressed={selected === concept.id}
            onClick={() => setSelected(concept.id)}
          >
            <span className="pick-card-meta">
              <span className="pick-card-name">{concept.name[locale]}</span>
              <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
                {tDifficulty(String(concept.difficulty))} ·{" "}
                {tCommon("credit", { n: concept.credit })}
              </span>
            </span>
            <ChevronRight size={22} />
          </button>
        ))}

        <div className="pick-requested">
          <Hand size={16} />
          <span className="t-label-sm">
            {t("requested", {
              name: request.requester,
              concept: conceptById(request.conceptId).name[locale],
            })}
          </span>
        </div>

        <Button size="lg" onClick={() => router.push(`/draw?concept=${selected}`)}>
          {t("cta")}
        </Button>
      </div>
    </AppShell>
  );
}

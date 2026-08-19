"use client";

import { ChevronRight, Hand, Loader2 } from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { AppShell } from "@/components/shell/AppShell";
import { Badge, Button } from "@/components/ui";
import { useRouter } from "@/i18n/navigation";
import { fetchOffer, startDrawing, type ConceptOffer } from "@/lib/game";

/**
 * Výběr pojmu (wireframe 6). Tři obtížnosti jako ventil pro slabé kreslíře,
 * vyžádaný pojem od konkrétního člověka jako silnější motivace než body.
 *
 * Nabídku skládá server — koncepty jsou pro klienta zavřené, protože zadání
 * je zároveň odpověď.
 */
export default function PickPage() {
  const t = useTranslations("pick");
  const tCommon = useTranslations("common");
  const tDifficulty = useTranslations("difficulty");
  const router = useRouter();

  const [offer, setOffer] = useState<ConceptOffer[] | null>(null);
  const [selected, setSelected] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [starting, setStarting] = useState(false);

  useEffect(() => {
    let alive = true;
    fetchOffer()
      .then((rows) => {
        if (!alive) return;
        setOffer(rows);
        setSelected(rows[0]?.conceptId ?? null);
      })
      .catch(() => alive && setError(t("loadFailed")));
    return () => {
      alive = false;
    };
  }, [t]);

  /**
   * Kresbu zakládáme tady, ne až při odeslání — od téhle chvíle běží serverové
   * měření doby kreslení a vzniká událost „začal kreslit".
   */
  async function begin() {
    if (!selected) return;
    setStarting(true);
    setError(null);
    try {
      const drawingId = await startDrawing(selected);
      router.push(`/draw?d=${drawingId}`);
    } catch {
      setError(t("startFailed"));
      setStarting(false);
    }
  }

  if (error && !offer) {
    return (
      <AppShell title={t("title")}>
        <p className="auth-note auth-note-error">{error}</p>
      </AppShell>
    );
  }

  if (!offer) {
    return (
      <AppShell title={t("title")}>
        <p className="pick-loading">
          <Loader2 size={18} className="spin" aria-hidden="true" /> {t("loading")}
        </p>
      </AppShell>
    );
  }

  const requested = offer.find((c) => c.requestedBy);

  return (
    <AppShell title={t("title")}>
      <div className="pick-list">
        {offer.map((concept) => (
          <button
            key={concept.conceptId}
            type="button"
            className="pick-card"
            aria-pressed={selected === concept.conceptId}
            onClick={() => setSelected(concept.conceptId)}
          >
            <span className="pick-card-meta">
              <span className="pick-card-name">{concept.prompt}</span>
              {/* Stejný zlatý štítek jako nad plátnem — obtížnost má vypadat
                  na obou obrazovkách stejně, ať ji člověk pozná bez čtení. */}
              <span className="pick-card-tags">
                <Badge tone="accent">{tDifficulty(String(concept.difficulty))}</Badge>
                <span className="t-label-sm">
                  {tCommon("credit", { n: concept.difficulty })}
                </span>
              </span>
            </span>
            <ChevronRight size={22} />
          </button>
        ))}

        {requested && (
          <div className="pick-requested">
            <Hand size={16} />
            <span className="t-label-sm">
              {t("requested", {
                name: requested.requestedBy as string,
                concept: requested.prompt,
              })}
            </span>
          </div>
        )}

        {error && (
          <p className="auth-note auth-note-error" role="alert">
            {error}
          </p>
        )}

        <Button size="lg" onClick={begin} disabled={starting || !selected}>
          {starting && <Loader2 size={17} className="spin" aria-hidden="true" />}
          {t("cta")}
        </Button>
      </div>
    </AppShell>
  );
}

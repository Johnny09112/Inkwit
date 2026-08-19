"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { Play, Trash2, TriangleAlert, X } from "lucide-react";
import { Button } from "@/components/ui";
import { Stars } from "@/components/Stars";
import { StrokePlayback } from "@/components/StrokePlayback";
import type { MyDrawing } from "@/lib/game";
import type { Stroke } from "@/lib/strokes";

/**
 * Detail vlastní kresby — zvětšení, přehrání a čísla k ní.
 *
 * **Počet tipů tu vědomě není a nedá se sem dostat.** Z rozdílu proti počtu
 * uhodnutí by autor odvodil, kolikrát ho lidé neuhodli, a to se mu podle
 * `docs/product.md` nezobrazuje. Server ho neposílá — tahle komponenta
 * pracuje jen s tím, co `my_drawings()` vydá.
 *
 * Přehrání je tady bez A/B skupiny: test z kroku F4 měří, jestli přehrání
 * pomáhá HÁDAJÍCÍMU. Nad vlastní kresbou nemá co měřit.
 */
export function DrawingDetail({
  drawing,
  strokes,
  onClose,
  onDelete,
}: {
  drawing: MyDrawing;
  strokes: readonly Stroke[] | undefined;
  onClose: () => void;
  onDelete: (drawingId: string) => Promise<boolean>;
}) {
  const t = useTranslations("mine");
  const tCommon = useTranslations("common");
  const format = useFormatter();

  const [playing, setPlaying] = useState(false);
  const [confirming, setConfirming] = useState(false);
  const [busy, setBusy] = useState(false);
  const [failed, setFailed] = useState(false);

  async function remove() {
    setBusy(true);
    setFailed(false);
    const ok = await onDelete(drawing.drawingId).catch(() => false);
    if (ok) return; // zavře rodič, až kresbu vyhodí ze seznamu
    setBusy(false);
    setFailed(true);
    setConfirming(false);
  }

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div
        className="modal detail-modal"
        role="dialog"
        aria-modal="true"
        aria-label={t("detailTitle")}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="detail-head">
          <h2 className="modal-title">{drawing.prompt}</h2>
          <button type="button" className="icon-btn icon-btn-plain" aria-label={tCommon("close")} onClick={onClose}>
            <X size={20} />
          </button>
        </div>

        <div className="detail-art">
          <StrokePlayback
            strokes={strokes ?? []}
            aspect={drawing.aspect}
            playing={playing}
            onEnd={() => setPlaying(false)}
          />
        </div>

        <dl className="detail-stats">
          <div>
            <dt>{t("statSolved")}</dt>
            <dd>{drawing.solvedCount}</dd>
          </div>
          <div>
            <dt>{t("statThumbs")}</dt>
            <dd>{drawing.thumbsCount}</dd>
          </div>
          <div>
            <dt>{t("stars")}</dt>
            <dd>
              {drawing.stars > 0 ? (
                <Stars
                  count={drawing.stars}
                  size={18}
                  label={t("starsOf", { n: drawing.stars })}
                />
              ) : (
                t("noStars")
              )}
            </dd>
          </div>
          <div>
            <dt>{t("drawnAt")}</dt>
            {/* Formát se předává rovnou — pojmenované formáty by musely být
                v konfiguraci next-intl, a jinak se datum vypíše syrově. */}
            <dd>
              {format.dateTime(new Date(drawing.createdAt), {
                day: "numeric",
                month: "numeric",
                year: "numeric",
                hour: "2-digit",
                minute: "2-digit",
              })}
            </dd>
          </div>
        </dl>

        {failed && (
          <p className="auth-note auth-note-error" role="alert">
            {t("deleteFailed")}
          </p>
        )}

        {confirming ? (
          <div className="detail-danger">
            <p className="t-secondary" style={{ fontSize: "var(--text-body-sm)" }}>
              <TriangleAlert size={15} aria-hidden="true" /> {t("deleteNote")}
            </p>
            <div className="modal-actions">
              <Button variant="secondary" size="lg" onClick={() => setConfirming(false)} disabled={busy}>
                {t("cancel")}
              </Button>
              <Button size="lg" onClick={remove} disabled={busy}>
                {t("deleteConfirm")}
              </Button>
            </div>
          </div>
        ) : (
          <div className="detail-actions">
            <Button
              variant="secondary"
              size="lg"
              disabled={playing || !strokes?.length}
              onClick={() => setPlaying(true)}
            >
              <Play size={18} aria-hidden="true" /> {t("play")}
            </Button>
            <button type="button" className="detail-delete" onClick={() => setConfirming(true)}>
              <Trash2 size={16} aria-hidden="true" /> {t("delete")}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

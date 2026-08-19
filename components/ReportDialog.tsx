"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { Button } from "@/components/ui";

/**
 * Nahlášení kresby s důvodem.
 *
 * Do teď se posílal natvrdo pořád stejný řetězec „nevhodný obsah", takže se
 * hlášení sice uložilo, ale k moderaci bylo k ničemu — nešlo poznat, jestli jde
 * o čmáranici, nebo o něco, co musí zmizet hned.
 *
 * Ukládá se **kód**, ne přeložená věta: moderace se dělá ze Supabase studia
 * a nemá cenu tam mít půl hlášení česky a půl anglicky.
 */

/** Pořadí je i pořadím v nabídce — od nejčastějšího po nejzávažnější. */
export const REPORT_REASONS = ["scribble", "mismatch", "text", "offensive", "other"] as const;

export type ReportReason = (typeof REPORT_REASONS)[number];

/** Volný text u „jiné" — víc se do moderace stejně nevejde. */
const NOTE_MAX = 200;

export function ReportDialog({
  onClose,
  onSubmit,
}: {
  onClose: () => void;
  onSubmit: (reason: string) => Promise<void>;
}) {
  const t = useTranslations("report");
  const [reason, setReason] = useState<ReportReason>("scribble");
  const [note, setNote] = useState("");
  const [busy, setBusy] = useState(false);

  const needsNote = reason === "other";
  const canSend = !busy && (!needsNote || note.trim().length > 0);

  async function send() {
    if (!canSend) return;
    setBusy(true);
    // Kód nese strojově čitelnou příčinu, poznámka jde za dvojtečku.
    const payload = needsNote ? `other: ${note.trim().slice(0, NOTE_MAX)}` : reason;
    await onSubmit(payload);
  }

  return (
    <div className="modal-backdrop" onClick={busy ? undefined : onClose}>
      <div
        className="modal"
        role="dialog"
        aria-modal="true"
        aria-label={t("title")}
        onClick={(e) => e.stopPropagation()}
      >
        <h2 className="modal-title">{t("title")}</h2>
        <p className="t-secondary" style={{ fontSize: "var(--text-body-sm)" }}>
          {t("lede")}
        </p>

        <div className="report-reasons">
          {REPORT_REASONS.map((key) => (
            <label key={key} className={`report-reason${reason === key ? " is-active" : ""}`}>
              <input
                type="radio"
                name="report-reason"
                value={key}
                checked={reason === key}
                onChange={() => setReason(key)}
              />
              <span>{t(`reasons.${key}`)}</span>
            </label>
          ))}
        </div>

        {needsNote && (
          <label className="report-note">
            <span className="t-label-sm">{t("noteLabel")}</span>
            <textarea
              className="input"
              rows={3}
              maxLength={NOTE_MAX}
              value={note}
              autoFocus
              placeholder={t("notePlaceholder")}
              onChange={(e) => setNote(e.target.value)}
            />
          </label>
        )}

        <div className="modal-actions">
          <Button size="lg" onClick={send} disabled={!canSend}>
            {t("send")}
          </Button>
          <Button variant="secondary" size="lg" onClick={onClose} disabled={busy}>
            {t("cancel")}
          </Button>
        </div>
      </div>
    </div>
  );
}

"use client";

import {
  Flag,
  Inbox,
  Loader2,
  Pencil,
  Play,
  SkipForward,
  ThumbsUp,
} from "lucide-react";
import { useTranslations } from "next-intl";
import { useCallback, useEffect, useState } from "react";
import { AppShell } from "@/components/shell/AppShell";
import { StrokePlayback } from "@/components/StrokePlayback";
import { Button } from "@/components/ui";
import { Link } from "@/i18n/navigation";
import {
  fetchNextDrawing,
  giveThumb,
  submitGuess,
  type FeedDrawing,
  type GuessResult,
} from "@/lib/game";

/**
 * Hádání (wireframy 3, 4, 5, 10).
 *
 * Hádá se nad **hotovým obrázkem** — kresba se nevykresluje postupně.
 * Přehrání tah po tahu je tlačítko a odměna po uhodnutí (`CLAUDE.md`).
 * Prázdný feed není chyba, ale stav „došla zásoba".
 *
 * Správnost tipu vyhodnocuje server. Klient odpověď nezná a dozví se ji až
 * po uhodnutí nebo vyčerpání pokusů.
 */

type Phase = "guessing" | "solved" | "failed";

export default function GuessPage() {
  const t = useTranslations("guess");
  const tSolved = useTranslations("solved");
  const tEmpty = useTranslations("empty");

  const [drawing, setDrawing] = useState<FeedDrawing | null | undefined>(undefined);
  const [phase, setPhase] = useState<Phase>("guessing");
  const [text, setText] = useState("");
  const [busy, setBusy] = useState(false);
  const [result, setResult] = useState<GuessResult | null>(null);
  const [feedback, setFeedback] = useState<string | null>(null);
  const [wrong, setWrong] = useState(false);
  const [playing, setPlaying] = useState(false);
  const [thumbGiven, setThumbGiven] = useState(false);
  const [thumbUsed, setThumbUsed] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setDrawing(undefined);
    setPhase("guessing");
    setText("");
    setResult(null);
    setFeedback(null);
    setWrong(false);
    setPlaying(false);
    setThumbGiven(false);
    try {
      setDrawing(await fetchNextDrawing());
    } catch {
      setError(t("loadFailed"));
    }
  }, [t]);

  useEffect(() => {
    void load();
  }, [load]);

  async function send(e: React.FormEvent) {
    e.preventDefault();
    if (!drawing || busy || !text.trim()) return;
    setBusy(true);
    setError(null);
    try {
      const r = await submitGuess(drawing.drawingId, text);
      setResult(r);
      if (r.correct) {
        setPhase("solved");
        // Hláška z předchozího špatného tipu by po uhodnutí zůstala viset.
        setFeedback(null);
        setWrong(false);
      } else if (r.attemptsLeft === 0) {
        setPhase("failed");
        setFeedback(t("failed", { concept: r.solution ?? "" }));
      } else {
        setWrong(true);
        setText("");
        setFeedback(
          r.hint
            ? t("wrongWithHint", { left: r.attemptsLeft, hint: r.hint })
            : t("wrong", { left: r.attemptsLeft }),
        );
      }
    } catch {
      setError(t("sendFailed"));
    } finally {
      setBusy(false);
    }
  }

  if (error) {
    return (
      <AppShell title={t("title")}>
        <p className="auth-note auth-note-error">{error}</p>
      </AppShell>
    );
  }

  if (drawing === undefined) {
    return (
      <AppShell title={t("title")}>
        <p className="pick-loading">
          <Loader2 size={18} className="spin" aria-hidden="true" /> {t("loading")}
        </p>
      </AppShell>
    );
  }

  // Prázdná zásoba je stav hry, ne porucha — a je to pobídka ke kreslení.
  if (drawing === null) {
    return (
      <AppShell title={t("title")}>
        <div className="empty-state">
          <div className="empty-icon">
            <Inbox size={34} />
          </div>
          <h2 className="t-display" style={{ fontSize: 24 }}>
            {tEmpty("title")}
          </h2>
          <p className="t-secondary">{tEmpty("note")}</p>
          <Link href="/pick" className="btn btn-primary btn-lg">
            <Pencil size={18} /> {tEmpty("cta")}
          </Link>
        </div>
      </AppShell>
    );
  }

  const attemptsUsed = result?.attemptNo ?? 0;

  return (
    <AppShell title={t("title")}>
      <div className="guess-screen">
        <div className="guess-art">
          <StrokePlayback
            strokes={drawing.strokes}
            playing={playing}
            onEnd={() => setPlaying(false)}
          />
        </div>

        <div className="guess-controls">
          {phase === "guessing" && (
            <>
              <div className="attempt-dots" aria-label={t("attemptsLeft", { left: 3 - attemptsUsed })}>
                {[0, 1, 2].map((i) => (
                  <span
                    key={i}
                    className={`attempt-dot${i < attemptsUsed ? " is-used" : ""}`}
                  />
                ))}
              </div>

              <form className="guess-form" onSubmit={send}>
                <input
                  className={`input${wrong ? " input-invalid" : ""}`}
                  placeholder={t("placeholder")}
                  value={text}
                  autoComplete="off"
                  onChange={(e) => {
                    setText(e.target.value);
                    setWrong(false);
                  }}
                />
                <Button type="submit" disabled={busy || !text.trim()}>
                  {busy ? <Loader2 size={16} className="spin" /> : t("submit")}
                </Button>
              </form>
            </>
          )}

          {feedback && <p className="guess-feedback">{feedback}</p>}

          {phase === "solved" && result && (
            <div className="solved-side">
              <h2 className="t-display">{result.solution}</h2>
              <p className="t-secondary">
                {tSolved("stars", { n: result.stars })} ·{" "}
                {tSolved("author", { name: drawing.authorName })}
              </p>
            </div>
          )}

          <div className="guess-meta-actions">
            {/* Přehrání je odměna po uhodnutí, ne výchozí zobrazení. */}
            <button
              type="button"
              aria-label={t("play")}
              disabled={playing}
              onClick={() => setPlaying(true)}
            >
              <Play size={18} />
            </button>

            <button
              type="button"
              aria-label={tSolved("thumb")}
              aria-pressed={thumbGiven}
              disabled={thumbGiven || thumbUsed || phase === "guessing"}
              onClick={async () => {
                const ok = await giveThumb(drawing.drawingId);
                if (ok) setThumbGiven(true);
                else setThumbUsed(true);
              }}
            >
              <ThumbsUp size={18} />
            </button>

            <button type="button" aria-label={t("report")}>
              <Flag size={18} />
            </button>
          </div>

          {thumbUsed && <p className="guess-feedback">{tSolved("thumbUsed")}</p>}

          {phase !== "guessing" && (
            <Button size="lg" onClick={() => void load()}>
              <SkipForward size={18} /> {t("next")}
            </Button>
          )}

          {phase === "guessing" && (
            <button type="button" className="btn btn-ghost" onClick={() => void load()}>
              {t("skip")}
            </button>
          )}
        </div>
      </div>
    </AppShell>
  );
}

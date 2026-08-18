"use client";

import { useEffect, useRef, useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import {
  Flag,
  Hand,
  Inbox,
  Pencil,
  Play,
  Share2,
  SkipForward,
  ThumbsUp,
} from "lucide-react";
import { Link } from "@/i18n/navigation";
import { AppShell } from "@/components/shell/AppShell";
import { Badge, Button, Card } from "@/components/ui";
import { conceptById, FEED, REQUESTS, SUPPLY_BASE } from "@/lib/mock";

/**
 * Hádání (wireframy 3, 4, 5, 10): hotový obrázek, tři pokusy, volný text.
 * Přehrání tah po tahu je volitelné tlačítko až po uhodnutí (pravidlo
 * z CLAUDE.md). Prázdný feed je surge stav, ne chyba.
 */

const MAX_ATTEMPTS = 3;
const PLAYBACK_TOTAL_S = 7;

type Phase = "guessing" | "solved" | "failed";

function normalize(text: string): string {
  return text.trim().toLowerCase();
}

export default function GuessPage() {
  const locale = useLocale() as "cs" | "en";
  const t = useTranslations("guess");
  const tSolved = useTranslations("solved");
  const tEmpty = useTranslations("empty");
  const tCommon = useTranslations("common");

  const [drawingIndex, setDrawingIndex] = useState(0);
  const [phase, setPhase] = useState<Phase>("guessing");
  const [attemptsUsed, setAttemptsUsed] = useState(0);
  const [guess, setGuess] = useState("");
  const [lastWrong, setLastWrong] = useState(false);
  const [thumbGiven, setThumbGiven] = useState(false);
  const [thumbUsedToday, setThumbUsedToday] = useState(false);
  const [playbackS, setPlaybackS] = useState(2);
  const [playing, setPlaying] = useState(false);
  const playTimer = useRef<ReturnType<typeof setInterval> | null>(null);

  const drawing = FEED[drawingIndex] as (typeof FEED)[number] | undefined;
  const concept = drawing ? conceptById(drawing.conceptId) : null;
  const supply = SUPPLY_BASE - drawingIndex;

  // Mock přehrání: jen posouvá ukazatel času
  useEffect(() => {
    if (!playing) {
      if (playTimer.current) clearInterval(playTimer.current);
      return;
    }
    playTimer.current = setInterval(() => {
      setPlaybackS((s) => {
        if (s >= PLAYBACK_TOTAL_S) {
          setPlaying(false);
          return PLAYBACK_TOTAL_S;
        }
        return s + 1;
      });
    }, 1000);
    return () => {
      if (playTimer.current) clearInterval(playTimer.current);
    };
  }, [playing]);

  const submitGuess = () => {
    if (!concept || guess.trim() === "") return;
    const correct = normalize(guess) === normalize(concept.name[locale]);
    if (correct) {
      setPhase("solved");
      setLastWrong(false);
      return;
    }
    const used = attemptsUsed + 1;
    setAttemptsUsed(used);
    setLastWrong(true);
    setGuess("");
    if (used >= MAX_ATTEMPTS) {
      setPhase("failed");
    }
  };

  const nextDrawing = () => {
    setDrawingIndex((i) => i + 1);
    setPhase("guessing");
    setAttemptsUsed(0);
    setGuess("");
    setLastWrong(false);
    setThumbGiven(false);
    setPlaybackS(2);
    setPlaying(false);
  };

  /* ---------- Prázdný feed (wireframe 10) ---------- */
  if (!drawing || !concept) {
    return (
      <AppShell title={t("title")}>
        <div className="guess-screen">
          <div className="empty-state">
            <div className="empty-icon">
              <Inbox size={34} />
            </div>
            <h2 className="t-display" style={{ fontSize: 24 }}>
              {tEmpty("title")}
            </h2>
            <p className="t-secondary">{tEmpty("note")}</p>
            <Card elevated={false} className="requested-list">
              <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
                {tEmpty("requested")}
              </span>
              {REQUESTS.map((r) => (
                <div key={r.conceptId} className="requested-item">
                  <Hand size={16} />
                  <span>
                    {tEmpty("wants", {
                      name: r.requester,
                      concept: conceptById(r.conceptId).name[locale],
                    })}
                  </span>
                </div>
              ))}
            </Card>
            <Link href="/pick" style={{ width: "100%" }}>
              <Button size="lg" style={{ width: "100%" }}>
                <Pencil size={18} /> {tEmpty("cta")}
              </Button>
            </Link>
          </div>
        </div>
      </AppShell>
    );
  }

  /* ---------- Uhodnuto (wireframe 5) ---------- */
  if (phase === "solved" || phase === "failed") {
    const solved = phase === "solved";
    const attempt = attemptsUsed + 1;
    const stars = solved ? "★".repeat(Math.max(1, MAX_ATTEMPTS + 1 - attempt)) : "";
    const attemptKey = attempt === 1 ? "first" : attempt === 2 ? "second" : "other";

    const summary = solved
      ? tSolved("summary", {
          attempt: attemptKey,
          count: drawing.solvedByCount + 1,
        })
      : t("failed", { concept: concept.name[locale] });

    const thumb = (
      <div className="thumb-group">
        <button
          type="button"
          className="thumb-btn"
          aria-label={tSolved("thumb")}
          aria-pressed={thumbGiven}
          disabled={thumbUsedToday && !thumbGiven}
          onClick={() => {
            setThumbGiven(true);
            setThumbUsedToday(true);
          }}
        >
          <ThumbsUp size={18} />
        </button>
        <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
          {tSolved("thumbLimit")}
        </span>
      </div>
    );

    const playback = (
      <div className="playback-row">
        <div className="playback-bar">
          <div
            className="playback-bar-fill"
            style={{ width: `${(playbackS / PLAYBACK_TOTAL_S) * 100}%` }}
          />
        </div>
        <span className="playback-time">
          0:0{Math.min(playbackS, PLAYBACK_TOTAL_S)} / 0:0{PLAYBACK_TOTAL_S}
        </span>
      </div>
    );

    const actions = (
      <div className="solved-actions">
        <Button size="lg" onClick={nextDrawing}>
          {tSolved("next")}
        </Button>
        <button
          type="button"
          className="icon-btn"
          aria-label={tSolved("play")}
          onClick={() => {
            setPlaybackS(0);
            setPlaying(true);
          }}
        >
          <Play size={20} />
        </button>
        <button type="button" className="icon-btn" aria-label={tSolved("gif")}>
          <Share2 size={20} />
        </button>
      </div>
    );

    return (
      <AppShell
        title={t("title")}
        meta={
          solved ? (
            <Badge tone="success">{tSolved("chip", { stars })}</Badge>
          ) : undefined
        }
      >
        {/* Mobil: karta pod hlavičkou (wireframe 5) */}
        <div className="only-mobile">
          <div className="solved-top">
            {solved ? (
              <Badge tone="success">{tSolved("chip", { stars })}</Badge>
            ) : (
              <span />
            )}
            {solved && thumb}
          </div>
          <Card>
            <h2 className="t-display" style={{ fontSize: 26 }}>
              {concept.name[locale]}
            </h2>
            <div className="hatch solved-card-art">
              <span className="t-label">{tSolved("playback")}</span>
            </div>
            {playback}
            {actions}
            <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
              {tSolved("author", { name: drawing.author })}
            </span>
          </Card>
          <p className="solved-summary">{summary}</p>
        </div>

        {/* Tablet + desktop: přehrání vlevo, odměna a akce vpravo */}
        <div className="only-wide">
          <div className="solved-layout">
            <div className="hatch solved-art-pane">
              <span className="t-label">{tSolved("playback")}</span>
            </div>
            <div className="solved-side">
              {solved && thumb}
              <h2 className="t-display">{concept.name[locale]}</h2>
              <p className="t-secondary">
                {summary} {tSolved("author", { name: drawing.author })}
              </p>
              {playback}
              {actions}
            </div>
          </div>
        </div>
      </AppShell>
    );
  }

  /* ---------- Hádání (wireframy 3 a 4) ---------- */
  const attemptsLeft = MAX_ATTEMPTS - attemptsUsed;

  return (
    <AppShell
      title={t("title")}
      meta={
        <span className="t-label-sm" style={{ color: "var(--text-muted)" }}>
          {lastWrong
            ? t("attemptsLeft", { left: attemptsLeft })
            : tCommon("supply", { n: supply })}
        </span>
      }
    >
      <div className="guess-screen">
        <div className="hatch guess-art">
          <span className="t-label">{t("finished")}</span>
        </div>
        <div className="guess-controls">
          <div className="attempt-dots" aria-label={t("attemptsLeft", { left: attemptsLeft })}>
            {Array.from({ length: MAX_ATTEMPTS }, (_, i) => (
              <span
                key={i}
                className={`attempt-dot${i < attemptsUsed ? " is-used" : ""}`}
              />
            ))}
          </div>
          <form
            className="guess-form"
            onSubmit={(e) => {
              e.preventDefault();
              submitGuess();
            }}
          >
            <input
              className={`input${lastWrong ? " input-invalid" : ""}`}
              placeholder={t("placeholder")}
              value={guess}
              autoComplete="off"
              onChange={(e) => {
                setGuess(e.target.value);
                setLastWrong(false);
              }}
            />
            <Button type="submit">{t("submit")}</Button>
          </form>
          <span className="guess-feedback" role="status">
            {lastWrong ? t("wrong", { left: attemptsLeft }) : " "}
          </span>
          <div className="guess-meta-actions">
            <button type="button" aria-label={t("skip")} onClick={nextDrawing}>
              <SkipForward size={18} />
            </button>
            <button type="button" aria-label={t("report")}>
              <Flag size={18} />
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  );
}

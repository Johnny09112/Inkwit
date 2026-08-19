"use client";

import { Loader2 } from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { DrawingDetail } from "@/components/DrawingDetail";
import { DrawingThumb } from "@/components/DrawingThumb";
import { AppShell } from "@/components/shell/AppShell";
import { Link } from "@/i18n/navigation";
import { deleteDrawing, fetchMyDrawings, fetchStrokes, type MyDrawing } from "@/lib/game";
import type { Stroke } from "@/lib/strokes";

type Filter = "all" | "solved" | "waiting";

/**
 * Moje kresby (wireframe 7).
 *
 * Autorovi se ukazuje, kolik lidí kresbu uhodlo — **nikdy kolikrát ji lidé
 * neuhodli** (`docs/product.md`). Server proto počet tipů vůbec neposílá,
 * takže se to nedá dopočítat ani omylem.
 */
export default function MinePage() {
  const t = useTranslations("mine");

  const [items, setItems] = useState<MyDrawing[] | null>(null);
  const [strokes, setStrokes] = useState<Map<string, Stroke[]>>(new Map());
  const [filter, setFilter] = useState<Filter>("all");
  const [error, setError] = useState<string | null>(null);
  const [openId, setOpenId] = useState<string | null>(null);

  useEffect(() => {
    let alive = true;
    fetchMyDrawings()
      .then(async (rows) => {
        if (!alive) return;
        setItems(rows);
        // Náhledy se kreslí z tahů, takže je potřeba dotáhnout — jedním
        // dotazem pro celou mřížku, ne po jedné.
        const byId = await fetchStrokes(rows.map((r) => r.drawingId));
        if (alive) setStrokes(byId);
      })
      .catch(() => alive && setError(t("loadFailed")));
    return () => {
      alive = false;
    };
  }, [t]);

  if (error) {
    return (
      <AppShell title={t("title")}>
        <p className="auth-note auth-note-error">{error}</p>
      </AppShell>
    );
  }

  if (!items) {
    return (
      <AppShell title={t("title")}>
        <p className="pick-loading">
          <Loader2 size={18} className="spin" aria-hidden="true" /> {t("loading")}
        </p>
      </AppShell>
    );
  }

  const open = items.find((d) => d.drawingId === openId) ?? null;

  const solved = items.filter((d) => d.solvedCount > 0);
  const waiting = items.filter((d) => d.solvedCount === 0);
  const shown = filter === "solved" ? solved : filter === "waiting" ? waiting : items;

  const filters: { key: Filter; label: string }[] = [
    { key: "all", label: t("filters.all", { n: items.length }) },
    { key: "solved", label: t("filters.solved", { n: solved.length }) },
    { key: "waiting", label: t("filters.waiting", { n: waiting.length }) },
  ];

  return (
    <AppShell title={t("title")}>
      <div className="filter-chips">
        {filters.map((f) => (
          <button
            key={f.key}
            type="button"
            className="filter-chip"
            aria-pressed={filter === f.key}
            onClick={() => setFilter(f.key)}
          >
            {f.label}
          </button>
        ))}
      </div>

      {items.length === 0 ? (
        <div className="mine-empty">
          <p>{t("empty")}</p>
          <Link href="/pick" className="btn btn-primary">
            {t("emptyCta")}
          </Link>
        </div>
      ) : (
        <div className="mine-grid">
          {shown.map((d) => (
            <button
              key={d.drawingId}
              type="button"
              className="mine-item"
              aria-label={t("detailTitle")}
              onClick={() => setOpenId(d.drawingId)}
            >
              <DrawingThumb
                strokes={strokes.get(d.drawingId)}
                aspect={d.aspect}
                label={d.prompt}
              />
              <div className="mine-item-name">{d.prompt}</div>
              <div className="mine-item-meta">
                {d.solvedCount > 0
                  ? `${t("guessed", { count: d.solvedCount })}${
                      d.thumbsCount > 0 ? ` · ${t("thumbs", { count: d.thumbsCount })}` : ""
                    }`
                  : t("waiting")}
              </div>
            </button>
          ))}
        </div>
      )}

      {open && (
        <DrawingDetail
          drawing={open}
          strokes={strokes.get(open.drawingId)}
          onClose={() => setOpenId(null)}
          onDelete={async (id) => {
            const ok = await deleteDrawing(id);
            if (ok) {
              // Seznam se nepřenačítá — server už kresbu nevrátí a jediná
              // změna je ta jedna položka.
              setItems((rows) => (rows ?? []).filter((r) => r.drawingId !== id));
              setOpenId(null);
            }
            return ok;
          }}
        />
      )}
    </AppShell>
  );
}

"use client";

import { useCallback, useEffect, useState } from "react";
import { Download, Flag, Images, Loader2, LayoutDashboard, Users } from "lucide-react";
import { AppShell } from "@/components/shell/AppShell";
import { DrawingThumb } from "@/components/DrawingThumb";
import { Button } from "@/components/ui";
import {
  downloadCsv,
  fetchDrawings,
  fetchHardConcepts,
  fetchMetric,
  fetchOverview,
  fetchReports,
  fetchSupply,
  fetchUsers,
  resolveReport,
  setDrawingStatus,
  setUserStatus,
  type AdminDrawing,
  type AdminOverviewRow,
  type AdminReport,
  type AdminSupplyRow,
  type AdminUser,
  type HardConcept,
  type MetricName,
} from "@/lib/admin";

/**
 * Správcovské rozhraní (blok H).
 *
 * **Oprávnění stojí na serveru, ne tady.** Každé volání si samo ověří admina;
 * tahle stránka jen ukáže chybu, když jím uživatel není. Kdyby to bylo naopak,
 * stačilo by URL uhodnout.
 *
 * Vědomě bez překladů: mluví jenom k majiteli a dvojjazyčnost by tu byla
 * práce navíc bez čtenáře.
 */

type Tab = "prehled" | "hlaseni" | "kresby" | "ucty";

/** Práh, pod kterým se hlásí, že docházejí slova. */
const MALO_SLOV = 15;

export default function AdminPage() {
  const [tab, setTab] = useState<Tab>("prehled");
  const [error, setError] = useState<string | null>(null);

  const [overview, setOverview] = useState<AdminOverviewRow[] | null>(null);
  const [supply, setSupply] = useState<AdminSupplyRow[] | null>(null);
  const [hard, setHard] = useState<HardConcept[]>([]);
  const [reports, setReports] = useState<AdminReport[] | null>(null);
  const [drawings, setDrawings] = useState<AdminDrawing[] | null>(null);
  const [drawFilter, setDrawFilter] = useState("live");
  const [users, setUsers] = useState<AdminUser[] | null>(null);
  const [busy, setBusy] = useState<string | null>(null);

  const load = useCallback(async () => {
    setError(null);
    try {
      if (tab === "prehled" && !overview) {
        setOverview(await fetchOverview());
        setSupply(await fetchSupply());
        setHard(await fetchHardConcepts());
      }
      if (tab === "hlaseni") setReports(await fetchReports("open"));
      if (tab === "kresby") setDrawings(await fetchDrawings(drawFilter));
      if (tab === "ucty") setUsers(await fetchUsers());
    } catch {
      setError("Načtení se nepovedlo — nejspíš tenhle účet není správce.");
    }
  }, [tab, drawFilter, overview]);

  useEffect(() => {
    void load();
  }, [load]);

  /** Obalí akci: zamkne tlačítko a po doběhnutí znovu načte seznam. */
  async function akce(klic: string, fn: () => Promise<unknown>) {
    setBusy(klic);
    try {
      await fn();
      if (tab === "hlaseni") setReports(await fetchReports("open"));
      if (tab === "kresby") setDrawings(await fetchDrawings(drawFilter));
      if (tab === "ucty") setUsers(await fetchUsers());
    } catch {
      setError("Akce se nepovedla.");
    } finally {
      setBusy(null);
    }
  }

  const taby: { key: Tab; label: string; icon: typeof Flag }[] = [
    { key: "prehled", label: "Přehled", icon: LayoutDashboard },
    { key: "hlaseni", label: "Hlášení", icon: Flag },
    { key: "kresby", label: "Kresby", icon: Images },
    { key: "ucty", label: "Účty", icon: Users },
  ];

  const dochazejiSlova = (supply ?? []).some((r) => r.nenakreslene <= MALO_SLOV);

  return (
    <AppShell title="Správa">
      <div className="admin-tabs">
        {taby.map(({ key, label, icon: Icon }) => (
          <button
            key={key}
            type="button"
            className="filter-chip"
            aria-pressed={tab === key}
            onClick={() => setTab(key)}
          >
            <Icon size={14} aria-hidden="true" /> {label}
          </button>
        ))}
      </div>

      {error && <p className="auth-note auth-note-error">{error}</p>}

      {tab === "prehled" && (
        <>
          {!overview ? (
            <p className="pick-loading">
              <Loader2 size={18} className="spin" aria-hidden="true" /> Načítám…
            </p>
          ) : (
            <>
              <table className="admin-table">
                <thead>
                  <tr>
                    <th>Období</th><th>Účty</th><th>Kresby</th><th>Tipy</th>
                    <th>Uhodnuté</th><th>Palce</th><th>Hlášení</th>
                  </tr>
                </thead>
                <tbody>
                  {overview.map((r) => (
                    <tr key={r.obdobi}>
                      <td>{r.obdobi}</td><td>{r.ucty}</td><td>{r.kresby}</td>
                      <td>{r.tipy}</td><td>{r.uhodnute}</td><td>{r.palce}</td>
                      <td>{r.novaHlaseni}</td>
                    </tr>
                  ))}
                </tbody>
              </table>

              {dochazejiSlova && (
                <p className="admin-alarm">
                  Docházejí slova — u některé obtížnosti zbývá {MALO_SLOV} a míň
                  nenakreslených pojmů. Přidej je do <code>supabase/seed/concepts.json</code>.
                </p>
              )}

              <h2 className="admin-h2">Zásoba</h2>
              <table className="admin-table">
                <thead>
                  <tr>
                    <th>Obtížnost</th><th>Pojmů</th><th>Nakreslených</th>
                    <th>Zbývá</th><th>Čeká na uhodnutí</th>
                  </tr>
                </thead>
                <tbody>
                  {(supply ?? []).map((r) => (
                    <tr key={r.obtiznost}>
                      <td>{["", "snadné", "střední", "těžké"][r.obtiznost]}</td>
                      <td>{r.koncepty}</td>
                      <td>{r.nakreslene}</td>
                      <td className={r.nenakreslene <= MALO_SLOV ? "admin-warn" : undefined}>
                        {r.nenakreslene}
                      </td>
                      <td>{r.kresbyCeka}</td>
                    </tr>
                  ))}
                </tbody>
              </table>

              {hard.length > 0 && (
                <>
                  <h2 className="admin-h2">Pojmy, které nikdo neuhodl</h2>
                  <p className="t-secondary" style={{ fontSize: "var(--text-body-sm)" }}>
                    Nejsou to špatní kreslíři, ale podezřelá zadání nebo chybějící
                    přijímané tvary.
                  </p>
                  <table className="admin-table">
                    <thead>
                      <tr><th>Pojem</th><th>Kreseb</th><th>Tipů</th></tr>
                    </thead>
                    <tbody>
                      {hard.map((h) => (
                        <tr key={h.prompt}>
                          <td>{h.prompt}</td><td>{h.kresby}</td><td>{h.tipy}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </>
              )}

              <h2 className="admin-h2">Export</h2>
              <div className="admin-actions">
                {(["funnel", "return", "supply", "effort", "ab_playback"] as MetricName[]).map(
                  (m) => (
                    <button
                      key={m}
                      type="button"
                      className="btn btn-secondary btn-sm"
                      onClick={async () => downloadCsv(`inkwit-${m}`, await fetchMetric(m))}
                    >
                      <Download size={14} aria-hidden="true" /> {m}
                    </button>
                  ),
                )}
              </div>
            </>
          )}
        </>
      )}

      {tab === "hlaseni" && (
        <>
          {!reports ? (
            <p className="pick-loading">
              <Loader2 size={18} className="spin" aria-hidden="true" /> Načítám…
            </p>
          ) : reports.length === 0 ? (
            <p className="t-secondary">Žádná otevřená hlášení. Fronta je prázdná.</p>
          ) : (
            reports.map((r) => (
              <div key={r.reportId} className="admin-card">
                <div className="admin-card-art">
                  <DrawingThumb strokes={r.strokes} aspect={r.aspect} label={r.prompt} />
                </div>
                <div className="admin-card-body">
                  <strong>{r.prompt}</strong>
                  <p className="t-secondary" style={{ fontSize: "var(--text-body-sm)" }}>
                    Důvod: <strong>{r.reason}</strong> · nahlásil {r.reporter} ·
                    kreslíř {r.author} {r.authorStatus === "banned" && "(zablokovaný)"} ·
                    kresba {r.drawingStatus}
                  </p>
                  <div className="admin-actions">
                    <Button
                      size="sm"
                      disabled={busy === r.reportId}
                      onClick={() =>
                        akce(r.reportId, async () => {
                          await setDrawingStatus(r.drawingId, "removed");
                          await resolveReport(r.reportId, "resolved");
                        })
                      }
                    >
                      Skrýt kresbu
                    </Button>
                    <Button
                      variant="secondary"
                      size="sm"
                      disabled={busy === r.reportId}
                      onClick={() => akce(r.reportId, () => resolveReport(r.reportId, "dismissed"))}
                    >
                      Planý poplach
                    </Button>
                    <button
                      type="button"
                      className="detail-delete"
                      disabled={busy === r.reportId}
                      onClick={() =>
                        akce(r.reportId, async () => {
                          await setUserStatus(r.authorId, "banned", `hlášení: ${r.reason}`);
                          await setDrawingStatus(r.drawingId, "removed");
                          await resolveReport(r.reportId, "resolved");
                        })
                      }
                    >
                      Zablokovat kreslíře
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </>
      )}

      {tab === "kresby" && (
        <>
          <div className="admin-tabs">
            {["live", "removed", "archived", "reported", "all"].map((f) => (
              <button
                key={f}
                type="button"
                className="filter-chip"
                aria-pressed={drawFilter === f}
                onClick={() => {
                  setDrawings(null);
                  setDrawFilter(f);
                }}
              >
                {f}
              </button>
            ))}
          </div>
          {!drawings ? (
            <p className="pick-loading">
              <Loader2 size={18} className="spin" aria-hidden="true" /> Načítám…
            </p>
          ) : (
            <div className="mine-grid">
              {drawings.map((d) => (
                <div key={d.drawingId} className="mine-item">
                  <DrawingThumb strokes={d.strokes} aspect={d.aspect} label={d.prompt} />
                  <div className="mine-item-name">{d.prompt}</div>
                  <div className="mine-item-meta">
                    {d.author} · {d.solvedCount}/{d.guessCount} · {d.status}
                    {d.reports > 0 && ` · ${d.reports} hlášení`}
                  </div>
                  <button
                    type="button"
                    className="btn btn-secondary btn-sm"
                    disabled={busy === d.drawingId}
                    onClick={() =>
                      akce(d.drawingId, () =>
                        setDrawingStatus(d.drawingId, d.status === "removed" ? "live" : "removed"),
                      )
                    }
                  >
                    {d.status === "removed" ? "Vrátit" : "Skrýt"}
                  </button>
                </div>
              ))}
            </div>
          )}
        </>
      )}

      {tab === "ucty" && (
        <>
          {!users ? (
            <p className="pick-loading">
              <Loader2 size={18} className="spin" aria-hidden="true" /> Načítám…
            </p>
          ) : (
            <table className="admin-table">
              <thead>
                <tr>
                  <th>Jméno</th><th>Kresby</th><th>Tipy</th><th>Uhodl</th>
                  <th>Hlášení</th><th>Stav</th><th></th>
                </tr>
              </thead>
              <tbody>
                {users.map((u) => (
                  <tr key={u.userId}>
                    <td>
                      {u.displayName}
                      {u.isAdmin && " ★"}
                    </td>
                    <td>{u.drawings}</td>
                    <td>{u.guesses}</td>
                    <td>{u.solved}</td>
                    <td className={u.reportsAgainst > 0 ? "admin-warn" : undefined}>
                      {u.reportsAgainst}
                    </td>
                    <td>{u.status === "banned" ? "zablokovaný" : "aktivní"}</td>
                    <td>
                      {!u.isAdmin && (
                        <button
                          type="button"
                          className={u.status === "banned" ? "btn btn-secondary btn-sm" : "detail-delete"}
                          disabled={busy === u.userId}
                          onClick={() =>
                            akce(u.userId, () =>
                              setUserStatus(
                                u.userId,
                                u.status === "banned" ? "active" : "banned",
                                u.status === "banned" ? undefined : "ručně správcem",
                              ),
                            )
                          }
                        >
                          {u.status === "banned" ? "Odblokovat" : "Zablokovat"}
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </>
      )}
    </AppShell>
  );
}

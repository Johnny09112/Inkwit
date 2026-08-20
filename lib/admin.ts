import { createClient } from "@/lib/supabase/client";
import { strokeFromPayload, type Stroke } from "@/lib/strokes";

/**
 * Volání pro správcovské rozhraní (blok H).
 *
 * Oprávnění **neřeší tenhle soubor** — každá funkce na serveru si sama ověří
 * admina a jinak skončí chybou. Kdyby to bylo naopak, stačilo by otevřít
 * `/admin` v prohlížeči a data by tekla ven.
 */

function strokesFrom(raw: unknown): Stroke[] {
  return ((raw ?? []) as Record<string, unknown>[]).map((s) =>
    strokeFromPayload({
      tool: s.tool as string,
      color: s.color as string,
      width: s.width as number,
      points: s.points as number[],
    }),
  );
}

async function call<T>(fn: string, args?: Record<string, unknown>): Promise<T> {
  const { data, error } = await createClient().rpc(fn, args);
  if (error) throw error;
  return data as T;
}

/** Zjistí, jestli je přihlášený správce. Používá to jen skrývání odkazu. */
export async function amIAdmin(): Promise<boolean> {
  try {
    return (await call<boolean>("am_i_admin")) === true;
  } catch {
    return false;
  }
}

export interface AdminReport {
  reportId: string;
  drawingId: string;
  prompt: string;
  reason: string;
  status: string;
  reporter: string;
  author: string;
  authorId: string;
  authorStatus: string;
  drawingStatus: string;
  aspect: number;
  strokes: Stroke[];
  createdAt: string;
}

export async function fetchReports(status = "open"): Promise<AdminReport[]> {
  const rows = await call<Record<string, unknown>[]>("admin_reports", { p_status: status });
  return (rows ?? []).map((r) => ({
    reportId: r.report_id as string,
    drawingId: r.drawing_id as string,
    prompt: r.prompt as string,
    reason: r.reason as string,
    status: r.status as string,
    reporter: r.reporter as string,
    author: r.author as string,
    authorId: r.author_id as string,
    authorStatus: r.author_status as string,
    drawingStatus: r.drawing_status as string,
    aspect: (r.aspect as number) ?? 0.68,
    strokes: strokesFrom(r.strokes),
    createdAt: r.created_at as string,
  }));
}

export const resolveReport = (id: string, status: "resolved" | "dismissed") =>
  call<boolean>("admin_resolve_report", { p_report_id: id, p_status: status });

export const setDrawingStatus = (id: string, status: "live" | "removed" | "archived") =>
  call<boolean>("admin_set_drawing_status", { p_drawing_id: id, p_status: status });

export interface AdminDrawing {
  drawingId: string;
  prompt: string;
  status: string;
  author: string;
  authorId: string;
  solvedCount: number;
  guessCount: number;
  thumbsCount: number;
  reports: number;
  durationMs: number;
  strokeCount: number;
  aspect: number;
  strokes: Stroke[];
  createdAt: string;
}

export async function fetchDrawings(status = "live", limit = 60): Promise<AdminDrawing[]> {
  const rows = await call<Record<string, unknown>[]>("admin_drawings", {
    p_status: status,
    p_limit: limit,
  });
  return (rows ?? []).map((r) => ({
    drawingId: r.drawing_id as string,
    prompt: r.prompt as string,
    status: r.status as string,
    author: r.author as string,
    authorId: r.author_id as string,
    solvedCount: r.solved_count as number,
    guessCount: r.guess_count as number,
    thumbsCount: r.thumbs_count as number,
    reports: r.reports as number,
    durationMs: r.duration_ms as number,
    strokeCount: r.stroke_count as number,
    aspect: (r.aspect as number) ?? 0.68,
    strokes: strokesFrom(r.strokes),
    createdAt: r.created_at as string,
  }));
}

export interface AdminUser {
  userId: string;
  displayName: string;
  status: string;
  isAdmin: boolean;
  drawings: number;
  guesses: number;
  solved: number;
  reportsAgainst: number;
  trustBand: string | null;
  banReason: string | null;
  createdAt: string;
}

export async function fetchUsers(): Promise<AdminUser[]> {
  const rows = await call<Record<string, unknown>[]>("admin_users");
  return (rows ?? []).map((r) => ({
    userId: r.user_id as string,
    displayName: r.display_name as string,
    status: r.status as string,
    isAdmin: r.is_admin as boolean,
    drawings: r.drawings as number,
    guesses: r.guesses as number,
    solved: r.solved as number,
    reportsAgainst: r.reports_against as number,
    trustBand: (r.trust_band as string | null) ?? null,
    banReason: (r.ban_reason as string | null) ?? null,
    createdAt: r.created_at as string,
  }));
}

export const setUserStatus = (id: string, status: "active" | "banned", reason?: string) =>
  call<boolean>("admin_set_user_status", {
    p_user_id: id,
    p_status: status,
    p_reason: reason ?? null,
  });

export interface AdminOverviewRow {
  obdobi: string;
  ucty: number;
  kresby: number;
  tipy: number;
  uhodnute: number;
  palce: number;
  novaHlaseni: number;
}

export async function fetchOverview(): Promise<AdminOverviewRow[]> {
  const rows = await call<Record<string, unknown>[]>("admin_overview");
  return (rows ?? []).map((r) => ({
    obdobi: r.obdobi as string,
    ucty: r.ucty as number,
    kresby: r.kresby as number,
    tipy: r.tipy as number,
    uhodnute: r.uhodnute as number,
    palce: r.palce as number,
    novaHlaseni: r.nova_hlaseni as number,
  }));
}

export interface AdminSupplyRow {
  obtiznost: number;
  koncepty: number;
  nakreslene: number;
  nenakreslene: number;
  kresbyCeka: number;
}

export async function fetchSupply(): Promise<AdminSupplyRow[]> {
  const rows = await call<Record<string, unknown>[]>("admin_supply");
  return (rows ?? []).map((r) => ({
    obtiznost: r.obtiznost as number,
    koncepty: r.koncepty as number,
    nakreslene: r.nakreslene as number,
    nenakreslene: r.nenakreslene as number,
    kresbyCeka: r.kresby_ceka as number,
  }));
}

export interface HardConcept {
  prompt: string;
  obtiznost: number;
  kresby: number;
  tipy: number;
  uhodnuti: number;
}

export async function fetchHardConcepts(): Promise<HardConcept[]> {
  const rows = await call<Record<string, unknown>[]>("admin_hard_concepts");
  return (rows ?? []).map((r) => ({
    prompt: r.prompt as string,
    obtiznost: r.obtiznost as number,
    kresby: r.kresby as number,
    tipy: r.tipy as number,
    uhodnuti: r.uhodnuti as number,
  }));
}

export type MetricName = "funnel" | "return" | "supply" | "effort" | "ab_playback";

export const fetchMetric = (name: MetricName) =>
  call<Record<string, unknown>[]>("admin_metrics", { p_name: name });

/**
 * Převod na CSV. Vědomě bez knihovny — jde o pár řádků a jediná past je
 * uvozovka uvnitř hodnoty.
 */
export function toCsv(rows: Record<string, unknown>[]): string {
  if (rows.length === 0) return "";
  const keys = Object.keys(rows[0]);
  const cell = (v: unknown) => {
    const s = v === null || v === undefined ? "" : String(v);
    return /[",;\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };
  // Středník, ne čárka: Excel v českém prostředí jinak nasype vše do jednoho sloupce.
  return [keys.join(";"), ...rows.map((r) => keys.map((k) => cell(r[k])).join(";"))].join("\n");
}

/** Stáhne data jako soubor. Blob URL se hned uvolní, ať v paměti nezůstává. */
export function downloadCsv(name: string, rows: Record<string, unknown>[]) {
  const blob = new Blob(["﻿" + toCsv(rows)], { type: "text/csv;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `${name}.csv`;
  a.click();
  URL.revokeObjectURL(url);
}

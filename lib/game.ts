import { createClient } from "@/lib/supabase/client";
import {
  dominantDevice,
  strokeFromPayload,
  strokesToPayload,
  type Stroke,
} from "@/lib/strokes";

/**
 * Herní volání na server.
 *
 * Všechno jde přes RPC, ne přes dotazy do tabulek — zadání konceptu je
 * tajemství hry a odvozená čísla o kresbě počítá server, ne prohlížeč.
 */

export interface ConceptOffer {
  conceptId: string;
  difficulty: 1 | 2 | 3;
  prompt: string;
  /** Jméno člověka, který si pojem vyžádal, nebo null. */
  requestedBy: string | null;
}

/** Tři koncepty, od každé obtížnosti jeden. */
export async function fetchOffer(): Promise<ConceptOffer[]> {
  const { data, error } = await createClient().rpc("offer_concepts");
  if (error) throw error;
  return (data ?? []).map((r: Record<string, unknown>) => ({
    conceptId: r.concept_id as string,
    difficulty: r.difficulty as 1 | 2 | 3,
    prompt: r.prompt as string,
    requestedBy: (r.requested_by as string | null) ?? null,
  }));
}

/**
 * Založí rozepsanou kresbu a vrátí její id.
 *
 * Volá se při odchodu z výběru pojmu, ne až při odeslání — od téhle chvíle
 * server měří dobu kreslení a vzniká tím událost „začal kreslit" oddělená
 * od „odeslal" (krok F3).
 */
export async function startDrawing(conceptId: string): Promise<string> {
  const { data, error } = await createClient().rpc("start_drawing", {
    p_concept_id: conceptId,
  });
  if (error) throw error;
  return data as string;
}

export interface Draft {
  conceptId: string;
  difficulty: 1 | 2 | 3;
  prompt: string;
}

/** Zadání rozepsané kresby. Vrátí null, když kresba není moje nebo už je odeslaná. */
export async function fetchDraft(drawingId: string): Promise<Draft | null> {
  const { data, error } = await createClient().rpc("my_draft", {
    p_drawing_id: drawingId,
  });
  if (error) throw error;
  const row = (data ?? [])[0] as Record<string, unknown> | undefined;
  if (!row) return null;
  return {
    conceptId: row.concept_id as string,
    difficulty: row.difficulty as 1 | 2 | 3,
    prompt: row.prompt as string,
  };
}

/** Odešle kresbu. Server si dopočítá dobu, počet tahů i pokrytí plátna. */
export async function submitDrawing(
  drawingId: string,
  strokes: readonly Stroke[],
  undoCount: number,
): Promise<void> {
  const { error } = await createClient().rpc("submit_drawing", {
    p_drawing_id: drawingId,
    p_device_kind: dominantDevice(strokes),
    p_undo_count: undoCount,
    p_strokes: strokesToPayload(strokes),
  });
  if (error) throw error;
}

export interface MyDrawing {
  drawingId: string;
  prompt: string;
  difficulty: 1 | 2 | 3;
  status: string;
  solvedCount: number;
  thumbsCount: number;
  stars: number;
  createdAt: string;
}

/**
 * Moje kresby.
 *
 * Vědomě sem nechodí počet tipů — z rozdílu proti počtu uhodnutí by autor
 * odvodil, kolikrát ho lidé neuhodli, a to se mu podle `docs/product.md`
 * nezobrazuje. Vynucuje to funkce na serveru, ne tenhle typ.
 */
export async function fetchMyDrawings(): Promise<MyDrawing[]> {
  const { data, error } = await createClient().rpc("my_drawings");
  if (error) throw error;
  return (data ?? []).map((r: Record<string, unknown>) => ({
    drawingId: r.drawing_id as string,
    prompt: r.prompt as string,
    difficulty: r.difficulty as 1 | 2 | 3,
    status: r.status as string,
    solvedCount: r.solved_count as number,
    thumbsCount: r.thumbs_count as number,
    stars: r.stars as number,
    createdAt: r.created_at as string,
  }));
}

/** Tahy pro víc kreseb najednou — na mřížku náhledů, ať to není dotaz na každou. */
export async function fetchStrokes(
  drawingIds: string[],
): Promise<Map<string, Stroke[]>> {
  const byDrawing = new Map<string, Stroke[]>();
  if (drawingIds.length === 0) return byDrawing;

  const { data, error } = await createClient().rpc("strokes_for", {
    p_drawing_ids: drawingIds,
  });
  if (error) throw error;

  for (const row of (data ?? []) as Record<string, unknown>[]) {
    const id = row.drawing_id as string;
    const list = byDrawing.get(id) ?? [];
    list.push(
      strokeFromPayload({
        tool: row.tool as string,
        color: row.color as string,
        width: row.width as number,
        points: row.points as number[],
      }),
    );
    byDrawing.set(id, list);
  }
  return byDrawing;
}

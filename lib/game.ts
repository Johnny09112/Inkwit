import { createClient } from "@/lib/supabase/client";
import { dominantDevice, strokesToPayload, type Stroke } from "@/lib/strokes";

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

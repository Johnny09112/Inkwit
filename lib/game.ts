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

/**
 * Proč server odeslání odmítl. Klíč sedí na hlášku z `submit_drawing()`;
 * aplikace si z něj vybere srozumitelnou větu.
 *
 * Bez tohohle dostane každé odmítnutí stejnou hlášku „zkus to znovu" — a když
 * je příčina trvalá (kresba přes strop), člověk to zkouší donekonečna a hlásí
 * jen „nejde uložit". Přesně to se stalo při zkoušce na iPadu.
 */
export type SubmitRefusal = "empty" | "tooManyStrokes" | "tooManyPoints" | "gone" | "unknown";

export class SubmitError extends Error {
  constructor(readonly reason: SubmitRefusal, message: string) {
    super(message);
    this.name = "SubmitError";
  }
}

function refusalFrom(message: string): SubmitRefusal {
  if (message.includes("žádné tahy")) return "empty";
  if (message.includes("mnoho tahů")) return "tooManyStrokes";
  if (message.includes("mnoho bodů")) return "tooManyPoints";
  if (message.includes("nenalezena")) return "gone";
  return "unknown";
}

/** Odešle kresbu. Server si dopočítá dobu, počet tahů i pokrytí plátna. */
export async function submitDrawing(
  drawingId: string,
  strokes: readonly Stroke[],
  undoCount: number,
  /** Poměr plátna, na kterém kresba vznikla — bez něj se u ostatních roztáhne. */
  aspect: number,
): Promise<void> {
  const { error } = await createClient().rpc("submit_drawing", {
    p_drawing_id: drawingId,
    p_device_kind: dominantDevice(strokes),
    p_undo_count: undoCount,
    p_strokes: strokesToPayload(strokes),
    p_aspect: aspect,
  });
  if (error) throw new SubmitError(refusalFrom(error.message ?? ""), error.message ?? "");
}

export interface MyDrawing {
  drawingId: string;
  /** Poměr plátna, na kterém kresba vznikla. */
  aspect: number;
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
    aspect: (r.aspect as number) ?? 0.68,
    createdAt: r.created_at as string,
  }));
}

/**
 * Smazání vlastní kresby.
 *
 * Měkké — server jen přepne status na `removed`. Tvrdé smazání by vzalo
 * s sebou cizí tipy a čísla, ze kterých se počítá zásoba neuhodnutých kreseb.
 * Vrací `false`, když se nic nezměnilo (cizí kresba nebo už smazaná).
 */
export async function deleteDrawing(drawingId: string): Promise<boolean> {
  const { data, error } = await createClient().rpc("delete_drawing", {
    p_drawing_id: drawingId,
  });
  if (error) throw error;
  return data === true;
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

export interface FeedDrawing {
  drawingId: string;
  authorName: string;
  solvedCount: number;
  thumbsCount: number;
  /** Poměr plátna, na kterém kresba vznikla. */
  aspect: number;
  strokes: Stroke[];
}

/** Další kresba k hádání. Vrací null, když zásoba došla. */
export async function fetchNextDrawing(): Promise<FeedDrawing | null> {
  const { data, error } = await createClient().rpc("next_drawing");
  if (error) throw error;
  const row = (data ?? [])[0] as Record<string, unknown> | undefined;
  if (!row) return null;
  return {
    drawingId: row.drawing_id as string,
    authorName: row.author_name as string,
    solvedCount: row.solved_count as number,
    thumbsCount: row.thumbs_count as number,
    aspect: (row.aspect as number) ?? 0.68,
    strokes: (row.strokes as Record<string, unknown>[]).map((s) =>
      strokeFromPayload({
        tool: s.tool as string,
        color: s.color as string,
        width: s.width as number,
        points: s.points as number[],
      }),
    ),
  };
}

export interface GuessResult {
  correct: boolean;
  attemptNo: number;
  attemptsLeft: number;
  /** První písmeno a délka odpovědi. Jen u nejtěžších pojmů a až po chybě. */
  hint: string | null;
  /** Správná odpověď. Přijde až po uhodnutí nebo vyčerpání pokusů. */
  solution: string | null;
  stars: number;
}

/** Odešle tip. Vyhodnocuje ho server — klient odpověď nezná. */
export async function submitGuess(
  drawingId: string,
  text: string,
): Promise<GuessResult> {
  const { data, error } = await createClient().rpc("submit_guess", {
    p_drawing_id: drawingId,
    p_text: text,
  });
  if (error) throw error;
  const r = (data ?? [])[0] as Record<string, unknown>;
  return {
    correct: r.correct as boolean,
    attemptNo: r.attempt_no as number,
    attemptsLeft: r.attempts_left as number,
    hint: (r.hint as string | null) ?? null,
    solution: (r.solution as string | null) ?? null,
    stars: r.stars as number,
  };
}

/** Palec. Vrací false, když už dnes jeden padl — je to vzácný hlas, ne lajk. */
export async function giveThumb(drawingId: string): Promise<boolean> {
  const { data, error } = await createClient().rpc("give_thumb", {
    p_drawing_id: drawingId,
  });
  if (error) throw error;
  return data as boolean;
}

export interface Notification {
  id: string;
  kind: "guessed" | "thumbed" | "request_filled" | "request_served";
  actorName: string | null;
  prompt: string | null;
  readAt: string | null;
  createdAt: string;
}

/** Upozornění. Cizí akce nad tvojí kresbou nese hlavní retenční hypotézu. */
export async function fetchNotifications(): Promise<Notification[]> {
  const { data, error } = await createClient().rpc("my_notifications");
  if (error) throw error;
  return (data ?? []).map((r: Record<string, unknown>) => ({
    id: r.id as string,
    kind: r.kind as Notification["kind"],
    actorName: (r.actor_name as string | null) ?? null,
    prompt: (r.prompt as string | null) ?? null,
    readAt: (r.read_at as string | null) ?? null,
    createdAt: r.created_at as string,
  }));
}

export async function markNotificationsRead(): Promise<void> {
  await createClient()
    .from("notifications")
    .update({ read_at: new Date().toISOString() })
    .is("read_at", null);
}

export interface Profile {
  displayName: string;
  locale: string;
  abPlayback: boolean;
  drawings: number;
  guesses: number;
  unread: number;
  /** Zůstatek kreditů — součet ledgeru, počítá ho server. */
  credits: number;
  /** Koupené odemčení míchání vlastních barev. */
  hasColorMixer: boolean;
}

export async function fetchProfile(): Promise<Profile | null> {
  const { data, error } = await createClient().rpc("my_profile");
  if (error) throw error;
  const r = (data ?? [])[0] as Record<string, unknown> | undefined;
  if (!r) return null;
  return {
    displayName: r.display_name as string,
    locale: r.locale as string,
    abPlayback: r.ab_playback as boolean,
    drawings: r.drawings as number,
    guesses: r.guesses as number,
    unread: r.unread as number,
    credits: (r.credits as number) ?? 0,
    hasColorMixer: Boolean(r.has_color_mixer),
  };
}

/** Odemčení míchání barev. Cenu i zůstatek hlídá server. */
export async function buyColorMixer(): Promise<void> {
  const { error } = await createClient().rpc("buy_color_mixer");
  if (error) throw error;
}

/**
 * Veřejné klíče konfigurace — odměny se z nich čtou, aby aplikace neukazovala
 * jiná čísla, než jaká server opravdu připisuje (pravidlo 6).
 */
export async function fetchRewards(): Promise<{
  base: Record<string, number>;
  bonus: Record<string, number>;
  mixerPrice: number;
}> {
  const { data, error } = await createClient()
    .from("game_config")
    .select("key, value")
    .in("key", ["reward_draw_base", "reward_draw_bonus", "price_color_mixer"]);
  if (error) throw error;
  const map = Object.fromEntries((data ?? []).map((r) => [r.key, r.value]));
  return {
    base: (map.reward_draw_base as Record<string, number>) ?? { 1: 1, 2: 2, 3: 3 },
    bonus: (map.reward_draw_bonus as Record<string, number>) ?? { 1: 1, 2: 3, 3: 5 },
    mixerPrice: (map.price_color_mixer as number) ?? 25,
  };
}

export interface LeaderboardRow {
  rank: number;
  displayName: string;
  score: number;
  isYou: boolean;
}

export async function fetchLeaderboard(): Promise<LeaderboardRow[]> {
  const { data, error } = await createClient().rpc("daily_leaderboard");
  if (error) throw error;
  return (data ?? []).map((r: Record<string, unknown>) => ({
    rank: r.rank as number,
    displayName: r.display_name as string,
    score: r.score as number,
    isYou: r.is_you as boolean,
  }));
}

/** Vyžádá pojem. Vrací false, když je vyčerpaný denní limit. */
export async function requestConcept(conceptId: string): Promise<boolean> {
  const { data, error } = await createClient().rpc("request_concept", {
    p_concept_id: conceptId,
  });
  if (error) throw error;
  return data as boolean;
}

export async function reportDrawing(drawingId: string, reason: string): Promise<void> {
  const { error } = await createClient().rpc("report_drawing", {
    p_drawing_id: drawingId,
    p_reason: reason,
  });
  if (error) throw error;
}

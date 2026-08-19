/**
 * Mock data pro wireframe implementaci — čísla a jména odpovídají
 * „Inkwit wireframy.dc.html". Nahradí je Supabase, až vznikne backend.
 * Koncepty nesou název per jazyk (koncepty ≠ překlady, pravidlo 4);
 * mock drží obě varianty přímo u záznamu.
 */

export type Difficulty = 1 | 2 | 3;

export interface Concept {
  id: string;
  name: Record<"cs" | "en", string>;
  difficulty: Difficulty;
  credit: number;
}

export const CONCEPTS: Concept[] = [
  { id: "octopus", name: { cs: "chobotnice", en: "octopus" }, difficulty: 1, credit: 1 },
  { id: "blunder", name: { cs: "trapas", en: "blunder" }, difficulty: 2, credit: 2 },
  { id: "nostalgia", name: { cs: "nostalgie", en: "nostalgia" }, difficulty: 3, credit: 3 },
  { id: "carousel", name: { cs: "kolotoč", en: "carousel" }, difficulty: 2, credit: 2 },
];

export function conceptById(id: string): Concept {
  return CONCEPTS.find((c) => c.id === id) ?? CONCEPTS[0];
}

/** Kresby ve frontě hádání. */
export interface FeedDrawing {
  id: string;
  conceptId: string;
  author: string;
  solvedByCount: number;
}

export const FEED: FeedDrawing[] = [
  { id: "d1", conceptId: "octopus", author: "Jana K.", solvedByCount: 3 },
  { id: "d2", conceptId: "carousel", author: "Petr V.", solvedByCount: 8 },
];

export const SUPPLY_BASE = 38;

/** Vyžádané pojmy — retenční mechanika fáze 0. */
export interface ConceptRequest {
  requester: string;
  conceptId: string;
}

export const REQUESTS: ConceptRequest[] = [
  { requester: "Marek", conceptId: "blunder" },
  { requester: "Lucie", conceptId: "nostalgia" },
];

/** Moje kresby. */
export interface MyDrawing {
  id: string;
  conceptId: string;
  solvedByCount: number;
  stars: number;
  thumbs: number;
}

export const MY_DRAWINGS: MyDrawing[] = [
  { id: "m1", conceptId: "octopus", solvedByCount: 4, stars: 2, thumbs: 2 },
  { id: "m2", conceptId: "blunder", solvedByCount: 0, stars: 0, thumbs: 0 },
  { id: "m3", conceptId: "carousel", solvedByCount: 9, stars: 3, thumbs: 5 },
  { id: "m4", conceptId: "nostalgia", solvedByCount: 2, stars: 1, thumbs: 0 },
];

export const MY_COUNTS = { all: 18, solved: 12, waiting: 6 };

/** Žebříčky — tři oddělené metriky, ligy po ~30 hráčích. */
export interface LeaderboardRow {
  rank: number;
  name: string;
  score: number;
  isYou?: boolean;
}

export const LEADERBOARDS: Record<
  "guesser" | "drawer" | "popularity",
  LeaderboardRow[]
> = {
  guesser: [
    { rank: 1, name: "Jana K.", score: 412 },
    { rank: 2, name: "Petr V.", score: 380 },
    { rank: 3, name: "", score: 351, isYou: true },
    { rank: 4, name: "Lucie M.", score: 344 },
    { rank: 5, name: "Tomáš R.", score: 310 },
  ],
  drawer: [
    { rank: 1, name: "Lucie M.", score: 298 },
    { rank: 2, name: "", score: 275, isYou: true },
    { rank: 3, name: "Jana K.", score: 260 },
    { rank: 4, name: "Ondřej B.", score: 244 },
    { rank: 5, name: "Petr V.", score: 231 },
  ],
  popularity: [
    { rank: 1, name: "Tomáš R.", score: 96 },
    { rank: 2, name: "Jana K.", score: 88 },
    { rank: 3, name: "Ondřej B.", score: 71 },
    { rank: 4, name: "", score: 64, isYou: true },
    { rank: 5, name: "Lucie M.", score: 58 },
  ],
};

export const LEAGUE = { league: 12, players: 28, endsInDays: 3 };

export const PROFILE = {
  name: "Jan H.",
  level: 7,
  drawings: 18,
  guesses: 214,
  badgesEarned: 4,
  badgesTotal: 12,
};

/** Barvy kreslení z wireframů — paleta pro kreslíře, ne UI barvy. */
export const RECENT_COLORS = [
  "#2B261F",
  "#B5462F",
  "#E9B44C",
  "#52633A",
  "#3C6E8F",
  "#8A5A8F",
  "#C9756B",
  "#6D6A64",
];


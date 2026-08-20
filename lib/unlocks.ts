/**
 * Co se na kterém levelu odemyká.
 *
 * Jediný zdroj pravdy pro cestu levely v profilu i pro oslavu postupu —
 * kdyby to byly dva seznamy, jeden by se dřív nebo později rozešel s druhým
 * a hráč by dostal gratulaci k něčemu, co v roadmapě nestojí.
 *
 * **Čísla levelů sem chodí z `game_config`**, ne z konstant (pravidlo 6:
 * balanc je serverová konfigurace). Tenhle soubor drží jen pořadí a názvy.
 */

export const UNLOCK_KEYS = ["core", "palette", "mixer", "shapes"] as const;

export type UnlockKey = (typeof UNLOCK_KEYS)[number];

export interface UnlockConfig {
  paletteFullLevel: number;
  mixerLevel: number;
  shapesLevel: number;
}

export interface Unlock {
  level: number;
  key: UnlockKey;
}

/**
 * Všechna odemčení s levelem, na kterém přijdou.
 *
 * Level 1 nese jádro hry — kreslení, hádání a všechny obtížnosti. Není to
 * výplň: je to připomínka, že se nic z toho nikdy gatovat nesmí
 * (`decisions/levely-bez-gati-na-jadro.md`).
 */
export function allUnlocks(cfg: UnlockConfig): Unlock[] {
  return [
    { level: 1, key: "core" },
    { level: cfg.paletteFullLevel, key: "palette" },
    { level: cfg.mixerLevel, key: "mixer" },
    { level: cfg.shapesLevel, key: "shapes" },
  ];
}

/** Co se odemyká právě na tomhle levelu. Prázdné pole je platná odpověď. */
export function unlocksAtLevel(level: number, cfg: UnlockConfig): UnlockKey[] {
  return allUnlocks(cfg)
    .filter((u) => u.level === level)
    .map((u) => u.key);
}

/**
 * Co přibylo mezi dvěma levely — `from` se nepočítá, `to` ano.
 *
 * Skok o víc pater najednou je možný: kdo dlouho nebyl v aplikaci a mezitím mu
 * naskákaly bonusy za uhodnutí, může přeskočit dva levely naráz. Gratulace pak
 * musí vyjmenovat obojí, ne jen to poslední.
 */
export function unlocksBetween(from: number, to: number, cfg: UnlockConfig): Unlock[] {
  return allUnlocks(cfg)
    .filter((u) => u.level > from && u.level <= to)
    .sort((a, b) => a.level - b.level);
}

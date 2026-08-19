/**
 * Hvězdičky za kresbu — kolik jich je z maxima, ne jen číslo.
 *
 * Hvězdičky měří, jak rychle byla kresba uhodnuta: napoprvé tři, napotřetí
 * jedna. Prázdné se kreslí taky, jinak by nebylo poznat, z kolika to je —
 * a v tom je celý smysl grafického zobrazení proti holému „2 hvězdičky".
 *
 * Barvy jsou z palety: plná je `--accent` (medová), prázdná jen obrys.
 */

import { Star } from "lucide-react";

export const MAX_STARS = 3;

export function Stars({
  count,
  size = 22,
  /** Popis pro čtečky. Bez něj by z ikon nebylo poznat nic. */
  label,
}: {
  count: number;
  size?: number;
  label: string;
}) {
  const filled = Math.max(0, Math.min(MAX_STARS, Math.round(count)));

  return (
    <span className="stars" role="img" aria-label={label}>
      {Array.from({ length: MAX_STARS }, (_, i) => (
        <Star
          key={i}
          size={size}
          aria-hidden="true"
          className={i < filled ? "star is-filled" : "star"}
          strokeWidth={2}
        />
      ))}
    </span>
  );
}

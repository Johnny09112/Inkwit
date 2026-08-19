/**
 * Logotyp Inkwit — směr „dokresleno a podtrženo".
 *
 * Převzato z návrhu (`handoff/logo/InkwitLogo.tsx` v projektu „Inkwit vizuální
 * směr"). **Dvě odchylky proti předloze**, obojí kvůli tokenům, které tenhle
 * repozitář opravdu má: barva textu bere `--text-primary` místo `--text`
 * a podtržení `--action-primary` místo `--primary`. Nedefinovaná proměnná by
 * v CSS spadla na dědění a podtržení by zmizelo úplně.
 *
 * `w` je kreslený tah, ne písmeno — právě on odlišuje logotyp od holého textu.
 * Velikost se řídí `font-size` obalu, takže se logo škáluje s okolím.
 */

/** Tah „w" — čtyři oblouky jedním nedokončeným pohybem. */
const W_PATH =
  "M6 8c1 14 5 34 12 48 4 8 9 13 14 11 6-3 10-17 13-31 2-9 4-15 6-15 3 1 4 8 6 17 3 14 7 28 13 30 6 2 12-6 16-16 6-15 8-33 8-44";

/** Podtržení — mírně nepravidelné, ať vypadá dokreslené rukou. */
const UNDERLINE_PATH = "M4 14C40 6 108 5 172 9c10 1 18 3 24 5";

export function InkwitLogo({
  fontSize = "2rem",
  /** Jednobarevná varianta — podtržení převezme barvu textu. */
  mono = false,
  className,
}: {
  fontSize?: string | number;
  mono?: boolean;
  className?: string;
}) {
  return (
    <span
      role="img"
      aria-label="Inkwit"
      className={className}
      style={{
        display: "inline-flex",
        alignItems: "baseline",
        fontFamily: "var(--font-display), sans-serif",
        fontWeight: 800,
        fontSize,
        lineHeight: 1,
        letterSpacing: "-0.045em",
        color: "var(--text-primary)",
      }}
    >
      <span aria-hidden="true">ink</span>
      <span style={{ position: "relative", display: "flex", alignItems: "baseline" }}>
        <svg
          viewBox="0 0 120 78"
          aria-hidden="true"
          style={{
            width: "0.72em",
            height: "0.60em",
            margin: "0 -0.10em 0 -0.03em",
            overflow: "visible",
          }}
        >
          <path
            d={W_PATH}
            fill="none"
            stroke="currentColor"
            strokeWidth={12.5}
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
        <span aria-hidden="true">it</span>
        <svg
          viewBox="0 0 200 22"
          preserveAspectRatio="none"
          aria-hidden="true"
          style={{
            position: "absolute",
            left: "-0.04em",
            bottom: "-0.11em",
            width: "calc(100% + 0.14em)",
            height: "0.15em",
            overflow: "visible",
          }}
        >
          <path
            d={UNDERLINE_PATH}
            fill="none"
            stroke={mono ? "currentColor" : "var(--action-primary)"}
            strokeWidth={9}
            strokeLinecap="round"
          />
        </svg>
      </span>
    </span>
  );
}

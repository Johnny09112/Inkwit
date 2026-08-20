# Paměť — inkwit

> Always-load index (harness auto-injektuje prvních ~200 řádků / 25 KB). Drž KRÁTKÉ — index, ne obsah.
> Mechanika: `BOOTSTRAP.md` · Invarianty: `policies.md` · Plný katalog: `memory/INDEX.md` · Živý stav: `memory/context/project-context.md`

## Feedback (always-load pravidla chování)

## ⇢ ODKUD POKRAČOVAT (2026-08-20)

**Přečti `memory/context/odkud-pokracovat.md` jako první.** Majitel řekl: až
napíše „pokračujeme", jde se na **slova a jednotlivé levely** — v tomhle pořadí.

**Slova hoří:** při třech hráčích zbývá 26 snadných, 13 středních a jen
**16 těžkých** nenakreslených pojmů. Alarm v `/admin` už svítí. Recept na tvorbu
je v `patterns/jak-tvorit-slovni-zasobu.md`.

**Levely mají zatím jen dvě reálná odemčení** (paleta na L2, míchání barev na L3),
levely 4–6 jsou prázdné. Prahy `level_thresholds` v `game_config`.

### Čtyři věci, které se NESMÍ gatovat levelem

Každá padla z jiného důvodu a při další úvaze o levelech se vrátí jako pokušení:

1. **Hádání** — vynucené kreslení zabije metriku 1 z `CLAUDE.md`.
2. **Obtížnosti** — s prodejem levelů je to pay-to-win (pravidlo 3), těžký pojem dá 4× víc.
3. **Vyžádání pojmu** — nese hlavní hypotézu fáze 0 (`docs/plan.md`, blok E).
4. **Přehrání kresby** — běží pod ním A/B test kroku F4.

**Levely se nedají koupit.** Prodává se kosmetika, ne postup.
Podrobně: `decisions/levely-bez-gati-na-jadro.md`, `decisions/kredity-a-odmeny.md`.

## Kde projekt stojí (2026-08-20)

Fáze 0 **nasazená a hratelná**: https://inkwit.vercel.app · Supabase
`iticpkeqirjfwkelhrvl` (eu-central-1, free) · **186 testů DB** (`npm run test:db`)
+ **26 unit** (`npm run test:unit`).

Hotové bloky 0–F, **G rozpracovaný**, **H správa** (`/admin`), **I kredity**,
levely. Zbývá **vlastní SMTP (G4)** a rozeslat pozvánky.

**Tři věci, které se nedají uhodnout z kódu:**
- Migrace pouští Claude sám (`npx supabase db push`), destruktivní ukazuje předem.
- Zadání konceptu je tajemství — klient nečte `concepts` ani `drawings` napřímo.
- `revoke update (sloupec)` v Postgresu nefunguje; práva se udělují po sloupcích.

## Jak používat tuto paměť

- Záznamy (decisions, bugs, patterns, …) jsou on-demand v `memory/` — najdi je přes `memory/INDEX.md`.
- Zapisuj event-triggered (triggery viz projektový CLAUDE.md). „Konec session" neřeš — neexistuje jako trigger.

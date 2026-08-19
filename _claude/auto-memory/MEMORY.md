# Paměť — inkwit

> Always-load index (harness auto-injektuje prvních ~200 řádků / 25 KB). Drž KRÁTKÉ — index, ne obsah.
> Mechanika: `BOOTSTRAP.md` · Invarianty: `policies.md` · Plný katalog: `memory/INDEX.md` · Živý stav: `memory/context/project-context.md`

## Feedback (always-load pravidla chování)

<!-- AUTO:feedback — jeden řádek na soubor z auto-memory/feedback/*.md; formát: - [[slug]] — háček -->
<!-- /AUTO:feedback -->

## Kde projekt stojí (2026-08-19)

Fáze 0 **nasazená a hratelná**: https://inkwit.vercel.app · Supabase
`iticpkeqirjfwkelhrvl` (eu-central-1, free) · 136 testů (`npm run test:db`).
Bloky 0–F hotové, G rozpracované. Zbývá **vlastní SMTP** (krok G4) a rozeslat
pozvánky. Podrobnosti a otevřené body: `memory/context/project-context.md`.

**Tři věci, které se nedají uhodnout z kódu:**
- Migrace pouští Claude sám (`npx supabase db push`), destruktivní ukazuje předem.
- Zadání konceptu je tajemství — klient nečte `concepts` ani `drawings` napřímo.
- `revoke update (sloupec)` v Postgresu nefunguje; u chráněných sloupců musí být test zápisu.

## Jak používat tuto paměť

- Záznamy (decisions, bugs, patterns, …) jsou on-demand v `memory/` — najdi je přes `memory/INDEX.md`.
- Zapisuj event-triggered (triggery viz projektový CLAUDE.md). „Konec session" neřeš — neexistuje jako trigger.

# Paměť — inkwit

> Always-load index (harness auto-injektuje prvních ~200 řádků / 25 KB). Drž KRÁTKÉ — index, ne obsah.
> Mechanika: `BOOTSTRAP.md` · Invarianty: `policies.md` · Plný katalog: `memory/INDEX.md` · Živý stav: `memory/context/project-context.md`

## Feedback (always-load pravidla chování)

## ⇢ ODKUD POKRAČOVAT (2026-08-20)

**Přečti `memory/context/odkud-pokracovat.md` jako první.**

Slova i levely jsou **hotové a nasazené**. Zbývá **vlastní SMTP (krok G4)** —
jediná technická věc, která brání rozeslání padesáti pozvánek. Vestavěný
odesílatel zvládne dvě zprávy za hodinu na všech plánech.

### Čtyři věci, které se NESMÍ gatovat levelem

Každá padla z jiného důvodu a při další úvaze o levelech se vrátí jako pokušení:

1. **Hádání** — vynucené kreslení zabije metriku 1 z `CLAUDE.md`.
2. **Obtížnosti** — s prodejem levelů je to pay-to-win (pravidlo 3), těžký pojem dá 4× víc.
3. **Vyžádání pojmu** — nese hlavní hypotézu fáze 0 (`docs/plan.md`, blok E).
4. **Přehrání kresby** — běží pod ním A/B test kroku F4.

**Levely se nedají koupit.** Prodává se kosmetika, ne postup.
A **kbelík (plošná výplň) se dělat nesmí** — porušuje pravidlo 2.
Podrobně: `decisions/levely-bez-gati-na-jadro.md`, `decisions/kredity-a-odmeny.md`.

## Kde projekt stojí (2026-08-20)

Fáze 0 **nasazená a hratelná**: https://inkwit.vercel.app · Supabase
`iticpkeqirjfwkelhrvl` (eu-central-1, free) · **202 testů DB**
(`npm run test:db`) + **31 unit** (`npm run test:unit`).

Hotové bloky 0–F, **H** správa (`/admin`), **I** kredity, **J** levely a tvary.
Rozpracovaný **G** — zbývá SMTP a rozeslat pozvánky.

**Slovník má 300 pojmů** ve vyrovnaném poměru 100 / 100 / 100. Alarm zásoby
zhasl. **Levely mají čtyři patra**, na čtvrtém se odemykají tvary.

**Čtyři věci, které se nedají uhodnout z kódu:**
- Migrace pouští Claude sám (`npx supabase db push`), destruktivní ukazuje předem.
- Zadání konceptu je tajemství — klient nečte `concepts` ani `drawings` napřímo.
- `revoke update (sloupec)` v Postgresu nefunguje; práva se udělují po sloupcích.
- Ve vývoji **service worker servíruje starý kód** — změna, která „se neprojevila",
  bývá tohle, ne chyba. Odregistrovat SW a smazat cache.

## Jak používat tuto paměť

- Záznamy (decisions, bugs, patterns, …) jsou on-demand v `memory/` — najdi je přes `memory/INDEX.md`.
- Zapisuj event-triggered (triggery viz projektový CLAUDE.md). „Konec session" neřeš — neexistuje jako trigger.

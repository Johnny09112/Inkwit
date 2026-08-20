---
name: odkud-pokracovat
description: Kde pokračovat po 2026-08-20 — slova i levely jsou hotové, zbývá vlastní SMTP a rozeslání pozvánek
type: context
status: active
created: 2026-08-20
updated: 2026-08-20
related: [slovnik-vyrovnany-pomer-obtiznosti, levely-bez-gati-na-jadro, tolerance-preklepu-uznavala-cizi-pojem]
---

# Odkud pokračovat

**Přepsáno 2026-08-20 odpoledne.** Předchozí verze čekala na „pokračujeme"
a zadávala dvě věci: slova a levely. **Obě jsou hotové a nasazené.**

---

## Co se udělalo

### Slova — 120 → 300 pojmů

Vyrovnaný poměr **100 / 100 / 100**, ne původních 58 / 40 / 22. Důvod je
v [[slovnik-vyrovnany-pomer-obtiznosti]]: nabídka bere jeden pojem od každé
obtížnosti, takže se buckety čerpají stejně rychle. Alarm v `/admin` zhasl
(nenakreslených 68 / 73 / 94, práh je 15).

**Při té příležitosti se našla chyba v produkci.** Validátor slovníku hlídal jen
dvojice do čtyř znaků — bezpečnou zónu. Po opravě našel jedenáct dvojic, které
si hra pletla: kdo dostal kresbu ovce a napsal `sleep`, dostal bod.
Viz [[tolerance-preklepu-uznavala-cizi-pojem]].

### Levely — čtyři patra, na posledním tvary

Žebříček se zkrátil ze šesti pater na čtyři (`[0, 10, 25, 50]`) a level 4 dostal
obsah: **tvary — čára, obdélník, elipsa**. Zámek je na serveru.
Viz [[levely-bez-gati-na-jadro]], blok J v `docs/plan.md`.

---

## Co zbývá — v tomhle pořadí

1. **Vlastní SMTP (krok G4).** Pořád jediná technická věc, která brání
   rozeslání pozvánek. Vestavěný odesílatel zvládne **dvě zprávy za hodinu na
   všech plánech**; placený Supabase to nevyřeší.
2. **Rozeslat pozvánky** (kódy v `pozvanky-faze-0.txt`, mimo git) a nechat test běžet.
3. **Uklidit před vyhodnocením:** dva testovací drafty v databázi
   (`0e017896-…`, `84d0f630-…`) plus pár dalších z ověřování — kazí
   `metrics_funnel` jako drop-off „začal kreslit, neodeslal".
4. **Tři otevřená hlášení** v `/admin` — majitel je chtěl odbavit sám.

## Co čeká na data, ne na práci

- **Sink pro kredity** (`J4`). Zůstatek jen roste. Nespěchá: nic se neztrácí,
  a meta-vrstva se podle `CLAUDE.md` nemá stavět dřív, než je ověřeno, že lidé
  dobrovolně kreslí.
- **Kalibrace prahů levelů** (`J5`) a **kalibrace odměn** — obojí je odhad.
- **Přijímané tvary na skutečných tipech** (kroky `B2`/`B3`, pořád `[~]`).
  Obrazovka „Pojmy, které nikdo neuhodl" v `/admin` je na to připravená
  (potřebuje ≥ 3 tipy).

## Čtyři věci, které se levelem gatovat nesmí

Pořád platí a **při další úvaze o levelech se vrátí jako pokušení**:

1. **Hádání** — vynucené kreslení zabije metriku 1 z `CLAUDE.md`.
2. **Obtížnosti** — těžký pojem vydělá 4× víc, je to pay-to-win (pravidlo 3).
3. **Vyžádání pojmu** — nese hlavní hypotézu fáze 0 (blok E).
4. **Přehrání kresby** — běží pod ním A/B test kroku F4.

**Levely se nedají koupit.** Prodává se kosmetika, ne postup.

## A jedna past navrch

**Kbelík (plošná výplň) se dělat nesmí** — porušuje pravidlo 2. Až příště padne
„přidejme kreslicí nástroje", tohle je ta odbočka, do které se dá spadnout.

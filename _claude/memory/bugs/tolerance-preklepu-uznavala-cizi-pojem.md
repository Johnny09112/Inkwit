---
name: tolerance-preklepu-uznavala-cizi-pojem
description: Kontrola slovníku hlídala jen dvojice do čtyř znaků, což je bezpečná zóna; od pěti znaků výš hra uznávala tip patřící jinému pojmu — „sleep" uhodlo ovci
type: bug
status: resolved
created: 2026-08-20
updated: 2026-08-20
related: [jak-tvorit-slovni-zasobu, slovnik-vyrovnany-pomer-obtiznosti]
---

# Tolerance překlepů uznávala tip patřící jinému pojmu

Nalezeno 2026-08-20 při rozšiřování slovníku ze 120 na 300 pojmů. Chyba byla
v produkci od nasazení kroku B4.

## Příznak

Hádající dostal kresbu ovce, napsal `sleep` a hra to uznala jako správně.
Kresba se označila za uhodnutou, autorovi naskočil bonus za první uhodnutí,
`solved_count` narostl — a v odhalení uviděl hádající něco jiného, než napsal.

## Kořen

Prahy tolerance v `private.answer_matches` jsou správně: do 4 znaků přesná
shoda, 5–7 vzdálenost 1, 8+ vzdálenost 2. Chyba byla ve **validátoru**
`check-concepts.mjs`. Ten porovnával jen tvary **do čtyř znaků** — tedy přesně
tu zónu, kde se tolerance nepoužívá a nic se stát nemůže.

**Kontrola hlídala bezpečnou zónu a nebezpečnou nechala bez dozoru.** Chyba
tohoto typu se okem nenajde a s velikostí sady roste kvadraticky.

Po doplnění skutečných prahů našel validátor v nasazených 120 pojmech
**jedenáct dvojic**. Tři z nich mají na OBOU stranách zadání, takže v datech
opravit nešly:

| | | |
|---|---|---|
| `mouse` (myš) | × | `house` (dům) |
| `sheep` (ovce) | × | `sleep` (spánek) |
| `clock` (hodiny) | × | `lock` (zámek) |

## Oprava — v pravidle, ne v datech

Migrace `20260820160000_answer_exact_guard.sql`:

**Tolerance překlepů se nepoužije na tip, který je PŘESNOU odpovědí jiného
pojmu.** Kdo napsal „sleep" na kresbu ovce, se nepřeklepl — napsal jiné slovo,
které umí. Přesná shoda se svým pojmem se vyhodnocuje první, takže na kresbě
spánku „sleep" dál platí.

Pořadí v `answer_matches` je od té doby: **přesná shoda → pojistka → fuzzy.**

Drží to normalizovaný rejstřík `private.answer_index`, který udržuje trigger
nad `public.concept_answers`. Pole se v Postgresu po prvcích indexovat nedá a
normalizovat 300 pojmů za každý tip by bylo dražší než hra sama.

## Co si z toho odnést

- **Kontrola musí hlídat tu zónu, kde chyba vzniká.** Pokud se validátor a
  runtime rozcházejí v prahu, validátor nekontroluje nic.
- Prahy ve validátoru (`FUZZY_EXACT`, `FUZZY_ONE`) musí sedět s `game_config`.
  Jsou to dvě kopie téhož čísla — když se v `game_config` doladí, doladit i tam.
- Zbylých ~55 dvojic po pojistce zůstává jako **upozornění**, ne chyba. Blízkost
  dvou tvarů je většinou znamení, že jeden z nich je zbytečný; třináct takových
  se při té příležitosti vyhodilo (`slůně`, `sovička`, `houska`, `kravál`, …).

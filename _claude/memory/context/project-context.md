---
name: project-context
description: Živý stav projektu inkwit — fáze, milníky, aktuální focus
type: context
status: active
created: 2026-08-18
updated: 2026-08-19
---

# inkwit — živý kontext

> Statické věci (stack, konvence, zákony) jsou v projektovém CLAUDE.md. Tady jen DYNAMICKÉ — co se mění během vývoje. Přepisuj v místě, neapenduj.

## Aktuální stav (2026-08-19)

**Fáze 0 je nasazená a hratelná od začátku do konce.**

- **Živá adresa:** https://inkwit.vercel.app (Vercel, staví se z GitHubu)
- **Databáze:** Supabase `Inkwit`, ref `iticpkeqirjfwkelhrvl`, region `eu-central-1`, **free plán**
- **Repo:** https://github.com/Johnny09112/Inkwit — **veřejné**, 32 commitů
- **Testy:** `npm run test:db` — 136 kontrol, běží na PGlite, nepotřebuje Docker ani síť
- **Slovník:** 120 konceptů, 240 zadání a sad odpovědí v databázi

**Hotové bloky:** 0 (UI), A (základ DB), B (slovník), C (kreslení), D (hádání),
E (vyžádání a upozornění), F (provoz a měření). **G (nasazení) rozpracované.**

Celý tok ověřený naostro na produkci: registrace pozvánkou → nabídka pojmů →
kreslení → uložení → hádání → hvězdičky → upozornění autorovi.

**V databázi jsou reálná data majitele** — tři jeho kresby (slon, ananas,
chameleon, 23–44 tahů, 100–240 s). Nemazat, jsou to první měřená čísla.
Použitá 1 pozvánka z 50.

## Aktuální focus

Zbývá **jediný technický krok k plnému provozu: vlastní SMTP** (krok G4
v `docs/plan.md`, včetně čtyř kritérií, jak ho otestovat).

Pak už je to na majiteli: **rozeslat pozvánky** (kódy jsou v `pozvanky-faze-0.txt`,
mimo git, repo je veřejné) a **nechat test běžet**.

## Kde se čtou výsledky

```sql
select * from private.metrics_funnel;   -- drop-off "začal kreslit" → "odeslal"
select * from private.metrics_return;   -- návrat druhý den KE KRESLENÍ (kritérium ≥ 20 %)
select * from private.metrics_supply;   -- zásoba neuhodnutých (metrika 2)
select * from private.metrics_effort;   -- doba a tahy → kalibrace detekce čmáranic
select * from private.metrics_ab_playback;
```

Pohledy jsou jen pro `service_role`, čtou se ze Supabase studia. Administrátorské
rozhraní se vědomě nestavělo.

## Otevřené body

### Čeká na majitele

1. **Vlastní SMTP** (G4) — vestavěný odesílatel má **2 zprávy za hodinu na všech
   plánech**. Placený Supabase to nevyřeší, dovolí jen upravit šablonu.
2. **Placený Supabase** — zvážit kvůli **stažitelným zálohám** (free je nedovolí;
   výstup fáze 0 je jediný důvod, proč se dělá) a **konci pozastavování projektu**
   po týdnu nízké aktivity. Ne kvůli poště.
3. **Zálohy** — než v DB budou data z testu, naplánovat `pg_dump` na vlastní disk.
4. **Tmavý režim** — nerozhodnuto, z ovesné palety se neodvodí 1:1.
5. **Kolik neuhodnutí do archivace** (otázka #3 v `roadmap.md`).

### Známé nedodělky

- **Nahlášené kresby** se řeší ručně ze studia, obrazovka pro to není.
- **V databázi zůstala testovací rozepsaná kresba** `0e017896-e357-4b53-bb6f-46168fb29521`
  (účet Johnny09112, 2026-08-19 16:46). Vznikla při ověřování vzhledu, smazat ji
  z Supabase studia — jinak se v `metrics_funnel` tváří jako drop-off „začal
  kreslit, neodeslal". Starší draft `84d0f630-…` z dřívějšího testování tam byl
  už předtím, ten má stejný problém.

### Vyřešeno 2026-08-19 (vzhled)

- **Kontrast** — `--text-muted` na `--bg-app` opraven na `--text-secondary`,
  změřeno 4.04 → **8.19**. Míst bylo víc než jen navigace: přibyly `/pick`,
  `/mine`, `/leaderboards` a přes `.t-label` i formuláře na `/login` a `/reset`.
  Detaily a postup opakovaného měření v `_archive/kontrast-text-muted-na-pozadi.md`.
- **Mazání kresby** — tlačítko palety se přesunulo na začátek řádku barev, trash
  dostal oddělovač a **dvoukrokové potvrzení** (druhé klepnutí, otázka se po 4 s
  sama zavře).
- **Leváci** — přepínač „Pravá / Levá" v profilu, strana svislé lišty na tabletu
  jde za ním. Viz `decisions/predvolby-zarizeni-v-localstorage.md`.
- **Tlačítko přehrání** — má popisek místo holé ikonky; stejně tak palec
  a nahlášení vedle něj. **Neověřeno v prohlížeči:** účet, pod kterým se testovalo,
  je v A/B skupině bez přehrání (`ab_playback = false`), takže se to tlačítko
  nezobrazilo. Sousední dvě ve stejném řádku vykreslená byla.

### Otevřené rozpory v zadání (nespěchá)

1. **Relay ve školním tenantu × pravidlo 1** — sdílené plátno je stejný kanál mezi
   žáky jako volná zpráva. *Fáze 3.*
2. **Surge × žebříček** — dává surge body do žebříčku, nebo jen kredity mimo něj?
   *Fáze 1.*

## Co je dobré vědět, než na tom začneš dělat

- **Migrace pouští Claude sám** přes `npx supabase db push` — CLI má přihlášení
  z majitelova `supabase login`. Destruktivní migrace se ukazují předem.
- **Zadání konceptu je tajemství hry.** Klient nečte `concepts`, `concept_locales`
  ani `concept_answers`, a ani `drawings` napřímo — všechno jde přes RPC.
  Viz `decisions/tajemstvi-hry-v-schematu.md`.
- **Pomocné funkce pro RLS patří do schématu `private`**, ne `public`.
  Viz `patterns/rls-pomocne-funkce-mimo-public.md`.
- **U každého sloupce, který uživatel měnit nesmí, musí být test zápisu.**
  `revoke update (sloupec)` nefunguje — viz `bugs/revoke-na-sloupec-nefunguje.md`.
- **Advisor hlásí několik věcí trvale a je to záměr** — seznam v
  `patterns/rls-pomocne-funkce-mimo-public.md`.
- **Testy nechytnou chyby v UI.** Visící hláška po uhodnutí i syrový klíč
  překladu se našly až proklikáním. U obrazovek zelené testy nestačí.

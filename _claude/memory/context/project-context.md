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
- **Dva testovací drafty v databázi** — `0e017896-…` (2026-08-19 16:46) a starší
  `84d0f630-…`. V knihovně už nevadí (rozepsané se neukazují), ale v
  `metrics_funnel` se počítají jako drop-off „začal kreslit, neodeslal".
  Před vyhodnocením testu je smazat ze studia.
- **Přehrání kresby se v tomhle prostředí nedá ověřit.** Náhledový prohlížeč
  běží skrytý a `requestAnimationFrame` v něm nefiruje vůbec (změřeno: 0 snímků
  za 1,2 s). Animace se proto nerozběhne a plátno zůstane prázdné — není to
  chyba kódu. Přehrání se musí zkoušet v běžném prohlížeči.

### Přidáno 2026-08-19 (obrazovka po uhodnutí)

- **Uhodnutí se pozná animací** — pojem přijede, hvězdičky naskočí po sobě,
  kolem kresby probleskne olivový prstenec. Respektuje `prefers-reduced-motion`.
- **Hvězdičky graficky** (`components/Stars.tsx`), včetně prázdných. Pozor na
  barvy — viz `patterns/hvezdicky-a-graficke-hodnoty.md`.
- Pojem, hvězdičky i řádek akcí **na střed**, autor na vlastní menší řádek.
- **Palec** je teď hlavní tlačítko řádku a po klepnutí zůstane medově plný.
- **Nahlášení má dialog s důvodem.** Do teď posílalo natvrdo „nevhodný obsah"
  a jen tiše zešedlo. Viz `decisions/nahlaseni-s-duvodem.md`.
- `.modal` dostal strop výšky a rolování — stejná past jako u panelu barev.

### Přidáno 2026-08-19 (logo a ikony)

- **Logotyp z návrhu** místo textového „Inkwit" — `components/InkwitLogo.tsx`,
  kreslené `w` jako SVG tah a podtržení pod „wit". Nasazeno na `login`, `reset`
  a v hlavičce `AppShell`.
- **Ikony**: tři SVG v repu, PNG se z nich rastrují přes `sharp`. Favikon,
  apple-touch, `any` i `maskable` varianty, manifest doplněn.
- `sw.js` má `CACHE = "inkwit-v2"`, jinak by lidem zůstala stará ikona.
- Zdroj: projekt „Inkwit vizuální směr" na claude.ai/design, složka `handoff/`.
  Viz `decisions/logo-a-ikony-z-navrhu.md`.

### Opraveno 2026-08-19 (iPad: ukládání kresby)

- **Strop bodů platil třetinový** — `submit_drawing` porovnávala délku plochého
  pole se stropem počtu bodů, takže limit byl 20 000 místo 60 000. Na 120Hz
  tabletu se dal potkat. Opraveno + tři testy.
  Viz `bugs/strop-bodu-se-pocital-tretinovy.md`.
- **Odmítnutí serveru se teď pojmenuje.** Do teď každé selhání ukázalo „Odeslání
  se nepovedlo, zkus to znovu" — u trvalé příčiny to člověka nechá zkoušet
  donekonečna. `submitDrawing()` vrací `SubmitError` s důvodem.
- **Zapomenutý prst už nezamkne kreslení.** Primární `pointerdown` uklidí
  evidenci prstů a přibylo `onLostPointerCapture`. Na iOS se ztracený `pointerup`
  stává (dlaň, systémové gesto) a bez úklidu by každý další dotyk vypadal jako
  gesto.
- **Nereprodukováno:** na simulovaném iPadu 834 × 1194 tlačítko Odeslat funguje
  včetně potvrzení a odeslání. Výše uvedené jsou opravené kandidáti, ne potvrzená
  příčina.

### Opraveno 2026-08-19 (paleta, druhé kolo)

- **Paleta vyjela mimo obrazovku** na iPhonu — obal dlaždic s `aspect-ratio`
  roztáhl stopy mřížky. Obal pryč, stopy `minmax(0, 1fr)`, `align-items: start`.
  Ověřeno na šířkách 320 až 1024.
- **Na iPadu nešlo uložit barvu** — panel neměl strop výšky ani rolování, takže
  tlačítko Uložit skončilo pod klávesnicí iOS bez cesty k němu.
  Teď `max-height: calc(100dvh - 24px)` a `overflow-y: auto`.
- **Ozubené kolečko odstraněno** i s režimem úprav. Barvu teď nejde odebrat,
  jen nahradit u plné palety.
- Ukázka vybrané barvy zvětšena z 26 na 44 px.
- **Vznikla `/playground`** — vývojová obrazovka kreslicích komponent bez
  přihlášení. Viz `patterns/vyvojova-obrazovka-playground.md`.

### Přidáno 2026-08-19 (paleta barev)

- **Vlastní paleta se ukládá** (localStorage, 23 barev + tlačítko přidat = 8 × 3).
  Do teď se neukládala vůbec — byla to konstanta v `lib/mock.ts`.
- **Kruh barev** pod tlačítkem „+": odstín a sytost tažením, jas posuvníkem,
  hex se přesunul sem z panelu.
- **Kolečko u palety oživeno** jako režim úprav s křížky. Do teď to byla mrtvá
  ikona bez obsluhy.
- Na umístění se ptá, **až když je paleta plná**; jinak barva padne do volného místa.
  Viz `decisions/paleta-barev-a-vyber-vlastni.md`.
- **Neověřeno v prohlížeči** — panel barev je jen na kreslicí obrazovce, kam se
  náhledový prohlížeč bez session nedostane. Ověřené jsou převody barev
  (19 testů `npm run test:unit`), typecheck a build.

### Přidáno 2026-08-19 (gesta a dotyk)

- **Dlouhý stisk už nevybírá text.** iOS Safari nad plátnem i paletou otevíral
  nabídku „Kopírovat". Řeší to `user-select` a `-webkit-touch-callout`, ne PWA.
  Viz `patterns/ios-dlouhy-stisk-vybira-text.md`.
- **Gesta na plátně:** jeden prst kreslí, dva přibližují a posouvají (1× až 8×).
  Přiblížení je jen zobrazení — body se dál ukládají v poměrných souřadnicích.
  Matematika je v `lib/canvasView.ts` a má vlastní testy: `npm run test:unit`
  (9 testů, vestavěný runner Node, žádná nová závislost).
  Viz `decisions/gesta-a-vyrez-platna.md`.
- **Neověřeno v prohlížeči:** náhledový prohlížeč nemá session, takže se do něj
  kreslicí obrazovka nedostane. Ověřená je matematika výřezu (testy) a vypnutý
  výběr textu (změřeno na `/login`). Samotné prsty na plátně a nabídku po dlouhém
  stisku otestuje až telefon.

### Přidáno 2026-08-19 (mobilní plátno)

- **Šipkové tlačítko `panMode` odstraněno** — jen vypínalo kreslení, žádný posun
  ani zoom v kódu nebyl. Pozůstatek wireframu. S ním i klíče `tools.move`
  a `tools.zoom` z překladů.
- **Lišta nástrojů má dva řádky místo tří:** barvy, pak guma — posuvník — štětec.
  Karta měří 123 px, plátno 515 px při 375×812.
- **Zpět a náhled plavou v rohu plátna** (36 px ikony), náhled má
  `Maximize2`/`Minimize2` místo oka. Náhled přidá plátnu 147 px.
- **Patka:** Smazat jako čtverec 54 × 54 vlevo, Odeslat vyplní zbytek.
  Sdílená proměnná `--footer-control` — `aspect-ratio` ve flex řádku nefunguje,
  šířka se vyřeší dřív, než se výška roztáhne.
- **Štítek obtížnosti na střed** — `.badge` má `align-self: flex-start`, což
  přebíjelo `align-items: center` na kontejneru. A stejný zlatý štítek je teď
  i na výběru pojmu, kde byla obtížnost jen textem.

### Přidáno 2026-08-19 (knihovna kreseb)

- **Prázdné dlaždice v „Moje" byly rozepsané kresby.** `my_drawings()` je teď
  nevrací. Řádek v databázi zůstává — `metrics_funnel` na něm stojí.
- **Varování při odchodu z rozdělané kresby** — křížek se s tahy na plátně
  nejdřív zeptá, prázdné plátno pustí rovnou.
- **Mazání vlastní kresby** — měkké, `status = removed`, RPC `delete_drawing()`.
- **Detail kresby** — zvětšení, přehrání, uhodlo / palce / hvězdičky / datum.
  **Počet pokusů tam vědomě není** (majitelovo rozhodnutí 2026-08-19).
  Viz `decisions/knihovna-kreseb-a-mazani.md`.

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

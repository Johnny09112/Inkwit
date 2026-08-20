---
name: prepnuti-zalozky-zamrzlo-bez-hranice-nacitani
description: Přepnutí záložky se na půl vteřiny až dvě zaseklo — App Router drží starou obrazovku, dokud nemá payload nové, když u ní není loading.tsx
type: bug
status: resolved
created: 2026-08-20
updated: 2026-08-20
---

# Přepnutí záložky zamrzlo, protože chyběla hranice načítání

Nahlásil majitel 2026-08-20: *„Přepínání v menu mezi Kreslit/Hádat/Moje/Žebříčky
trvá extra-dlouho."*

## Co příznak rozhodl

Nejcennější věta celého vyšetřování byla jeho odpověď na otázku, **co dělá
obrazovka**: *„Chvíli (0,5–2 s) se nic neděje, stránka nezmizí a pak se to
přepne."*

- Kdyby stránka problikla → plná navigace prohlížeče.
- Kdyby zůstala lišta a obsah byl prázdný → čekání na data z databáze.
- **Stará obrazovka drží a nic se neděje** → zamrzlá navigace.

Bez toho rozlišení jsem měl tři hypotézy a dvě z nich byly špatné.

## Kořen

App Router **nepotvrdí přechod, dokud nemá payload nové trasy** — pokud u ní
není Suspense hranice, tedy `loading.tsx`. V projektu nebyla ani jedna
(`ls app/[locale]/*/loading.tsx` → nic). Celá prodleva se odehrávala se starou
obrazovkou na displeji a bez jakékoli zpětné vazby.

Oprava: `loading.tsx` pro pět obrazovek + `components/shell/ScreenSkeleton.tsx`.

**Kostra si musí vykreslit lištu sama.** `AppShell` sedí uvnitř jednotlivých
stránek, ne v layoutu, takže by při přepínání navigace mizela.

## Dvě hypotézy, které padly — a proč je dobře, že se neopravovaly

1. **„Každá datová funkce volá `createClient()`, takže vzniká hromada
   GoTrueClientů, které se serializují na zámku autentizace."** Znělo to velmi
   pravděpodobně. Jenže `createBrowserClient` z `@supabase/ssr` je v prohlížeči
   **singleton by default** (`shouldUseSingleton` v `createBrowserClient.js`,
   verze 0.12.4). Opakované volání vrací tutéž instanci. Kdybych to „opravil",
   přepsal bych šestnáct míst za nic.
2. **„Service worker rozbíjí RSC požadavky."** Nerozbíjí — všechno mimo
   `/_next/static/` jen propouští přes `fetch()`.

## Co zůstalo nedořešené

- **`/mine` má řetězení dvou dotazů** — nejdřív kresby, pak jejich tahy.
  Kostra to zakryje, ale dvě cesty tam a zpátky za sebou tam pořád jsou.
- **Mezi přepnutími se nic necachuje.** Návrat na záložku platí plnou latenci
  znovu. Kdyby si obrazovky držely poslední data a načítaly na pozadí, byl by
  návrat okamžitý.

## Poznámka k ověřování

Navigace je za přihlášením a heslo zadávat nesmím, takže **jsem to sám změřit
nemohl**. Kostru jsem ověřil dočasnou sondou pod `/playground` (vykreslila se
i s lištou, titulkem a hlášením pro čtečku) a sondu zase smazal. Zbytek
potvrzuje majitel po nasazení.

**Po smazání stránky zůstane v `.next/types` vygenerovaný typ** a `tsc` pak
hlásí chybu na neexistující modul. Smazat ten adresář, není to chyba v kódu —
příbuzné [[next-cache-rozbita-buildem]].

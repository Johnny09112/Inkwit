---
name: vyvojova-obrazovka-playground
description: /playground pouští kreslicí komponenty bez přihlášení, aby šly prohlédnout v prohlížeči; v produkci ji notFound() vypne napevno a middleware ji nepouští
type: pattern
status: active
created: 2026-08-19
updated: 2026-08-19
---

# Vývojová obrazovka `/playground`

**Proč vznikla:** plátno i panel barev žijí za přihlášením. Náhledový prohlížeč
nemá session a **účet si založit nesmím** — zakládání účtů a zadávání hesel do
přihlášení je zakázaná akce, takže by mi testovací účet stejně nepomohl.
Bez playgroundu se veškeré UI kreslení posílalo majiteli neviděné.

`app/[locale]/playground/page.tsx` pustí `DrawingCanvas` a `ColorSheet` nasucho:
žádný server, žádný zápis do databáze, žádný záznam v `metrics_funnel`.

## Dvě pojistky, aby se to nedostalo ven

1. **Stránka sama**: `if (process.env.NODE_ENV !== "development") notFound();`
   Next tuhle proměnnou při překladu dosadí, takže v produkčním balíčku zbude
   `function j(){(0,e.notFound)(); …}` — volání bez podmínky. *Ověřeno čtením
   `.next/server/app/[locale]/playground/page.js`.*
2. **Middleware**: `/playground` je v `PUBLIC_PATHS` jen ve vývoji. V produkci
   nepřihlášeného odkloní na `/login`.

## Jak se v něm měří šířky

Náhledový prohlížeč běží skrytý a `resize_window` se na stránce neprojeví —
`innerWidth` zůstane na svém. Šířky telefonu se proto zkoušejí tak, že se
panelu nastaví `style.width` na `šířka okna − 24` a měří se, jestli dlaždice
nepřesahují jeho pravou hranu. Ověřeno na 320 / 375 / 390 / 430 / 768 / 1024.

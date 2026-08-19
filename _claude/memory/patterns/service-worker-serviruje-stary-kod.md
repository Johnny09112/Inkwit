---
name: service-worker-serviruje-stary-kod
description: Ve vývoji drží service worker z PWA staré balíčky a stránka pak ukazuje kód, který v souborech dávno není — vypadá to jako by se změna neprojevila
type: pattern
status: active
created: 2026-08-19
updated: 2026-08-19
---

# Service worker ve vývoji servíruje starý kód

**Příznak:** ve zdroji je změna, `npm run typecheck` ji vidí, dev server ji
přeloží — a prohlížeč pořád vykresluje starou verzi. V DOM jsou elementy, které
v JSX už nejsou.

Stálo to jedno smazání `.next` a restart serveru navíc, než se ukázalo, že cache
není v Nextu, ale v prohlížeči.

**Příčina:** service worker z kroku G1 cachuje buildové soubory
(cache `inkwit-v1`). V produkci mají obsahový hash v názvu, takže nová verze má
nové jméno a problém nenastane. **Ve vývoji se jména opakují**, takže SW vrací
staré chunky.

**Náprava v prohlížeči:**

```js
(await navigator.serviceWorker.getRegistrations()).forEach(r => r.unregister());
(await caches.keys()).forEach(n => caches.delete(n));
```

Pak načíst stránku znovu.

**Nezaměňovat s** [[next-cache-rozbita-buildem]] — ta se hlásí chybami
`Cannot find module './vendor-chunks/*.js'` v logu serveru. Tahle je tichá.

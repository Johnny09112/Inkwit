---
name: next-cache-rozbita-buildem
description: npm run build za běhu dev serveru přepíše .next a dev pak hlásí "Cannot find module ./vendor-chunks/*.js" — vypadá to jako chyba v kódu, ale je to jen cache
type: pattern
status: active
created: 2026-08-19
updated: 2026-08-19
---

# `npm run build` za běhu dev serveru rozbije `.next`

**Příznak:** dev server začne na každé stránce hlásit

```
Error: Cannot find module './vendor-chunks/next.js'
Require stack: C:\Projekty\inkwit\.next\server\webpack-runtime.js
```

a v prohlížeči k tomu `Element type is invalid` nebo prázdná stránka. Vypadá
to jako rozbitý import v komponentě, kterou jsi právě psal — a hodinu se hledá
chyba, která tam není.

**Příčina:** produkční build zapisuje do stejného `.next` jako běžící dev
server. Přepíše vendor chunky, na které si dev server drží odkazy, a ty už
nesedí.

**Náprava:** zastavit dev server, `rm -rf .next`, spustit znovu.

**Jak se tomu vyhnout:** typecheck a testy se pouštět kdykoliv, ale `npm run
build` **až po zastavení dev serveru**. Ověřování v prohlížeči a produkční
build se nedají prokládat.

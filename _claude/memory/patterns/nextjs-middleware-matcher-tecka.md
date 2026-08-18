---
name: nextjs-middleware-matcher-tecka
description: V Next.js middleware matcheru nefunguje escapovaná tečka \. uvnitř custom skupiny — path-to-regexp zbaští backslash a lookahead pak odmítne všechno; použij [.]
type: pattern
status: active
created: 2026-08-18
updated: 2026-08-18
related: []
---

# Next.js middleware matcher: tečka jako [.], ne \.

**Kontext:** Standardní next-intl matcher `"/((?!api|_next|_vercel|.*\..*).*)"`
v Next 15.5.23 nefungoval — middleware běžel jen pro `/`, každá delší cesta
(`/guess`) dostala 404, protože spadla do `[locale]` segmentu jako neexistující
locale.

**Root cause:** Nextem bundlovaný `path-to-regexp` při parsování custom skupiny
`(...)` v matcheru zbaští zpětné lomítko z `\.`. Z `.*\..*` se stane `.*..*`,
což matchuje KAŽDÝ řetězec o ≥ 2 znacích — negative lookahead pak odmítne
všechno kromě `/`. Ověřeno přímo:
`pathToRegexp('/((?!.*\..*).*)')` → `/^(?:\/((?!.*..*).*))...$/`.

**Fix:** tečku psát jako character class — `"/((?!api|_next|_vercel|.*[.].*).*)"`.
Character class path-to-regexp nechá být. Viz `middleware.ts`.

**Pozn.:** stejná past číhá kdekoliv v `config.matcher`, ne jen u next-intl.

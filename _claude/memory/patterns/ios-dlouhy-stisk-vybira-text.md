---
name: ios-dlouhy-stisk-vybira-text
description: Dlouhý stisk v iOS Safari označí text a otevře nabídku Kopírovat i nad plátnem a tlačítky; řeší to user-select a -webkit-touch-callout, ne PWA
type: pattern
status: active
created: 2026-08-19
updated: 2026-08-19
---

# Dlouhý stisk v iOS Safari vybere text i nad plátnem

**Příznak:** na iPhonu se při delším podržení prstu na kreslicím plátně označí
celá oblast namodro a vyjede systémová nabídka „Kopírovat · Hledat výběr ·
Vyhledat". Vypadá to jako omezení webové aplikace proti nativní.

**Není to omezení PWA.** iOS Safari umí výběr textu a systémovou nabídku vypnout:

```css
.draw-screen, button, .swatch, .tabbar {
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  user-select: none;
}
```

Samotné `touch-action: none` **nestačí** — to řeší posouvání stránky, ne výběr.

**Nezapomenout na opačný směr.** Pole pro psaní a text, který má jít označit, si
musí výběr vzít zpátky (`user-select: text`), jinak se z aplikace nedá nic
zkopírovat ani napsat.

**Ověřování v Chromiu má hranici:** `getComputedStyle` `-webkit-touch-callout`
nevrací, je to vlastnost WebKitu. `user-select` zkontrolovat jde (ověřeno:
tlačítka `none`, pole `text`), ale samotnou nabídku po dlouhém stisku otestuje
až skutečný iPhone.

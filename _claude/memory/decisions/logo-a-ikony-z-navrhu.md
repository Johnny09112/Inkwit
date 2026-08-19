---
name: logo-a-ikony-z-navrhu
description: Logotyp „ink[w]it" je React komponenta s kresleným w a podtržením, ikony se rastrují ze tří SVG přes sharp; z návrhu se převzalo vše kromě názvů tokenů
type: decision
status: active
created: 2026-08-19
updated: 2026-08-19
related: [paleta-oves-a-oliva-a-fonty, pisma-self-host-a-ofl]
---

# Logotyp a ikony z návrhového projektu

**Zavedeno 2026-08-19** z projektu „Inkwit vizuální směr"
(claude.ai/design, `5cca46cb-05ef-4a76-bcd7-692ba12c8747`), složka `handoff/`.
Do té doby bylo logo všude jen textové „Inkwit" a ikona dočasné „I".

## Logotyp je komponenta, ne obrázek

`components/InkwitLogo.tsx`: text „ink" + **kreslené `w` jako SVG tah** + „it",
podtržené pod „wit". Právě to `w` odlišuje logotyp od holého textu.

Velikost se řídí `font-size` obalu, takže se logo škáluje s okolím — v hlavičce
aplikace jede na `--text-title`, na přihlašovací obrazovce na 42 px.

**Dvě odchylky proti předloze.** Návrh používal `var(--text)` a `var(--primary)`,
což jsou tokeny, které tenhle repozitář nemá. Přepsáno na `--text-primary`
a `--action-primary`. Nedefinovaná proměnná v CSS spadne na dědění, takže by
podtržení zmizelo úplně a nikdo by si toho nemusel všimnout.

Nasazeno na: `login`, `reset`, hlavička `AppShell`. Třídy `.auth-logo`
a `.shell-logo` tím osiřely a byly smazány.

## Ikony se rastrují ze SVG, ne stahují

V repu jsou **tři SVG** (`icon.svg`, `icon-maskable.svg`, `favicon.svg`) a PNG
se z nich vyrábí `sharp`, který v projektu už je (závislost Nextu):

```js
sharp(fs.readFileSync(src), { density: 384 }).resize(size, size).png()
```

Vzniká: `apple-touch-icon.png` (180), `icon-192/512.png`,
`icon-maskable-192/512.png`. `favicon-16/32.png` jsou z návrhu — **v 16 px se
podtržení vypouští**, což rastr z SVG neudělá.

**Proč rastrovat a nekopírovat:** base64 velkých PNG přes kontext je drahé a
hlavně nespolehlivé — při prvním pokusu se blob přepsal špatně. Rastr ze SVG na
disku je přesný a opakovatelný. *Ověřeno:* vlastní rastr `favicon.svg` na 32 px
proti PNG od návrháře má průměrnou odchylku kanálu **1,36 / 255**, tedy jen
vyhlazení hran.

## Co k tomu patří

- `manifest.webmanifest` má teď PNG i `maskable` položky.
- `metadata.icons` v `app/[locale]/layout.tsx` — SVG první, PNG jako záloha.
  **Apple ikona musí být PNG**, iOS vektor na plochu nevezme.
- `sw.js`: `CACHE` bumpnuto na `inkwit-v2`, jinak by lidem zůstala stará ikona
  v cache. Precache `/icon.svg` platí dál, jen soubor má nový obsah.

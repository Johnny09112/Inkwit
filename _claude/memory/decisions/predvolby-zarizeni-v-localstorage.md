---
name: predvolby-zarizeni-v-localstorage
description: Kreslicí ruka (strana lišty nástrojů) žije v localStorage, ne ve sloupci profiles — vlastnost zařízení, ne účtu; migrace kvůli vzhledu se nevyplatí
type: decision
status: active
created: 2026-08-19
updated: 2026-08-19
related: [paleta-oves-a-oliva-a-fonty, tajemstvi-hry-v-schematu]
---

# Předvolby vzhledu patří zařízení, ne účtu

**Rozhodnuto 2026-08-19** (majitel vybral ze tří variant) při opravě toho, že
svislá lišta nástrojů na tabletu byla natvrdo vpravo a leváci přes ni kreslili.

## Co se zvolilo

Přepínač „Pravá / Levá" v nastavení profilu, hodnota v `localStorage`
pod klíčem `inkwit.hand`. Mechanika je v `lib/prefs.ts`.

## Proč ne sloupec v `profiles`

Sloupec by se přenesl mezi zařízeními, ale stál by migraci, RPC na zápis a test —
a to všechno kvůli tomu, na které straně visí lišta. **Kreslicí ruka je navíc
vlastnost toho, jak člověk drží konkrétní tablet**, ne vlastnost účtu: na
telefonu je lišta celou šířkou pod plátnem a preference se neuplatní vůbec.

Přehodnotit, až se ukáže, že lidé přenastavují na každém zařízení znovu.

## Dvě věci, které z toho plynou pro kód

1. **Číst se smí až po připojení komponenty.** Na serveru `localStorage`
   neexistuje a rozdíl mezi serverovým a klientským výstupem React ohlásí jako
   chybu hydratace. Hook `useHand()` proto do prvního renderu vždycky vrací
   `"right"`.
2. **Změna se rozesílá vlastní událostí.** `storage` se ve *stejné* záložce
   neodpaluje, takže profil a plátno by se rozešly. `writeHand()` posílá
   `CustomEvent("inkwit.hand")`, `useHand()` poslouchá obojí.

## Kam to nesahá

Tohle je předvolba **vzhledu**. Nic, co ovlivňuje férovost, průběh hry nebo
měření, do `localStorage` nepatří — klientu se nevěří nic (viz `CLAUDE.md`).

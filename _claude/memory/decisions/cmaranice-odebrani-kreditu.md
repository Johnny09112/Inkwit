---
name: cmaranice-odebrani-kreditu
description: Majitelův návrh trestu za čmáranice — potvrzení při odeslání, varování a odebrání kreditů, když kresbu nikdo třikrát neuhodne; schváleno se třemi výhradami, zatím nepostaveno
type: decision
status: pending
created: 2026-08-20
updated: 2026-08-20
related: [preskoceni-vracelo-tutez-kresbu, kredity-a-odmeny]
---

# Čmáranice: odebrání kreditů za nepochopenou kresbu

**Navrhl majitel 2026-08-20:**

> Poznačíme si, když hráč udělá rychlou čmáranici = odklikne, že to chce
> opravdu publikovat. Doplníme informaci, že pokud to nikdo neuhodne, může
> přijít o získané kredity za tuto kresbu. Pokud to nikdo 3× neuhodne, pak mu
> opravdu budou kredity odmazány.

**Stav: schváleno v principu, nepostaveno.** Zatím jen zapsáno.

## Proč to dává smysl

- **Staví na tom, co už existuje.** `looksRushed()` v `lib/strokes.ts` (méně než
  tři tahy nebo pod osm vteřin) už dnes ukazuje kontrolní krok před odesláním.
  Stačí zapamatovat, že jím člověk prošel.
- **Nepotřebuje lidskou obsluhu.** Vyhodnotí se samo při vyčerpání pokusů
  posledního hádajícího. Žádný cron, žádná fronta — přesně to, co `CLAUDE.md`
  vyžaduje.
- **Trest je opožděný a úměrný.** Nebere se víc, než co ta kresba vynesla.

## Tři výhrady, které se musí vyřešit před stavbou

1. **„Neuhodne" musí znamenat „někdo to zkusil a nedal to", ne „nikdo to
   neviděl".** Kresba leží neuhodnutá i proto, že se k ní nikdo nedostal —
   ve fázi 0 s padesáti lidmi je to běžný stav. Podmínka: **tři různí hádající
   vyčerpali všechny pokusy** a neuhodli.

2. **Nesmí to trestat těžké pojmy.** Těžká kresba zůstane neuhodnutá i když je
   dobrá, a vydělává 4× víc — plošně by to bralo kredity právě těm, kdo si
   troufli na těžké. Proto **jen kresby s příznakem rychlé čmáranice**, ne
   všechny neuhodnuté. Majitel to tak navrhl a je to ta správná polovina.

3. **Zůstatek nesmí spadnout pod nulu.** Odebrat jde **nejvýš to, co ta kresba
   vynesla, a nejvýš do výše aktuálního zůstatku.** Je to vrácení odměny, ne
   pokuta. Level to neohrozí — počítá se z kladných pohybů, takže záporný zápis
   ho nesnižuje.

## Co to nesmí rozbít

- **Metriku 2** (zásoba neuhodnutých kreseb na hádače). Neuhodnutá kresba je
  zásoba, ne vada. Trest mířený na neuhodnutí obecně by tlačil lidi kreslit jen
  snadné pojmy a zásobu vysušil.
- **Měření fáze 0.** Zavádět trest uprostřed měření, jestli lidé kreslí
  dobrovolně, mění to, co se měří. Zvážit, jestli to nepočká na data.

## Pozor na záměnu

Majitel to napsal jako reakci na „cenu za nesmyslné tipy". To je ale **jiná
věc**: tipy jsou vstup hádajícího, čmáranice výstup kreslíře. Díra
s nesmyslnými tipy (`next_drawing()` vylučuje i kresbu, na kterou člověk napsal
cokoli) tímhle vyřešená není — viz [[preskoceni-vracelo-tutez-kresbu]].

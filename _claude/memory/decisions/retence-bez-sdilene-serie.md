---
name: retence-bez-sdilene-serie
description: Sdílená série z Draw Something se nenahrazuje; retenci nese cizí akce nad tvojí kresbou, měří se ve fázi 0. Achievementy až potom, s omezeními.
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
related: [faze-0-uzavrena-skupina]
---

# Retence bez sdílené série

Odpověď na otevřenou otázku #1 z `docs/roadmap.md`. Probráno s majitelem 2026-08-18.

**Rozhodnutí:** sdílená série se **nenahrazuje jedna ku jedné**. Retenci má nést
kombinace „ty vs. zbytek světa" + cizí akce nad tvojí kresbou. Achievementy jsou
nadstavba **po** ověření smyčky, ne odpověď na retenci.

**Co se měří ve fázi 0:** jestli notifikace typu *„někdo něco udělal s tvojí kresbou"*
vrátí člověka **ke kreslení** (ne jen k hádání). Logování už je v rozsahu fáze 0.

## Proč — mechanika, ne motivace

Série neřešila *důvod* se vrátit, řešila **kdo tě vyvolá**. V DS taktovala smyčku cizí
akce (partner tahl → notifikace → tvůj tah). Achievement je opačný stroj: musíš si
vzpomenout sám. Druhá půlka: sérii jsi neporušil sobě, ale konkrétnímu člověku —
cena za nehraní dopadla na někoho jiného.

**Náhrada už v dokumentech je, jen pod špatným nadpisem.** *„Marek si vyžádal kresbu
pojmu trapas"* je v `docs/product.md` vedené jako páka na *zásobování*, ale je to
strukturálně tentýž stroj jako série: konkrétní člověk, konkrétní očekávání, cizí akce
jako spouštěč. Bez křehkosti DS, protože Marek není jediný partner, na kterém hra visí.
Slabší varianta téhož: *„Tvoji chobotnici uhodli 4 lidé, Jana ti dala palec."*

**Proti sérii mluví i to, co uměla špatně:** když partner přestal hrát, hra skončila.
Broadcast je odolnější. Trvalé kresby jsou navíc aktivum, které DS nemělo.

## Omezení pro budoucí achievementy (platí, až se budou stavět)

1. **Žádná denní série za kreslení.** Je to znovuzavedení kvóty, kterou návrh záměrně
   zrušil (viz `docs/roadmap.md`, sekce o vysloužení), a vytváří tlak odčárat čmáranici
   před půlnocí — tedy motor proti vlastnímu detektoru snahy.
2. **Koruna „nejlepší obrázek u slova" jen jako klouzavé okno** (majitel 2026-08-18:
   např. posledních 7 dní). Trvalá koruna = globální žebříček, kvůli kterému vznikly
   ligy, jen bez resetu. Camping neřeší, protože slovo se dostává ze tří nabídnutých,
   nevybírá se.

## Otevřené k rozhodnutí (moje výhrady, nevyřešené)

- **Práh objemu.** Při malé komunitě dostane většina konceptů 1–3 kresby za týden →
  koruna je účast, ne výhra. Udělovat jen nad N kresbami v okně; N do `game_config`.
- **Kterou osou se koruna udílí.** Hvězdičky a palce jsou schválně oddělené (jsou
  v konfliktu). Jedna koruna je slepí zpět. Hvězdičky → vyhrává nejotřelejší kresba.
  Palce → denní zásoba palců v systému = počet aktivních lidí, takže se koruna
  rozhodne poměrem 1:0 a měří spíš distribuční štěstí než kvalitu. Buď palce
  s minimem hlasů, nebo korunu přiznat jako cenu za srozumitelnost.
- **Notifikovat jen zisk koruny, nikdy ztrátu.** Slovo se nevybírá → korunu nelze
  bránit. Zpráva o ztrátě je špatná zpráva bez páky.

## Promítnuto do dokumentů (2026-08-18)

- `docs/product.md`, sekce **Retence** — přepsána na rozhodnutou variantu; zrušeni
  tři dřívější kandidáti (osobní série, série mezi dvojicí, „čeká na 3. uhodnutí").
- `docs/roadmap.md`, **otevřená otázka #1** — přeformulována z „čím nahradit sérii"
  na „vrací notifikace o cizí akci člověka ke kreslení?".
- `docs/roadmap.md`, **rozsah fáze 0** — doplněny notifikace autorovi. Bez nich by
  nebylo co měřit; předtím v rozsahu chyběly, ačkoli na nich hypotéza stojí.

**Pozor na čtení výsledku fáze 0:** silnější polovina mechaniky (vyžádání kresby
konkrétním člověkem) je až ve fázi 1, takže fáze 0 testuje jen slabší signál.
Záporný výsledek je důvod přitáhnout vyžádání dřív, ne zavrhnout směr.

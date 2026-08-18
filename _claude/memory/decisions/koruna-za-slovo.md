---
name: koruna-za-slovo
description: Koruna „nejoblíbenější obrázek u slova" — jednorázové týdenní vyhodnocení za palce, dva prahy v game_config, trvalý datovaný záznam v profilu
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
related: [retence-bez-sdilene-serie]
---

# Koruna za slovo — dořešené tři detaily

Navazuje na [[retence-bez-sdilene-serie]], kde koruna zůstala jako achievement
s klouzavým oknem a třemi nevyřešenými věcmi. Dořešeno 2026-08-18.

## 1. Vyhodnocení: jednorázově na konci pevného týdenního okna

Ne průběžně, ne klouzavých 7 dní. Jednou týdně se spočítá vítěz, ten dostane
zprávu a **trvalý datovaný záznam v profilu**. Nikdo jiný nedostane nic.

**Proč to řeší problém, ne schovává:** původní výhrada byla, že korunu nelze
bránit (slovo se nevybírá, dostáváš ho ze tří nabídnutých), takže hráč může jen
pasivně ztrácet. Při jednorázovém vyhodnocení **není co ztratit** — jsou jen
týdenní vítězové. Zároveň to ruší potřebu řešit „notifikovat jen zisk": ztráta
jako událost neexistuje.

**Pevné okno místo klouzavého je vědomá odchylka od zadání majitele** („např.
posledních 7 dní"). Klouzavé okno vyžaduje průběžný přepočet, pevné jeden job
týdně. U projektu, kde je nejdražší položkou provozní obsluha, vyhrává levnější
varianta se stejným efektem. Datovaný záznam navíc dá odměně trvalost, aniž by
kdokoli zablokoval slot navždy.

## 2. Osa: palce, a jmenuje se podle toho

**„Nejoblíbenější", ne „nejlepší".** Hvězdičky měří srozumitelnost a mají vlastní
žebříček — kdyby rozhodovaly korunu, vyhrála by nejotřelejší možná kresba
a duplikovalo by to existující tabulku. Hvězdičky slouží jen jako deterministický
rozstřel při shodě palců.

Pojmenování je součást rozhodnutí: hvězdičky a palce jsou schválně oddělené,
protože jsou v konfliktu, a jedna koruna je slepí zpátky. Přiznat, kterou osu
měří, ten konflikt rozpouští.

## 3. Dva prahy, obojí v `game_config`

- **`crown_min_drawings`** (návrh 5) — kolik kreseb musí koncept v okně dostat.
  Koruna ze dvou kandidátů je účast, ne výhra, a devalvuje se obráceně, než
  potřebuješ: bezcenná je právě když je komunita malá.
- **`crown_min_thumbs`** (návrh 3) — kolik palců musí mít vítěz. Denní zásoba
  palců v systému = počet aktivních lidí, takže bez prahu se koruna rozhodne
  poměrem 1:0 a měří distribuční štěstí, ne kvalitu.

**Nesplněné prahy = koruna se neudělí a nikde se to neoznamuje.** Hlásit „tento
týden bez vítěze" je reklama na prázdnotu.

## Fáze

Koruna je achievement, tedy **fáze 1+**, ne fáze 0. Zapsáno teď, aby se u návrhu
schématu počítalo s tím, že palce a hvězdičky musí jít agregovat po konceptu
a po časovém okně.

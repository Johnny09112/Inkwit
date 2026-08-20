---
name: kredity-a-odmeny
description: Kredity se do 2026-08-20 nikam neukládaly a aplikace slibovala odměnu, která nikdy nepřišla; nový balanc je základ podle obtížnosti plus bonus za první uhodnutí, utrácí se za odemčení míchání barev
type: decision
status: active
created: 2026-08-20
updated: 2026-08-20
related: [koruna-za-slovo, paleta-barev-a-vyber-vlastni, spravcovske-rozhrani]
---

# Kredity a odměny

**Rozhodnuto 2026-08-20.** Majitel se zeptal, kam se kredity ukládají a k čemu
jsou. Odpověď byla nepříjemná v obou částech.

## Co bylo špatně

**V `ledger` byla nula řádků a žádný účet neměl XP.** Za celou dobu se nepřipsal
jediný kredit. Konfigurace přitom obsahovala `reward_draw_solved = 10`
a `reward_guess_correct = 2` i s promyšlenými popisy — **balanc někdo navrhl
a nikdo ho nezapojil**.

Aplikace navíc ukazovala „kredit +2" spočítaný **z obtížnosti v klientovi**.
To je porušení pravidla 6 (*„balanc odměn je serverová konfigurace, ne konstanty
v kódu"*) a zároveň slib, který se nikdy nesplnil. Do třetice hláška u prázdné
zásoby slibovala „dvojnásobný kredit" — surge, který ve fázi 0 neexistuje.

## Nový balanc

| obtížnost | základ při odeslání | bonus za první uhodnutí | celkem |
|---|---|---|---|
| snadné | 1 | 1 | 2 |
| střední | 2 | 3 | 5 |
| těžké | 3 | 5 | 8 |

Uhodnutí dá 1. Všechno v `game_config`, mění se bez nasazení.

**Proč tenhle tvar.** Víc než polovina odměny visí na tom, jestli kresbě někdo
rozumí — u těžkých je ten podíl nejvyšší (63 %). Očekávaný výnos při realistické
šanci na uhodnutí (95 / 80 / 60 %) vychází 1,95 · 4,4 · 6,0, takže se vyplatí
zkusit těžší slovo.

**Nekalibrováno daty.** V době rozhodnutí bylo v databázi 6 těžkých kreseb
a 5 tipů na ně — to není vzorek. Čísla jsou úvaha, ne měření.
**Co sledovat:** jestli se všichni nevrhnou na těžká slova a nezaplní zásobu
neuhodnutelnými kresbami. Rozptyl 1,95 → 6,0 je trojnásobný a nabídka dává
jeden pojem od každé obtížnosti, takže pobídka k těžkým je silná.

## Bonus se platí jednou, a drží to index

`private.award()` zapisuje do ledgeru s `on conflict do nothing` nad unikátním
indexem `(user_id, reason, ref_id)`. `submit_guess` proto volá bonus autorovi
**při každém uhodnutí** a druhý zápis se tiše zahodí.

**Idempotence je v databázi, ne v podmínce**, kterou by šlo obejít souběhem —
kdyby se počítalo „je tohle první uhodnutí?", dvě současná uhodnutí by vyplatila
bonus dvakrát. Bez toho by populární kresba uhodnutá třiceti lidmi vyplatila
třicet bonusů a balanc by nedržel.

## Za co se utrácí

**Odemčení míchání vlastních barev**, jednorázově za 25 kreditů.

Vybralo se to proto, že kruh barev do té doby **namíchal cokoli zadarmo** —
„kredity za barvy" by šlo obejít za tři vteřiny. Placené je proto samo míchání;
základní paleta zůstává zdarma. Je to kosmetika, takže pravidlo 3 (žádné
pay-to-win) platí dál.

**Paleta zůstává v prohlížeči** (viz [[predvolby-zarizeni-v-localstorage]]),
na účtu je jen to, co se koupilo. Nákup zamyká profil (`for update`), jinak by
dvě rychlá klepnutí odečetla cenu dvakrát.

## Co se tím nezavedlo

XP ani level. Sloupce v `profiles` zůstávají nepoužité — dvě měny bez účelu jsou
horší než jedna. Zůstatek je prostý součet ledgeru, žádné druhé místo pravdy.

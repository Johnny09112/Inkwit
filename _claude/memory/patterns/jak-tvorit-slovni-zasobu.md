---
name: jak-tvorit-slovni-zasobu
description: Recept na tvorbu konceptů — kalibrace obtížnosti, co patří a nepatří do přijímaných tvarů, kritéria jednojazyčnosti, povinná kontrola validátorem
type: pattern
status: active
created: 2026-08-18
updated: 2026-08-18
---

# Jak tvořit slovní zásobu

Sepsáno 2026-08-18 po první sadě 120 pojmů, aby příště stačilo zadání
„vytvoř dalších 1 000 slov" a výsledek byl použitelný napoprvé.

**Zdroj pravdy:** `supabase/seed/concepts.json`.
**Kontrola:** `node supabase/seed/check-concepts.mjs` — **není volitelná**, viz níž.

## Tvar záznamu

```json
{ "id": "kolotoc", "difficulty": 2, "category": "predmet",
  "crossLanguage": true, "schoolSafe": true,
  "cs": { "prompt": "kolotoč", "accepted": ["kolotoč", "kolotoče", "ruské kolo"] },
  "en": { "prompt": "carousel", "accepted": ["carousel", "merry-go-round"] } }
```

`id` je ASCII kebab bez diakritiky — stabilní klíč, ne text pro člověka.
Kategorie: `zvire`, `predmet`, `priroda`, `jidlo`, `cinnost`, `abstraktni`.

## Jediná otázka, která rozhoduje: jde to nakreslit?

Ne „je to hezké slovo" ani „je to zajímavé". **Pokusil by se o to člověk, který
kreslit neumí?** Když ne, pojem patří ven, i kdyby byl sebehezčí.

Druhá kontrola: **jedna kresba → jedno slovo.** Když typická kresba pojmu vede
stejně dobře na jiný pojem, je to past na hádající, ne obtížnost.

## Kalibrace obtížnosti

| | Co to je | Poznávací znak |
|---|---|---|
| ★ | konkrétní věc s jasnou siluetou | pes, dům, jablko, slunce |
| ★★ | potřebuje detail, scénu nebo vztah dvou věcí | kolotoč, maják, plavání, vodopád |
| ★★★ | abstraktní nebo dějové, jde nakreslit mnoha způsoby | nostalgie, spěch, ticho, kýchnutí |

**Poměr má být nakloněný ke snadným, ne vyvážený** — první sada je 58 / 40 / 22,
tedy zhruba 50 / 33 / 17 %. Důvod: nabídka tří konceptů je ventil pro toho, kdo
kreslit neumí (`docs/product.md`). Kdyby byly obtížnosti rovnoměrné, ventil
přestane fungovat, protože v nabídce často nebude nic snadného.

## Přijímané tvary

**Patří tam:** základní tvar, zdrobněliny (`pejsek`, `kočička`), synonyma
a hovorové varianty (`hafan`, `čokl`, `barák`), blízké pojmy, které kresba stejně
dobře popisuje (`vosa` u včely, `zajíc` u králíka), a u víceslovných i běžná
zkrácení.

**Nepatří tam:**
- **Varianty lišící se jen diakritikou** (`déšť` × `dešť`). Normalizace je srovná,
  v seznamu jsou pak dvakrát a validátor je nahlásí.
- **Plné skloňování.** Vědomě se vynechává — hádající píše nominativ a zbytek
  pokryje fuzzy shoda. Pár častých pádů (`psa`, `krávu`) uškodit nemůže.
- **Tvary, které patří jinému pojmu.** Viz kolize níž.

Rozsah 3–7 tvarů na jazyk je akorát. Delší seznam většinou znamená, že se do něj
propašovaly cizí pojmy.

## `crossLanguage: false` — kdy

- Slovo je dvojznačné už v češtině: `zámek` (hrad i visací).
- Nemá čistý jednoslovný protějšek: `trapas`.
- Protějšky si nesedí významem: `štěstí` (radost i náhoda) × `happiness`.

Takový pojem se **nesmí** dostat do cross-language hry, ale v jednojazyčné je v pořádku.

## `schoolSafe`

Je to **opt-in, ne opt-out** — nastavuj `true` jen po vědomé kontrole. Ven patří
zbraně, alkohol, násilí, strašidelné motivy, značky a skutečné osoby.
Nejlevnější je tvořit rovnou školně bezpečně; pak se nemusí sada procházet
podruhé před fází 2.

## Kontrola je povinná, ne doporučená

`check-concepts.mjs` hlídá věci, které se okem v sedmi stech tvarech nenajdou.
Na první sadě našel:

1. **Kolizi přijímaných tvarů.** Slovo `budík` přijímaly `hodiny` i `budik`.
   V praxi: hráč napíše správnou odpověď a hra ji vyhodnotí jako špatnou.
   **Tohle je nejzávažnější chyba, jakou lze v sadě udělat**, a roste s velikostí.
2. **Krátká slova lišící se jedním znakem** napříč pojmy — `pes`/`děs`,
   `slon`/`shon`, `cat`/`bat`/`car`, `bear`/`pear`/`fear`. Neopravují se v datech;
   je to vstup pro prahy fuzzy shody (do 4 znaků jen přesná shoda).
3. Duplicity uvnitř seznamu a zadání chybějící mezi přijímanými tvary.

**U tisíce slov roste počet dvojic kvadraticky.** Bez validátoru je sada té
velikosti neudržitelná.

## Postup u velké dávky

1. Tvořit **po kategoriích**, ne dohromady — jinak vznikne dvacet zvířat a tři předměty.
2. Po každé dávce spustit validátor a **kolize opravit hned**; na konci se v nich
   nikdo nevyzná.
3. Držet poměr obtížnosti průběžně, ne dorovnávat na konci.
4. Nové pojmy porovnat proti existujícím — validátor to udělá sám, ale je levnější
   nevymýšlet `budík` dvakrát.
5. Výsledek nechat projet majitelem přes generovaný přehled
   (`scratchpad/gen-slovnik.mjs`), ne jako JSON.

## Čemu se vyhnout

Značky, skutečné osoby, politika, cokoli vázané na jednu kulturu (`americké
kulturní reference` jsou v `docs/product.md` uvedené jako chyba Draw Something).
Dál složeniny, které jsou v jednom jazyce jedno slovo a v druhém tři —
kreslíř je nakreslí, ale hádající je nikdy netrefí přesně.

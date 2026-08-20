---
name: spravcovske-rozhrani
description: Blok H — role admina, fronta hlášení, bany vynucené triggerem a čísla s exportem; obrací rozhodnutí F3, že fáze 0 admina nemá
type: decision
status: active
created: 2026-08-20
updated: 2026-08-20
related: [faze-0-uzavrena-skupina, nahlaseni-s-duvodem, rls-pomocne-funkce-mimo-public]
---

# Správcovské rozhraní (blok H)

**Rozhodnuto 2026-08-20** na žádost majitele. Obrací krok F3, kde stálo, že
fáze 0 administrátorské rozhraní nemá, protože pět dotazů ve studiu je levnější.

**Proč to přestalo platit:** platilo pro čtení čísel. Neplatí pro moderaci —
nahlášení je akce uživatele, na kterou musí někdo odpovědět. V okamžiku
rozhodnutí ležela v `public.reports` **tři hlášení, o kterých nikdo nevěděl**.

## Čtyři věci, které v datech chyběly

Role admina · banování · uzavření hlášení · metriky dosažitelné z prohlížeče
(pohledy `private.metrics_*` jsou jen pro `service_role`).

## Rozhodnutí, která nejsou zjevná

**Příznak správce se nastavuje jen v SQL.** Žádné RPC, žádné rozšíření GRANTu.
Ochrana stojí na tom, že `UPDATE` na `profiles` je udělený jen na vyjmenované
sloupce (viz migrace 20260819080000) — nový sloupec je tím chráněný sám.
Hlídá to test.

**Ban vynucuje trigger, ne RPC.** Kontrola v jednotlivých funkcích by znamenala
pět míst a šesté, dopsané za půl roku, by se na ni zapomnělo. Trigger na zápisu
do `drawings`, `guesses`, `reactions` a `concept_requests` drží ban i pro kód,
který o něm neví. `next_drawing()` navíc přestane nabízet kresby zablokovaných.

**Oprávnění je na serveru, ne na stránce.** Každá `admin_*` funkce si sama ověří
admina; `/admin` jen ukáže chybu. Kdyby to bylo naopak, stačilo by uhodnout URL.
`am_i_admin()` slouží jen ke skrytí odkazu v profilu.

**Název metriky se nesmí skládat do dotazu.** `admin_metrics(text)` používá
`execute format(...)`, takže parametr prochází výčtem povolených jmen — jinak
by to byla injektáž. Test to zkouší.

**Školní tenant se nezahrnuje.** Pravidlo 1 ho tvrdě izoluje; admin přes hranici
tenanta by z toho udělal díru. Všechny `admin_*` funkce filtrují
`tenant_id is null`. Ve fázi 0 žádný školní tenant neexistuje, takže to nic
nestojí — až vznikne, bude to samostatné rozhodnutí.

**Skrytí kresby je měkké.** `status = 'removed'`, ne `delete`: cizí tipy a čísla,
ze kterých se počítá zásoba neuhodnutých, musí zůstat.

**Zásahy se logují.** `admin_actions`. Při jednom majiteli to vypadá zbytečně,
ale ban bez stopy je věc, které se za rok nedá věřit.

## Co to nemění

Roadmapa varuje: *„Denní ruční fronta projekt zabije dřív než nedostatek
uživatelů."* Pro padesát testerů je fronta v pořádku. **Pro veřejné spuštění
zůstává podmínkou klasifikátor**, ne tahle obrazovka — jinak se z ní stane plán,
kterým nikdy být neměla.

## Práh pro slova

Alarm „docházejí slova" se rozsvítí, když u některé obtížnosti zbývá **15 a míň**
nenakreslených pojmů. Při zavedení bylo ze 120 pojmů 60 nenakreslených při třech
hráčích — práh je odhad, ne měření, a po pozvánkách se bude kalibrovat.

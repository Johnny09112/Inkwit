# Inkwit — roadmapa, monetizace, otevřené otázky

## Fáze 0 — MVP pro 50 lidí (3–4 týdny)

Ověřuje **jedinou hypotézu: budou lidé dobrovolně kreslit pro cizí lidi bez okamžité zpětné vazby?**

V rozsahu:
- přihlášení, výběr jazyka
- kreslicí plátno (PointerEvent, vektorové tahy, undo)
- výběr ze tří konceptů
- hádání s přehráním kresby, tři pokusy, CZ + EN
- hvězdičky, palec (1×/den)
- nahlášení + ruční review majitelem
- jeden denní žebříček
- základní logování metrik

**Mimo rozsah — vědomě:** odznaky, ligy, komunity a sledování, uživatelská slovní zásoba, surge, kategorie podle zařízení, trust score, platby, nativní aplikace.

Trust score a surge jsou nadstavby nad chováním, které se teprve ověřuje. Když se hypotéza neprokáže, žádná z nich to nezachrání.

**Kritérium postupu:** ≥20 % uživatelů se druhý den vrátí a nakreslí další kresbu.

## Fáze 1 — udržitelná smyčka

Trust score a probační fronta · automatická kontrola obsahu · vyžádání kresby · surge · ligy · malá sada odznaků · přehrání jako sdílitelný GIF.

## Fáze 2 — školy (placené, s výjimkami)

Školní tenant s tvrdou izolací · učitelský panel a `join_code` · kurátorované sady A1–B2 · cross-language režim CZ↔EN.

**Model: €39/rok za učitelskou licenci** (jeden učitel, jeho třídy). Roční platba, ne měsíční — školní rozpočty a schvalování fungují v ročním cyklu a učitel v červenci neplatí za nic.

**Volné licence uděluje majitel projektu ručně**, jako `plan = 'partner'`. Určeno pro design partnery — první testery, kteří dávají zpětnou vazbu, a pro reference. Není to veřejná nabídka a nikde se neinzeruje; jinak si o ni řekne každý.

- 400 platících učitelů = **~€1 300/měsíc**
- kanál: přímo přes učitele, ne přes vedení škol. Rozhodnutí o nástroji na patnáct minut hodiny dělá učitel sám.
- uzavřené třídní místnosti navíc nepotřebují globální moderaci, takže je to zároveň nejlevnější testovací prostředí pro cross-language mechaniku

V `tenants.plan` tedy tři hodnoty: `free` (zkušební období), `paid`, `partner`.

## Fáze 3 — monetizace

**Nikdy žádné reklamy.** Free verze je kompletní hra bez omezení.

### Firemní místnosti — první placená funkce

Nevyžaduje škálu, jen landing page a zákazníky. Zaplatí provoz dřív, než vznikne publikum.

- €39/měsíc za workspace, nebo €25 za jednorázovou akci
- soukromé místnosti, firemní slovníky, žádní cizí lidé, export galerie z akce
- **~40 firem = ~€1 500/měsíc**
- kanál: LinkedIn, remote-work newslettery, jedna dobrá landing page

### Spotřebitelská vrstva

- €4,99 / měsíc · €24,99 / rok · **€44,99 lifetime** ← tady bude většina objemu, casual hráči odmítají předplatné a přijímají jednorázovku
- **regionální ceny od prvního dne** — světová penetrace znamená trhy, kde €4,99 nikdo nezaplatí, ale €1,49 ano
- **prodej přes Stripe na webu, ne přes IAP.** Obchody berou 15–30 %, Stripe ~3 %. V EU lze z aplikace odkazovat na externí platbu. Rozhodni teď, zpětně se to mění špatně.

Rozdělení, aby vyslužení nekanibalizovalo placení:
- **kreslením se odemyká** tvorba a kosmetika: štětce, barvy, rámečky, export GIF
- **platbou** pohodlí a podpora: statistiky, neomezený archiv, soukromé místnosti, badge podporovatele

Do vysloužení se počítá **jen kresba, kterou někdo uhodl a která prošla reliability.** Jinak se tím znovu vytvoří kvóta, kterou návrh záměrně zrušil — a tentokrát s hmotnou odměnou, tedy s ještě větším tlakem odčárat pět obrázků.

### Relay režim — až po prvních platících firmách

Synchronní teambuildingový mód (pravidla v `docs/product.md`). Zařazen sem záměrně: **nejdřív prodej jednoduché soukromé místnosti.** Pokud si je nikdo nekoupí, relay režim to nezachrání a ušetříš si měsíc práce na real-time infrastruktuře.

Je to druhý engine, ne přírůstek — WebSockety, presence, orchestrace kol. Jediné, co je potřeba udělat **dřív**, je `author_id` v `drawing_strokes`, jinak přijdeš o atribuci u všeho staršího.

### Později

Roční tištěné leporelo vlastní tvorby (print-on-demand, žádný sklad, tiskne se jen vlastní obsah autora → bez moderačního rizika). Sezónní, slabá marže, ale silné emoční pouto.

## Ekonomika — realistický pohled

Cíl €3 000 čistého měsíčně:
- čistý příjem na spotřebitelského předplatitele ≈ €2–2,50/měsíc po poplatcích
- konverze v casual hrách 1–3 % z MAU
- čistě spotřebitelsky by to znamenalo **~65 000 MAU** — to je hit, ne part-time projekt

Proto jsou páteří **linky s vysokým ARPU, které škálu nevyžadují**: firemní workspace (~20× ARPU spotřebitele) a učitelské licence. Spotřebitelské předplatné je doplněk, ne základ.

Hrubý cílový mix:
- firmy: 40 × €39 = **€1 560**
- učitelé: 400 × €39/rok = **€1 300**
- spotřebitelé: zbytek, řádově stovky eur při realistické velikosti komunity

Náklady, které z toho ukrojí:
- hosting a egress při 60k MAU: €150–400/měsíc (vektorové tahy tohle drží nízko — argument je dnes finanční, ne technický)
- **moderace: největší položka**, roste s počtem jazyků, klidně třetina příjmů
- účty, doména, právník na podmínky: pár set ročně
- **vlastní čas** — produkt s desítkami tisíc uživatelů není part-time; support a incidenty přijdou i o víkendu

Na čistých €3 000 mířit spíš na **€4 500 hrubého**.

## Jazyková strategie

Architektura **vícejazyčná od prvního dne** (koncepty s CZ/EN variantami). Spuštění a marketing **jen v češtině + angličtina pro školy**.

Globální spuštění hned by znamenalo prázdné místnosti v třiceti jazycích a moderační frontu, kterou nepřečteš. Česko dá levnou, ovladatelnou testovací komunitu, kde rozumíš každému hlášení.

## Povaha projektu — rozhodnuto

**Cílem je mít to na světě. Příjem je vítaný bonus, ne podmínka.** Majitel má souběžně jiné projekty, takže **nejvzácnějším zdrojem není kapitál, ale čas.**

Z toho plynou závazná rozhodnutí:

- **Moderace musí být téměř bezobslužná.** Ne „automatizace, kterou doděláme" — automatický klasifikátor a komunitní moderace jsou podmínkou spuštění veřejné hry. Denní ruční fronta projekt zabije dřív než nedostatek uživatelů.
- **Žádná funkce, která vyžaduje pravidelnou lidskou obsluhu.** Kurátorování obsahu, ruční turnaje, správa sezón — vše musí běžet samo, nebo neexistovat.
- **Provoz musí být levný i při nule příjmů.** Rozpočet, který snese, že to rok nevydělá nic.
- **Škálovací práci nedělat dopředu.** Optimalizace pro 100k uživatelů je marnost u produktu, který jich možná bude mít 3 000. Řeš to, až to bude bolet.
- **Firemní a učitelská linka mají přednost před spotřebitelskou** — méně zákazníků, méně supportu, vyšší ARPU. Přesně to, co part-time provoz unese.
- **Support má být asynchronní a veřejný** (FAQ, jeden e-mail, žádný chat). Nesliboj reakční doby.

Otevřená věc k rozhodnutí: **co se stane, když zájem opadne.** U projektu, který má být na světě, je slušné mít předem promyšlené, jestli se data dají exportovat a jestli se komunitě řekne pravda včas. Není to urgentní, ale nemá to zůstat nepromyšlené — právě proto, že motivací není byznys.

## Otevřené otázky

1. **Čím nahradit sdílenou sérii z Draw Something?** Nejsilnější retenční mechanika toho žánru a broadcast model ji přímo nemá. Bez odpovědi hrozí, že produkt drží lidi tři týdny.
2. **Poměr odměn kreslení : hádání.** Nechat na testech, ale zafixovat strop (~10:1) a cílovou metriku předem.
3. **Kolik neuhodnutí do archivace** a jak přesně škáluje s obtížností.
4. **Jak vypadá moderace bez lidské obsluhy.** Vzhledem k povaze projektu to není otázka „kdo to bude dělat", ale „jak to udělat, aby to nikdo dělat nemusel". Komunitní moderátoři z důvěryhodného pásma jsou pravděpodobná odpověď, ale potřebují návrh dřív, než přijde první krize.
5. **Doména a finální branding.** Pracovní název `inkwit` stačí do fáze 1.
6. **Věková brána ve veřejné hře.** Školní tenant je vyřešený izolací, ale co nezletilí, kteří přijdou sami z internetu?

# Inkwit — produkt

## Herní smyčka

**Kreslení**
1. Hráč dostane na výběr ze **tří konceptů různé obtížnosti** (1–3 hvězdy). Volba je ventil: kdo neumí kreslit, vezme si snadný.
2. **Žádný časový limit.** Čas se měří kvůli detekci čmáranic, ale hráči se nezobrazuje odpočet.
3. Tahy se ukládají průběžně jako vektory (viz datový model). Undo je zdarma.
4. Po odeslání projde kresba automatickou kontrolou obsahu, pak vstupuje do distribuce.

**Hádání**
1. Hádající vidí **přehrání kresby tah po tahu**, ne finální obrázek. To je klíčový zážitek — hádající sleduje cizího člověka přemýšlet.
2. **Tři pokusy**, volný text, ve zvoleném jazyce (CZ nebo EN).
3. Čím dřív uhodne, tím víc hvězdiček kresba dostane.
4. Po vyřešení (nebo vyčerpání pokusů) může dát **palec nahoru — jednou denně celkem**, tedy je to vzácný hlas, ne lajk.
5. Kdykoliv může kresbu nahlásit.

**Archivace**
Kresba se archivuje po N neuhodnutích, kde **N škáluje s obtížností konceptu** (snadné slovo zmizí dřív, těžké dostane víc šancí). Autorovi se počet neuhodnutí **nezobrazuje** — jen kolik lidí uhodlo.

## Poměr rolí

**Není žádný povinný poměr.** Hádat lze neomezeně a zdarma. Kreslení se nevynucuje, ale je řádově lépe odměněné a odemyká věci, které jinak získat nejdou: levely, většinu odznaků, žebříček kreslířů, viditelnost profilu, možnost vyžádat si kresbu.

Tři páky, které zásobování drží:

1. **Ekonomika.** Kreslení dává násobně víc než hádání. Konkrétní poměr = serverová konfigurace, laděná testem. Strop: nad ~10:1 se hádání stane bezcenným.
2. **Surge.** Když zásoba neuhodnutých kreseb klesne pod práh, systém sám zvedne odměnu za kreslení a aktivně ho nabídne.
3. **Poptávka jako trigger.** „Marek si vyžádal kresbu pojmu *trapas*." Konkrétní člověk čeká na konkrétní věc — silnější motivace než body.

## Bodování a žebříčky

Dvě **oddělené** metriky, protože jsou v konfliktu (rychle uhodnutelná kresba je otřelá, vtipná kresba je často pomalá):

- **Hvězdičky** — jak rychle bylo uhodnuto. Měří srozumitelnost.
- **Palce** — jak moc se to líbilo. Měří kvalitu a humor.

Tři žebříčky: **Hádač**, **Kreslíř (srozumitelnost)**, **Popularita**.

Žebříčky se dělí na **ligy po ~30 hráčích**, ne jeden globální. Jeden globální žebříček při malé komunitě znamená, že vyhrává pořád stejných pět lidí a zbytek rezignuje.

Odznaků málo a s jasným významem. Dvě stě odznaků nemá cenu žádný.

**Typ zařízení** (myš / dotyk / pero) se ukládá do metadat kresby od prvního dne, ale **samostatné žebříčky podle zařízení se nespouští, dokud není objem.** Rozdělily by řídkou komunitu na tři poloprázdné tabulky a user-agent se dá podvrhnout. Férovost řeš raději uniformním štětcem bez tlaku pera.

## Retence

Slabé místo návrhu. Draw Something drželo lidi **sdílenou sérií mezi dvěma hráči** — nevracíš se pro body, ale abys nezabil něco, co s někým tři měsíce stavíš. Broadcast model tohle přímo nemá.

Náhrady k otestování (viz otevřené otázky):
- osobní série dnů, kdy tě někdo uhodl
- série mezi dvojicí, která se navzájem sleduje
- „tvoje kresba čeká na 3. uhodnutí" jako notifikační háček

Rychlá emoční odměna autorovi je povinná: *„Tvoji chobotnici uhodli 4 lidé, Jana ti dala palec."* Tohle Draw Something nikdy nedodalo, protože obrázky mizely. Tady je to hlavní výhoda.

## Trust score

**Dvě nezávislé osy.** Nesmí se smíchat „neumí kreslit" s „podvádí".

- **Reliability** (0–1): snaží se? Vstupy: signály procesu, historická uhodnutelnost, poměr nahlášení, věk účtu, počet dokončených kreseb.
- **Skill:** jak dobré to je. Ovlivňuje doporučování a žebříčky, **nikdy ne moderaci**.

Reliability gatuje **jen tři věci**: velikost publika při první distribuci, zda kresba jde přes probační frontu, a rate limit.

Tři pásma: **nový / ověřený / důvěryhodný**. Postup nahoru rychlý (pár uhodnutých kreseb), pád dolů okamžitý, automatická rehabilitace po několika dobrých příspěvcích.

**Skóre je vlastnost účtu, ne obrázku.** Jednotlivé rozhodnutí „tahle kresba je čmáranice" bude vždy nespolehlivé; vzorec deseti kreseb je spolehlivý.

## Anti-čmáranice

Signály snahy z uložených tahů:
- doba kreslení a **její rytmus** — nejsilnější signál; skutečná kresba má pauzy a návraty, čmáranice je jedno gesto za dvě sekundy
- počet tahů a délka dráhy
- pokrytí plátna / bounding box
- počet undo, změny barvy a štětce
- podíl náhodných překryvů (cikcak vs. uzavřené tvary)

Používat **jako prior, ne jako soud**. Ground truth je uhodnutelnost.

Nízká uhodnutelnost sama o sobě neznamená nic (to je jen slabý kreslíř). Nízká uhodnutelnost **plus** slabé signály snahy je záměr.

Eskalace, od nejměkčího:
1. Při odeslání: „Tohle vypadá hodně narychlo — poslat?" Jedno kliknutí dál. Nic se neblokuje, jen se zvýší tření. Odchytí to překvapivě velkou část, protože většina lidí není troll, jen líný.
2. Kredit se nezapočítá, musí kreslit znovu. Bez dramatu a bez obvinění.
3. Snížená distribuce. Uživateli se neoznamuje.
4. Rate limit.
5. **Ban až za skutečný abuse** — obscénnosti, napsané slovo v obrázku, cílené urážky. Nikdy za nesnahu.

**Falešně pozitivní jsou dražší než falešně negativní.** Jedna čmáranice mezi dvaceti nikoho neurazí; jedno neoprávněné obvinění nováčka znamená odinstalaci. Kalibruj přísně na tuhle stranu.

## Moderace

Není to feature, je to hlavní provozní náklad a roste superlineárně s počtem jazyků.

- Automatický klasifikátor obsahu **před prvním zobrazením**, ne po nahlášení.
- AI jako **první hádač**: dá signál „je tady vůbec něco rozpoznatelného" a spolehlivě odchytí napsané slovo v obrázku (nejčastější podvod). Nikdy nerozhoduje sama — nejoriginálnější kresby často nepozná.
- Fronta k ručnímu review, prioritizovaná podle reliability autora.
- Uživatelské slovníky (posílání „zákeřných slov") musí být **vynuceně slovníkové** — whitelist proti jazykovému korpusu, ne důvěra. Jinak je to vektor pro nadávky a šikanu.
- Školní tenant tohle celé obchází izolací. To je jeho hlavní hodnota, ne jen bezpečnost.

## Relay režim (v záloze, nespouštět předčasně)

Synchronní teambuildingový režim. **Není součástí hlavní hry** a nespouští se dřív než ve fázi 3 — viz roadmapa.

**Pravidla:**
- Slovo zná **jen první kreslíř**. Všichni další kreslí naslepo a jen interpretují, co vidí. Jakmile slovo zná víc lidí, mechanika se rozpadá.
- Střídání po **15 s** (jedna hodnota, nekombinovat), plátno hotové do 2 minut.
- **Běží tolik pláten, kolik je hráčů, současně** — po každém intervalu se každému podsune cizí plátno. Nikdo nikdy nečeká. Bez tohohle je při osmi lidech 105 sekund prostoje ze dvou minut a je to nehratelné.
- Na konci **přehrání s atribucí**: plátno se přehraje vrstvu po vrstvě, barevně podle autorů. „Tuhle nohu přikreslila Jana, tenhle knír Petr." Tohle je ten moment, kvůli kterému si firma řekne o druhou session.
- **Žádný vítěz.** Teambuilding a soutěž jdou proti sobě.

**Dvojjazyčnost:** kreslířům naslepo je jazyk lhostejný, ti slovo nevidí. Reálná mechanika je tedy *prompt v jednom jazyce, závěrečné hádání ve druhém*. Je to překladové cvičení zabalené do hry — proto to zpřístupnit i **školnímu** tenantu, ne jen firemnímu.

**Izolace — nutné podmínky:**
1. Relay kresby **nikdy** do veřejné distribuce. Vždy `tenant_id NOT NULL`.
2. **Nevstupují do trust score ani do kreditů.** Patnáctivteřinová čmáranice je tady správný výstup; detektor snahy by střílel samé falešné poplachy.
3. **Auto-skip při vypršení timeru**, bez výjimek. Jinak jeden spadlý prohlížeč zablokuje celý řetěz.

**Dopad na datový model — myslet na to teď:** `drawing_strokes` potřebuje `author_id`. Přidat to dodatečně znamená ztrátu atribuce u všeho, co vzniklo dřív, a atribuce je hlavní hodnota režimu.

**Realistický odhad:** není to přírůstek k existující hře, je to **druhý engine sdílející knihovnu** — WebSocket místnosti, presence, orchestrace kol, ošetření odpojení, lobby. Znovupoužije se plátno, tahy, koncepty a přehrávání; session vrstva se staví celá.

**Konkurence:** Gartic Phone a Jackbox dělají totéž a Gartic Phone je zdarma. Odlišení musí být to sdílené plátno s atribucí a dvojjazyčnost, ne samotný formát.

## Co se přebírá z Draw Something

Fungovalo a nikdo to dnes nedělá:
- **přehrání kresby jako animace** — nejlepší část toho produktu
- **volba ze tří konceptů o různé obtížnosti**
- **žádný časový limit při kreslení**
- **nesoutěžní rámování pro slabé kreslíře** — DS bylo záměrně kooperativní, aby v něm mohli hrát lidé, co kreslit neumí

Co se opravuje:
- obrázky mizely → tady zůstávají, takže má smysl se snažit
- hra vyžadovala konkrétního partnera → broadcast, hraješ i v šest ráno
- skládání odpovědi z písmen → volný text
- americké kulturní reference ve slovníku → kurátorované koncepty per jazyk

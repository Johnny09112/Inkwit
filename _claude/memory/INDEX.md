<!-- AUTO-GENEROVÁNO reindex.js — NEEDITUJ ručně. Zdroj pravdy = frontmatter souborů. -->
# Index paměti — inkwit

> Plný katalog on-demand záznamů. Always-load vrstvu viz auto-memory/MEMORY.md.

## Context
- [[project-context]] — Živý stav projektu inkwit — fáze, milníky, aktuální focus · active · 2026-08-19

## Decisions
- [[gesta-a-vyrez-platna]] — Jeden prst kreslí, dva přibližují a posouvají; přiblížení je jen zobrazení, body zůstávají v poměrných souřadnicích 0–1, matematika výřezu je v lib/canvasView.ts a má vlastní testy · active · 2026-08-19
- [[knihovna-kreseb-a-mazani]] — Rozepsané kresby se z knihovny skrývají, ale řádek zůstává kvůli metrics_funnel; mazání vlastní kresby je měkké (status removed), detail nesmí ukázat počet pokusů · active · 2026-08-19
- [[paleta-barev-a-vyber-vlastni]] — Vlastní paleta se ukládá do localStorage (23 barev + tlačítko přidat), nová barva se míchá v kruhu HSV, hex je v něm místo v panelu; na umístění se ptáme až když je paleta plná · active · 2026-08-19
- [[predvolby-zarizeni-v-localstorage]] — Kreslicí ruka (strana lišty nástrojů) žije v localStorage, ne ve sloupci profiles — vlastnost zařízení, ne účtu; migrace kvůli vzhledu se nevyplatí · active · 2026-08-19
- [[faze-0-uzavrena-skupina]] — Fáze 0 běží jako uzavřená skupina ~50 pozvaných; veřejné otevření je podmíněné automatickým klasifikátorem obsahu · active · 2026-08-18
- [[hadani-nad-hotovym-obrazkem]] — Hádá se nad hotovým obrázkem; přehrání tah po tahu je volitelné tlačítko a odměna po uhodnutí, poměr se měří ve fázi 0 · active · 2026-08-18
- [[kodovani-bodu-tahu]] — Souřadnice se zaokrouhlují na 4 desetinná místa už při záznamu, body se ukládají jako ploché pole [x,y,t,…]; zaokrouhlení je 2,8× úspora, ploché pole jen 1,1× na drátě · active · 2026-08-18
- [[koruna-za-slovo]] — Koruna „nejoblíbenější obrázek u slova" — jednorázové týdenní vyhodnocení za palce, dva prahy v game_config, trvalý datovaný záznam v profilu · active · 2026-08-18
- [[paleta-oves-a-oliva-a-fonty]] — Vizuální základ = paleta „Oves a oliva" + Bricolage Grotesque / IBM Plex Sans / IBM Plex Mono; úvodní návrh v docs/design-system.md, ne fix · active · 2026-08-18
- [[pamet-v-repu-ne-v-osobnim-vaultu]] — Projektová paměť žije v _claude/ uvnitř repa a verzuje se gitem, ne v osobním vaultu na H: · active · 2026-08-18
- [[pisma-self-host-a-ofl]] — Písma se self-hostují přes next/font/google (build-time), za běhu nulový request na Google; OFL licence a atribuce leží v licenses/ · active · 2026-08-18
- [[retence-bez-sdilene-serie]] — Sdílená série z Draw Something se nenahrazuje; retenci nese cizí akce nad tvojí kresbou, měří se ve fázi 0. Achievementy až potom, s omezeními. · active · 2026-08-18
- [[supabase-free-plan-a-region]] — Projekt Inkwit běží na free plánu v eu-central-1; free stačí na fázi 0, ale zálohy nejdou stáhnout a kvóta dvou aktivních projektů je vyčerpaná · active · 2026-08-18
- [[tajemstvi-hry-v-schematu]] — Text konceptu a drawings.concept_id jsou tajemství hry — klient je nečte vůbec; RLS je řádková, takže se tajné sloupce oddělují do vlastních tabulek a feed jde přes pohled · active · 2026-08-18

## Patterns
- [[ctvercove-tlacitko-ve-flex-radku]] — aspect-ratio nevyrobí čtvercové tlačítko vedle roztaženého ve flex řádku — šířka se vyřeší dřív, než align-items stretch roztáhne výšku · active · 2026-08-19
- [[ios-dlouhy-stisk-vybira-text]] — Dlouhý stisk v iOS Safari označí text a otevře nabídku Kopírovat i nad plátnem a tlačítky; řeší to user-select a -webkit-touch-callout, ne PWA · active · 2026-08-19
- [[next-cache-rozbita-buildem]] — npm run build za běhu dev serveru přepíše .next a dev pak hlásí "Cannot find module ./vendor-chunks/*.js" — vypadá to jako chyba v kódu, ale je to jen cache · active · 2026-08-19
- [[jak-tvorit-slovni-zasobu]] — Recept na tvorbu konceptů — kalibrace obtížnosti, co patří a nepatří do přijímaných tvarů, kritéria jednojazyčnosti, povinná kontrola validátorem · active · 2026-08-18
- [[nextjs-middleware-matcher-tecka]] — V Next.js middleware matcheru nefunguje escapovaná tečka \. uvnitř custom skupiny — path-to-regexp zbaští backslash a lookahead pak odmítne všechno; použij [.] · active · 2026-08-18
- [[rls-pomocne-funkce-mimo-public]] — Politiky RLS se vyhodnocují právy dotazujícího se uživatele, takže revoke execute je rozbije — pomocné funkce se schovávají přesunem do schématu mimo PostgREST, ne odebráním práv · active · 2026-08-18
- [[supabase-chyby-podle-kodu]] — Chyby ze Supabase Auth mapovat podle err.code, ne podle textu; zamítnutá pozvánka z triggeru dorazí jako 23514 a fallback nesmí svalovat všechno na pozvánku · active · 2026-08-18

## Bugs
- [[revoke-na-sloupec-nefunguje]] — revoke update (sloupec) nedělá nic, když má role právo na celou tabulku — uživatel si mohl přepsat tenant_id a obejít izolaci školního tenantu · resolved · 2026-08-19
- [[ledger-pravidlo-blokovalo-mazani-uctu]] — Pravidlo "do instead nothing" chránící append-only ledger rozbilo kaskádu z cizího klíče — účet nešel smazat vůbec, ani na žádost podle GDPR · resolved · 2026-08-18


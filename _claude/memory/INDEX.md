<!-- AUTO-GENEROVÁNO reindex.js — NEEDITUJ ručně. Zdroj pravdy = frontmatter souborů. -->
# Index paměti — inkwit

> Plný katalog on-demand záznamů. Always-load vrstvu viz auto-memory/MEMORY.md.

## Context
- [[project-context]] — Živý stav projektu inkwit — fáze, milníky, aktuální focus · active · 2026-08-18

## Decisions
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
- [[jak-tvorit-slovni-zasobu]] — Recept na tvorbu konceptů — kalibrace obtížnosti, co patří a nepatří do přijímaných tvarů, kritéria jednojazyčnosti, povinná kontrola validátorem · active · 2026-08-18
- [[nextjs-middleware-matcher-tecka]] — V Next.js middleware matcheru nefunguje escapovaná tečka \. uvnitř custom skupiny — path-to-regexp zbaští backslash a lookahead pak odmítne všechno; použij [.] · active · 2026-08-18
- [[rls-pomocne-funkce-mimo-public]] — Politiky RLS se vyhodnocují právy dotazujícího se uživatele, takže revoke execute je rozbije — pomocné funkce se schovávají přesunem do schématu mimo PostgREST, ne odebráním práv · active · 2026-08-18
- [[supabase-chyby-podle-kodu]] — Chyby ze Supabase Auth mapovat podle err.code, ne podle textu; zamítnutá pozvánka z triggeru dorazí jako 23514 a fallback nesmí svalovat všechno na pozvánku · active · 2026-08-18

## Bugs
- [[revoke-na-sloupec-nefunguje]] — revoke update (sloupec) nedělá nic, když má role právo na celou tabulku — uživatel si mohl přepsat tenant_id a obejít izolaci školního tenantu · resolved · 2026-08-19
- [[ledger-pravidlo-blokovalo-mazani-uctu]] — Pravidlo "do instead nothing" chránící append-only ledger rozbilo kaskádu z cizího klíče — účet nešel smazat vůbec, ani na žádost podle GDPR · resolved · 2026-08-18

## Code issues
- [[kontrast-text-muted-na-pozadi]] — Neaktivní navigace, tabbar a štítek zásoby používají --text-muted na --bg = 4.04:1, což je pod AA; design-system.md přesně před tímhle varoval · active · 2026-08-18


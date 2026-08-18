---
name: pamet-v-repu-ne-v-osobnim-vaultu
description: Projektová paměť žije v _claude/ uvnitř repa a verzuje se gitem, ne v osobním vaultu na H:
type: decision
status: active
created: 2026-08-18
updated: 2026-08-18
---

# Paměť v repu (`_claude/`), ne v osobním vaultu

**Kontext:** Šablona VZOR předpokládá vault mimo repo na `H:\Vaults\<PROJECT_NAME>\`.
Ten disk na stroji neexistuje a šablona byla rozbalená rovnou do `C:\Projekty\inkwit\`,
ale nikdy nedokončena — placeholdery zůstaly nenahrazené, `.claude/` s hookem chyběl,
takže paměť fakticky neběžela.

**Rozhodnutí (2026-08-18):** paměť zůstává v `_claude/` uvnitř repa, verzovaná gitem.
`autoMemoryDirectory` v `.claude/settings.json` míří na `C:/Projekty/inkwit/_claude/auto-memory`.

**Důvod:**
- Routing pravidlo majitele: *„Platí to i pro jiné projekty?"* Ne + projektové → git
  projektu, ne osobní vault. Rozhodnutí a stav Inkwitu jsou projektová fakta.
- Verzování je půlka hodnoty `decisions/` — bez historie je to jen složka souborů.
- `_claude/` (na rozdíl od `.claude/`) je jednoznačně čitelné jako „tohle jde do gitu";
  `.claude/` míchá verzované věci se `settings.local.json`, který se ignoruje.

**Důsledky:**
- Repo bylo 2026-08-18 inicializováno jako git (do té doby neverzované, bez remote).
- Do `_claude/` nesmí nic osobního ani žádné credentials — commituje se to.
- Osobní/cross-project věci patří do `~\.claude\vault\`, který je mimo git.
- INDEX vlastní `.claude/hooks/reindex.js` (SessionStart hook), needitovat ručně.

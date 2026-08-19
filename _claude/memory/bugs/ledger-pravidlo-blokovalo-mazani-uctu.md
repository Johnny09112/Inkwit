---
name: ledger-pravidlo-blokovalo-mazani-uctu
description: Pravidlo "do instead nothing" chránící append-only ledger rozbilo kaskádu z cizího klíče — účet nešel smazat vůbec, ani na žádost podle GDPR
type: bug
status: resolved
created: 2026-08-18
updated: 2026-08-18
related: [tajemstvi-hry-v-schematu]
---

# Ochrana ledgeru znemožnila smazat uživatele

**Nalezeno 2026-08-18** při úklidu testovacích účtů po kroku C0. Nešlo o test,
který by spadl — spadl obyčejný `delete from auth.users`.

## Příznak

```
ERROR: XX000: referential integrity query on "profiles" from constraint
"ledger_user_id_fkey" on "ledger" gave unexpected result
HINT: This is most likely due to a rule having rewritten the query.
```

## Root cause

Append-only ledger jsem jistil dvakrát — odebranými právy **a** pravidly:

```sql
create rule ledger_no_delete as on delete to public.ledger do instead nothing;
```

Pravidlo ale přepisuje **každý** `delete` nad tabulkou, včetně toho, který si
Postgres pouští sám při vyhodnocování `on delete cascade`. Kaskáda pak vrátí
jiný výsledek, než integrita čeká, a celé mazání spadne.

**Dopad byl větší, než se zdá:** účet nešel smazat vůbec. Ani testovací, ani
na žádost podle GDPR — a to u produktu pro nezletilé není detail.

## Oprava

Pravidla zrušena, append-only drží **jen odebraná práva**:

```sql
revoke update, delete on public.ledger from anon, authenticated, service_role;
```

Práva se na kaskády z cizích klíčů nevztahují (běží pod vlastníkem omezení),
takže mazání projde, ale přes API historii nikdo nepřepíše.

## Poučení

**Na append-only nepoužívat pravidla (`do instead nothing`).** Vypadají jako
silnější ochrana, ale tiše mění chování cizích klíčů. Práva dělají totéž
a nic nerozbíjejí.

Obecněji: dvojí jištění téhož není zadarmo. Tohle byla druhá vrstva, kterou
jsem přidal „pro jistotu", a rozbila funkci, o které jsem v tu chvíli nepřemýšlel.

Regresi hlídá test „účet jde smazat i se záznamy v ledgeru (GDPR)".

## Druhý výskyt téže chyby (2026-08-19)

`drawing_strokes.author_id` odkazoval na `profiles` **bez `on delete cascade`**,
takže platilo NO ACTION a účet, který už něco nakreslil, zase nešel smazat.

**Test to nechytil, protože testovací uživatel žádné tahy neměl.** Test „účet
jde smazat" existoval od první opravy, ale ověřoval prázdný účet — což je přesně
ten případ, který nikdy neselže.

Poučení navíc: **test na mazání musí mazat účet, který po sobě něco nechal.**
Rozšířeno o kresbu, tahy, tip i záznam v ledgeru.

Obecné pravidlo pro tenhle projekt: **každý nový cizí klíč mířící na `profiles`
potřebuje vědomé rozhodnutí, co se stane při smazání účtu.** Výchozí NO ACTION
znamená „účet nejde smazat", a to je u produktu pro nezletilé špatná výchozí
hodnota.

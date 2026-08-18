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

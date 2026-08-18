-- Inkwit — oprava: kvůli ochraně ledgeru nešel smazat uživatel
--
-- Původní ochrana append-only byla dvojí: odebraná práva a k tomu pravidla
--
--   create rule ledger_no_delete as on delete to public.ledger do instead nothing;
--
-- Pravidlo ale přepisuje KAŽDÝ delete nad tabulkou, včetně toho, který si
-- Postgres pouští sám při kaskádě z cizího klíče. Smazání uživatele proto
-- skončilo na:
--
--   ERROR: referential integrity query on "profiles" from constraint
--          "ledger_user_id_fkey" on "ledger" gave unexpected result
--
-- Prakticky to znamenalo, že **účet nešel smazat vůbec** — ani testovací,
-- ani na žádost podle GDPR. Nalezeno 2026-08-18 při úklidu testovacích účtů.

drop rule ledger_no_update on public.ledger;
drop rule ledger_no_delete on public.ledger;

-- Append-only se drží právy, ne pravidly. Práva se na kaskády z cizích klíčů
-- nevztahují (ty běží pod vlastníkem omezení), takže mazání uživatele projde,
-- ale nikdo přes API historii nepřepíše.
revoke update, delete on public.ledger from anon, authenticated, service_role;

comment on table public.ledger is
  'Append-only: body a kredity se nikdy nepřepisují, jen přičítá záznam. '
  'Drží to odebrané právo UPDATE/DELETE pro všechny API role. '
  'NEPOUŽÍVAT na to pravidla (do instead nothing) — rozbíjejí kaskádu '
  'z cizích klíčů a znemožní smazat uživatele. Opravu balanc dělej protizápisem.';

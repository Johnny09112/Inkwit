-- Inkwit — nápověda u těžkých pojmů
--
-- Tři pokusy na „nostalgii" jsou u většiny hráčů tři prohry. Nápověda to má
-- zmírnit, aniž by se z hádání stalo luštění.
--
-- Nápověda se NEPÍŠE ručně, POČÍTÁ se ze zadání: první písmeno a délka.
-- U tisíce pojmů by ruční nápovědy znamenaly tisíc dalších rozhodnutí —
-- a `docs/roadmap.md` říká, že co vyžaduje pravidelnou lidskou obsluhu,
-- to nemá vzniknout. Sloupec `concept_locales.hint` zůstává jako ruční
-- výjimka pro pojmy, kde první písmeno nepomůže.

-- Zaznamenat, že hráč nápovědu dostal. Bez toho nejde poznat, jestli kresba
-- byla srozumitelná, nebo jestli jen pomohla nápověda — a srozumitelnost je
-- jedna ze dvou metrik, na kterých stojí žebříčky.
alter table public.guesses
  add column hint_shown boolean not null default false;

comment on column public.guesses.hint_shown is
  'Dostal hráč u tohoto tipu nápovědu? Metrika srozumitelnosti kresby smí '
  'počítat jen tipy bez nápovědy, jinak měří nápovědu, ne kresbu.';

-- Prahy do konfigurace, ne do kódu (neporušitelné pravidlo 6).
insert into public.game_config (key, value, is_public, note) values
  ('hint_after_attempt', '1'::jsonb, true,
   'Po kolikátém špatném tipu se ukáže nápověda. 0 = nikdy.'),

  ('hint_min_difficulty', '3'::jsonb, true,
   'Od jaké obtížnosti se nápověda nabízí. 3 = jen nejtěžší pojmy. '
   'U snadných by z hádání udělala luštění.')
on conflict (key) do nothing;

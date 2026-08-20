-- Generováno z supabase/seed/concepts.json příkazem
--   node supabase/seed/check-concepts.mjs --sql > supabase/migrations/<ts>_seed_concepts.sql
-- Needituj ručně. Klíčem je slug, takže opakované nasazení je bezpečné.

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('had', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'had' from public.concepts where slug = 'had'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['had', 'hada', 'hadi', 'užovka', 'zmije']::text[] from public.concepts where slug = 'had'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'snake' from public.concepts where slug = 'had'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['snake', 'serpent']::text[] from public.concepts where slug = 'had'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('holub', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'holub' from public.concepts where slug = 'holub'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['holub', 'holuba', 'holoubek']::text[] from public.concepts where slug = 'holub'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pigeon' from public.concepts where slug = 'holub'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pigeon', 'dove']::text[] from public.concepts where slug = 'holub'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kachna', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kachna' from public.concepts where slug = 'kachna'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kachna', 'kachnu', 'kachnička', 'kačer']::text[] from public.concepts where slug = 'kachna'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'duck' from public.concepts where slug = 'kachna'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['duck', 'duckling', 'drake']::text[] from public.concepts where slug = 'kachna'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kocka', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kočka' from public.concepts where slug = 'kocka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kočka', 'kocour', 'kočku', 'kočička', 'koťátko']::text[] from public.concepts where slug = 'kocka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cat' from public.concepts where slug = 'kocka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cat', 'kitten', 'kitty', 'tomcat']::text[] from public.concepts where slug = 'kocka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('koza', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'koza' from public.concepts where slug = 'koza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['koza', 'kozu', 'kozel', 'kůzle']::text[] from public.concepts where slug = 'koza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'goat' from public.concepts where slug = 'koza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['goat', 'billy goat', 'nanny goat']::text[] from public.concepts where slug = 'koza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('krab', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'krab' from public.concepts where slug = 'krab'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['krab', 'kraba', 'rak']::text[] from public.concepts where slug = 'krab'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'crab' from public.concepts where slug = 'krab'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['crab', 'crayfish']::text[] from public.concepts where slug = 'krab'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kralik', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'králík' from public.concepts where slug = 'kralik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['králík', 'králíka', 'zajíc', 'zajíček']::text[] from public.concepts where slug = 'kralik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'rabbit' from public.concepts where slug = 'kralik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['rabbit', 'bunny', 'hare']::text[] from public.concepts where slug = 'kralik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('krava', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kráva' from public.concepts where slug = 'krava'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kráva', 'krávu', 'kravka', 'býk', 'tele']::text[] from public.concepts where slug = 'krava'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cow' from public.concepts where slug = 'krava'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cow', 'cattle', 'calf']::text[] from public.concepts where slug = 'krava'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kun', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kůň' from public.concepts where slug = 'kun'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kůň', 'koně', 'koníček', 'hřebec', 'klisna', 'poník']::text[] from public.concepts where slug = 'kun'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'horse' from public.concepts where slug = 'kun'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['horse', 'pony', 'stallion', 'mare', 'foal']::text[] from public.concepts where slug = 'kun'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lev', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lev' from public.concepts where slug = 'lev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lev', 'lva', 'lvice']::text[] from public.concepts where slug = 'lev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lion' from public.concepts where slug = 'lev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lion', 'lioness']::text[] from public.concepts where slug = 'lev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('liska', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'liška' from public.concepts where slug = 'liska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['liška', 'lišku', 'lišák']::text[] from public.concepts where slug = 'liska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'fox' from public.concepts where slug = 'liska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['fox', 'vixen']::text[] from public.concepts where slug = 'liska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('medved', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'medvěd' from public.concepts where slug = 'medved'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['medvěd', 'medvěda', 'méďa', 'medvídek']::text[] from public.concepts where slug = 'medved'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bear' from public.concepts where slug = 'medved'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bear', 'teddy bear']::text[] from public.concepts where slug = 'medved'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('motyl', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'motýl' from public.concepts where slug = 'motyl'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['motýl', 'motýla', 'motýlek']::text[] from public.concepts where slug = 'motyl'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'butterfly' from public.concepts where slug = 'motyl'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['butterfly', 'moth']::text[] from public.concepts where slug = 'motyl'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mys', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'myš' from public.concepts where slug = 'mys'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['myš', 'myšku', 'myška', 'myši']::text[] from public.concepts where slug = 'mys'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'mouse' from public.concepts where slug = 'mys'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['mouse', 'mice']::text[] from public.concepts where slug = 'mys'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('opice', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'opice' from public.concepts where slug = 'opice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['opice', 'opici', 'opička', 'šimpanz']::text[] from public.concepts where slug = 'opice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'monkey' from public.concepts where slug = 'opice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['monkey', 'ape', 'chimpanzee', 'chimp']::text[] from public.concepts where slug = 'opice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ovce', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ovce' from public.concepts where slug = 'ovce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ovce', 'ovečka', 'beran', 'jehně']::text[] from public.concepts where slug = 'ovce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sheep' from public.concepts where slug = 'ovce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sheep', 'lamb', 'ram']::text[] from public.concepts where slug = 'ovce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pavouk', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pavouk' from public.concepts where slug = 'pavouk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pavouk', 'pavouka', 'pavoučí']::text[] from public.concepts where slug = 'pavouk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'spider' from public.concepts where slug = 'pavouk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['spider']::text[] from public.concepts where slug = 'pavouk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pes', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pes' from public.concepts where slug = 'pes'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pes', 'psa', 'psi', 'pejsek', 'hafan', 'štěně', 'čokl']::text[] from public.concepts where slug = 'pes'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'dog' from public.concepts where slug = 'pes'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['dog', 'doggy', 'puppy', 'hound']::text[] from public.concepts where slug = 'pes'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('prase', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'prase' from public.concepts where slug = 'prase'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['prase', 'prasátko', 'čuně', 'vepř']::text[] from public.concepts where slug = 'prase'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pig' from public.concepts where slug = 'prase'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pig', 'piglet', 'hog']::text[] from public.concepts where slug = 'prase'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ptak', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pták' from public.concepts where slug = 'ptak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pták', 'ptáka', 'ptáček', 'ptáci']::text[] from public.concepts where slug = 'ptak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bird' from public.concepts where slug = 'ptak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bird', 'birdie']::text[] from public.concepts where slug = 'ptak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ryba', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ryba' from public.concepts where slug = 'ryba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ryba', 'rybu', 'rybka', 'kapr']::text[] from public.concepts where slug = 'ryba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'fish' from public.concepts where slug = 'ryba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['fish', 'fishy', 'carp']::text[] from public.concepts where slug = 'ryba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('slepice', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'slepice' from public.concepts where slug = 'slepice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['slepice', 'slepici', 'kuře', 'kuřátko', 'kohout']::text[] from public.concepts where slug = 'slepice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hen' from public.concepts where slug = 'slepice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hen', 'chicken', 'chick', 'rooster']::text[] from public.concepts where slug = 'slepice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('slon', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'slon' from public.concepts where slug = 'slon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['slon', 'slona', 'slonice']::text[] from public.concepts where slug = 'slon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'elephant' from public.concepts where slug = 'slon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['elephant']::text[] from public.concepts where slug = 'slon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('sova', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sova' from public.concepts where slug = 'sova'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sova', 'sovu', 'výr']::text[] from public.concepts where slug = 'sova'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'owl' from public.concepts where slug = 'sova'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['owl']::text[] from public.concepts where slug = 'sova'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tucnak', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tučňák' from public.concepts where slug = 'tucnak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tučňák', 'tučňáka']::text[] from public.concepts where slug = 'tucnak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'penguin' from public.concepts where slug = 'tucnak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['penguin']::text[] from public.concepts where slug = 'tucnak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tygr', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tygr' from public.concepts where slug = 'tygr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tygr', 'tygra', 'tygřík']::text[] from public.concepts where slug = 'tygr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tiger' from public.concepts where slug = 'tygr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tiger', 'tigress']::text[] from public.concepts where slug = 'tygr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vcela', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'včela' from public.concepts where slug = 'vcela'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['včela', 'včelu', 'včelka', 'vosa']::text[] from public.concepts where slug = 'vcela'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bee' from public.concepts where slug = 'vcela'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bee', 'honeybee', 'wasp']::text[] from public.concepts where slug = 'vcela'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vlk', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vlk' from public.concepts where slug = 'vlk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vlk', 'vlka', 'vlci']::text[] from public.concepts where slug = 'vlk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'wolf' from public.concepts where slug = 'vlk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['wolf', 'wolves']::text[] from public.concepts where slug = 'vlk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zaba', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žába' from public.concepts where slug = 'zaba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žába', 'žábu', 'žabka', 'skokan']::text[] from public.concepts where slug = 'zaba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'frog' from public.concepts where slug = 'zaba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['frog', 'toad']::text[] from public.concepts where slug = 'zaba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zebra', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zebra' from public.concepts where slug = 'zebra'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zebra', 'zebru']::text[] from public.concepts where slug = 'zebra'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'zebra' from public.concepts where slug = 'zebra'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['zebra']::text[] from public.concepts where slug = 'zebra'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zirafa', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žirafa' from public.concepts where slug = 'zirafa'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žirafa', 'žirafu']::text[] from public.concepts where slug = 'zirafa'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'giraffe' from public.concepts where slug = 'zirafa'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['giraffe']::text[] from public.concepts where slug = 'zirafa'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zralok', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žralok' from public.concepts where slug = 'zralok'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žralok', 'žraloka']::text[] from public.concepts where slug = 'zralok'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'shark' from public.concepts where slug = 'zralok'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['shark']::text[] from public.concepts where slug = 'zralok'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('beruska', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'beruška' from public.concepts where slug = 'beruska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['beruška', 'berušku', 'slunéčko sedmitečné']::text[] from public.concepts where slug = 'beruska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'ladybug' from public.concepts where slug = 'beruska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['ladybug', 'ladybird']::text[] from public.concepts where slug = 'beruska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('delfin', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'delfín' from public.concepts where slug = 'delfin'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['delfín', 'delfína']::text[] from public.concepts where slug = 'delfin'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'dolphin' from public.concepts where slug = 'delfin'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['dolphin']::text[] from public.concepts where slug = 'delfin'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hroch', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hroch' from public.concepts where slug = 'hroch'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hroch', 'hrocha']::text[] from public.concepts where slug = 'hroch'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hippo' from public.concepts where slug = 'hroch'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hippo', 'hippopotamus']::text[] from public.concepts where slug = 'hroch'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('chobotnice', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'chobotnice' from public.concepts where slug = 'chobotnice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['chobotnice', 'chobotnici', 'krakatice', 'oliheň']::text[] from public.concepts where slug = 'chobotnice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'octopus' from public.concepts where slug = 'chobotnice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['octopus', 'squid']::text[] from public.concepts where slug = 'chobotnice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('jelen', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'jelen' from public.concepts where slug = 'jelen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['jelen', 'jelena', 'srnec', 'srna', 'paroháč']::text[] from public.concepts where slug = 'jelen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'deer' from public.concepts where slug = 'jelen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['deer', 'stag']::text[] from public.concepts where slug = 'jelen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('jezek', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ježek' from public.concepts where slug = 'jezek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ježek', 'ježka', 'ježeček']::text[] from public.concepts where slug = 'jezek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hedgehog' from public.concepts where slug = 'jezek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hedgehog']::text[] from public.concepts where slug = 'jezek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('klokan', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'klokan' from public.concepts where slug = 'klokan'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['klokan', 'klokana']::text[] from public.concepts where slug = 'klokan'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'kangaroo' from public.concepts where slug = 'klokan'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['kangaroo', 'roo']::text[] from public.concepts where slug = 'klokan'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('krokodyl', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'krokodýl' from public.concepts where slug = 'krokodyl'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['krokodýl', 'krokodýla', 'aligátor']::text[] from public.concepts where slug = 'krokodyl'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'crocodile' from public.concepts where slug = 'krokodyl'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['crocodile', 'croc', 'alligator']::text[] from public.concepts where slug = 'krokodyl'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('meduza', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'medúza' from public.concepts where slug = 'meduza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['medúza', 'medúzu']::text[] from public.concepts where slug = 'meduza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'jellyfish' from public.concepts where slug = 'meduza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['jellyfish', 'jelly fish']::text[] from public.concepts where slug = 'meduza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mravenec', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'mravenec' from public.concepts where slug = 'mravenec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['mravenec', 'mravence', 'mraveneček']::text[] from public.concepts where slug = 'mravenec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'ant' from public.concepts where slug = 'mravenec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['ant']::text[] from public.concepts where slug = 'mravenec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('netopyr', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'netopýr' from public.concepts where slug = 'netopyr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['netopýr', 'netopýra']::text[] from public.concepts where slug = 'netopyr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bat' from public.concepts where slug = 'netopyr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bat']::text[] from public.concepts where slug = 'netopyr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nosorozec', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'nosorožec' from public.concepts where slug = 'nosorozec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['nosorožec', 'nosorožce']::text[] from public.concepts where slug = 'nosorozec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'rhino' from public.concepts where slug = 'nosorozec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['rhino', 'rhinoceros']::text[] from public.concepts where slug = 'nosorozec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('orel', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'orel' from public.concepts where slug = 'orel'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['orel', 'orla', 'orlice']::text[] from public.concepts where slug = 'orel'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'eagle' from public.concepts where slug = 'orel'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['eagle', 'hawk']::text[] from public.concepts where slug = 'orel'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('panda', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'panda' from public.concepts where slug = 'panda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['panda', 'pandu', 'medvídek panda']::text[] from public.concepts where slug = 'panda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'panda' from public.concepts where slug = 'panda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['panda', 'giant panda']::text[] from public.concepts where slug = 'panda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('papousek', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'papoušek' from public.concepts where slug = 'papousek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['papoušek', 'papouška', 'ara']::text[] from public.concepts where slug = 'papousek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'parrot' from public.concepts where slug = 'papousek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['parrot', 'macaw']::text[] from public.concepts where slug = 'papousek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('plamenak', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'plameňák' from public.concepts where slug = 'plamenak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['plameňák', 'plameňáka']::text[] from public.concepts where slug = 'plamenak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'flamingo' from public.concepts where slug = 'plamenak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['flamingo']::text[] from public.concepts where slug = 'plamenak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pstros', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pštros' from public.concepts where slug = 'pstros'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pštros', 'pštrosa']::text[] from public.concepts where slug = 'pstros'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'ostrich' from public.concepts where slug = 'pstros'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['ostrich']::text[] from public.concepts where slug = 'pstros'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('snek', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'šnek' from public.concepts where slug = 'snek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['šnek', 'šneka', 'hlemýžď', 'plž']::text[] from public.concepts where slug = 'snek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'snail' from public.concepts where slug = 'snek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['snail', 'slug']::text[] from public.concepts where slug = 'snek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tulen', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tuleň' from public.concepts where slug = 'tulen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tuleň', 'tuleně', 'lachtan']::text[] from public.concepts where slug = 'tulen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'seal' from public.concepts where slug = 'tulen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['seal', 'sea lion']::text[] from public.concepts where slug = 'tulen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vazka', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vážka' from public.concepts where slug = 'vazka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vážka', 'vážku']::text[] from public.concepts where slug = 'vazka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'dragonfly' from public.concepts where slug = 'vazka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['dragonfly']::text[] from public.concepts where slug = 'vazka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('velbloud', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'velbloud' from public.concepts where slug = 'velbloud'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['velbloud', 'velblouda', 'dromedár']::text[] from public.concepts where slug = 'velbloud'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'camel' from public.concepts where slug = 'velbloud'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['camel', 'dromedary']::text[] from public.concepts where slug = 'velbloud'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('velryba', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'velryba' from public.concepts where slug = 'velryba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['velryba', 'velrybu', 'kytovec']::text[] from public.concepts where slug = 'velryba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'whale' from public.concepts where slug = 'velryba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['whale', 'humpback']::text[] from public.concepts where slug = 'velryba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('veverka', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'veverka' from public.concepts where slug = 'veverka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['veverka', 'veverku', 'veverča']::text[] from public.concepts where slug = 'veverka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'squirrel' from public.concepts where slug = 'veverka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['squirrel']::text[] from public.concepts where slug = 'veverka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zelva', 2, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'želva' from public.concepts where slug = 'zelva'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['želva', 'želvu', 'želvička']::text[] from public.concepts where slug = 'zelva'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'turtle' from public.concepts where slug = 'zelva'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['turtle', 'tortoise']::text[] from public.concepts where slug = 'zelva'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('chameleon', 3, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'chameleon' from public.concepts where slug = 'chameleon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['chameleon', 'chameleona']::text[] from public.concepts where slug = 'chameleon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'chameleon' from public.concepts where slug = 'chameleon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['chameleon']::text[] from public.concepts where slug = 'chameleon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lenochod', 3, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lenochod' from public.concepts where slug = 'lenochod'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lenochod', 'lenochoda']::text[] from public.concepts where slug = 'lenochod'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sloth' from public.concepts where slug = 'lenochod'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sloth']::text[] from public.concepts where slug = 'lenochod'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ptakopysk', 3, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ptakopysk' from public.concepts where slug = 'ptakopysk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ptakopysk', 'ptakopyska']::text[] from public.concepts where slug = 'ptakopysk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'platypus' from public.concepts where slug = 'ptakopysk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['platypus', 'duck-billed platypus']::text[] from public.concepts where slug = 'ptakopysk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('surikata', 3, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'surikata' from public.concepts where slug = 'surikata'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['surikata', 'surikatu']::text[] from public.concepts where slug = 'surikata'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'meerkat' from public.concepts where slug = 'surikata'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['meerkat', 'suricate']::text[] from public.concepts where slug = 'surikata'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tapir', 3, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tapír' from public.concepts where slug = 'tapir'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tapír', 'tapíra']::text[] from public.concepts where slug = 'tapir'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tapir' from public.concepts where slug = 'tapir'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tapir']::text[] from public.concepts where slug = 'tapir'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('auto', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'auto' from public.concepts where slug = 'auto'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['auto', 'automobil', 'autíčko', 'vůz']::text[] from public.concepts where slug = 'auto'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'car' from public.concepts where slug = 'auto'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['car', 'automobile', 'vehicle']::text[] from public.concepts where slug = 'auto'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('boty', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'boty' from public.concepts where slug = 'boty'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['boty', 'bota', 'botu', 'obuv', 'tenisky']::text[] from public.concepts where slug = 'boty'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'shoes' from public.concepts where slug = 'boty'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['shoes', 'shoe', 'boot', 'boots', 'sneakers']::text[] from public.concepts where slug = 'boty'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('bryle', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'brýle' from public.concepts where slug = 'bryle'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['brýle', 'brejle', 'očala']::text[] from public.concepts where slug = 'bryle'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'glasses' from public.concepts where slug = 'bryle'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['glasses', 'spectacles', 'eyeglasses']::text[] from public.concepts where slug = 'bryle'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('darek', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'dárek' from public.concepts where slug = 'darek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['dárek', 'dárku', 'dáreček', 'balíček']::text[] from public.concepts where slug = 'darek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'gift' from public.concepts where slug = 'darek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['gift', 'present', 'parcel']::text[] from public.concepts where slug = 'darek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('destnik', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'deštník' from public.concepts where slug = 'destnik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['deštník', 'deštníku', 'slunečník']::text[] from public.concepts where slug = 'destnik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'umbrella' from public.concepts where slug = 'destnik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['umbrella', 'parasol']::text[] from public.concepts where slug = 'destnik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('dum', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'dům' from public.concepts where slug = 'dum'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['dům', 'domu', 'domek', 'chalupa', 'barák']::text[] from public.concepts where slug = 'dum'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'house' from public.concepts where slug = 'dum'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['house', 'home', 'cottage']::text[] from public.concepts where slug = 'dum'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('dvere', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'dveře' from public.concepts where slug = 'dvere'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['dveře', 'dveří', 'vrata']::text[] from public.concepts where slug = 'dvere'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'door' from public.concepts where slug = 'dvere'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['door', 'doors', 'gate']::text[] from public.concepts where slug = 'dvere'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hodiny', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hodiny' from public.concepts where slug = 'hodiny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hodiny', 'hodinky', 'ciferník']::text[] from public.concepts where slug = 'hodiny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'clock' from public.concepts where slug = 'hodiny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['clock', 'watch']::text[] from public.concepts where slug = 'hodiny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hrnek', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hrnek' from public.concepts where slug = 'hrnek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hrnek', 'hrnku', 'šálek', 'hrneček']::text[] from public.concepts where slug = 'hrnek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'mug' from public.concepts where slug = 'hrnek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['mug', 'cup']::text[] from public.concepts where slug = 'hrnek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('klic', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'klíč' from public.concepts where slug = 'klic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['klíč', 'klíče', 'klíček']::text[] from public.concepts where slug = 'klic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'key' from public.concepts where slug = 'klic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['key', 'keys']::text[] from public.concepts where slug = 'klic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('klobouk', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'klobouk' from public.concepts where slug = 'klobouk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['klobouk', 'klobouku', 'čepice', 'cylindr']::text[] from public.concepts where slug = 'klobouk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hat' from public.concepts where slug = 'klobouk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hat', 'cap', 'top hat']::text[] from public.concepts where slug = 'klobouk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kniha', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kniha' from public.concepts where slug = 'kniha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kniha', 'knihu', 'knížka', 'kniška']::text[] from public.concepts where slug = 'kniha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'book' from public.concepts where slug = 'kniha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['book']::text[] from public.concepts where slug = 'kniha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kolo', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kolo' from public.concepts where slug = 'kolo'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kolo', 'bicykl', 'jízdní kolo', 'bike']::text[] from public.concepts where slug = 'kolo'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bicycle' from public.concepts where slug = 'kolo'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bicycle', 'bike', 'cycle']::text[] from public.concepts where slug = 'kolo'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('koste', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'koště' from public.concepts where slug = 'koste'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['koště', 'smeták', 'metla']::text[] from public.concepts where slug = 'koste'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'broom' from public.concepts where slug = 'koste'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['broom', 'broomstick']::text[] from public.concepts where slug = 'koste'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kytara', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kytara' from public.concepts where slug = 'kytara'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kytara', 'kytaru', 'elektrická kytara']::text[] from public.concepts where slug = 'kytara'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'guitar' from public.concepts where slug = 'kytara'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['guitar', 'electric guitar']::text[] from public.concepts where slug = 'kytara'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lampa', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lampa' from public.concepts where slug = 'lampa'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lampa', 'lampu', 'lampička', 'svítilna']::text[] from public.concepts where slug = 'lampa'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lamp' from public.concepts where slug = 'lampa'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lamp', 'light']::text[] from public.concepts where slug = 'lampa'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('letadlo', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'letadlo' from public.concepts where slug = 'letadlo'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['letadlo', 'letadla', 'letoun']::text[] from public.concepts where slug = 'letadlo'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'airplane' from public.concepts where slug = 'letadlo'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['airplane', 'plane', 'aeroplane', 'aircraft']::text[] from public.concepts where slug = 'letadlo'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lod', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'loď' from public.concepts where slug = 'lod'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['loď', 'lodě', 'lodička', 'plachetnice']::text[] from public.concepts where slug = 'lod'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'boat' from public.concepts where slug = 'lod'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['boat', 'ship', 'sailboat']::text[] from public.concepts where slug = 'lod'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mic', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'míč' from public.concepts where slug = 'mic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['míč', 'míče', 'balón', 'míček']::text[] from public.concepts where slug = 'mic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'ball' from public.concepts where slug = 'mic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['ball', 'balloon']::text[] from public.concepts where slug = 'mic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nuzky', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'nůžky' from public.concepts where slug = 'nuzky'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['nůžky', 'nůžek']::text[] from public.concepts where slug = 'nuzky'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'scissors' from public.concepts where slug = 'nuzky'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['scissors']::text[] from public.concepts where slug = 'nuzky'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('panev', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pánev' from public.concepts where slug = 'panev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pánev', 'pánvička', 'pekáč']::text[] from public.concepts where slug = 'panev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pan' from public.concepts where slug = 'panev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pan', 'frying pan', 'skillet']::text[] from public.concepts where slug = 'panev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('postel', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'postel' from public.concepts where slug = 'postel'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['postel', 'postele', 'lůžko', 'peřina']::text[] from public.concepts where slug = 'postel'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bed' from public.concepts where slug = 'postel'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bed']::text[] from public.concepts where slug = 'postel'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('stul', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'stůl' from public.concepts where slug = 'stul'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['stůl', 'stolu', 'psací stůl', 'jídelní stůl']::text[] from public.concepts where slug = 'stul'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'table' from public.concepts where slug = 'stul'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['table', 'desk', 'dining table']::text[] from public.concepts where slug = 'stul'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('svicka', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'svíčka' from public.concepts where slug = 'svicka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['svíčka', 'svíčku', 'svíce']::text[] from public.concepts where slug = 'svicka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'candle' from public.concepts where slug = 'svicka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['candle', 'candles']::text[] from public.concepts where slug = 'svicka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('telefon', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'telefon' from public.concepts where slug = 'telefon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['telefon', 'telefonu', 'mobil', 'mobilní telefon']::text[] from public.concepts where slug = 'telefon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'phone' from public.concepts where slug = 'telefon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['phone', 'telephone', 'mobile', 'cellphone']::text[] from public.concepts where slug = 'telefon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tuzka', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tužka' from public.concepts where slug = 'tuzka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tužka', 'tužku', 'pastelka', 'propiska']::text[] from public.concepts where slug = 'tuzka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pencil' from public.concepts where slug = 'tuzka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pencil', 'pen', 'crayon']::text[] from public.concepts where slug = 'tuzka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vlak', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vlak' from public.concepts where slug = 'vlak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vlak', 'vlaku', 'lokomotiva', 'mašinka']::text[] from public.concepts where slug = 'vlak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'train' from public.concepts where slug = 'vlak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['train', 'locomotive', 'steam train']::text[] from public.concepts where slug = 'vlak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zarovka', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žárovka' from public.concepts where slug = 'zarovka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žárovka', 'žárovku', 'elektrická žárovka']::text[] from public.concepts where slug = 'zarovka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'light bulb' from public.concepts where slug = 'zarovka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['light bulb', 'bulb', 'lightbulb']::text[] from public.concepts where slug = 'zarovka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zidle', 1, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'židle' from public.concepts where slug = 'zidle'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['židle', 'židli', 'křeslo', 'stolička']::text[] from public.concepts where slug = 'zidle'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'chair' from public.concepts where slug = 'zidle'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['chair', 'stool', 'seat']::text[] from public.concepts where slug = 'zidle'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('buben', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'buben' from public.concepts where slug = 'buben'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['buben', 'bubny', 'bubínek', 'bicí']::text[] from public.concepts where slug = 'buben'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'drum' from public.concepts where slug = 'buben'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['drum', 'drums', 'drum kit']::text[] from public.concepts where slug = 'buben'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('budik', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'budík' from public.concepts where slug = 'budik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['budík', 'budíku', 'budíček']::text[] from public.concepts where slug = 'budik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'alarm clock' from public.concepts where slug = 'budik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['alarm clock', 'alarm']::text[] from public.concepts where slug = 'budik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('dalekohled', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'dalekohled' from public.concepts where slug = 'dalekohled'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['dalekohled', 'dalekohledu', 'triedr']::text[] from public.concepts where slug = 'dalekohled'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'telescope' from public.concepts where slug = 'dalekohled'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['telescope', 'binoculars', 'spyglass']::text[] from public.concepts where slug = 'dalekohled'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('fotoaparat', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'fotoaparát' from public.concepts where slug = 'fotoaparat'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['fotoaparát', 'foťák', 'kamera', 'aparát']::text[] from public.concepts where slug = 'fotoaparat'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'camera' from public.concepts where slug = 'fotoaparat'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['camera', 'photo camera']::text[] from public.concepts where slug = 'fotoaparat'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('globus', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'glóbus' from public.concepts where slug = 'globus'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['glóbus', 'zeměkoule']::text[] from public.concepts where slug = 'globus'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'globe' from public.concepts where slug = 'globus'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['globe']::text[] from public.concepts where slug = 'globus'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('harmonika', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'harmonika' from public.concepts where slug = 'harmonika'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['harmonika', 'harmoniku', 'akordeon', 'tahací harmonika']::text[] from public.concepts where slug = 'harmonika'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'accordion' from public.concepts where slug = 'harmonika'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['accordion', 'harmonica']::text[] from public.concepts where slug = 'harmonika'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('houpacka', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'houpačka' from public.concepts where slug = 'houpacka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['houpačka', 'houpačku', 'houpání']::text[] from public.concepts where slug = 'houpacka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'swing' from public.concepts where slug = 'houpacka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['swing', 'swings']::text[] from public.concepts where slug = 'houpacka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('housle', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'housle' from public.concepts where slug = 'housle'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['housle', 'housličky']::text[] from public.concepts where slug = 'housle'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'violin' from public.concepts where slug = 'housle'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['violin', 'fiddle']::text[] from public.concepts where slug = 'housle'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kolobezka', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'koloběžka' from public.concepts where slug = 'kolobezka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['koloběžka', 'koloběžku']::text[] from public.concepts where slug = 'kolobezka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'scooter' from public.concepts where slug = 'kolobezka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['scooter', 'kick scooter']::text[] from public.concepts where slug = 'kolobezka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kolotoc', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kolotoč' from public.concepts where slug = 'kolotoc'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kolotoč', 'kolotoče', 'ruské kolo']::text[] from public.concepts where slug = 'kolotoc'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'carousel' from public.concepts where slug = 'kolotoc'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['carousel', 'merry-go-round', 'roundabout']::text[] from public.concepts where slug = 'kolotoc'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kompas', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kompas' from public.concepts where slug = 'kompas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kompas', 'kompasu', 'buzola']::text[] from public.concepts where slug = 'kompas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'compass' from public.concepts where slug = 'kompas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['compass']::text[] from public.concepts where slug = 'kompas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kotva', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kotva' from public.concepts where slug = 'kotva'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kotva', 'kotvu']::text[] from public.concepts where slug = 'kotva'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'anchor' from public.concepts where slug = 'kotva'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['anchor']::text[] from public.concepts where slug = 'kotva'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kufr', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kufr' from public.concepts where slug = 'kufr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kufr', 'kufru', 'zavazadlo', 'kufřík']::text[] from public.concepts where slug = 'kufr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'suitcase' from public.concepts where slug = 'kufr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['suitcase', 'luggage', 'briefcase']::text[] from public.concepts where slug = 'kufr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('majak', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'maják' from public.concepts where slug = 'majak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['maják', 'majáku']::text[] from public.concepts where slug = 'majak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lighthouse' from public.concepts where slug = 'majak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lighthouse']::text[] from public.concepts where slug = 'majak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mikroskop', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'mikroskop' from public.concepts where slug = 'mikroskop'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['mikroskop', 'mikroskopu']::text[] from public.concepts where slug = 'mikroskop'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'microscope' from public.concepts where slug = 'mikroskop'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['microscope']::text[] from public.concepts where slug = 'mikroskop'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('most', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'most' from public.concepts where slug = 'most'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['most', 'mostu', 'můstek']::text[] from public.concepts where slug = 'most'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bridge' from public.concepts where slug = 'most'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bridge']::text[] from public.concepts where slug = 'most'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('presypaci-hodiny', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'přesýpací hodiny' from public.concepts where slug = 'presypaci-hodiny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['přesýpací hodiny', 'přesýpačky', 'hodiny přesýpací']::text[] from public.concepts where slug = 'presypaci-hodiny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hourglass' from public.concepts where slug = 'presypaci-hodiny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hourglass', 'sand timer', 'egg timer']::text[] from public.concepts where slug = 'presypaci-hodiny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('psaci-stroj', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'psací stroj' from public.concepts where slug = 'psaci-stroj'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['psací stroj', 'stroj na psaní']::text[] from public.concepts where slug = 'psaci-stroj'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'typewriter' from public.concepts where slug = 'psaci-stroj'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['typewriter']::text[] from public.concepts where slug = 'psaci-stroj'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('raketa', 2, 'predmet', false, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'raketa' from public.concepts where slug = 'raketa'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['raketa', 'raketu', 'vesmírná raketa']::text[] from public.concepts where slug = 'raketa'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'rocket' from public.concepts where slug = 'raketa'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['rocket', 'spaceship']::text[] from public.concepts where slug = 'raketa'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('sici-stroj', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'šicí stroj' from public.concepts where slug = 'sici-stroj'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['šicí stroj', 'šicí stroje']::text[] from public.concepts where slug = 'sici-stroj'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sewing machine' from public.concepts where slug = 'sici-stroj'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sewing machine']::text[] from public.concepts where slug = 'sici-stroj'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('stan', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'stan' from public.concepts where slug = 'stan'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['stan', 'stanu', 'kemp']::text[] from public.concepts where slug = 'stan'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tent' from public.concepts where slug = 'stan'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tent', 'camping tent']::text[] from public.concepts where slug = 'stan'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('studna', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'studna' from public.concepts where slug = 'studna'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['studna', 'studnu', 'studánka']::text[] from public.concepts where slug = 'studna'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'well' from public.concepts where slug = 'studna'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['well', 'water well', 'wishing well']::text[] from public.concepts where slug = 'studna'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('trumpeta', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'trumpeta' from public.concepts where slug = 'trumpeta'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['trumpeta', 'trumpetu', 'trubka', 'polnice']::text[] from public.concepts where slug = 'trumpeta'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'trumpet' from public.concepts where slug = 'trumpeta'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['trumpet', 'bugle']::text[] from public.concepts where slug = 'trumpeta'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vahy', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'váhy' from public.concepts where slug = 'vahy'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['váhy', 'váha', 'kuchyňská váha', 'závaží']::text[] from public.concepts where slug = 'vahy'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'scales' from public.concepts where slug = 'vahy'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['scales', 'weighing scales']::text[] from public.concepts where slug = 'vahy'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vetrny-mlyn', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'větrný mlýn' from public.concepts where slug = 'vetrny-mlyn'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['větrný mlýn', 'mlýn', 'mlýnské kolo']::text[] from public.concepts where slug = 'vetrny-mlyn'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'windmill' from public.concepts where slug = 'vetrny-mlyn'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['windmill', 'mill']::text[] from public.concepts where slug = 'vetrny-mlyn'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vrtulnik', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vrtulník' from public.concepts where slug = 'vrtulnik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vrtulník', 'helikoptéra', 'vrtulníku']::text[] from public.concepts where slug = 'vrtulnik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'helicopter' from public.concepts where slug = 'vrtulnik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['helicopter', 'chopper']::text[] from public.concepts where slug = 'vrtulnik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vzducholod', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vzducholoď' from public.concepts where slug = 'vzducholod'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vzducholoď', 'vzducholodě', 'zeppelin']::text[] from public.concepts where slug = 'vzducholod'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'airship' from public.concepts where slug = 'vzducholod'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['airship', 'blimp']::text[] from public.concepts where slug = 'vzducholod'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zamek', 2, 'predmet', false, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zámek' from public.concepts where slug = 'zamek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zámek', 'zámku', 'visací zámek', 'hrad']::text[] from public.concepts where slug = 'zamek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lock' from public.concepts where slug = 'zamek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lock', 'padlock']::text[] from public.concepts where slug = 'zamek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zebrik', 2, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žebřík' from public.concepts where slug = 'zebrik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žebřík', 'žebříku', 'štafle']::text[] from public.concepts where slug = 'zebrik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'ladder' from public.concepts where slug = 'zebrik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['ladder', 'stepladder']::text[] from public.concepts where slug = 'zebrik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('gramofon', 3, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'gramofon' from public.concepts where slug = 'gramofon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['gramofon', 'gramofonu', 'gramec']::text[] from public.concepts where slug = 'gramofon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'record player' from public.concepts where slug = 'gramofon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['record player', 'turntable', 'gramophone']::text[] from public.concepts where slug = 'gramofon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hlavolam', 3, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hlavolam' from public.concepts where slug = 'hlavolam'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hlavolam', 'hlavolamu', 'puzzle']::text[] from public.concepts where slug = 'hlavolam'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'puzzle' from public.concepts where slug = 'hlavolam'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['puzzle', 'brain teaser']::text[] from public.concepts where slug = 'hlavolam'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kaleidoskop', 3, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kaleidoskop' from public.concepts where slug = 'kaleidoskop'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kaleidoskop', 'kaleidoskopu']::text[] from public.concepts where slug = 'kaleidoskop'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'kaleidoscope' from public.concepts where slug = 'kaleidoskop'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['kaleidoscope']::text[] from public.concepts where slug = 'kaleidoskop'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('metronom', 3, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'metronom' from public.concepts where slug = 'metronom'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['metronom', 'metronomu']::text[] from public.concepts where slug = 'metronom'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'metronome' from public.concepts where slug = 'metronom'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['metronome']::text[] from public.concepts where slug = 'metronom'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('sextant', 3, 'predmet', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sextant' from public.concepts where slug = 'sextant'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sextant', 'sextantu']::text[] from public.concepts where slug = 'sextant'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sextant' from public.concepts where slug = 'sextant'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sextant']::text[] from public.concepts where slug = 'sextant'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('dest', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'déšť' from public.concepts where slug = 'dest'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['déšť', 'déště', 'prší']::text[] from public.concepts where slug = 'dest'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'rain' from public.concepts where slug = 'dest'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['rain', 'raining']::text[] from public.concepts where slug = 'dest'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('duha', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'duha' from public.concepts where slug = 'duha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['duha', 'duhu']::text[] from public.concepts where slug = 'duha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'rainbow' from public.concepts where slug = 'duha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['rainbow']::text[] from public.concepts where slug = 'duha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hora', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hora' from public.concepts where slug = 'hora'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hora', 'horu', 'kopec', 'hory', 'vrchol']::text[] from public.concepts where slug = 'hora'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'mountain' from public.concepts where slug = 'hora'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['mountain', 'hill', 'peak']::text[] from public.concepts where slug = 'hora'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hvezda', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hvězda' from public.concepts where slug = 'hvezda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hvězda', 'hvězdu', 'hvězdička', 'hvězdy']::text[] from public.concepts where slug = 'hvezda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'star' from public.concepts where slug = 'hvezda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['star', 'stars']::text[] from public.concepts where slug = 'hvezda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('jezero', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'jezero' from public.concepts where slug = 'jezero'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['jezero', 'jezera', 'rybník']::text[] from public.concepts where slug = 'jezero'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lake' from public.concepts where slug = 'jezero'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lake', 'pond']::text[] from public.concepts where slug = 'jezero'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kamen', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kámen' from public.concepts where slug = 'kamen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kámen', 'kameny', 'balvan', 'kamínek']::text[] from public.concepts where slug = 'kamen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'stone' from public.concepts where slug = 'kamen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['stone', 'rock', 'boulder']::text[] from public.concepts where slug = 'kamen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kvetina', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'květina' from public.concepts where slug = 'kvetina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['květina', 'květinu', 'kytka', 'kytička', 'květ']::text[] from public.concepts where slug = 'kvetina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'flower' from public.concepts where slug = 'kvetina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['flower', 'blossom']::text[] from public.concepts where slug = 'kvetina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('les', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'les' from public.concepts where slug = 'les'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['les', 'lesa', 'lesík', 'hvozd']::text[] from public.concepts where slug = 'les'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'forest' from public.concepts where slug = 'les'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['forest', 'woods']::text[] from public.concepts where slug = 'les'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('list', 1, 'priroda', false, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'list' from public.concepts where slug = 'list'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['list', 'listí', 'lístek']::text[] from public.concepts where slug = 'list'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'leaf' from public.concepts where slug = 'list'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['leaf', 'leaves']::text[] from public.concepts where slug = 'list'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mesic', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'měsíc' from public.concepts where slug = 'mesic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['měsíc', 'měsíce', 'úplněk', 'půlměsíc']::text[] from public.concepts where slug = 'mesic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'moon' from public.concepts where slug = 'mesic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['moon', 'crescent']::text[] from public.concepts where slug = 'mesic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('more', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'moře' from public.concepts where slug = 'more'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['moře', 'mořem', 'oceán']::text[] from public.concepts where slug = 'more'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sea' from public.concepts where slug = 'more'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sea', 'ocean']::text[] from public.concepts where slug = 'more'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mrak', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'mrak' from public.concepts where slug = 'mrak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['mrak', 'mraky', 'oblak', 'obláček']::text[] from public.concepts where slug = 'mrak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cloud' from public.concepts where slug = 'mrak'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cloud', 'clouds']::text[] from public.concepts where slug = 'mrak'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ohen', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'oheň' from public.concepts where slug = 'ohen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['oheň', 'ohně', 'plamen', 'táborák', 'ohníček']::text[] from public.concepts where slug = 'ohen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'fire' from public.concepts where slug = 'ohen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['fire', 'flame', 'campfire']::text[] from public.concepts where slug = 'ohen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('palma', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'palma' from public.concepts where slug = 'palma'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['palma', 'palmu', 'kokosová palma']::text[] from public.concepts where slug = 'palma'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'palm tree' from public.concepts where slug = 'palma'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['palm tree', 'palm', 'coconut tree']::text[] from public.concepts where slug = 'palma'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('plaz', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pláž' from public.concepts where slug = 'plaz'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pláž', 'pláže', 'břeh']::text[] from public.concepts where slug = 'plaz'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'beach' from public.concepts where slug = 'plaz'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['beach', 'shore', 'seaside']::text[] from public.concepts where slug = 'plaz'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('reka', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'řeka' from public.concepts where slug = 'reka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['řeka', 'řeku', 'potok']::text[] from public.concepts where slug = 'reka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'river' from public.concepts where slug = 'reka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['river', 'stream', 'creek']::text[] from public.concepts where slug = 'reka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('slunce', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'slunce' from public.concepts where slug = 'slunce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['slunce', 'sluníčko', 'slunko']::text[] from public.concepts where slug = 'slunce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sun' from public.concepts where slug = 'slunce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sun', 'sunshine']::text[] from public.concepts where slug = 'slunce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('snih', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sníh' from public.concepts where slug = 'snih'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sníh', 'sněhu', 'sněží', 'vločka', 'sněhulák']::text[] from public.concepts where slug = 'snih'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'snow' from public.concepts where slug = 'snih'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['snow', 'snowing', 'snowflake']::text[] from public.concepts where slug = 'snih'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('strom', 1, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'strom' from public.concepts where slug = 'strom'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['strom', 'stromu', 'stromek', 'dub', 'smrk']::text[] from public.concepts where slug = 'strom'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tree' from public.concepts where slug = 'strom'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tree']::text[] from public.concepts where slug = 'strom'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('bazina', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'bažina' from public.concepts where slug = 'bazina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['bažina', 'bažinu', 'močál']::text[] from public.concepts where slug = 'bazina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'swamp' from public.concepts where slug = 'bazina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['swamp', 'marsh', 'bog']::text[] from public.concepts where slug = 'bazina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('blesk', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'blesk' from public.concepts where slug = 'blesk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['blesk', 'blesku', 'bouřka', 'hrom']::text[] from public.concepts where slug = 'blesk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lightning' from public.concepts where slug = 'blesk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lightning', 'thunder', 'bolt']::text[] from public.concepts where slug = 'blesk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('gejzir', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'gejzír' from public.concepts where slug = 'gejzir'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['gejzír', 'gejzíru']::text[] from public.concepts where slug = 'gejzir'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'geyser' from public.concepts where slug = 'gejzir'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['geyser']::text[] from public.concepts where slug = 'gejzir'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('jeskyne', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'jeskyně' from public.concepts where slug = 'jeskyne'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['jeskyně', 'jeskyni', 'sluj']::text[] from public.concepts where slug = 'jeskyne'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cave' from public.concepts where slug = 'jeskyne'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cave', 'cavern']::text[] from public.concepts where slug = 'jeskyne'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lavina', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lavina' from public.concepts where slug = 'lavina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lavina', 'lavinu', 'sesuv']::text[] from public.concepts where slug = 'lavina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'avalanche' from public.concepts where slug = 'lavina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['avalanche', 'landslide']::text[] from public.concepts where slug = 'lavina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ledovec', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ledovec' from public.concepts where slug = 'ledovec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ledovec', 'ledovce', 'ledová kra']::text[] from public.concepts where slug = 'ledovec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'iceberg' from public.concepts where slug = 'ledovec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['iceberg', 'glacier']::text[] from public.concepts where slug = 'ledovec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mlha', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'mlha' from public.concepts where slug = 'mlha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['mlha', 'mlhu', 'opar']::text[] from public.concepts where slug = 'mlha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'fog' from public.concepts where slug = 'mlha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['fog', 'mist', 'haze']::text[] from public.concepts where slug = 'mlha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('oaza', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'oáza' from public.concepts where slug = 'oaza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['oáza', 'oázu']::text[] from public.concepts where slug = 'oaza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'oasis' from public.concepts where slug = 'oaza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['oasis']::text[] from public.concepts where slug = 'oaza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ostrov', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ostrov' from public.concepts where slug = 'ostrov'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ostrov', 'ostrova', 'ostrůvek']::text[] from public.concepts where slug = 'ostrov'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'island' from public.concepts where slug = 'ostrov'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['island', 'isle']::text[] from public.concepts where slug = 'ostrov'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('poust', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'poušť' from public.concepts where slug = 'poust'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['poušť', 'pouště', 'pustina', 'duna']::text[] from public.concepts where slug = 'poust'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'desert' from public.concepts where slug = 'poust'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['desert', 'dune']::text[] from public.concepts where slug = 'poust'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('sopka', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sopka' from public.concepts where slug = 'sopka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sopka', 'sopku', 'vulkán']::text[] from public.concepts where slug = 'sopka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'volcano' from public.concepts where slug = 'sopka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['volcano']::text[] from public.concepts where slug = 'sopka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('souhvezdi', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'souhvězdí' from public.concepts where slug = 'souhvezdi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['souhvězdí', 'hvězdokupa']::text[] from public.concepts where slug = 'souhvezdi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'constellation' from public.concepts where slug = 'souhvezdi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['constellation']::text[] from public.concepts where slug = 'souhvezdi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tornado', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tornádo' from public.concepts where slug = 'tornado'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tornádo', 'tornáda', 'vichřice', 'smršť']::text[] from public.concepts where slug = 'tornado'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tornado' from public.concepts where slug = 'tornado'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tornado', 'twister', 'whirlwind']::text[] from public.concepts where slug = 'tornado'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('utes', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'útes' from public.concepts where slug = 'utes'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['útes', 'útesu', 'skála']::text[] from public.concepts where slug = 'utes'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cliff' from public.concepts where slug = 'utes'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cliff', 'rock face']::text[] from public.concepts where slug = 'utes'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vodopad', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vodopád' from public.concepts where slug = 'vodopad'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vodopád', 'vodopádu', 'vodopády']::text[] from public.concepts where slug = 'vodopad'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'waterfall' from public.concepts where slug = 'vodopad'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['waterfall', 'falls']::text[] from public.concepts where slug = 'vodopad'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zatmeni', 2, 'priroda', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zatmění' from public.concepts where slug = 'zatmeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zatmění', 'zatmění slunce', 'eklipsa']::text[] from public.concepts where slug = 'zatmeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'eclipse' from public.concepts where slug = 'zatmeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['eclipse', 'solar eclipse']::text[] from public.concepts where slug = 'zatmeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('banan', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'banán' from public.concepts where slug = 'banan'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['banán', 'banánu', 'banány']::text[] from public.concepts where slug = 'banan'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'banana' from public.concepts where slug = 'banan'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['banana']::text[] from public.concepts where slug = 'banan'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('citron', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'citron' from public.concepts where slug = 'citron'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['citron', 'citronu']::text[] from public.concepts where slug = 'citron'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lemon' from public.concepts where slug = 'citron'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lemon']::text[] from public.concepts where slug = 'citron'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('cokolada', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'čokoláda' from public.concepts where slug = 'cokolada'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['čokoláda', 'čokoládu', 'tabulka čokolády']::text[] from public.concepts where slug = 'cokolada'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'chocolate' from public.concepts where slug = 'cokolada'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['chocolate', 'chocolate bar']::text[] from public.concepts where slug = 'cokolada'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('dort', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'dort' from public.concepts where slug = 'dort'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['dort', 'dortu', 'koláč', 'narozeninový dort']::text[] from public.concepts where slug = 'dort'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cake' from public.concepts where slug = 'dort'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cake', 'birthday cake']::text[] from public.concepts where slug = 'dort'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hamburger', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hamburger' from public.concepts where slug = 'hamburger'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hamburger', 'burger', 'cheeseburger']::text[] from public.concepts where slug = 'hamburger'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'burger' from public.concepts where slug = 'hamburger'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['burger', 'hamburger', 'cheeseburger']::text[] from public.concepts where slug = 'hamburger'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hrozny', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hrozny' from public.concepts where slug = 'hrozny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hrozny', 'hrozen', 'hroznové víno']::text[] from public.concepts where slug = 'hrozny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'grapes' from public.concepts where slug = 'hrozny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['grapes', 'grape', 'bunch of grapes']::text[] from public.concepts where slug = 'hrozny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hruska', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hruška' from public.concepts where slug = 'hruska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hruška', 'hrušku', 'hrušky']::text[] from public.concepts where slug = 'hruska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pear' from public.concepts where slug = 'hruska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pear']::text[] from public.concepts where slug = 'hruska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('chleba', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'chleba' from public.concepts where slug = 'chleba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['chleba', 'chléb', 'chlebík', 'bochník']::text[] from public.concepts where slug = 'chleba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bread' from public.concepts where slug = 'chleba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bread', 'loaf', 'bun']::text[] from public.concepts where slug = 'chleba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('jablko', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'jablko' from public.concepts where slug = 'jablko'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['jablko', 'jablka', 'jablíčko']::text[] from public.concepts where slug = 'jablko'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'apple' from public.concepts where slug = 'jablko'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['apple']::text[] from public.concepts where slug = 'jablko'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('jahoda', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'jahoda' from public.concepts where slug = 'jahoda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['jahoda', 'jahodu', 'jahody']::text[] from public.concepts where slug = 'jahoda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'strawberry' from public.concepts where slug = 'jahoda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['strawberry', 'strawberries']::text[] from public.concepts where slug = 'jahoda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kobliha', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kobliha' from public.concepts where slug = 'kobliha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kobliha', 'koblihu', 'donut']::text[] from public.concepts where slug = 'kobliha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'donut' from public.concepts where slug = 'kobliha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['donut', 'doughnut']::text[] from public.concepts where slug = 'kobliha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kukurice', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kukuřice' from public.concepts where slug = 'kukurice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kukuřice', 'kukuřici', 'klas kukuřice']::text[] from public.concepts where slug = 'kukurice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'corn' from public.concepts where slug = 'kukurice'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['corn', 'sweetcorn', 'corn on the cob']::text[] from public.concepts where slug = 'kukurice'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mrkev', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'mrkev' from public.concepts where slug = 'mrkev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['mrkev', 'mrkve', 'karotka']::text[] from public.concepts where slug = 'mrkev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'carrot' from public.concepts where slug = 'mrkev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['carrot']::text[] from public.concepts where slug = 'mrkev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pizza', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pizza' from public.concepts where slug = 'pizza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pizza', 'pizzu', 'pizza slice']::text[] from public.concepts where slug = 'pizza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pizza' from public.concepts where slug = 'pizza'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pizza']::text[] from public.concepts where slug = 'pizza'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('popcorn', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'popcorn' from public.concepts where slug = 'popcorn'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['popcorn', 'popkorn', 'pukance']::text[] from public.concepts where slug = 'popcorn'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'popcorn' from public.concepts where slug = 'popcorn'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['popcorn']::text[] from public.concepts where slug = 'popcorn'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('rajce', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'rajče' from public.concepts where slug = 'rajce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['rajče', 'rajčata', 'rajské jablíčko']::text[] from public.concepts where slug = 'rajce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tomato' from public.concepts where slug = 'rajce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tomato', 'tomatoes']::text[] from public.concepts where slug = 'rajce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('susenka', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sušenka' from public.concepts where slug = 'susenka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sušenka', 'sušenky', 'keks']::text[] from public.concepts where slug = 'susenka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cookie' from public.concepts where slug = 'susenka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cookie', 'biscuit', 'cookies']::text[] from public.concepts where slug = 'susenka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('syr', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sýr' from public.concepts where slug = 'syr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sýr', 'sýra', 'ementál', 'sýrek']::text[] from public.concepts where slug = 'syr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cheese' from public.concepts where slug = 'syr'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cheese']::text[] from public.concepts where slug = 'syr'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vejce', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vejce' from public.concepts where slug = 'vejce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vejce', 'vajíčko', 'vajec']::text[] from public.concepts where slug = 'vejce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'egg' from public.concepts where slug = 'vejce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['egg', 'eggs']::text[] from public.concepts where slug = 'vejce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zmrzlina', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zmrzlina' from public.concepts where slug = 'zmrzlina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zmrzlina', 'zmrzlinu', 'nanuk', 'zmrzka']::text[] from public.concepts where slug = 'zmrzlina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'ice cream' from public.concepts where slug = 'zmrzlina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['ice cream', 'icecream', 'popsicle']::text[] from public.concepts where slug = 'zmrzlina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ananas', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ananas' from public.concepts where slug = 'ananas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ananas', 'ananasu']::text[] from public.concepts where slug = 'ananas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pineapple' from public.concepts where slug = 'ananas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pineapple']::text[] from public.concepts where slug = 'ananas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('croissant', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'croissant' from public.concepts where slug = 'croissant'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['croissant', 'croissanty', 'loupák']::text[] from public.concepts where slug = 'croissant'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'croissant' from public.concepts where slug = 'croissant'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['croissant']::text[] from public.concepts where slug = 'croissant'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('houba', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'houba' from public.concepts where slug = 'houba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['houba', 'houbu', 'hřib', 'muchomůrka', 'žampion']::text[] from public.concepts where slug = 'houba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'mushroom' from public.concepts where slug = 'houba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['mushroom', 'toadstool']::text[] from public.concepts where slug = 'houba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('knedliky', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'knedlíky' from public.concepts where slug = 'knedliky'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['knedlíky', 'knedlík', 'houskový knedlík']::text[] from public.concepts where slug = 'knedliky'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'dumplings' from public.concepts where slug = 'knedliky'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['dumplings', 'dumpling']::text[] from public.concepts where slug = 'knedliky'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('meloun', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'meloun' from public.concepts where slug = 'meloun'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['meloun', 'melounu', 'vodní meloun']::text[] from public.concepts where slug = 'meloun'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'watermelon' from public.concepts where slug = 'meloun'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['watermelon', 'melon']::text[] from public.concepts where slug = 'meloun'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('muffin', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'muffin' from public.concepts where slug = 'muffin'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['muffin', 'muffiny', 'košíček']::text[] from public.concepts where slug = 'muffin'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'muffin' from public.concepts where slug = 'muffin'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['muffin', 'cupcake']::text[] from public.concepts where slug = 'muffin'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('palacinka', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'palačinka' from public.concepts where slug = 'palacinka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['palačinka', 'palačinku', 'lívanec', 'palačinky']::text[] from public.concepts where slug = 'palacinka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pancake' from public.concepts where slug = 'palacinka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pancake', 'pancakes', 'crepe']::text[] from public.concepts where slug = 'palacinka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('polevka', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'polévka' from public.concepts where slug = 'polevka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['polévka', 'polévku', 'vývar']::text[] from public.concepts where slug = 'polevka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'soup' from public.concepts where slug = 'polevka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['soup', 'bowl of soup']::text[] from public.concepts where slug = 'polevka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('salat', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'salát' from public.concepts where slug = 'salat'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['salát', 'salátu', 'míchaný salát']::text[] from public.concepts where slug = 'salat'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'salad' from public.concepts where slug = 'salat'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['salad', 'lettuce']::text[] from public.concepts where slug = 'salat'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('sendvic', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sendvič' from public.concepts where slug = 'sendvic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sendvič', 'sendviče', 'obložený chléb']::text[] from public.concepts where slug = 'sendvic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sandwich' from public.concepts where slug = 'sendvic'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sandwich']::text[] from public.concepts where slug = 'sendvic'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('spagety', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'špagety' from public.concepts where slug = 'spagety'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['špagety', 'špaget', 'těstoviny']::text[] from public.concepts where slug = 'spagety'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'spaghetti' from public.concepts where slug = 'spagety'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['spaghetti', 'pasta', 'noodles']::text[] from public.concepts where slug = 'spagety'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('sushi', 2, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sushi' from public.concepts where slug = 'sushi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sushi', 'suši']::text[] from public.concepts where slug = 'sushi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sushi' from public.concepts where slug = 'sushi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sushi', 'sushi roll']::text[] from public.concepts where slug = 'sushi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('beh', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'běh' from public.concepts where slug = 'beh'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['běh', 'běhání', 'běží', 'běžec', 'utíká']::text[] from public.concepts where slug = 'beh'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'running' from public.concepts where slug = 'beh'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['running', 'run', 'runner', 'jogging']::text[] from public.concepts where slug = 'beh'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('brusleni', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'bruslení' from public.concepts where slug = 'brusleni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['bruslení', 'bruslit', 'brusle', 'bruslař']::text[] from public.concepts where slug = 'brusleni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'skating' from public.concepts where slug = 'brusleni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['skating', 'ice skating', 'skater']::text[] from public.concepts where slug = 'brusleni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('cteni', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'čtení' from public.concepts where slug = 'cteni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['čtení', 'číst', 'čtenář', 'čte si']::text[] from public.concepts where slug = 'cteni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'reading' from public.concepts where slug = 'cteni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['reading', 'read', 'reader']::text[] from public.concepts where slug = 'cteni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('fotbal', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'fotbal' from public.concepts where slug = 'fotbal'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['fotbal', 'fotbálek', 'kopaná']::text[] from public.concepts where slug = 'fotbal'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'football' from public.concepts where slug = 'fotbal'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['football', 'soccer', 'playing football']::text[] from public.concepts where slug = 'fotbal'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lezeni', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lezení' from public.concepts where slug = 'lezeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lezení', 'lézt', 'šplhání', 'horolezec']::text[] from public.concepts where slug = 'lezeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'climbing' from public.concepts where slug = 'lezeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['climbing', 'climb', 'climber']::text[] from public.concepts where slug = 'lezeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lyzovani', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lyžování' from public.concepts where slug = 'lyzovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lyžování', 'lyžovat', 'lyžař', 'lyže']::text[] from public.concepts where slug = 'lyzovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'skiing' from public.concepts where slug = 'lyzovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['skiing', 'ski', 'skier']::text[] from public.concepts where slug = 'lyzovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('malovani', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'malování' from public.concepts where slug = 'malovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['malování', 'malovat', 'maluje', 'malíř']::text[] from public.concepts where slug = 'malovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'painting' from public.concepts where slug = 'malovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['painting', 'paint', 'painter']::text[] from public.concepts where slug = 'malovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('objeti', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'objetí' from public.concepts where slug = 'objeti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['objetí', 'obejmutí', 'obejmout', 'objímání']::text[] from public.concepts where slug = 'objeti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hug' from public.concepts where slug = 'objeti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hug', 'hugging', 'embrace']::text[] from public.concepts where slug = 'objeti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('plac', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pláč' from public.concepts where slug = 'plac'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pláč', 'brekot', 'pláče', 'slzy']::text[] from public.concepts where slug = 'plac'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'crying' from public.concepts where slug = 'plac'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['crying', 'cry', 'tears', 'weeping']::text[] from public.concepts where slug = 'plac'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('plavani', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'plavání' from public.concepts where slug = 'plavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['plavání', 'plavat', 'plavec']::text[] from public.concepts where slug = 'plavani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'swimming' from public.concepts where slug = 'plavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['swimming', 'swim', 'swimmer']::text[] from public.concepts where slug = 'plavani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('potapeni', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'potápění' from public.concepts where slug = 'potapeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['potápění', 'potápět se', 'potápěč']::text[] from public.concepts where slug = 'potapeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'diving' from public.concepts where slug = 'potapeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['diving', 'scuba diving', 'dive']::text[] from public.concepts where slug = 'potapeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('rybareni', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'rybaření' from public.concepts where slug = 'rybareni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['rybaření', 'rybařit', 'rybář', 'chytání ryb']::text[] from public.concepts where slug = 'rybareni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'fishing' from public.concepts where slug = 'rybareni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['fishing', 'fisherman']::text[] from public.concepts where slug = 'rybareni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('skok', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'skok' from public.concepts where slug = 'skok'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['skok', 'skákání', 'skáče', 'skočit']::text[] from public.concepts where slug = 'skok'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'jumping' from public.concepts where slug = 'skok'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['jumping', 'jump', 'leap']::text[] from public.concepts where slug = 'skok'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('smich', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'smích' from public.concepts where slug = 'smich'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['smích', 'smát se', 'směje se', 'řehot']::text[] from public.concepts where slug = 'smich'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'laughter' from public.concepts where slug = 'smich'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['laughter', 'laughing', 'laugh']::text[] from public.concepts where slug = 'smich'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('spanek', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'spánek' from public.concepts where slug = 'spanek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['spánek', 'spaní', 'spí', 'spát', 'chrápání']::text[] from public.concepts where slug = 'spanek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sleep' from public.concepts where slug = 'spanek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sleep', 'sleeping', 'nap', 'snoring']::text[] from public.concepts where slug = 'spanek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tanec', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tanec' from public.concepts where slug = 'tanec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tanec', 'tancování', 'tančí', 'tanečník', 'tancovat']::text[] from public.concepts where slug = 'tanec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'dancing' from public.concepts where slug = 'tanec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['dancing', 'dance', 'dancer']::text[] from public.concepts where slug = 'tanec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('uklid', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'úklid' from public.concepts where slug = 'uklid'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['úklid', 'uklízení', 'uklízet']::text[] from public.concepts where slug = 'uklid'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cleaning' from public.concepts where slug = 'uklid'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cleaning', 'tidying up', 'cleaning up']::text[] from public.concepts where slug = 'uklid'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vareni', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vaření' from public.concepts where slug = 'vareni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vaření', 'vařit', 'vaří', 'kuchař']::text[] from public.concepts where slug = 'vareni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cooking' from public.concepts where slug = 'vareni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cooking', 'cook', 'chef']::text[] from public.concepts where slug = 'vareni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zpev', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zpěv' from public.concepts where slug = 'zpev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zpěv', 'zpívání', 'zpívá', 'zpěvák']::text[] from public.concepts where slug = 'zpev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'singing' from public.concepts where slug = 'zpev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['singing', 'sing', 'singer', 'song']::text[] from public.concepts where slug = 'zpev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('balancovani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'balancování' from public.concepts where slug = 'balancovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['balancování', 'balancovat', 'rovnováha']::text[] from public.concepts where slug = 'balancovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'balancing' from public.concepts where slug = 'balancovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['balancing', 'keeping balance']::text[] from public.concepts where slug = 'balancovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('bloudeni', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'bloudění' from public.concepts where slug = 'bloudeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['bloudění', 'zabloudit', 'ztratit se', 'bloudí']::text[] from public.concepts where slug = 'bloudeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'getting lost' from public.concepts where slug = 'bloudeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['getting lost', 'lost', 'wandering']::text[] from public.concepts where slug = 'bloudeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('cestovani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'cestování' from public.concepts where slug = 'cestovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['cestování', 'cestovat', 'výlet']::text[] from public.concepts where slug = 'cestovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'travelling' from public.concepts where slug = 'cestovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['travelling', 'traveling', 'travel']::text[] from public.concepts where slug = 'cestovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hadka', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hádka' from public.concepts where slug = 'hadka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hádka', 'hádku', 'spor', 'hádání se']::text[] from public.concepts where slug = 'hadka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'argument' from public.concepts where slug = 'hadka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['argument', 'quarrel', 'arguing']::text[] from public.concepts where slug = 'hadka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hledani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hledání' from public.concepts where slug = 'hledani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hledání', 'hledat', 'hledá', 'pátrání']::text[] from public.concepts where slug = 'hledani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'searching' from public.concepts where slug = 'hledani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['searching', 'looking for', 'search']::text[] from public.concepts where slug = 'hledani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('honicka', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'honička' from public.concepts where slug = 'honicka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['honička', 'honěná', 'pronásledování']::text[] from public.concepts where slug = 'honicka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'chase' from public.concepts where slug = 'honicka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['chase', 'chasing', 'tag']::text[] from public.concepts where slug = 'honicka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('krik', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'křik' from public.concepts where slug = 'krik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['křik', 'křičení', 'křičí', 'řev']::text[] from public.concepts where slug = 'krik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'shouting' from public.concepts where slug = 'krik'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['shouting', 'scream', 'yelling']::text[] from public.concepts where slug = 'krik'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('kychnuti', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kýchnutí' from public.concepts where slug = 'kychnuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kýchnutí', 'kýchání', 'kýchá', 'kejchnutí']::text[] from public.concepts where slug = 'kychnuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sneeze' from public.concepts where slug = 'kychnuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sneeze', 'sneezing']::text[] from public.concepts where slug = 'kychnuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lechtani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lechtání' from public.concepts where slug = 'lechtani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lechtání', 'lechtat', 'lechtá']::text[] from public.concepts where slug = 'lechtani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tickling' from public.concepts where slug = 'lechtani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tickling', 'tickle']::text[] from public.concepts where slug = 'lechtani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('louceni', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'loučení' from public.concepts where slug = 'louceni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['loučení', 'rozloučení', 'sbohem']::text[] from public.concepts where slug = 'louceni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'farewell' from public.concepts where slug = 'louceni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['farewell', 'goodbye', 'saying goodbye']::text[] from public.concepts where slug = 'louceni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mavani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'mávání' from public.concepts where slug = 'mavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['mávání', 'mávat', 'mává']::text[] from public.concepts where slug = 'mavani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'waving' from public.concepts where slug = 'mavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['waving', 'wave goodbye']::text[] from public.concepts where slug = 'mavani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('mrknuti', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'mrknutí' from public.concepts where slug = 'mrknuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['mrknutí', 'mrknout', 'mrkání']::text[] from public.concepts where slug = 'mrknuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'wink' from public.concepts where slug = 'mrknuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['wink', 'winking']::text[] from public.concepts where slug = 'mrknuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nakupovani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'nakupování' from public.concepts where slug = 'nakupovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['nakupování', 'nakupovat', 'nákup']::text[] from public.concepts where slug = 'nakupovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'shopping' from public.concepts where slug = 'nakupovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['shopping', 'buying groceries']::text[] from public.concepts where slug = 'nakupovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('odpocitavani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'odpočítávání' from public.concepts where slug = 'odpocitavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['odpočítávání', 'odpočet', 'počítání do startu']::text[] from public.concepts where slug = 'odpocitavani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'countdown' from public.concepts where slug = 'odpocitavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['countdown', 'counting down']::text[] from public.concepts where slug = 'odpocitavani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('oslava', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'oslava' from public.concepts where slug = 'oslava'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['oslava', 'oslavu', 'večírek', 'párty']::text[] from public.concepts where slug = 'oslava'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'celebration' from public.concepts where slug = 'oslava'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['celebration', 'party', 'celebrating']::text[] from public.concepts where slug = 'oslava'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('plazeni', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'plazení' from public.concepts where slug = 'plazeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['plazení', 'plazit se', 'lezení po břiše']::text[] from public.concepts where slug = 'plazeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'crawling' from public.concepts where slug = 'plazeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['crawling', 'crawl']::text[] from public.concepts where slug = 'plazeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('podani-ruky', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'podání ruky' from public.concepts where slug = 'podani-ruky'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['podání ruky', 'potřesení rukou']::text[] from public.concepts where slug = 'podani-ruky'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'handshake' from public.concepts where slug = 'podani-ruky'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['handshake', 'shaking hands']::text[] from public.concepts where slug = 'podani-ruky'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('potlesk', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'potlesk' from public.concepts where slug = 'potlesk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['potlesk', 'tleskání', 'tleská', 'aplaus']::text[] from public.concepts where slug = 'potlesk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'applause' from public.concepts where slug = 'potlesk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['applause', 'clapping', 'applauding']::text[] from public.concepts where slug = 'potlesk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pristani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'přistání' from public.concepts where slug = 'pristani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['přistání', 'přistát', 'přistání letadla']::text[] from public.concepts where slug = 'pristani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'landing' from public.concepts where slug = 'pristani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['landing', 'touchdown']::text[] from public.concepts where slug = 'pristani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('probuzeni', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'probuzení' from public.concepts where slug = 'probuzeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['probuzení', 'probudit se', 'vstávání']::text[] from public.concepts where slug = 'probuzeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'waking up' from public.concepts where slug = 'probuzeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['waking up', 'wake up']::text[] from public.concepts where slug = 'probuzeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('schovavana', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'schovávaná' from public.concepts where slug = 'schovavana'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['schovávaná', 'schovka', 'hra na schovávanou']::text[] from public.concepts where slug = 'schovavana'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hide and seek' from public.concepts where slug = 'schovavana'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hide and seek', 'hiding']::text[] from public.concepts where slug = 'schovavana'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('skytavka', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'škytavka' from public.concepts where slug = 'skytavka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['škytavka', 'škytání', 'škytá']::text[] from public.concepts where slug = 'skytavka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hiccups' from public.concepts where slug = 'skytavka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hiccups', 'hiccup']::text[] from public.concepts where slug = 'skytavka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('stehovani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'stěhování' from public.concepts where slug = 'stehovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['stěhování', 'stěhovat se', 'stěhováci']::text[] from public.concepts where slug = 'stehovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'moving' from public.concepts where slug = 'stehovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['moving', 'moving house', 'moving out']::text[] from public.concepts where slug = 'stehovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('uklouznuti', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'uklouznutí' from public.concepts where slug = 'uklouznuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['uklouznutí', 'uklouznout', 'podklouznutí']::text[] from public.concepts where slug = 'uklouznuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'slipping' from public.concepts where slug = 'uklouznuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['slipping', 'slip']::text[] from public.concepts where slug = 'uklouznuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('usmireni', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'usmíření' from public.concepts where slug = 'usmireni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['usmíření', 'smír', 'udobření']::text[] from public.concepts where slug = 'usmireni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'making up' from public.concepts where slug = 'usmireni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['making up', 'reconciliation', 'peace']::text[] from public.concepts where slug = 'usmireni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('utek', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'útěk' from public.concepts where slug = 'utek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['útěk', 'utéct', 'uprchnout']::text[] from public.concepts where slug = 'utek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'escape' from public.concepts where slug = 'utek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['escape', 'escaping', 'getaway']::text[] from public.concepts where slug = 'utek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zakopnuti', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zakopnutí' from public.concepts where slug = 'zakopnuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zakopnutí', 'zakopnout', 'klopýtnutí']::text[] from public.concepts where slug = 'zakopnuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tripping' from public.concepts where slug = 'zakopnuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tripping', 'stumbling', 'trip']::text[] from public.concepts where slug = 'zakopnuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zaspani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zaspání' from public.concepts where slug = 'zaspani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zaspání', 'zaspat', 'zaspal']::text[] from public.concepts where slug = 'zaspani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'oversleeping' from public.concepts where slug = 'zaspani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['oversleeping', 'overslept']::text[] from public.concepts where slug = 'zaspani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zivani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zívání' from public.concepts where slug = 'zivani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zívání', 'zívnutí', 'zívá', 'zívat']::text[] from public.concepts where slug = 'zivani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'yawning' from public.concepts where slug = 'zivani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['yawning', 'yawn']::text[] from public.concepts where slug = 'zivani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zonglovani', 3, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žonglování' from public.concepts where slug = 'zonglovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žonglování', 'žonglovat', 'žonglér']::text[] from public.concepts where slug = 'zonglovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'juggling' from public.concepts where slug = 'zonglovani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['juggling', 'juggler']::text[] from public.concepts where slug = 'zonglovani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('bolest', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'bolest' from public.concepts where slug = 'bolest'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['bolest', 'bolí', 'bolestí']::text[] from public.concepts where slug = 'bolest'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pain' from public.concepts where slug = 'bolest'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pain', 'ache', 'hurt']::text[] from public.concepts where slug = 'bolest'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('cas', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'čas' from public.concepts where slug = 'cas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['čas', 'času', 'plynutí času']::text[] from public.concepts where slug = 'cas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'time' from public.concepts where slug = 'cas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['time', 'passing time']::text[] from public.concepts where slug = 'cas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('cekani', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'čekání' from public.concepts where slug = 'cekani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['čekání', 'čeká', 'čekat', 'fronta']::text[] from public.concepts where slug = 'cekani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'waiting' from public.concepts where slug = 'cekani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['waiting', 'wait', 'queue']::text[] from public.concepts where slug = 'cekani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('detstvi', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'dětství' from public.concepts where slug = 'detstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['dětství', 'dětstvím', 'dítě']::text[] from public.concepts where slug = 'detstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'childhood' from public.concepts where slug = 'detstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['childhood', 'being a child']::text[] from public.concepts where slug = 'detstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('duvera', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'důvěra' from public.concepts where slug = 'duvera'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['důvěra', 'důvěřovat', 'spolehnutí']::text[] from public.concepts where slug = 'duvera'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'trust' from public.concepts where slug = 'duvera'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['trust', 'trusting', 'faith']::text[] from public.concepts where slug = 'duvera'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('gravitace', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'gravitace' from public.concepts where slug = 'gravitace'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['gravitace', 'přitažlivost', 'tíhová síla']::text[] from public.concepts where slug = 'gravitace'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'gravity' from public.concepts where slug = 'gravitace'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['gravity', 'falling down']::text[] from public.concepts where slug = 'gravitace'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hlad', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hlad' from public.concepts where slug = 'hlad'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hlad', 'hladový', 'hladovění']::text[] from public.concepts where slug = 'hlad'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hunger' from public.concepts where slug = 'hlad'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hunger', 'hungry', 'starving']::text[] from public.concepts where slug = 'hlad'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hluk', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hluk' from public.concepts where slug = 'hluk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hluk', 'hlučnost', 'rámus']::text[] from public.concepts where slug = 'hluk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'noise' from public.concepts where slug = 'hluk'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['noise', 'noisy', 'loudness']::text[] from public.concepts where slug = 'hluk'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hnev', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hněv' from public.concepts where slug = 'hnev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hněv', 'vztek', 'zlost', 'naštvání']::text[] from public.concepts where slug = 'hnev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'anger' from public.concepts where slug = 'hnev'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['anger', 'angry', 'rage', 'fury']::text[] from public.concepts where slug = 'hnev'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hrdost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hrdost' from public.concepts where slug = 'hrdost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hrdost', 'hrdý', 'pýcha']::text[] from public.concepts where slug = 'hrdost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'pride' from public.concepts where slug = 'hrdost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['pride', 'proud']::text[] from public.concepts where slug = 'hrdost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('hudba', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'hudba' from public.concepts where slug = 'hudba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['hudba', 'hudbu', 'muzika', 'melodie']::text[] from public.concepts where slug = 'hudba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'music' from public.concepts where slug = 'hudba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['music', 'melody']::text[] from public.concepts where slug = 'hudba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('chaos', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'chaos' from public.concepts where slug = 'chaos'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['chaos', 'chaosu', 'zmatek', 'nepořádek', 'bordel']::text[] from public.concepts where slug = 'chaos'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'chaos' from public.concepts where slug = 'chaos'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['chaos', 'mess', 'confusion']::text[] from public.concepts where slug = 'chaos'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('konec', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'konec' from public.concepts where slug = 'konec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['konec', 'konce', 'finiš']::text[] from public.concepts where slug = 'konec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'end' from public.concepts where slug = 'konec'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['end', 'the end', 'ending']::text[] from public.concepts where slug = 'konec'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('laska', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'láska' from public.concepts where slug = 'laska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['láska', 'lásku', 'zamilovanost', 'zamilovaný']::text[] from public.concepts where slug = 'laska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'love' from public.concepts where slug = 'laska'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['love', 'in love', 'romance']::text[] from public.concepts where slug = 'laska'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lenost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lenost' from public.concepts where slug = 'lenost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lenost', 'lenošení']::text[] from public.concepts where slug = 'lenost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'laziness' from public.concepts where slug = 'lenost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['laziness', 'lazy', 'being lazy']::text[] from public.concepts where slug = 'lenost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('lhani', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lhaní' from public.concepts where slug = 'lhani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lhaní', 'lež', 'lhát']::text[] from public.concepts where slug = 'lhani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'lying' from public.concepts where slug = 'lhani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['lying', 'lie', 'telling a lie']::text[] from public.concepts where slug = 'lhani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('litost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'lítost' from public.concepts where slug = 'litost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['lítost', 'litovat', 'výčitky']::text[] from public.concepts where slug = 'litost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'regret' from public.concepts where slug = 'litost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['regret', 'remorse']::text[] from public.concepts where slug = 'litost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nadeje', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'naděje' from public.concepts where slug = 'nadeje'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['naděje', 'naději', 'doufání']::text[] from public.concepts where slug = 'nadeje'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hope' from public.concepts where slug = 'nadeje'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hope', 'hopeful']::text[] from public.concepts where slug = 'nadeje'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('napad', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'nápad' from public.concepts where slug = 'napad'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['nápad', 'nápadu', 'myšlenka']::text[] from public.concepts where slug = 'napad'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'idea' from public.concepts where slug = 'napad'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['idea', 'inspiration']::text[] from public.concepts where slug = 'napad'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('narozeniny', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'narozeniny' from public.concepts where slug = 'narozeniny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['narozeniny', 'oslava narozenin']::text[] from public.concepts where slug = 'narozeniny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'birthday' from public.concepts where slug = 'narozeniny'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['birthday', 'birthday party']::text[] from public.concepts where slug = 'narozeniny'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nekonecno', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'nekonečno' from public.concepts where slug = 'nekonecno'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['nekonečno', 'nekonečna']::text[] from public.concepts where slug = 'nekonecno'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'infinity' from public.concepts where slug = 'nekonecno'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['infinity', 'endless', 'eternity']::text[] from public.concepts where slug = 'nekonecno'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nocni-mura', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'noční můra' from public.concepts where slug = 'nocni-mura'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['noční můra', 'noční můru', 'zlý sen']::text[] from public.concepts where slug = 'nocni-mura'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'nightmare' from public.concepts where slug = 'nocni-mura'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['nightmare', 'bad dream']::text[] from public.concepts where slug = 'nocni-mura'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nostalgie', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'nostalgie' from public.concepts where slug = 'nostalgie'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['nostalgie', 'nostalgii', 'stesk', 'vzpomínání']::text[] from public.concepts where slug = 'nostalgie'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'nostalgia' from public.concepts where slug = 'nostalgie'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['nostalgia', 'longing', 'reminiscing']::text[] from public.concepts where slug = 'nostalgie'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('nuda', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'nuda' from public.concepts where slug = 'nuda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['nuda', 'nudu', 'nudí se', 'otrava']::text[] from public.concepts where slug = 'nuda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'boredom' from public.concepts where slug = 'nuda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['boredom', 'bored', 'boring']::text[] from public.concepts where slug = 'nuda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('odpusteni', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'odpuštění' from public.concepts where slug = 'odpusteni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['odpuštění', 'odpustit', 'prominutí']::text[] from public.concepts where slug = 'odpusteni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'forgiveness' from public.concepts where slug = 'odpusteni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['forgiveness', 'forgiving', 'sorry']::text[] from public.concepts where slug = 'odpusteni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('odvaha', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'odvaha' from public.concepts where slug = 'odvaha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['odvaha', 'statečnost', 'kuráž']::text[] from public.concepts where slug = 'odvaha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'courage' from public.concepts where slug = 'odvaha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['courage', 'bravery', 'brave']::text[] from public.concepts where slug = 'odvaha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ozvena', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ozvěna' from public.concepts where slug = 'ozvena'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ozvěna', 'ozvěnu', 'echo']::text[] from public.concepts where slug = 'ozvena'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'echo' from public.concepts where slug = 'ozvena'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['echo', 'echoing']::text[] from public.concepts where slug = 'ozvena'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pamet', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'paměť' from public.concepts where slug = 'pamet'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['paměť', 'vzpomínka', 'pamatování']::text[] from public.concepts where slug = 'pamet'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'memory' from public.concepts where slug = 'pamet'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['memory', 'remembering', 'recollection']::text[] from public.concepts where slug = 'pamet'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pochybnost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pochybnost' from public.concepts where slug = 'pochybnost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pochybnost', 'pochyby', 'nejistota']::text[] from public.concepts where slug = 'pochybnost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'doubt' from public.concepts where slug = 'pochybnost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['doubt', 'uncertainty', 'doubting']::text[] from public.concepts where slug = 'pochybnost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pratelstvi', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'přátelství' from public.concepts where slug = 'pratelstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['přátelství', 'kamarádství', 'přátelé']::text[] from public.concepts where slug = 'pratelstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'friendship' from public.concepts where slug = 'pratelstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['friendship', 'friends', 'friend']::text[] from public.concepts where slug = 'pratelstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('pravda', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pravda' from public.concepts where slug = 'pravda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pravda', 'pravdu', 'pravdivost']::text[] from public.concepts where slug = 'pravda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'truth' from public.concepts where slug = 'pravda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['truth', 'the truth']::text[] from public.concepts where slug = 'pravda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('prekvapeni', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'překvapení' from public.concepts where slug = 'prekvapeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['překvapení', 'překvapený', 'úžas']::text[] from public.concepts where slug = 'prekvapeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'surprise' from public.concepts where slug = 'prekvapeni'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['surprise', 'surprised', 'astonishment']::text[] from public.concepts where slug = 'prekvapeni'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('prohra', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'prohra' from public.concepts where slug = 'prohra'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['prohra', 'prohru', 'porážka']::text[] from public.concepts where slug = 'prohra'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'defeat' from public.concepts where slug = 'prohra'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['defeat', 'losing']::text[] from public.concepts where slug = 'prohra'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('rodina', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'rodina' from public.concepts where slug = 'rodina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['rodina', 'rodinu', 'rodiče']::text[] from public.concepts where slug = 'rodina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'family' from public.concepts where slug = 'rodina'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['family', 'parents']::text[] from public.concepts where slug = 'rodina'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('rozhodnuti', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'rozhodnutí' from public.concepts where slug = 'rozhodnuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['rozhodnutí', 'rozhodování', 'volba']::text[] from public.concepts where slug = 'rozhodnuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'decision' from public.concepts where slug = 'rozhodnuti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['decision', 'choice', 'deciding']::text[] from public.concepts where slug = 'rozhodnuti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('rust', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'růst' from public.concepts where slug = 'rust'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['růst', 'růstu', 'vyrůstání']::text[] from public.concepts where slug = 'rust'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'growth' from public.concepts where slug = 'rust'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['growth', 'growing', 'grow']::text[] from public.concepts where slug = 'rust'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('samota', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'samota' from public.concepts where slug = 'samota'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['samota', 'osamělost', 'sám']::text[] from public.concepts where slug = 'samota'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'loneliness' from public.concepts where slug = 'samota'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['loneliness', 'lonely', 'solitude']::text[] from public.concepts where slug = 'samota'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('sen', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sen' from public.concepts where slug = 'sen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sen', 'sny', 'snění']::text[] from public.concepts where slug = 'sen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'dream' from public.concepts where slug = 'sen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['dream', 'dreaming', 'dreams']::text[] from public.concepts where slug = 'sen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('smula', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'smůla' from public.concepts where slug = 'smula'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['smůla', 'smůlu', 'nešťastná náhoda']::text[] from public.concepts where slug = 'smula'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bad luck' from public.concepts where slug = 'smula'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bad luck', 'misfortune', 'unlucky']::text[] from public.concepts where slug = 'smula'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('smutek', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'smutek' from public.concepts where slug = 'smutek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['smutek', 'smutný', 'zármutek']::text[] from public.concepts where slug = 'smutek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'sadness' from public.concepts where slug = 'smutek'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['sadness', 'sad', 'sorrow']::text[] from public.concepts where slug = 'smutek'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('soutez', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'soutěž' from public.concepts where slug = 'soutez'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['soutěž', 'soutěžení', 'závod']::text[] from public.concepts where slug = 'soutez'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'competition' from public.concepts where slug = 'soutez'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['competition', 'contest', 'race']::text[] from public.concepts where slug = 'soutez'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('spech', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'spěch' from public.concepts where slug = 'spech'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['spěch', 'spěchá', 'pospíchá', 'chvat', 'shon']::text[] from public.concepts where slug = 'spech'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'hurry' from public.concepts where slug = 'spech'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['hurry', 'rush', 'haste']::text[] from public.concepts where slug = 'spech'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('spravedlnost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'spravedlnost' from public.concepts where slug = 'spravedlnost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['spravedlnost', 'spravedlivost', 'právo']::text[] from public.concepts where slug = 'spravedlnost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'justice' from public.concepts where slug = 'spravedlnost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['justice', 'fairness']::text[] from public.concepts where slug = 'spravedlnost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('stari', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'stáří' from public.concepts where slug = 'stari'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['stáří', 'stárnutí', 'stařec']::text[] from public.concepts where slug = 'stari'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'old age' from public.concepts where slug = 'stari'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['old age', 'ageing', 'aging']::text[] from public.concepts where slug = 'stari'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('stesti', 3, 'abstraktni', false, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'štěstí' from public.concepts where slug = 'stesti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['štěstí', 'štěstíčko', 'radost']::text[] from public.concepts where slug = 'stesti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'happiness' from public.concepts where slug = 'stesti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['happiness', 'happy', 'joy']::text[] from public.concepts where slug = 'stesti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('strach', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'strach' from public.concepts where slug = 'strach'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['strach', 'strachu', 'bát se', 'hrůza', 'děs']::text[] from public.concepts where slug = 'strach'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'fear' from public.concepts where slug = 'strach'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['fear', 'afraid', 'scared', 'terror']::text[] from public.concepts where slug = 'strach'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('svoboda', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'svoboda' from public.concepts where slug = 'svoboda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['svoboda', 'svobodu', 'volnost']::text[] from public.concepts where slug = 'svoboda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'freedom' from public.concepts where slug = 'svoboda'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['freedom', 'liberty']::text[] from public.concepts where slug = 'svoboda'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tajemstvi', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tajemství' from public.concepts where slug = 'tajemstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tajemství', 'tajnost', 'šeptání']::text[] from public.concepts where slug = 'tajemstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'secret' from public.concepts where slug = 'tajemstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['secret', 'whisper', 'secrecy']::text[] from public.concepts where slug = 'tajemstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('tiha', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'tíha' from public.concepts where slug = 'tiha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['tíha', 'tíže', 'břemeno']::text[] from public.concepts where slug = 'tiha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'burden' from public.concepts where slug = 'tiha'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['burden', 'heaviness']::text[] from public.concepts where slug = 'tiha'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('ticho', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'ticho' from public.concepts where slug = 'ticho'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['ticho', 'tichem', 'mlčení', 'klid']::text[] from public.concepts where slug = 'ticho'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'silence' from public.concepts where slug = 'ticho'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['silence', 'quiet', 'hush']::text[] from public.concepts where slug = 'ticho'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('trapas', 3, 'abstraktni', false, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'trapas' from public.concepts where slug = 'trapas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['trapas', 'trapasu', 'ostuda', 'trapná situace', 'faux pas']::text[] from public.concepts where slug = 'trapas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'awkward moment' from public.concepts where slug = 'trapas'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['awkward moment', 'awkward', 'embarrassment', 'cringe']::text[] from public.concepts where slug = 'trapas'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('trpelivost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'trpělivost' from public.concepts where slug = 'trpelivost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['trpělivost', 'trpělivý']::text[] from public.concepts where slug = 'trpelivost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'patience' from public.concepts where slug = 'trpelivost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['patience', 'patient']::text[] from public.concepts where slug = 'trpelivost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('unava', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'únava' from public.concepts where slug = 'unava'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['únava', 'únavu', 'vyčerpání', 'ospalost']::text[] from public.concepts where slug = 'unava'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'tiredness' from public.concepts where slug = 'unava'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['tiredness', 'fatigue', 'exhaustion']::text[] from public.concepts where slug = 'unava'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vdecnost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vděčnost' from public.concepts where slug = 'vdecnost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vděčnost', 'vděk', 'poděkování']::text[] from public.concepts where slug = 'vdecnost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'gratitude' from public.concepts where slug = 'vdecnost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['gratitude', 'thankfulness', 'thank you']::text[] from public.concepts where slug = 'vdecnost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vitezstvi', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vítězství' from public.concepts where slug = 'vitezstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vítězství', 'výhra', 'vyhrát']::text[] from public.concepts where slug = 'vitezstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'victory' from public.concepts where slug = 'vitezstvi'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['victory', 'winning', 'win']::text[] from public.concepts where slug = 'vitezstvi'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('vune', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'vůně' from public.concepts where slug = 'vune'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['vůně', 'vonět', 'voní', 'aroma']::text[] from public.concepts where slug = 'vune'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'smell' from public.concepts where slug = 'vune'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['smell', 'scent', 'aroma']::text[] from public.concepts where slug = 'vune'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zarlivost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žárlivost' from public.concepts where slug = 'zarlivost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žárlivost', 'žárlivý', 'závist']::text[] from public.concepts where slug = 'zarlivost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'jealousy' from public.concepts where slug = 'zarlivost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['jealousy', 'jealous', 'envy']::text[] from public.concepts where slug = 'zarlivost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zizen', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'žízeň' from public.concepts where slug = 'zizen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['žízeň', 'žízní', 'žíznivý']::text[] from public.concepts where slug = 'zizen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'thirst' from public.concepts where slug = 'zizen'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['thirst', 'thirsty']::text[] from public.concepts where slug = 'zizen'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zmena', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'změna' from public.concepts where slug = 'zmena'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['změna', 'změnu', 'proměna']::text[] from public.concepts where slug = 'zmena'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'change' from public.concepts where slug = 'zmena'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['change', 'transformation']::text[] from public.concepts where slug = 'zmena'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;

insert into public.concepts (slug, difficulty, category, is_cross_language, is_school_safe)
values ('zvedavost', 3, 'abstraktni', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'zvědavost' from public.concepts where slug = 'zvedavost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['zvědavost', 'zvědavý', 'zvídavost']::text[] from public.concepts where slug = 'zvedavost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'curiosity' from public.concepts where slug = 'zvedavost'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['curiosity', 'curious']::text[] from public.concepts where slug = 'zvedavost'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;


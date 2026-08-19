-- Generováno z supabase/seed/concepts.json příkazem
--   node supabase/seed/check-concepts.mjs --sql > supabase/migrations/<ts>_seed_concepts.sql
-- Needituj ručně. Klíčem je slug, takže opakované nasazení je bezpečné.

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
values ('kocka', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'kočka' from public.concepts where slug = 'kocka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['kočka', 'kocour', 'kočku', 'kočička', 'koťátko', 'koťe']::text[] from public.concepts where slug = 'kocka'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'cat' from public.concepts where slug = 'kocka'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['cat', 'kitten', 'kitty', 'tomcat']::text[] from public.concepts where slug = 'kocka'
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
values ('slon', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'slon' from public.concepts where slug = 'slon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['slon', 'slona', 'slonice', 'slůně']::text[] from public.concepts where slug = 'slon'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'elephant' from public.concepts where slug = 'slon'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['elephant']::text[] from public.concepts where slug = 'slon'
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
values ('sova', 1, 'zvire', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'sova' from public.concepts where slug = 'sova'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['sova', 'sovu', 'sovička', 'výr']::text[] from public.concepts where slug = 'sova'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'owl' from public.concepts where slug = 'sova'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['owl']::text[] from public.concepts where slug = 'sova'
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
values ('chleba', 1, 'jidlo', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'chleba' from public.concepts where slug = 'chleba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['chleba', 'chléb', 'chlebík', 'bochník', 'houska']::text[] from public.concepts where slug = 'chleba'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'bread' from public.concepts where slug = 'chleba'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['bread', 'loaf', 'bun']::text[] from public.concepts where slug = 'chleba'
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
select id, 'cs', array['vejce', 'vajíčko', 'vajec', 'vajce']::text[] from public.concepts where slug = 'vejce'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'egg' from public.concepts where slug = 'vejce'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['egg', 'eggs']::text[] from public.concepts where slug = 'vejce'
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
values ('plavani', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'plavání' from public.concepts where slug = 'plavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['plavání', 'plavat', 'plave', 'plavec']::text[] from public.concepts where slug = 'plavani'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'swimming' from public.concepts where slug = 'plavani'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['swimming', 'swim', 'swimmer']::text[] from public.concepts where slug = 'plavani'
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
values ('plac', 2, 'cinnost', true, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'pláč' from public.concepts where slug = 'plac'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['pláč', 'brekot', 'pláče', 'slzy', 'plakat']::text[] from public.concepts where slug = 'plac'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'crying' from public.concepts where slug = 'plac'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['crying', 'cry', 'tears', 'weeping']::text[] from public.concepts where slug = 'plac'
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
values ('stesti', 3, 'abstraktni', false, true)
on conflict (slug) do update set difficulty = excluded.difficulty,
  category = excluded.category, is_cross_language = excluded.is_cross_language,
  is_school_safe = excluded.is_school_safe;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'cs', 'štěstí' from public.concepts where slug = 'stesti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'cs', array['štěstí', 'štěstíčko', 'radost', 'smůla naopak']::text[] from public.concepts where slug = 'stesti'
on conflict (concept_id, locale) do update set accepted = excluded.accepted;
insert into public.concept_locales (concept_id, locale, prompt)
select id, 'en', 'happiness' from public.concepts where slug = 'stesti'
on conflict (concept_id, locale) do update set prompt = excluded.prompt;
insert into public.concept_answers (concept_id, locale, accepted)
select id, 'en', array['happiness', 'happy', 'joy']::text[] from public.concepts where slug = 'stesti'
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


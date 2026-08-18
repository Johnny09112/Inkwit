-- Inkwit — výchozí herní konfigurace (krok A4)
--
-- Neporušitelné pravidlo 6: balanc je serverová konfigurace, ne konstanty v kódu.
-- Tyhle hodnoty jsou VÝCHOZÍ NÁVRH k doladění testem, ne zamčená čísla.
--
-- is_public = smí to přečíst klient.
--   true  → potřebuje to UI (počet pokusů, denní limity)
--   false → pravidlo 7: prahy trust score se nezveřejňují, a co se nezveřejní,
--           to se taky nedá cíleně obcházet

insert into public.game_config (key, value, is_public, note) values

  -- Herní pravidla viditelná v UI
  ('guess_attempts',          '3'::jsonb,     true,
   'Počet pokusů na kresbu. Vynucuje i CHECK na guesses.attempt_no.'),

  ('thumbs_per_day',          '1'::jsonb,     true,
   'Palců na uživatele a den CELKEM. Vzácný hlas, ne lajk. Drží unikátní index reactions_one_per_day_idx.'),

  ('requests_per_day',        '3'::jsonb,     true,
   'Kolik kreseb si smí uživatel vyžádat za den. Bez limitu je vyžádání spam kanál.'),

  ('request_ttl_hours',       '168'::jsonb,   true,
   'Životnost otevřené žádosti (7 dní). Otevřené žádosti se musí uklidit samy, jinak vzniká ruční fronta.'),

  ('concept_choices',         '3'::jsonb,     true,
   'Kolik konceptů se nabídne kreslíři. Volba je ventil pro toho, kdo neumí kreslit.'),

  -- Ekonomika. Poměr kreslení : hádání je otevřená otázka #2 v roadmap.md,
  -- strop ~10:1 je ale daný — nad ním se hádání stane bezcenným.
  ('reward_draw_solved',      '10'::jsonb,    true,
   'Kredit za kresbu, kterou někdo uhodl. Za neuhodnutou se nedává nic navíc.'),

  ('reward_guess_correct',    '2'::jsonb,     true,
   'Kredit za uhodnutí. Poměr ke kreslení je 5:1, strop je 10:1.'),

  -- Anti-čmáranice: klientský práh pro kontrolní krok „vypadá to narychlo".
  -- Veřejný proto, že ho potřebuje klient a je to jen tření, ne trest.
  -- Skutečná detekce je serverová a její prahy veřejné nejsou.
  ('rushed_min_strokes',      '3'::jsonb,     true,
   'Pod tímhle počtem tahů se při odeslání ukáže kontrolní krok.'),

  ('rushed_min_duration_ms',  '8000'::jsonb,  true,
   'Pod touhle dobou kreslení se při odeslání ukáže kontrolní krok.'),

  -- Archivace. Otevřená otázka #3 v roadmap.md — čísla jsou zatím odhad,
  -- ne výsledek měření. Doladit před tím, než se zapne archivace (krok D1).
  ('archive_after_unsolved',  '{"1": 20, "2": 30, "3": 45}'::jsonb, false,
   'Kolik neuhodnutí do archivace, podle obtížnosti konceptu. Autorovi se počet nikdy nezobrazuje.'),

  -- Trust score. Neveřejné podle pravidla 7 — uživateli se nezobrazuje číslo
  -- ani prahy. Ve fázi 0 se nepoužívá, hodnoty tu jsou, aby balanc nevznikal
  -- v kódu, až na to dojde.
  ('trust_band_verified_at',  '0.6'::jsonb,   false,
   'Reliability, od které je účet ověřený. NEZVEŘEJŇOVAT.'),

  ('trust_band_trusted_at',   '0.85'::jsonb,  false,
   'Reliability, od které je účet důvěryhodný. NEZVEŘEJŇOVAT.'),

  -- Koruna za slovo. Fáze 1+, ne fáze 0. Zapsáno teď, aby se balanc nezadrátoval
  -- do kódu, až se bude stavět. Zdůvodnění prahů v memory/decisions/koruna-za-slovo.md.
  ('crown_min_drawings',      '5'::jsonb,     false,
   'Kolik kreseb musí koncept v týdnu dostat, aby se koruna vůbec udílela. Koruna ze dvou kandidátů je účast, ne výhra.'),

  ('crown_min_thumbs',        '3'::jsonb,     false,
   'Kolik palců musí mít vítěz koruny. Bez prahu se koruna rozhodne poměrem 1:0 a měří distribuční štěstí.')

on conflict (key) do nothing;

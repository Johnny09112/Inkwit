-- Inkwit — porovnávání odpovědí (krok B4)
--
-- Vědomě BEZ rozšíření `unaccent` a `fuzzystrmatch`. Důvody dva:
--
--   1. Nejsou v PGlite, na kterém běží testy. Neotestovaná shoda odpovědí je
--      to poslední, co si tenhle projekt může dovolit — chyba tady znamená,
--      že hra vyhodnotí správný tip jako špatný.
--   2. Vlastní tabulka znaků je pro češtinu přesnější než obecný unaccent.

-- ---------------------------------------------------------------------------
-- Normalizace
-- ---------------------------------------------------------------------------
--
-- Diakritika, velikost písmen ani vícenásobné mezery nesmí rozhodovat.
-- „DÉŠŤ", „dest" a „  déšť " je pro hru jedna a tatáž odpověď.

create or replace function private.normalize_answer(p_text text)
returns text
language sql
immutable
set search_path = pg_temp
as $$
  select btrim(regexp_replace(
    translate(
      lower(coalesce(p_text, '')),
      'áäàâãčćďéěëèêíïìîľĺňñóöòôõřŕšśťúůüùûýÿžźż',
      'aaaaaccdeeeeeiiiillnnooooorrsstuuuuuyyzzz'
    ),
    '\s+', ' ', 'g'
  ));
$$;

-- ---------------------------------------------------------------------------
-- Levenshteinova vzdálenost
-- ---------------------------------------------------------------------------
--
-- Počítá se jen do zadaného stropu — delší rozdíl nás nezajímá a předčasné
-- ukončení šetří práci při porovnávání proti desítkám přijímaných tvarů.

create or replace function private.edit_distance(a text, b text, p_max int)
returns int
language plpgsql
immutable
set search_path = pg_temp
as $$
declare
  la int := length(a);
  lb int := length(b);
  prev int[];
  cur  int[];
  i int; j int; cost int; best int;
begin
  if abs(la - lb) > p_max then return p_max + 1; end if;
  if la = 0 then return lb; end if;
  if lb = 0 then return la; end if;

  prev := array(select generate_series(0, lb));

  for i in 1..la loop
    cur := array_fill(0, array[lb + 1]);
    cur[1] := i;
    best := cur[1];

    for j in 1..lb loop
      cost := case when substr(a, i, 1) = substr(b, j, 1) then 0 else 1 end;
      cur[j + 1] := least(cur[j] + 1, prev[j + 1] + 1, prev[j] + cost);
      if cur[j + 1] < best then best := cur[j + 1]; end if;
    end loop;

    -- Když je i nejlepší hodnota v řádku nad stropem, lepší už to nebude.
    if best > p_max then return p_max + 1; end if;
    prev := cur;
  end loop;

  return prev[lb + 1];
end;
$$;

-- ---------------------------------------------------------------------------
-- Shoda odpovědi
-- ---------------------------------------------------------------------------
--
-- **Prahy tolerance překlepů podle délky — podloženo daty, ne odhadem.**
-- Kontrola slovníku našla 22 dvojic tvarů kratších než pět znaků, které se liší
-- jediným znakem a patří RŮZNÝM pojmům: `pes`/`děs`, `slon`/`shon`, `výr`/`sýr`,
-- `dům`/`dub`, `klíč`/`klid`, anglicky `cat`/`bat`/`car`, `bear`/`pear`/`fear`,
-- `sun`/`run`/`bun`. Levenshtein ≤ 1 by je zaměnil a hráč by dostal bod za
-- uhodnutí něčeho jiného.
--
-- Proto: do 4 znaků jen přesná shoda, 5–7 vzdálenost 1, 8+ vzdálenost 2.
-- Prahy jsou v `game_config`, aby šly doladit testem bez nasazení.

create or replace function private.answer_matches(
  p_concept_id uuid,
  p_locale     text,
  p_text       text
)
returns boolean
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_guess    text := private.normalize_answer(p_text);
  v_accepted text[];
  v_short    int;
  v_medium   int;
  a          text;
  n          text;
  v_allow    int;
begin
  if v_guess = '' then return false; end if;

  select accepted into v_accepted
  from public.concept_answers
  where concept_id = p_concept_id and locale = p_locale;

  if v_accepted is null then return false; end if;

  select (value)::int into v_short  from public.game_config where key = 'fuzzy_exact_below';
  select (value)::int into v_medium from public.game_config where key = 'fuzzy_one_below';

  foreach a in array v_accepted loop
    n := private.normalize_answer(a);
    if n = v_guess then return true; end if;

    -- Strop se řídí délkou SPRÁVNÉ odpovědi, ne tipu — jinak by dlouhý
    -- nesmysl dostal velkou toleranci proti krátkému slovu.
    v_allow := case
      when length(n) < v_short  then 0
      when length(n) < v_medium then 1
      else 2
    end;

    if v_allow > 0 and private.edit_distance(n, v_guess, v_allow) <= v_allow then
      return true;
    end if;
  end loop;

  return false;
end;
$$;

insert into public.game_config (key, value, is_public, note) values
  ('fuzzy_exact_below', '5'::jsonb, false,
   'Pod tolik znaků se vyžaduje přesná shoda. Slovník obsahuje 22 dvojic krátkých slov lišících se jedním znakem u RŮZNÝCH pojmů (pes/děs, cat/bat) — tolerance by je zaměnila.'),
  ('fuzzy_one_below', '8'::jsonb, false,
   'Pod tolik znaků se toleruje jeden překlep, od téhle délky dva.')
on conflict (key) do nothing;

-- Inkwit — tvary jako nástroj a zkrácení žebříčku levelů na to, co existuje
--
-- ## Proč se žebříček zkracuje
--
-- Prahy byly `[0, 10, 25, 50, 100, 175]`, tedy šest levelů, ale reálná odemčení
-- byla dvě (paleta na 2, míchání barev na 3). Levely 4–6 nedělaly nic. Majitel
-- na nich přitom stál — jeho tři účty měly 133 / 71 / 53 vydělaných kreditů,
-- tedy level 5 / 4 / 4. **Prázdný level cítí jako první ten, kdo hraje nejvíc.**
--
-- Nově `[0, 10, 25, 50]`: čtyři levely a za každým něco je. Prahy jsou
-- v konfiguraci, takže páté patro se dá přidat bez nasazení, až bude čím.
--
-- | level | odemyká |
-- |---|---|
-- | 1 | kreslení, hádání, všechny obtížnosti, 8 barev |
-- | 2 | celá základní paleta (15 barev) |
-- | 3 | míchání vlastních barev |
-- | 4 | **tvary — čára, obdélník, elipsa** |
--
-- ## Proč zrovna tvary, a proč ne kbelík
--
-- **Kbelík (plošná výplň) porušuje pravidlo 2** z `CLAUDE.md`: kresba se ukládá
-- jako vektorové tahy, nikdy jako bitmapa. Vyplněná plocha se jako tah zapsat
-- nedá — rozbila by přehrání, export GIFu i detekci čmáranic, která stojí na
-- časových značkách bodů.
--
-- **Tvar je naopak tah jako každý jiný:** dva body (začátek a konec) a jiná
-- hodnota v `tool`. Přehrání, poměr stran i bounding box z něj vyjdou beze změny
-- datového modelu.
--
-- Tvary nejsou pay-to-win (pravidlo 3): nedávají pokusy navíc, násobič bodů ani
-- výhodu v žebříčku, a level se nedá koupit.

-- ---------------------------------------------------------------------------
-- Nové hodnoty v `tool`
-- ---------------------------------------------------------------------------

alter table public.drawing_strokes drop constraint if exists drawing_strokes_tool_check;
alter table public.drawing_strokes add constraint drawing_strokes_tool_check
  check (tool in ('pen', 'brush', 'eraser', 'line', 'rect', 'ellipse'));

-- ---------------------------------------------------------------------------
-- Konfigurace
-- ---------------------------------------------------------------------------

insert into public.game_config (key, value, is_public, note) values
  ('level_shapes', '4'::jsonb, true,
   'Od kterého levelu jde kreslit tvary (čára, obdélník, elipsa). Vynucuje submit_drawing, ne jen klient.')
on conflict (key) do update set value = excluded.value, note = excluded.note;

update public.game_config
set value = '[0, 10, 25, 50]'::jsonb,
    note = 'Kolik CELKEM vydělaných kreditů dělá který level. Index 0 = level 1. Levelů je tolik, kolik je odemčení — prázdný level je horší než žádný. Další patro se přidá tady, bez nasazení.'
where key = 'level_thresholds';

-- ---------------------------------------------------------------------------
-- Odeslání kresby
-- ---------------------------------------------------------------------------
--
-- Proti verzi z `20260820140000_credits.sql` přibyly dvě věci a nic jiného se
-- nemění:
--
--   1. **Level se ověřuje na serveru.** `CLAUDE.md`: „Každý zápis, který mění
--      stav hry, prochází serverovou validací. Klientu se nevěří nic."
--      Zamčený nástroj v UI je pohodlí, ne zámek — kdo si upraví payload,
--      prošel by. Kontrola je jednou za kresbu, ne za každý tah.
--   2. **Neznámý nástroj se pojmenuje.** Do teď by spadl až na CHECK constraintu
--      a člověk by uviděl jen obecné „Odeslání se nepovedlo".

create or replace function public.submit_drawing(
  p_drawing_id  uuid,
  p_device_kind text,
  p_undo_count  integer,
  p_strokes     jsonb,
  p_aspect      real default null
)
returns uuid
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user        uuid := auth.uid();
  v_created     timestamptz;
  v_max_strokes int;
  v_max_points  int;
  v_count       int;
  v_points      int;
  v_min_x       real; v_max_x real; v_min_y real; v_max_y real;
  v_aspect      real;
  v_diff        smallint;
  v_base        int;
  s             jsonb;
  v_tool        text;
  seq           int := 0;
begin
  if v_user is null then
    raise exception 'Odeslat kresbu může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  select created_at into v_created
  from public.drawings
  where id = p_drawing_id and author_id = v_user and status = 'draft'
  for update;

  if not found then
    raise exception 'Rozepsaná kresba nenalezena.' using errcode = '23503';
  end if;

  if jsonb_typeof(p_strokes) <> 'array' or jsonb_array_length(p_strokes) = 0 then
    raise exception 'Kresba nemá žádné tahy.' using errcode = '23514';
  end if;

  select (value)::int into v_max_strokes from public.game_config where key = 'max_strokes_per_drawing';
  select (value)::int into v_max_points  from public.game_config where key = 'max_points_per_drawing';

  v_count := jsonb_array_length(p_strokes);
  if v_count > v_max_strokes then
    raise exception 'Příliš mnoho tahů.' using errcode = '23514';
  end if;

  select coalesce(sum(jsonb_array_length(x -> 'points')), 0) / 3
    into v_points
  from jsonb_array_elements(p_strokes) x;

  -- v_points UŽ JSOU body (pole má tři čísla na bod); násobit je znovu třemi
  -- znamenalo srovnávat délku pole se stropem počtu bodů.
  if v_points > v_max_points then
    raise exception 'Příliš mnoho bodů.' using errcode = '23514';
  end if;

  -- Tvary jsou odemčené levelem. Jednou za kresbu — počítat level u každého
  -- tahu by znamenalo sečíst ledger tolikrát, kolik má kresba tahů.
  if exists (
    select 1 from jsonb_array_elements(p_strokes) x
    where coalesce(x ->> 'tool', 'brush') in ('line', 'rect', 'ellipse')
  ) then
    perform private.require_level('level_shapes');
  end if;

  -- Nesmyslný poměr se tiše nahradí výchozím, ne odmítne — kresba za to nemůže.
  v_aspect := case
    when p_aspect is null or p_aspect <= 0.2 or p_aspect >= 5 then 0.68
    else p_aspect
  end;

  -- Tahy uložit v pořadí, v jakém přišly.
  for s in select * from jsonb_array_elements(p_strokes) loop
    if jsonb_typeof(s -> 'points') <> 'array'
       or jsonb_array_length(s -> 'points') = 0
       or jsonb_array_length(s -> 'points') % 3 <> 0 then
      raise exception 'Poškozený tah — body musí být ploché pole [x,y,t,…].'
        using errcode = '23514';
    end if;

    v_tool := coalesce(s ->> 'tool', 'brush');
    if v_tool not in ('pen', 'brush', 'eraser', 'line', 'rect', 'ellipse') then
      raise exception 'Neznámý nástroj „%".', v_tool using errcode = '23514';
    end if;

    insert into public.drawing_strokes (drawing_id, seq, author_id, tool, color, width, points)
    values (
      p_drawing_id,
      seq,
      v_user,
      v_tool,
      coalesce(s ->> 'color', '#2B261F'),
      coalesce((s ->> 'width')::real, 14),
      s -> 'points'
    );
    seq := seq + 1;
  end loop;

  -- Pokrytí plátna z bounding boxu všech bodů. Souřadnice jsou normalizované
  -- 0–1, takže plocha vyjde rovnou jako podíl.
  -- V plochém poli [x,y,t,…] je x na pozicích 1,4,7… a y na 2,5,8…
  -- (`ordinality` počítá od jedné), takže stačí zbytek po dělení třemi.
  select
    min(v) filter (where m = 0), max(v) filter (where m = 0),
    min(v) filter (where m = 1), max(v) filter (where m = 1)
  into v_min_x, v_max_x, v_min_y, v_max_y
  from (
    select (pt.value)::text::real as v, (pt.ord - 1) % 3 as m
    from jsonb_array_elements(p_strokes) as st
    cross join lateral jsonb_array_elements(st.value -> 'points')
      with ordinality as pt(value, ord)
  ) q;

  update public.drawings set
    status       = 'live',
    published_at = now(),
    -- Dobu měří SERVER, ne klient. Zahrnuje i to, že si člověk odskočil —
    -- rytmus kreslení se čte z časových značek v tazích, ne odsud.
    duration_ms  = greatest(0, (extract(epoch from (now() - v_created)) * 1000)::int),
    stroke_count = v_count,
    undo_count   = greatest(0, coalesce(p_undo_count, 0)),
    device_kind  = case when p_device_kind in ('mouse','touch','pen') then p_device_kind else 'unknown' end,
    aspect       = v_aspect,
    coverage     = least(1.0, greatest(0.0, (v_max_x - v_min_x) * (v_max_y - v_min_y)))
  where id = p_drawing_id;

  -- Základ podle obtížnosti, hned. Jistá odměna za to, že vůbec něco vzniklo;
  -- bonus za uhodnutí přidá submit_guess, až kresbě někdo porozumí.
  select c.difficulty into v_diff
  from public.drawings d join public.concepts c on c.id = d.concept_id
  where d.id = p_drawing_id;

  select (value -> v_diff::text)::int into v_base
  from public.game_config where key = 'reward_draw_base';

  perform private.award(v_user, coalesce(v_base, 0), 'draw_base', p_drawing_id);

  return p_drawing_id;
end;
$$;

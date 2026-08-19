-- Inkwit — oprava stropu bodů na kresbu
--
-- `submit_drawing()` počítala body a pak je znovu násobila třemi:
--
--     select sum(jsonb_array_length(x -> 'points')) / 3 into v_points ...
--     if v_points * 3 > v_max_points then
--
-- `v_points` už jsou body (ploché pole má tři čísla na bod), takže se proti
-- stropu porovnávala délka pole. Skutečný strop byl **20 000 bodů**, ne 60 000,
-- které má klíč `max_points_per_drawing` a jeho popis: „Při 1500 bodech u běžné
-- kresby je to čtyřicetinásobná rezerva."
--
-- Proč na tom záleží: největší dosud odeslaná kresba má 6 204 bodů, tedy 31 %
-- toho nechtěného stropu. Na displeji se 120 Hz a na velkém plátně tabletu
-- vzniká bodů zhruba dvojnásobek proti telefonu, takže se hranice dala potkat —
-- a odeslání by skončilo hláškou „Odeslání se nepovedlo".
--
-- Mění se jen tenhle jeden výraz; zbytek funkce je beze změny.

create or replace function public.submit_drawing(
  p_drawing_id  uuid,
  p_device_kind text,
  p_undo_count  integer,
  p_strokes     jsonb
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
  s             jsonb;
  seq           int := 0;
  i             int;
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

  -- Tady byla chyba: v_points UŽ JSOU body (pole má tři čísla na bod),
  -- takže se proti stropu porovnávala délka pole a platil třetinový limit.
  if v_points > v_max_points then
    raise exception 'Příliš mnoho bodů.' using errcode = '23514';
  end if;

  -- Tahy uložit v pořadí, v jakém přišly.
  for s in select * from jsonb_array_elements(p_strokes) loop
    if jsonb_typeof(s -> 'points') <> 'array'
       or jsonb_array_length(s -> 'points') = 0
       or jsonb_array_length(s -> 'points') % 3 <> 0 then
      raise exception 'Poškozený tah — body musí být ploché pole [x,y,t,…].'
        using errcode = '23514';
    end if;

    insert into public.drawing_strokes (drawing_id, seq, author_id, tool, color, width, points)
    values (
      p_drawing_id,
      seq,
      v_user,
      coalesce(s ->> 'tool', 'brush'),
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
    coverage     = least(1.0, greatest(0.0, (v_max_x - v_min_x) * (v_max_y - v_min_y)))
  where id = p_drawing_id;

  return p_drawing_id;
end;
$$;

revoke execute on function public.submit_drawing(uuid, text, integer, jsonb) from public, anon;
grant execute on function public.submit_drawing(uuid, text, integer, jsonb) to authenticated, service_role;

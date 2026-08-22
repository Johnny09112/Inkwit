-- Inkwit — výplň uzavřeného tvaru
--
-- Majitel chtěl kbelík. Ten nejde: plošná výplň libovolných pixelů se jako
-- vektorový tah zapsat nedá a při přehrání by se musel pustit znovu tentýž
-- rastrový flood fill — antialiasing se ale liší podle rozlišení, takže by
-- výplň u hádajícího protekla škvírou. Je to stejná třída chyby jako to
-- roztahování kresby (`bugs/kresba-se-roztahovala-podle-plochy.md`).
--
-- **Výplň uzavřeného tvaru ale jde.** Obdélník i elipsa už jsou vektorová
-- cesta; vyplnit ji je jedna vlastnost navíc, ne nový formát. Pravidlo 2 tím
-- zůstává v platnosti a přehrání, export i poměr stran fungují beze změny.
--
-- Čára se vyplnit nedá a nic to neznamená — server to hlídá sám, ať se na
-- klienta nemusí spoléhat.
--
-- Výplň je součástí nástroje tvarů, takže **platí pro ni tentýž level**.

alter table public.drawing_strokes
  add column if not exists filled boolean not null default false;

comment on column public.drawing_strokes.filled is
  'Vyplněný uzavřený tvar (rect, ellipse). U ostatních nástrojů vždy false — hlídá submit_drawing.';

-- ---------------------------------------------------------------------------
-- Odeslání kresby
-- ---------------------------------------------------------------------------
--
-- Proti verzi z `20260820180000_shapes_tool.sql` přibyl jediný sloupec
-- v INSERTu. Tělo funkce se sem kopíruje ze zdroje skriptem, ne rukou —
-- je to potřetí za den a přepis rukou je přesně to, jak se ztratí řádek.

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

    insert into public.drawing_strokes (drawing_id, seq, author_id, tool, color, width, points, filled)
    values (
      p_drawing_id,
      seq,
      v_user,
      v_tool,
      coalesce(s ->> 'color', '#2B261F'),
      coalesce((s ->> 'width')::real, 14),
      s -> 'points',
      -- Výplň dává smysl jen u uzavřeného tvaru. U čáry a štětce se tiše
      -- ignoruje, ať se na klienta nemusí spoléhat.
      coalesce((s ->> 'filled')::boolean, false) and v_tool in ('rect', 'ellipse')
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

revoke execute on function public.submit_drawing(uuid, text, integer, jsonb, real) from public, anon;
grant execute on function public.submit_drawing(uuid, text, integer, jsonb, real) to authenticated, service_role;

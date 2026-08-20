-- Inkwit — vlastní kreslený avatar
--
-- Avatar se kreslí **stejným plátnem jako kresby a ukládá se jako vektorové
-- tahy** (pravidlo 2). Bitmapa by znamenala Storage, egress a ztrátu možnosti
-- avatar překreslit v jakémkoli rozlišení; tahů je u avatara pár desítek,
-- takže se vejdou do sloupce vedle profilu.
--
-- **Není to kresba.** Nesmí se dostat do fondu k hádání, do metrik ani do
-- knihovny — proto sloupec v `profiles`, ne řádek v `drawings`. Kdyby to byla
-- kresba, musela by mít koncept, obtížnost a stav, a `next_drawing()` by ji
-- jednou nabídl k uhodnutí.
--
-- Formát je shodný s tahy kreseb: pole objektů `{tool, color, width, points}`,
-- kde `points` je ploché pole `[x, y, t, …]` (viz
-- `_claude/memory/decisions/kodovani-bodu-tahu.md`). Díky tomu ho vykreslí
-- tatáž funkce v prohlížeči a nevzniká druhý formát, který by se rozešel.
--
-- Avatar je čtvercový, takže se neukládá poměr stran — je vždycky 1.

alter table public.profiles add column if not exists avatar_strokes jsonb;

comment on column public.profiles.avatar_strokes is
  'Vektorové tahy avatara ve stejném formátu jako drawing_strokes. NULL = žádný avatar. Zapisuje jen public.set_avatar().';

-- Zápis přes RPC, ne napřímo: `UPDATE` na profiles je udělený jen na
-- vyjmenované sloupce (viz 20260819080000_fix_column_grants.sql), takže nový
-- sloupec je pro roli `authenticated` automaticky jen ke čtení.

insert into public.game_config (key, value, is_public, note) values
  ('max_avatar_strokes', '60'::jsonb, false,
   'Strop tahů avatara. Řádově míň než u kresby — avatar je ikona, ne obraz.'),
  ('max_avatar_points', '6000'::jsonb, false,
   'Strop bodů avatara. Pozor: počítají se BODY, ne délka plochého pole — na tom se už jednou spálil submit_drawing.')
on conflict (key) do update set value = excluded.value, note = excluded.note;

-- ---------------------------------------------------------------------------
-- Uložení avatara
-- ---------------------------------------------------------------------------

create or replace function public.set_avatar(p_strokes jsonb)
returns void
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user   uuid := auth.uid();
  v_max_s  int;
  v_max_p  int;
  v_points int;
  s        jsonb;
  v_tool   text;
begin
  if v_user is null then
    raise exception 'Avatar si nastaví jen přihlášený uživatel.' using errcode = '28000';
  end if;

  -- Prázdné pole i NULL znamenají „smaž avatar" a vracejí piktogram.
  if p_strokes is null
     or jsonb_typeof(p_strokes) = 'null'
     or (jsonb_typeof(p_strokes) = 'array' and jsonb_array_length(p_strokes) = 0) then
    update public.profiles set avatar_strokes = null where id = v_user;
    return;
  end if;

  if jsonb_typeof(p_strokes) <> 'array' then
    raise exception 'Avatar musí být pole tahů.' using errcode = '23514';
  end if;

  select (value)::int into v_max_s from public.game_config where key = 'max_avatar_strokes';
  select (value)::int into v_max_p from public.game_config where key = 'max_avatar_points';

  if jsonb_array_length(p_strokes) > coalesce(v_max_s, 60) then
    raise exception 'Avatar má příliš mnoho tahů.' using errcode = '23514';
  end if;

  -- Dělí se třemi, protože pole je [x,y,t,…]. Tohle je přesně to místo,
  -- kde submit_drawing kdysi porovnávala délku pole se stropem POČTU bodů
  -- a strop pak platil třetinový.
  select coalesce(sum(jsonb_array_length(x -> 'points')), 0) / 3
    into v_points
  from jsonb_array_elements(p_strokes) x;

  if v_points > coalesce(v_max_p, 6000) then
    raise exception 'Avatar má příliš mnoho bodů.' using errcode = '23514';
  end if;

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
  end loop;

  -- Tvary jsou odemčené levelem stejně jako u kreseb — jinak by byl avatar
  -- zadními vrátky k zamčenému nástroji.
  if exists (
    select 1 from jsonb_array_elements(p_strokes) x
    where coalesce(x ->> 'tool', 'brush') in ('line', 'rect', 'ellipse')
  ) then
    perform private.require_level('level_shapes');
  end if;

  update public.profiles set avatar_strokes = p_strokes where id = v_user;
end;
$$;

revoke execute on function public.set_avatar(jsonb) from public, anon;
grant execute on function public.set_avatar(jsonb) to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Profil vrací avatar
-- ---------------------------------------------------------------------------

drop function if exists public.my_profile();

create function public.my_profile()
returns table (
  display_name    text,
  locale          text,
  ab_playback     boolean,
  drawings        integer,
  guesses         integer,
  unread          integer,
  credits         integer,
  lifetime        integer,
  level           integer,
  next_level_at   integer,
  avatar_strokes  jsonb
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    p.display_name,
    p.locale_primary,
    p.ab_playback,
    (select count(*)::int from public.drawings d where d.author_id = p.id and d.status <> 'removed'),
    (select count(*)::int from public.guesses g where g.user_id = p.id),
    (select count(*)::int from public.notifications n where n.user_id = p.id and n.read_at is null),
    private.balance(p.id),
    private.lifetime_earned(p.id),
    private.level_of(p.id),
    -- Kolik celkem vydělaných chce další level. Null na stropu žebříčku.
    (select min(t.prah::int)
     from jsonb_array_elements_text(
       (select value from public.game_config where key = 'level_thresholds')
     ) as t(prah)
     where t.prah::int > private.lifetime_earned(p.id)),
    p.avatar_strokes
  from public.profiles p
  where p.id = auth.uid();
$$;

revoke execute on function public.my_profile() from public, anon;
grant execute on function public.my_profile() to authenticated, service_role;

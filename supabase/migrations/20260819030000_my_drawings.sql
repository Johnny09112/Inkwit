-- Inkwit — Moje kresby (krok C4)
--
-- **Tahle migrace opravuje porušení produktového pravidla, ne chybu v kódu.**
--
-- `docs/product.md` říká u archivace: „Autorovi se počet neuhodnutí
-- **nezobrazuje** — jen kolik lidí uhodlo." Jenže politika `drawings_select_own`
-- pouštěla autorovi celý řádek včetně `guess_count`. Autor tedy stačilo, aby
-- odečetl `solved_count`, a měl přesně to číslo, které vidět neměl.
--
-- Skrýt jeden sloupec RLS neumí (je řádková), takže se to řeší stejně jako
-- u trust score: přímý přístup se zavře a data chodí přes funkci, která pustí
-- jen povolené sloupce.

drop policy drawings_select_own on public.drawings;

-- Autor svoje kresby napřímo nečte. Rozepsanou dostane přes `my_draft()`,
-- hotové přes `my_drawings()` — obě vydají jen to, co vidět smí.
revoke select on public.drawings from anon, authenticated;

create or replace function public.my_drawings()
returns table (
  drawing_id   uuid,
  prompt       text,
  difficulty   smallint,
  status       text,
  solved_count integer,
  thumbs_count integer,
  stars        smallint,
  created_at   timestamptz
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    d.id,
    cl.prompt,
    c.difficulty,
    d.status,
    d.solved_count,
    d.thumbs_count,
    -- Hvězdičky měří, jak rychle byla kresba uhodnuta: na první pokus tři,
    -- na třetí jedna. Bez uhodnutí nula. Plnou podobu dostane krok D3.
    coalesce((
      select (4 - min(g.attempt_no))::smallint
      from public.guesses g
      where g.drawing_id = d.id and g.is_correct
    ), 0)::smallint,
    d.created_at
  from public.drawings d
  join public.concepts c on c.id = d.concept_id
  join public.concept_locales cl
    on cl.concept_id = c.id and cl.locale = d.source_locale
  where d.author_id = auth.uid()
    and d.status <> 'removed'
  order by d.created_at desc;
$$;

-- Vědomě chybí `guess_count`. Kdyby tu byl, autor si počet neuhodnutí
-- dopočítá odečtením a pravidlo padá.

revoke execute on function public.my_drawings() from public, anon;
grant execute on function public.my_drawings() to authenticated, service_role;

comment on function public.my_drawings() is
  'Kresby přihlášeného autora. NIKDY nesmí vracet guess_count — z rozdílu '
  'proti solved_count by autor odvodil počet neuhodnutí, který se mu podle '
  'docs/product.md nezobrazuje. Hlídá to test.';

-- ---------------------------------------------------------------------------
-- Tahy pro náhled
-- ---------------------------------------------------------------------------
--
-- Náhledy se kreslí z tahů v prohlížeči, ne z uložené bitmapy — zdůvodnění
-- v `docs/plan.md` u kroku C3. Tahle funkce je vydá pro víc kreseb najednou,
-- ať se na mřížku „Moje kresby" nedělá dotaz na každou zvlášť.

create or replace function public.strokes_for(p_drawing_ids uuid[])
returns table (
  drawing_id uuid,
  seq        integer,
  tool       text,
  color      text,
  width      real,
  points     jsonb
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select s.drawing_id, s.seq, s.tool, s.color, s.width, s.points
  from public.drawing_strokes s
  where s.drawing_id = any(p_drawing_ids)
    -- Funkce běží s právy vlastníka, takže smí sáhnout do `private` přímo.
    -- Obálka v `public` by jen přidala další volatelné rozhraní navíc.
    and private.can_view_drawing(s.drawing_id)
  order by s.drawing_id, s.seq;
$$;

revoke execute on function public.strokes_for(uuid[]) from public, anon;
grant execute on function public.strokes_for(uuid[]) to authenticated, service_role;

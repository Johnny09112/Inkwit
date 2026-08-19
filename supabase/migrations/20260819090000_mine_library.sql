-- Inkwit — knihovna „Moje kresby": rozepsané ven, mazání vlastní kresby
--
-- **Rozepsané kresby se v knihovně neukazují.** `my_drawings()` vracela každý
-- řádek kromě smazaných, takže se do mřížky dostaly i `draft` — kresby, které
-- vznikly založením plátna a autor od nich odešel křížkem. V knihovně z nich
-- byly prázdné dlaždice s popiskem „čeká na 1. uhodnutí", což je dvakrát vedle:
-- nemají jediný tah a nikdo je hádat nemůže.
--
-- **Řádek se ale nemaže.** `private.metrics_funnel` stojí přesně na něm — měří
-- drop-off mezi „začal kreslit" a „odeslal", a to je jedno ze tří čísel, kvůli
-- kterým se fáze 0 dělá. Úklid databáze by zabil měření.

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
    -- `draft` = rozepsaná, `removed` = smazaná autorem nebo moderací.
    -- Ani jedno nepatří do knihovny hotových kreseb.
    and d.status not in ('draft', 'removed')
  order by d.created_at desc;
$$;

-- Vědomě pořád chybí `guess_count`. Kdyby tu byl, autor si počet neuhodnutí
-- dopočítá odečtením a pravidlo z `docs/product.md` padá. Platí i pro detail
-- kresby — ten se skládá z týchž sloupců, žádná druhá cesta k datům není.

revoke execute on function public.my_drawings() from public, anon;
grant execute on function public.my_drawings() to authenticated, service_role;

comment on function public.my_drawings() is
  'Hotové kresby přihlášeného autora — bez rozepsaných a smazaných. NIKDY '
  'nesmí vracet guess_count: z rozdílu proti solved_count by autor odvodil '
  'počet neuhodnutí, který se mu podle docs/product.md nezobrazuje. '
  'Hlídá to test.';

-- ---------------------------------------------------------------------------
-- Smazání vlastní kresby
-- ---------------------------------------------------------------------------
--
-- **Měkké smazání, ne `delete`.** Status `removed` už schéma zná a používá ho
-- moderace. Tvrdé smazání by vzalo s sebou i tipy ostatních hráčů (cizí
-- historii) a čísla, ze kterých se počítá zásoba neuhodnutých kreseb —
-- metrika 2 z `CLAUDE.md`. Kresba zmizí z knihovny i z nabídky k hádání,
-- protože `next_drawing()` bere jen `live`.
--
-- Rozepsanou kresbu funkce vědomě odmítne: v knihovně stejně není a její řádek
-- drží drop-off pro `metrics_funnel`.

create or replace function public.delete_drawing(p_drawing_id uuid)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
  v_rows integer;
begin
  if v_user is null then
    raise exception 'není přihlášen' using errcode = '28000';
  end if;

  update public.drawings
  set status = 'removed'
  where id = p_drawing_id
    and author_id = v_user
    and status not in ('draft', 'removed');

  get diagnostics v_rows = row_count;
  return v_rows > 0;
end;
$$;

revoke execute on function public.delete_drawing(uuid) from public, anon;
grant execute on function public.delete_drawing(uuid) to authenticated, service_role;

comment on function public.delete_drawing(uuid) is
  'Měkké smazání vlastní kresby (status = removed). Cizí kresbu neodstraní — '
  'podmínka author_id = auth.uid() je uvnitř update, ne v aplikaci. Vrací '
  'false, když se nic nezměnilo (cizí, už smazaná, nebo rozepsaná).';

-- Inkwit — zadání rozepsané kresby pro jejího autora
--
-- Plátno potřebuje vědět, co má kreslit. Nabídku sestavil server (C1), ale
-- po přechodu na kreslicí obrazovku se ta informace ztratí.
--
-- Posílat zadání v URL by fungovalo, ale odpověď by se válela v historii
-- prohlížeče a v logu serveru. Autor si ho místo toho vyzvedne podle id
-- kresby — a jen pro svoji vlastní rozepsanou.

create or replace function public.my_draft(p_drawing_id uuid)
returns table (
  concept_id uuid,
  difficulty smallint,
  prompt     text
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select c.id, c.difficulty, cl.prompt
  from public.drawings d
  join public.concepts c on c.id = d.concept_id
  join public.concept_locales cl
    on cl.concept_id = c.id and cl.locale = d.source_locale
  where d.id = p_drawing_id
    and d.author_id = auth.uid()   -- cizí zadání nikdo nedostane
    and d.status = 'draft';        -- po odeslání už zadání není k čemu
$$;

revoke execute on function public.my_draft(uuid) from public, anon;
grant execute on function public.my_draft(uuid) to authenticated, service_role;

comment on function public.my_draft(uuid) is
  'Zadání rozepsané kresby pro jejího autora. Vrací prázdno pro cizí kresbu '
  'i pro už odeslanou — zadání je odpověď, takže se nepouští dál, než musí.';

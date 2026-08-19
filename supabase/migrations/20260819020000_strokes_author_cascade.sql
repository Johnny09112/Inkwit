-- Inkwit — oprava: účet s kresbou nešel smazat
--
-- `drawing_strokes.author_id` odkazoval na `profiles` bez pravidla pro mazání,
-- takže platilo NO ACTION. Smazání uživatele, který už něco nakreslil, spadlo na:
--
--   ERROR: 23503: update or delete on table "profiles" violates foreign key
--   constraint "drawing_strokes_author_id_fkey" on table "drawing_strokes"
--
-- Je to **druhý výskyt téže chyby** — první byla pravidla nad `ledger`
-- (migrace 20260818230000). Tehdy jsem doplnil test „účet jde smazat", jenže
-- testovací uživatel neměl žádné tahy, takže tudy prošel. Test se rozšiřuje
-- o kresbu s tahy.
--
-- Nalezeno 2026-08-19 při úklidu po ověření toku C1+C2.

alter table public.drawing_strokes
  drop constraint drawing_strokes_author_id_fkey,
  add constraint drawing_strokes_author_id_fkey
    foreign key (author_id) references public.profiles (id) on delete cascade;

comment on column public.drawing_strokes.author_id is
  'Autor tahu — u běžné kresby shodný s autorem kresby, u relay režimu ne. '
  'ON DELETE CASCADE je nutné: bez něj nejde smazat účet, který už kreslil. '
  'V relay režimu to znamená, že odchod hráče smaže jeho tahy i z cizího '
  'plátna — až se relay bude stavět, je to rozhodnutí k přehodnocení.';

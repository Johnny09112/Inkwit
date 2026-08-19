-- Inkwit — stabilní klíč konceptu
--
-- Koncepty měly jen náhodné UUID, takže nešlo znovu nasadit slovník, aniž by
-- vznikly duplikáty. `slug` je klíč ze `supabase/seed/concepts.json` a drží
-- vazbu mezi souborem v repu a řádkem v databázi.
--
-- ASCII bez diakritiky záměrně: je to identifikátor, ne text pro člověka.
-- Zadání pro kreslíře žije v `concept_locales.prompt`.

alter table public.concepts
  add column slug text;

update public.concepts set slug = id::text where slug is null;

alter table public.concepts
  alter column slug set not null,
  add constraint concepts_slug_shape check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');

create unique index concepts_slug_unique_idx on public.concepts (slug);

comment on column public.concepts.slug is
  'Klíč ze supabase/seed/concepts.json. Podle něj se slovník znovu nasazuje, '
  'takže se nesmí měnit — přejmenování slugu vytvoří nový koncept.';

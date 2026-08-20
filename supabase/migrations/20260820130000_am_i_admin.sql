-- Inkwit — drobný dotaz „jsem správce?"
--
-- `my_profile()` příznak nevrací a měnit jí kvůli tomu návratový typ by
-- znamenalo zahodit a znovu vytvořit funkci, kterou používá profil. Tohle
-- slouží jen k tomu, aby se odkaz na správu ukázal jen tomu, kdo ho má vidět —
-- **oprávnění na něm nestojí**, to si hlídá každá admin funkce sama.

create or replace function public.am_i_admin()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select private.is_admin();
$$;

revoke execute on function public.am_i_admin() from public, anon;
grant execute on function public.am_i_admin() to authenticated, service_role;

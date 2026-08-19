-- Inkwit — nahlášení kresby s důvodem
--
-- Do teď se z aplikace posílal natvrdo pořád stejný řetězec „nevhodný obsah",
-- takže hlášení sice vznikla, ale k moderaci byla k ničemu — nešlo poznat,
-- jestli jde o čmáranici, nebo o něco, co musí zmizet hned.
--
-- Nová obrazovka posílá kód důvodu (scribble, mismatch, text, offensive)
-- a u „jiné" i větu od člověka. Tím se do reports.reason poprvé dostává
-- uživatelský text, takže potřebuje strop délky: sloupec je text bez omezení
-- a nic jiného ho nehlídá.
--
-- 300 znaků = 200 z pole v dialogu plus rezerva na prefix „other: ".
-- Výchozí hodnota se mění z české věty na kód other, ať je moderace ze studia
-- strojově čitelná a nemíchají se v ní jazyky.

create or replace function public.report_drawing(p_drawing_id uuid, p_reason text)
returns boolean
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Nahlásit může jen přihlášený uživatel.' using errcode = '28000';
  end if;

  if not private.can_view_drawing(p_drawing_id) then
    raise exception 'Tuhle kresbu nahlásit nemůžeš.' using errcode = '42501';
  end if;

  insert into public.reports (drawing_id, reporter_id, reason)
  values (p_drawing_id, v_user, left(coalesce(nullif(btrim(p_reason), ''), 'other'), 300))
  on conflict (drawing_id, reporter_id) do nothing;

  return true;
end;
$$;

revoke execute on function public.report_drawing(uuid, text) from public, anon;
grant execute on function public.report_drawing(uuid, text) to authenticated, service_role;

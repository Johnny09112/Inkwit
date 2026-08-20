-- Inkwit — přesná odpověď jiného pojmu nesmí projít jako překlep
--
-- Kontrola slovníku (`node supabase/seed/check-concepts.mjs`) po rozšíření
-- o skutečné prahy tolerance našla v nasazených 120 pojmech jedenáct dvojic,
-- které si hra plete. Tři z nich jsou mezi dvěma ZADÁNÍMI a v datech se
-- opravit nedají:
--
--   en  mouse (myš)   × house (dům)     — vzdálenost 1, obojí je zadání
--   en  sheep (ovce)  × sleep (spánek)  — vzdálenost 1, obojí je zadání
--   en  clock (hodiny)× lock (zámek)    — vzdálenost 1, obojí je zadání
--
-- Kdo dostal kresbu ovce a napsal „sleep", dostal bod. Kresba se označila za
-- uhodnutou, `solved_count` narostl a hádající viděl v odhalení něco jiného,
-- než napsal. S každou další stovkou pojmů takových dvojic přibývá — u tisíce
-- slov je jich řádově sto a v datech je vyřešit nejde.
--
-- Oprava je v pravidle, ne v datech: **tolerance překlepů se nesmí použít na
-- tip, který je přesnou odpovědí jiného pojmu.** Kdo napsal „sleep", nepřeklepl
-- se — napsal jiné slovo, které umí. Přesná shoda se SVÝM pojmem má pořád
-- přednost, takže na kresbě spánku „sleep" dál platí.
--
-- Cena za to je jedno vyhledání v indexu na tip. Proto vedle `concept_answers`
-- žije normalizovaná kopie: pole se v Postgresu indexovat po prvcích nedá
-- a normalizace 300 pojmů za každý tip by byla dražší než hra sama.

-- ---------------------------------------------------------------------------
-- Normalizovaný rejstřík odpovědí
-- ---------------------------------------------------------------------------

create table if not exists private.answer_index (
  locale     text not null,
  normalized text not null,
  concept_id uuid not null references public.concepts (id) on delete cascade,
  primary key (locale, normalized, concept_id)
);

-- Vlastník (a tím i SECURITY DEFINER funkce) RLS obchází, takže zapnutí bez
-- politik jen zavře dveře komukoliv jinému. Schéma `private` PostgREST
-- nevystavuje, tohle je druhý zámek.
alter table private.answer_index enable row level security;

comment on table private.answer_index is
  'Normalizované odpovědi pro kontrolu „patří tenhle tip jinému pojmu?". Udržuje trigger nad public.concept_answers, needituj ručně.';

-- ---------------------------------------------------------------------------
-- Rejstřík drží trigger, ne ruka
-- ---------------------------------------------------------------------------

create or replace function private.sync_answer_index()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if tg_op in ('UPDATE', 'DELETE') then
    delete from private.answer_index
    where concept_id = old.concept_id and locale = old.locale;
  end if;

  if tg_op in ('INSERT', 'UPDATE') then
    insert into private.answer_index (locale, normalized, concept_id)
    select distinct new.locale, private.normalize_answer(a), new.concept_id
    from unnest(new.accepted) as a
    where private.normalize_answer(a) <> ''
    on conflict do nothing;
  end if;

  return null;
end;
$$;

drop trigger if exists trg_sync_answer_index on public.concept_answers;
create trigger trg_sync_answer_index
after insert or update or delete on public.concept_answers
for each row execute function private.sync_answer_index();

-- Naplnění z toho, co už v databázi je.
insert into private.answer_index (locale, normalized, concept_id)
select distinct ca.locale, private.normalize_answer(a), ca.concept_id
from public.concept_answers ca, unnest(ca.accepted) as a
where private.normalize_answer(a) <> ''
on conflict do nothing;

-- ---------------------------------------------------------------------------
-- Porovnávání odpovědí — doplněná pojistka
-- ---------------------------------------------------------------------------

create or replace function private.answer_matches(
  p_concept_id uuid,
  p_locale     text,
  p_text       text
)
returns boolean
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_guess    text := private.normalize_answer(p_text);
  v_accepted text[];
  v_short    int;
  v_medium   int;
  a          text;
  n          text;
  v_allow    int;
begin
  if v_guess = '' then return false; end if;

  select accepted into v_accepted
  from public.concept_answers
  where concept_id = p_concept_id and locale = p_locale;

  if v_accepted is null then return false; end if;

  -- 1) Přesná shoda se svým pojmem vyhrává vždycky a řeší se dřív než cokoliv
  --    dalšího. Kdyby se stejný tvar objevil u dvou pojmů, ten správný pořád
  --    projde (validátor to hlásí jako chybu, tady je to jen pojistka).
  foreach a in array v_accepted loop
    if private.normalize_answer(a) = v_guess then return true; end if;
  end loop;

  -- 2) Tip, který je přesnou odpovědí JINÉHO pojmu, není překlep. „sleep" na
  --    kresbě ovce, „potato" na kresbě rajčete — tam se nikdo nespletl na
  --    klávesnici, napsal jiné slovo.
  if exists (
    select 1 from private.answer_index ai
    where ai.locale = p_locale
      and ai.normalized = v_guess
      and ai.concept_id <> p_concept_id
  ) then
    return false;
  end if;

  select (value)::int into v_short  from public.game_config where key = 'fuzzy_exact_below';
  select (value)::int into v_medium from public.game_config where key = 'fuzzy_one_below';

  -- 3) Teprve teď tolerance překlepů. Strop se řídí délkou SPRÁVNÉ odpovědi,
  --    ne tipu — jinak by dlouhý nesmysl dostal velkou toleranci proti
  --    krátkému slovu.
  foreach a in array v_accepted loop
    n := private.normalize_answer(a);
    v_allow := case
      when length(n) < v_short  then 0
      when length(n) < v_medium then 1
      else 2
    end;

    if v_allow > 0 and private.edit_distance(n, v_guess, v_allow) <= v_allow then
      return true;
    end if;
  end loop;

  return false;
end;
$$;

comment on function private.answer_matches(uuid, text, text) is
  'Uzná tip? Přesná shoda → ano. Přesná odpověď jiného pojmu → ne (není to překlep). Jinak Levenshtein podle délky správné odpovědi.';

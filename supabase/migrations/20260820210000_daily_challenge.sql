-- Inkwit — denní výzva
--
-- Majitelův nápad: *„Varianta super-těžké — to bude denní výzva. Jednu
-- nakreslit a jednu uhádnout, kombinace je +15 kreditů."*
--
-- ## Proč NENÍ pojem dne společný pro všechny
--
-- První verze návrhu počítala s jedním slovem pro celou komunitu — společné
-- téma dne, sdílený hovor. **Rozbilo by to hru.** Zadání konceptu je tajemství
-- (`decisions/tajemstvi-hry-v-schematu.md`); kdyby všichni věděli, že dnešní
-- slovo je „nostalgie", hádání dnešních kreseb by nebylo hádání.
--
-- Výzva je proto **obtížnost, ne slovo**: nakresli jednu těžkou a uhodni jednu
-- těžkou. Tajemství zůstává a denní rituál taky.
--
-- ## Proč se nezavádí čtvrtá obtížnost
--
-- `offer_concepts()` bere jeden pojem od KAŽDÉ obtížnosti (`for d in 1..3`) —
-- je to ventil pro toho, kdo kreslit neumí. Čtvrté patro by ho rozředilo
-- a navíc pro něj neexistují pojmy; „super-těžké" je obsahová práce, ne
-- programování. Výzva zatím jede na existující nejvyšší obtížnosti.
--
-- ## Bez obsluhy a bez cronu
--
-- Nic se nepředpočítává. Stav se spočítá dotazem nad `drawings` a `guesses`
-- za dnešek a bonus se připíše ve chvíli, kdy jsou obě půlky hotové.
-- `ref_id` je odvozený z data, takže `ledger_once_idx` zaručí **nejvýš jeden
-- bonus na člověka a den** i při opakovaném volání.

insert into public.game_config (key, value, is_public, note) values
  ('daily_bonus', '15'::jsonb, true,
   'Bonus za splnění denní výzvy (nakreslit i uhodnout těžký pojem tentýž den).'),
  ('daily_difficulty', '3'::jsonb, true,
   'Která obtížnost se počítá do denní výzvy. Čtvrté patro se vědomě nezavádí — rozředilo by ventil v offer_concepts().')
on conflict (key) do update set value = excluded.value, note = excluded.note;

-- ---------------------------------------------------------------------------
-- Stav výzvy a připsání bonusu
-- ---------------------------------------------------------------------------
--
-- Funkce je `volatile`, protože kromě čtení může připsat bonus. Je to vědomé:
-- klient tím nemusí volat druhé RPC a stav se sám dorovná i tomu, kdo druhou
-- půlku splnil na jiné obrazovce.

create or replace function public.daily_challenge()
returns table (
  difficulty smallint,
  drawn      boolean,
  guessed    boolean,
  bonus      integer,
  awarded    boolean
)
language plpgsql
volatile
security definer
set search_path = public, pg_temp
as $$
declare
  v_user   uuid := auth.uid();
  v_diff   smallint;
  v_bonus  int;
  v_den    timestamptz;
  v_ref    uuid;
  v_drawn  boolean;
  v_guess  boolean;
  v_awarded boolean;
begin
  if v_user is null then
    raise exception 'Denní výzvu má jen přihlášený uživatel.' using errcode = '28000';
  end if;

  select (value)::int into v_diff  from public.game_config where key = 'daily_difficulty';
  select (value)::int into v_bonus from public.game_config where key = 'daily_bonus';
  v_diff := coalesce(v_diff, 3);
  v_bonus := coalesce(v_bonus, 15);

  -- Den v UTC, stejně jako všechny ostatní časy v projektu.
  v_den := date_trunc('day', (now() at time zone 'UTC')) at time zone 'UTC';

  -- Odkaz odvozený z data: `ledger_once_idx` pak sám hlídá jeden bonus na den.
  -- Bez toho by opakované volání funkce vyplácelo pořád dokola.
  v_ref := md5('daily:' || to_char(v_den, 'YYYY-MM-DD'))::uuid;

  select exists (
    select 1
    from public.drawings d
    join public.concepts c on c.id = d.concept_id
    where d.author_id = v_user
      and d.status = 'live'
      and c.difficulty = v_diff
      and d.published_at >= v_den
  ) into v_drawn;

  select exists (
    select 1
    from public.guesses g
    join public.drawings d on d.id = g.drawing_id
    join public.concepts c on c.id = d.concept_id
    where g.user_id = v_user
      and g.is_correct
      and c.difficulty = v_diff
      and g.created_at >= v_den
  ) into v_guess;

  if v_drawn and v_guess then
    perform private.award(v_user, v_bonus, 'daily_bonus', v_ref);
  end if;

  select exists (
    select 1 from public.ledger l
    where l.user_id = v_user and l.reason = 'daily_bonus' and l.ref_id = v_ref
  ) into v_awarded;

  return query select v_diff, v_drawn, v_guess, v_bonus, v_awarded;
end;
$$;

revoke execute on function public.daily_challenge() from public, anon;
grant execute on function public.daily_challenge() to authenticated, service_role;

comment on function public.daily_challenge() is
  'Stav denní výzvy a připsání bonusu. Výzva je obtížnost, ne konkrétní slovo — společný pojem dne by prozradil odpověď všem hádajícím.';

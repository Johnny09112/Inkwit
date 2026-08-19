---
name: rls-pomocne-funkce-mimo-public
description: Politiky RLS se vyhodnocují právy dotazujícího se uživatele, takže revoke execute je rozbije — pomocné funkce se schovávají přesunem do schématu mimo PostgREST, ne odebráním práv
type: pattern
status: active
created: 2026-08-18
updated: 2026-08-18
related: [tajemstvi-hry-v-schematu]
---

# Pomocné funkce pro RLS patří mimo schéma `public`

Narazeno 2026-08-18 při kroku A3, když Supabase security advisor nahlásil, že
funkce se `SECURITY DEFINER` jdou zavolat přes `/rest/v1/rpc/…`.

## Past

Přirozený první nápad je odebrat práva:

```sql
revoke execute on function public.current_tenant_id() from anon, authenticated;
```

**Tím se rozbijí politiky.** Výrazy v RLS politikách se vyhodnocují **právy
dotazujícího se uživatele**, ne vlastníka tabulky. Když roli `authenticated`
odebereš EXECUTE, přestane projít i politika, která funkci volá, a uživatel
neuvidí nic. Chyba je navíc tichá — nevrátí se chyba oprávnění, vrátí se
prostě prázdno.

Odhaleno testem: po `revoke` spadly čtyři testy typu „Alice vidí živou kresbu
ve feedu" a „žák nevidí veřejnou kresbu". Bez testu by se to našlo až v aplikaci
jako „proč je feed prázdný".

## Řešení

Přesunout funkce do schématu, které PostgREST nevystavuje (vystavuje jen `public`
a nakonfigurovaná schémata):

```sql
create schema if not exists private;
grant usage on schema private to authenticated, service_role;
-- funkce vytvořit v private, EXECUTE nechat udělený
```

Práva zůstanou, takže politiky fungují, ale přes REST se na funkci nedá dosáhnout.
V Inkwitu tam žijí `private.current_tenant_id()`, `private.can_view_drawing()`
a `private.handle_new_user()`.

**Pozor:** politiky i pohledy na funkci drží odkaz, takže přesun znamená jejich
`drop` a znovuvytvoření ve stejné migraci. Jinak migrace spadne na závislosti.

## Co advisor hlásí a co je záměr

`rls_enabled_no_policy` na tabulkách bez jediné politiky je u nás **úmysl** —
default deny u tajných tabulek (`concepts`, `concept_locales`, `concept_answers`,
`profile_trust`). Advisor to hlásí jako INFO a nechává se to být.

`security_definer_view` u `feed_drawings` je taky záměr — pohled musí obejít RLS
nad `drawings`, jinak nevrátí nikdy nic. Hlídá to test na seznam sloupců, ne komentář.

## Které nálezy advisoru jsou trvalý záměr

Po krocích C1/C2 hlásí advisor tyhle věci a **žádná se neopravuje**:

| Nález | Proč je to v pořádku |
|---|---|
| `rls_enabled_no_policy` u `concepts`, `concept_locales`, `concept_answers`, `profile_trust`, `invites`, `invite_redemptions` | Default deny je u tajných tabulek účel, ne opomenutí |
| `security_definer_view` u `feed_drawings` | Musí obejít RLS nad `drawings`, jinak nevrátí nic. Hlídá to test na seznam sloupců |
| `authenticated … execute` u `offer_concepts`, `start_drawing`, `submit_drawing` | **Tohle JE API hry.** Klient je volat musí — jsou to jediné dveře k datům, ke kterým nemá přímý přístup |
| `anon … execute` u `display_name_available` | Volá se při registraci, kdy uživatel ještě přihlášený není |

Rozdíl proti `private.*` funkcím: ty jsou stavební kameny politik a klient je volat
nemá. Tyhle jsou naopak rozhraní. **Kritérium: volá to prohlížeč záměrně?**
Ano → `public`. Ne → `private`.

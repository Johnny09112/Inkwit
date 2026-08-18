---
name: supabase-chyby-podle-kodu
description: Chyby ze Supabase Auth mapovat podle err.code, ne podle textu; zamítnutá pozvánka z triggeru dorazí jako 23514 a fallback nesmí svalovat všechno na pozvánku
type: pattern
status: active
created: 2026-08-18
updated: 2026-08-18
related: [rls-pomocne-funkce-mimo-public]
---

# Chyby Supabase Auth: rozhoduje `code`, ne text

Zjištěno 2026-08-18 při kroku C0, když přihlašovací obrazovka poslala uživatele
špatným směrem.

## Co se stalo

Napsal jsem mapování chyb podle podřetězců v anglické hlášce a jako fallback
dal „kód pozvánky neplatí" — s odůvodněním, že nic jiného při registraci selhat
nemůže. Při prvním testu appka tvrdila, že kód neplatí, **přestože platil**.
Skutečná příčina: Supabase odmítá `example.com` jako neplatnou adresu
(`email_address_invalid`).

**Poučení není „udělal jsem překlep", ale že takový fallback aktivně škodí.**
Obecná chyba se tváří jako konkrétní diagnóza a člověk pak hledá problém tam,
kde není.

## Jak to dělat

Přepínat podle `err.code` z `AuthError`, ne podle textu — texty se mění mezi
verzemi. Užitečné kódy: `email_address_invalid`, `user_already_exists`,
`weak_password`, `invalid_credentials`, `email_not_confirmed`,
`over_request_rate_limit`, `signup_disabled`.

**Default musí být neutrální hláška**, ne nejpravděpodobnější tip.

## Kód z databázového triggeru projde až do klienta

Trigger, který odmítá registraci, může poslat vlastní errcode:

```sql
raise exception 'Pozvánka neplatí.' using errcode = 'check_violation';
```

GoTrue ho propustí jako `error_code: "23514"` a klient ho vidí v `err.code`.
Ověřeno proti ostrému projektu (HTTP 500, `23514`). Je to **spolehlivější signál
než `unexpected_failure`** — dá se podle něj rozeznat právě zamítnutá pozvánka
od jiné chyby zápisu.

Konkrétní text hlášky z `raise` se ale cestou ztratí, takže překlad musí být
na straně klienta.

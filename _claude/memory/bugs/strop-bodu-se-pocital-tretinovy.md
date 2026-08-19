---
name: strop-bodu-se-pocital-tretinovy
description: submit_drawing porovnávala délku plochého pole se stropem počtu bodů, takže platil limit 20 000 místo 60 000; na 120Hz tabletu se dal potkat a odeslání skončilo obecným "nepovedlo se"
type: bug
status: resolved
created: 2026-08-19
updated: 2026-08-19
related: [kodovani-bodu-tahu]
---

# Strop bodů platil třetinový

**Nalezeno 2026-08-19** při hledání příčiny toho, proč majiteli nešlo uložit
kresbu na iPadu Pro 11".

```sql
select coalesce(sum(jsonb_array_length(x -> 'points')), 0) / 3 into v_points ...
if v_points * 3 > v_max_points then          -- ← v_points UŽ JSOU body
```

Body se spočítaly správně (ploché pole má tři čísla na bod), ale výraz je pak
znovu vynásobil třemi. Proti stropu se tak porovnávala **délka pole**, ne počet
bodů, a skutečný limit byl **20 000 bodů** místo 60 000, které má klíč
`max_points_per_drawing` i jeho popis („Při 1500 bodech u běžné kresby je to
čtyřicetinásobná rezerva").

## Proč to nikdo nechytil dřív

Největší dosud odeslaná kresba má **6 204 bodů**, tedy 31 % toho nechtěného
stropu. Na telefonu se hranice nedala potkat. Na tabletu ano: větší plátno
a displej se 120 Hz dávají zhruba dvojnásobek bodů na stejný tah.

**Testy to nepokrývaly vůbec** — na strop nebyl jediný test. Teď jsou tři:
těsně pod stropem projde, nad stropem se odmítne, a třetina stropu se už
neodmítá.

## Past při psaní toho testu

Test běžel uvnitř už otevřené transakce a použil `begin`/`rollback`. Vnořený
`begin` Postgres ignoruje, takže `rollback` zrušil práci **předchozích** kroků
a rozbil test o dva dál („tahy se uložily → 0"). Uvnitř transakce se musí
používat `savepoint` / `rollback to savepoint`.

## Co z toho ještě vzešlo

Odmítnutí serveru se v aplikaci schovávalo za jednu obecnou hlášku
„Odeslání se nepovedlo. Zkus to znovu." U trvalé příčiny to člověka nechá zkoušet
donekonečna a nahlásí jen „nejde uložit". `submitDrawing()` teď vrací
`SubmitError` s důvodem a obrazovka řekne konkrétně, co je špatně.

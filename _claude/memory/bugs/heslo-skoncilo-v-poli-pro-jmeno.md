---
name: heslo-skoncilo-v-poli-pro-jmeno
description: Účet měl jako veřejnou přezdívku vlastní heslo; kód ho tam nedal, přišlo z formuláře — pole pro jméno leželo hned za heslem a e-mail neměl kotvu username
type: bug
status: resolved
created: 2026-08-20
updated: 2026-08-20
---

# Heslo skončilo v poli pro jméno

Nahlásil majitel 2026-08-20: *„uložil se mi další testovací účet se jménem jako
heslo, ale nevím, jestli to není moje chyba."*

## Co bylo potvrzené

**Jméno bylo doopravdy heslo toho účtu.** Ověřeno porovnáním proti hashi
v `auth.users` — u jednoho ze čtyř účtů `true`, u ostatních `false`:

```sql
select u.encrypted_password = extensions.crypt(p.display_name, u.encrypted_password)
from auth.users u join public.profiles p on p.id = u.id;
```

**Tenhle dotaz je použitelný znovu**, kdyby to někdo nahlásil po pozvánkách.
Neodhalí žádné heslo — jen potvrdí nebo vyvrátí kandidáta, který už veřejně
sedí v `display_name`.

## Kde chyba NEBYLA

- **Ne na serveru.** Hodnota byla v `raw_user_meta_data` už při `signUp()`,
  takže dorazila z prohlížeče hotová.
- **Ne v kódu.** V `LoginForm` teče do `display_name` výhradně `trimmedName`;
  `password` je nezávislý stav. Kdyby kód heslo kopíroval, potkalo by to
  všechny účty — ostatní tři měly normální jména.

## Kořen: příčinu nešlo zjistit, a to je samo o sobě zjištění

Vložil ho tam člověk, nebo správce hesel? **To se zpětně určit nedá** a majitel
si nevzpomněl. Formulář ale té záměně vycházel vstříc dvěma způsoby:

1. **Pole „jméno" leželo hned za heslem** — tedy přesně tam, kde správci hesel
   hledají „heslo znovu".
2. **E-mail měl `autocomplete="email"`, ne `username`.** Bez kotvy `username`
   si správce uživatelské jméno hledá sám, a bere ho z pole, které mu přijde
   nejbližší.

## Oprava — tři vrstvy

1. **Pojistka `nameMatchesPassword()`** (`lib/auth.ts`): shodné jméno a heslo
   neprojde. Porovnává bez okrajových mezer a bez ohledu na velikost písmen.
   **Žádná heuristika „vypadá to jako heslo"** — `Johnny09112` je skutečná
   přezdívka majitele a falešný poplach na registraci je horší než ta nehoda,
   protože ho uvidí každý. Šest unit testů, většina na to, co projít MUSÍ.
2. **Heslo je poslední pole formuláře.** Za ním už není žádný textový vstup,
   takže není co splést. V přihlášení se pořadí nemění — jméno ani kód se tam
   nevykreslují.
3. **E-mail má `autocomplete="username"`.**

## Proč pojistka není na serveru

GoTrue heslo zahašuje dřív, než ho uvidí jakýkoli trigger, takže porovnání
potřebuje bcrypt, tedy `pgcrypto`. **PGlite ho nemá** (ověřeno) a testy databáze
na něm stojí — kód, který v produkci běží a v testech ne, je přesně to, čemu se
projekt vyhnul už u porovnávání odpovědí (`20260819040000_matching.sql`).

A hlavně **tady není proti komu se bránit**: kdo si zámek obejde a dá si jméno
shodné s vlastním heslem, uškodí jen sobě. Pravidlo „klientu se nevěří nic"
míří na herní stav, kde se podvodem něco získává. Tohle je nehoda, ne útok.

## Úklid

Účet smazán na pokyn majitele (jediná kresba byla `draft`, nikdy nepublikovaná,
takže jméno nikdo jiný neviděl). **Pozvánka `INK-Y9Q9HX` vrácena do oběhu** —
`used_count` zpátky na 0. Mazání účtu totiž smaže řádek v `invite_redemptions`
kaskádou, ale `used_count` v `invites` nechá být, takže by se kód spálil.
Až se bude mazat další testovací účet, počítat s tím.

Heslo si majitel měnil sám — hesla nezadávám ani neměním.

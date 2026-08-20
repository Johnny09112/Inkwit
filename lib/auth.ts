/**
 * Pomocné kontroly registračního formuláře.
 *
 * Proč to není na serveru: GoTrue heslo zahašuje dřív, než ho uvidí jakýkoli
 * trigger, takže porovnání se jménem potřebuje bcrypt — tedy `pgcrypto`.
 * To v PGlite není a testy databáze na něm stojí; stejný důvod, proč se
 * porovnávání odpovědí obešlo bez `unaccent` (viz `20260819040000_matching.sql`).
 * Kód, který v produkci běží a v testech ne, je v tomhle projektu horší než
 * kontrola o patro níž.
 *
 * A hlavně: tady není proti komu se bránit. Kdo si zámek obejde a dá si jméno
 * shodné s vlastním heslem, uškodí jen sobě. Pravidlo „klientu se nevěří nic"
 * míří na herní stav, kde se podvodem něco získává.
 */

/**
 * Shoduje se jméno s heslem?
 *
 * Vzniklo z reálného případu (2026-08-20): v poli pro jméno skončilo heslo účtu
 * a uložilo se jako veřejná přezdívka. Nešlo poznat, jestli ho tam vložil člověk,
 * nebo správce hesel — pole „jméno" leželo hned za heslem, tedy přesně tam, kde
 * správci čekají „heslo znovu".
 *
 * Porovnává se bez okrajových mezer a bez ohledu na velikost písmen: vložené
 * heslo s mezerou navíc je pořád vložené heslo. **Žádná heuristika typu
 * „vypadá to jako heslo"** — `Johnny09112` je legitimní přezdívka a falešný
 * poplach by lidi učil klikat přes varování.
 */
export function nameMatchesPassword(name: string, password: string): boolean {
  const a = name.trim();
  const b = password.trim();
  if (a === "" || b === "") return false;
  return a.toLowerCase() === b.toLowerCase();
}

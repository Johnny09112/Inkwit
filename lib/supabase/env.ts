/**
 * Čtení konfigurace Supabase.
 *
 * Bez téhle kontroly by chybějící proměnná skončila bílou obrazovkou a
 * hláškou o `undefined` někde uvnitř knihovny — tedy přesně tím druhem
 * chyby, kterou nejde přečíst. Nejčastější příčina je, že se proměnná
 * nastavila ve Vercelu až po posledním nasazení: hodnoty s předponou
 * NEXT_PUBLIC_ se zapékají při buildu, ne načítají za běhu.
 */

function required(name: string, value: string | undefined): string {
  if (!value) {
    throw new Error(
      `Chybí proměnná prostředí ${name}. Lokálně patří do .env.local, ` +
        `na Vercelu do Settings → Environment Variables. Po jejím přidání ` +
        `je nutné znovu nasadit — hodnoty NEXT_PUBLIC_ se zapékají při buildu.`,
    );
  }
  return value;
}

export const SUPABASE_URL = () =>
  required("NEXT_PUBLIC_SUPABASE_URL", process.env.NEXT_PUBLIC_SUPABASE_URL);

export const SUPABASE_KEY = () =>
  required(
    "NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY",
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
  );

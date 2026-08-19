import { createServerClient } from "@supabase/ssr";
import { SUPABASE_KEY, SUPABASE_URL } from "@/lib/supabase/env";
import { cookies } from "next/headers";

/**
 * Supabase klient na serveru. Jede pod přihlášeným uživatelem, tedy pořád
 * pod RLS — servisní klíč, který pravidla obchází, se tu vědomě nepoužívá.
 */
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    SUPABASE_URL(),
    SUPABASE_KEY(),
    {
      cookies: {
        getAll: () => cookieStore.getAll(),
        setAll: (cookiesToSet) => {
          try {
            for (const { name, value, options } of cookiesToSet) {
              cookieStore.set(name, value, options);
            }
          } catch {
            // Volání ze Server Componenty — cookies se nastavit nedají.
            // Session obnovuje middleware, takže se tím nic neztratí.
          }
        },
      },
    },
  );
}

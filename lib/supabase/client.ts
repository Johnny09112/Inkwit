import { createBrowserClient } from "@supabase/ssr";
import { SUPABASE_KEY, SUPABASE_URL } from "@/lib/supabase/env";

/** Supabase klient v prohlížeči. Vidí jen to, co pustí RLS. */
export function createClient() {
  return createBrowserClient(
    SUPABASE_URL(),
    SUPABASE_KEY(),
  );
}

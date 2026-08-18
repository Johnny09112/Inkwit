import { createBrowserClient } from "@supabase/ssr";

/** Supabase klient v prohlížeči. Vidí jen to, co pustí RLS. */
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
  );
}

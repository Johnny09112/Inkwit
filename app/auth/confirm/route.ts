import { type EmailOtpType } from "@supabase/supabase-js";
import { redirect } from "next/navigation";
import { type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";

/**
 * Přistání odkazu z e-mailu (obnova hesla).
 *
 * Zvládá dvě podoby odkazu:
 *
 *   `code`       — co posílá VÝCHOZÍ šablona Supabase. Kód je přes PKCE svázaný
 *                  s prohlížečem, ve kterém žádost vznikla, takže e-mail je
 *                  potřeba otevřít na stejném zařízení. Uživateli to říkáme
 *                  rovnou při odeslání.
 *   `token_hash` — co umí vlastní šablona. Funguje odkudkoliv, ale vlastní
 *                  šablony nejdou na free plánu s výchozím odesílatelem
 *                  (`supabase/templates/recovery.html` na to čeká).
 *
 * Obojí je tu proto, aby přechod na vlastní SMTP nevyžadoval zásah do kódu.
 */
export async function GET(request: NextRequest) {
  const params = request.nextUrl.searchParams;
  const supabase = await createClient();

  const tokenHash = params.get("token_hash");
  const type = params.get("type") as EmailOtpType | null;
  const code = params.get("code");

  if (tokenHash && type) {
    const { error } = await supabase.auth.verifyOtp({ type, token_hash: tokenHash });
    if (!error) redirect("/reset");
  } else if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) redirect("/reset");
  }

  // Odkaz je jednorázový, má omezenou platnost a u PKCE i vazbu na prohlížeč.
  redirect("/login?chyba=odkaz");
}

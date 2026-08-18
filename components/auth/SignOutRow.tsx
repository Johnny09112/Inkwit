"use client";

import { LogOut } from "lucide-react";
import { useTranslations } from "next-intl";
import { useState } from "react";
import { useRouter } from "@/i18n/navigation";
import { createClient } from "@/lib/supabase/client";

/** Odhlášení. Sedí ve stejném seznamu jako ostatní nastavení profilu. */
export function SignOutRow() {
  const t = useTranslations("profile");
  const router = useRouter();
  const [busy, setBusy] = useState(false);

  return (
    <button
      type="button"
      className="settings-row"
      disabled={busy}
      onClick={async () => {
        setBusy(true);
        await createClient().auth.signOut();
        router.replace("/login");
        router.refresh();
      }}
    >
      <LogOut size={18} />
      <span className="settings-row-label">{t("signOut")}</span>
    </button>
  );
}

"use client";

import { AlertTriangle, Check, Loader2 } from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { InkwitLogo } from "@/components/InkwitLogo";
import { useRouter } from "@/i18n/navigation";
import { createClient } from "@/lib/supabase/client";

/**
 * Nastavení nového hesla po kliknutí na odkaz z e-mailu.
 *
 * Sem se člověk dostane přes `/auth/confirm`, které odkaz ověří a založí
 * sezení. Bez platného sezení tu není co dělat — odkaz vypršel nebo už byl
 * jednou použitý.
 */
export default function ResetPage() {
  const t = useTranslations("reset");
  const router = useRouter();

  const [ready, setReady] = useState<boolean | null>(null);
  const [password, setPassword] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState(false);

  useEffect(() => {
    createClient()
      .auth.getUser()
      .then(({ data }) => setReady(!!data.user));
  }, []);

  async function save(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    const { error: err } = await createClient().auth.updateUser({ password });
    setBusy(false);
    if (err) {
      setError(err.code === "weak_password" ? t("weak") : t("failed"));
      return;
    }
    setDone(true);
    setTimeout(() => router.replace("/"), 1500);
  }

  return (
    <main className="auth-screen">
      <div className="auth-card">
        <div className="auth-head">
          <span className="t-label">{t("eyebrow")}</span>
          <InkwitLogo fontSize={42} />
        </div>

        {ready === null && (
          <p className="pick-loading" style={{ justifyContent: "center" }}>
            <Loader2 size={18} className="spin" aria-hidden="true" /> {t("checking")}
          </p>
        )}

        {ready === false && (
          <div className="auth-panel">
            <p className="auth-note auth-note-error">
              <AlertTriangle size={17} aria-hidden="true" />
              <span>{t("expired")}</span>
            </p>
            <a href="/login" className="btn btn-primary btn-lg">
              {t("backToLogin")}
            </a>
          </div>
        )}

        {ready === true && (
          <form className="auth-panel" onSubmit={save}>
            <div className="auth-field">
              <label className="t-label" htmlFor="password">
                {t("newPassword")}
              </label>
              <input
                id="password"
                className="input"
                type="password"
                autoComplete="new-password"
                required
                minLength={6}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
              <span className="auth-hint">{t("hint")}</span>
            </div>

            {error && (
              <p className="auth-note auth-note-error" role="alert">
                <AlertTriangle size={17} aria-hidden="true" />
                <span>{error}</span>
              </p>
            )}

            {done && (
              <p className="auth-note auth-note-info" role="status">
                <Check size={17} aria-hidden="true" />
                <span>{t("done")}</span>
              </p>
            )}

            <button type="submit" className="btn btn-primary btn-lg" disabled={busy || done}>
              {busy && <Loader2 size={17} className="spin" aria-hidden="true" />}
              {t("save")}
            </button>
          </form>
        )}
      </div>
    </main>
  );
}

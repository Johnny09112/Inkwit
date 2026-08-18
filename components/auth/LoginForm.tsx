"use client";

import { AlertTriangle, Check, Loader2 } from "lucide-react";
import { useTranslations } from "next-intl";
import { useSearchParams } from "next/navigation";
import { useState } from "react";
import { useRouter } from "@/i18n/navigation";
import { createClient } from "@/lib/supabase/client";

type Mode = "signin" | "signup";

/** Kód se píše bez prefixu, ale vložený z e-mailu ho nejspíš obsahuje. */
function normalizeCode(raw: string): string {
  return raw.trim().toUpperCase().replace(/^INK-/, "").replace(/[^A-Z0-9]/g, "");
}

export function LoginForm() {
  const t = useTranslations("auth");
  const router = useRouter();
  const searchParams = useSearchParams();

  const [mode, setMode] = useState<Mode>("signin");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [code, setCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);

  /**
   * Supabase vrací chyby anglicky. Rozhoduje `code`, ne text hlášky — texty se
   * mění mezi verzemi a překlad podle podřetězce je křehký.
   *
   * Neplatná pozvánka se pozná spolehlivě: trigger ji odmítá přes
   * `raise ... using errcode = 'check_violation'` a GoTrue ten kód propustí
   * až sem jako `23514`. Ověřeno proti ostrému projektu.
   *
   * Svalovat na pozvánku VŠECHNO neznámé by byla chyba — pak dostane špatnou
   * radu i člověk, který má jen překlep v e-mailu. Proto má default vlastní,
   * neutrální hlášku.
   */
  function messageFor(
    err: { code?: string; message: string },
    forMode: Mode,
  ): string {
    switch (err.code) {
      case "email_address_invalid":
        return t("errors.emailInvalid");
      case "user_already_exists":
      case "email_exists":
        return t("errors.emailTaken");
      case "weak_password":
        return t("errors.weakPassword");
      case "invalid_credentials":
        return t("errors.badCredentials");
      case "email_not_confirmed":
        return t("errors.unconfirmed");
      case "over_request_rate_limit":
      case "over_email_send_rate_limit":
        return t("errors.tooMany");
      case "signup_disabled":
        return t("errors.signupsClosed");
      case "23514": // check_violation z private.enforce_invite()
      case "unexpected_failure":
        return forMode === "signup" ? t("errors.badInvite") : t("errors.generic");
      default:
        return t("errors.generic");
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setInfo(null);
    setBusy(true);

    const supabase = createClient();
    const next = searchParams.get("dal");
    const target = next && next.startsWith("/") ? next : "/";

    try {
      if (mode === "signup") {
        const cleaned = normalizeCode(code);
        if (!cleaned) {
          setError(t("errors.missingInvite"));
          return;
        }

        const { data, error: err } = await supabase.auth.signUp({
          email: email.trim(),
          password,
          options: { data: { invite_code: `INK-${cleaned}` } },
        });

        if (err) {
          setError(messageFor(err, "signup"));
          return;
        }
        // Když je v projektu zapnuté potvrzování e-mailu, session nevznikne hned.
        if (!data.session) {
          setInfo(t("confirmEmail"));
          return;
        }
      } else {
        const { error: err } = await supabase.auth.signInWithPassword({
          email: email.trim(),
          password,
        });
        if (err) {
          setError(messageFor(err, "signin"));
          return;
        }
      }

      router.replace(target);
      router.refresh();
    } finally {
      setBusy(false);
    }
  }

  return (
    <form className="auth-panel" onSubmit={handleSubmit}>
      <div className="auth-modes" role="group" aria-label={t("modeLabel")}>
        <button
          type="button"
          className="lb-tab"
          aria-pressed={mode === "signin"}
          onClick={() => {
            setMode("signin");
            setError(null);
            setInfo(null);
          }}
        >
          {t("modes.signin")}
        </button>
        <button
          type="button"
          className="lb-tab"
          aria-pressed={mode === "signup"}
          onClick={() => {
            setMode("signup");
            setError(null);
            setInfo(null);
          }}
        >
          {t("modes.signup")}
        </button>
      </div>

      <div className="auth-fields">
        <div className="auth-field">
          <label className="t-label" htmlFor="email">
            {t("fields.email")}
          </label>
          <input
            id="email"
            className="input"
            type="email"
            autoComplete="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>

        <div className="auth-field">
          <label className="t-label" htmlFor="password">
            {t("fields.password")}
          </label>
          <input
            id="password"
            className="input"
            type="password"
            autoComplete={mode === "signup" ? "new-password" : "current-password"}
            required
            minLength={6}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>

        {mode === "signup" && (
          <div className="auth-field">
            <label className="t-label" htmlFor="code">
              {t("fields.code")}
            </label>
            <div className="auth-code">
              <span className="auth-code-prefix" aria-hidden="true">
                INK-
              </span>
              <input
                id="code"
                type="text"
                inputMode="text"
                autoComplete="off"
                spellCheck={false}
                required
                maxLength={12}
                placeholder="XXXXXX"
                aria-describedby="code-hint"
                value={code}
                onChange={(e) => setCode(e.target.value)}
              />
            </div>
            <span id="code-hint" className="auth-foot" style={{ textAlign: "left" }}>
              {t("fields.codeHint")}
            </span>
          </div>
        )}
      </div>

      {error && (
        <p className="auth-note auth-note-error" role="alert">
          <AlertTriangle size={17} aria-hidden="true" />
          <span>{error}</span>
        </p>
      )}

      {info && (
        <p className="auth-note auth-note-info" role="status">
          <Check size={17} aria-hidden="true" />
          <span>{info}</span>
        </p>
      )}

      <button type="submit" className="btn btn-primary btn-lg" disabled={busy}>
        {busy && <Loader2 size={17} className="spin" aria-hidden="true" />}
        {mode === "signup" ? t("actions.signup") : t("actions.signin")}
      </button>
    </form>
  );
}

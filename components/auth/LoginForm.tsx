"use client";

import { AlertTriangle, Check, Loader2, X } from "lucide-react";
import { useTranslations } from "next-intl";
import { useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import { useRouter } from "@/i18n/navigation";
import { nameMatchesPassword } from "@/lib/auth";
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
  const [name, setName] = useState("");
  const [code, setCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);

  /**
   * Obnova hesla. Odkaz míří na /auth/confirm, které ho ověří a pustí dál
   * na /reset — ne rovnou na /reset, protože ten odkaz je jednorázový token
   * a musí ho někdo uplatnit.
   */
  async function forgotPassword() {
    if (!email.trim()) {
      setError(t("errors.needEmail"));
      return;
    }
    setBusy(true);
    setError(null);
    setInfo(null);
    const { error: err } = await createClient().auth.resetPasswordForEmail(email.trim(), {
      redirectTo: `${window.location.origin}/auth/confirm?type=recovery`,
    });
    setBusy(false);
    if (err) {
      setError(err.code === "over_email_send_rate_limit" ? t("errors.tooMany") : t("errors.generic"));
      return;
    }
    setInfo(t("resetSent"));
  }

  const trimmedName = name.trim();
  const nameLongEnough = trimmedName.length >= 3;
  /**
   * Heslo v poli pro jméno. Stalo se to doopravdy (2026-08-20) a nešlo zjistit,
   * jestli ho tam vložil člověk, nebo správce hesel — proto se to hlídá, ať už
   * je příčina jakákoli. Jméno vidí ostatní hráči, heslo do něj nepatří.
   */
  const nameIsPassword = nameMatchesPassword(name, password);
  const [nameTaken, setNameTaken] = useState<boolean | null>(null);
  const [checkingName, setCheckingName] = useState(false);

  /**
   * Jestli je jméno volné, se ptáme během psaní — dozvědět se to až po
   * odeslání je zbytečně pozdě. Unikátnost stejně vynucuje databáze; tohle je
   * jen laskavost, ne kontrola.
   */
  useEffect(() => {
    if (mode !== "signup" || !nameLongEnough) {
      setNameTaken(null);
      return;
    }
    setCheckingName(true);
    const timer = setTimeout(async () => {
      const { data, error: err } = await createClient().rpc("display_name_available", {
        p_name: trimmedName,
      });
      setNameTaken(err ? null : data === false);
      setCheckingName(false);
    }, 400);

    return () => {
      clearTimeout(timer);
      setCheckingName(false);
    };
  }, [trimmedName, nameLongEnough, mode]);

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
      case "23505": // unique_violation — jméno v profilu už někdo má
        return t("errors.nameTaken");
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
        if (nameIsPassword) {
          setError(t("errors.nameIsPassword"));
          return;
        }

        const { data, error: err } = await supabase.auth.signUp({
          email: email.trim(),
          password,
          options: {
            data: { invite_code: `INK-${cleaned}`, display_name: trimmedName },
          },
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
            autoComplete="username"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>

        {mode === "signup" && (
          <div className="auth-field">
            <label className="t-label" htmlFor="name">
              {t("fields.name")}
            </label>
            <input
              id="name"
              className="input"
              type="text"
              autoComplete="nickname"
              required
              minLength={3}
              maxLength={24}
              aria-describedby="name-hint"
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
            <span id="name-hint" className="auth-hint" aria-live="polite">
              {nameIsPassword && (
                <span className="auth-hint-taken">
                  <X size={13} aria-hidden="true" /> {t("fields.nameIsPassword")}
                </span>
              )}
              {!nameIsPassword && !nameLongEnough && t("fields.nameHint")}
              {!nameIsPassword && nameLongEnough && checkingName && t("fields.nameChecking")}
              {!nameIsPassword && nameLongEnough && !checkingName && nameTaken === true && (
                <span className="auth-hint-taken">
                  <X size={13} aria-hidden="true" /> {t("fields.nameTaken")}
                </span>
              )}
              {!nameIsPassword && nameLongEnough && !checkingName && nameTaken === false && (
                <span className="auth-hint-free">
                  <Check size={13} aria-hidden="true" /> {t("fields.nameFree")}
                </span>
              )}
            </span>
          </div>
        )}

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
            <span id="code-hint" className="auth-hint">
              {t("fields.codeHint")}
            </span>
          </div>
        )}
        {/* Heslo je schválně POSLEDNÍ pole.
            Do 2026-08-20 leželo mezi e-mailem a jménem, tedy přesně tam, po čem
            správci hesel hledají „heslo znovu" — a v jednom případě skončilo
            heslo v poli pro jméno. Za heslem už teď žádné textové pole není,
            takže není co splést. V přihlášení se pořadí nemění: tam se jméno
            ani kód nevykreslují. */}
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

      <button
        type="submit"
        className="btn btn-primary btn-lg"
        disabled={busy || (mode === "signup" && (nameTaken === true || nameIsPassword))}
      >
        {busy && <Loader2 size={17} className="spin" aria-hidden="true" />}
        {mode === "signup" ? t("actions.signup") : t("actions.signin")}
      </button>

      {mode === "signin" && (
        <button type="button" className="btn btn-ghost btn-sm" onClick={forgotPassword} disabled={busy}>
          {t("actions.forgot")}
        </button>
      )}
    </form>
  );
}

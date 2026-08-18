import { getTranslations } from "next-intl/server";
import { Suspense } from "react";
import { LoginForm } from "@/components/auth/LoginForm";

export default async function LoginPage() {
  const t = await getTranslations("auth");

  return (
    <main className="auth-screen">
      <div className="auth-card">
        <div className="auth-head">
          <span className="t-label">{t("eyebrow")}</span>
          <span className="auth-logo">Inkwit</span>
          <p className="auth-lede">{t("lede")}</p>
        </div>

        <Suspense fallback={null}>
          <LoginForm />
        </Suspense>

        <p className="auth-foot">{t("noInvite")}</p>
      </div>
    </main>
  );
}

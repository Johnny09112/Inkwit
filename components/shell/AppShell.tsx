"use client";

import type { ReactNode } from "react";
import { useTranslations } from "next-intl";
import {
  CircleUserRound,
  Images,
  Lightbulb,
  Pencil,
  Trophy,
} from "lucide-react";
import { Link, usePathname } from "@/i18n/navigation";

/**
 * Společná kostra obrazovek mimo plátno: mobil = velký titulek + spodní
 * tab bar, tablet/desktop = logo + mono navigace v hlavičce (wireframy,
 * sekce Desktop/Tablet). Plátno kreslení shell nepoužívá.
 */

const TABS = [
  { href: "/pick", key: "draw", icon: Pencil },
  { href: "/guess", key: "guess", icon: Lightbulb },
  { href: "/mine", key: "mine", icon: Images },
  { href: "/leaderboards", key: "leaderboards", icon: Trophy },
] as const;

function isActive(pathname: string, href: string): boolean {
  if (href === "/pick") {
    // Kreslicí větev: výběr pojmu i samotné plátno
    return pathname.startsWith("/pick") || pathname.startsWith("/draw");
  }
  return pathname.startsWith(href);
}

interface AppShellProps {
  title: string;
  /** Mono meta vpravo v hlavičce (např. „Zásoba 38"). */
  meta?: ReactNode;
  /** Nahrazuje ikonu profilu vpravo (profil sám ji nepotřebuje). */
  headerAction?: ReactNode;
  children: ReactNode;
}

export function AppShell({ title, meta, headerAction, children }: AppShellProps) {
  const t = useTranslations("nav");
  const tApp = useTranslations("app");
  const pathname = usePathname();

  return (
    <div className="shell">
      <header className="shell-header">
        <div className="shell-header-side">
          <span className="only-mobile">
            <h1 className="shell-title">{title}</h1>
          </span>
          <span className="only-wide">
            <span className="shell-logo">{tApp("name")}</span>
          </span>
          <nav className="shell-nav" aria-label={tApp("name")}>
            {TABS.map(({ href, key }) => (
              <Link
                key={key}
                href={href}
                className={isActive(pathname, href) ? "is-active" : undefined}
              >
                {t(key)}
              </Link>
            ))}
          </nav>
        </div>
        <div className="shell-header-side">
          {meta}
          {headerAction ?? (
            <Link
              href="/profile"
              aria-label={t("profile")}
              className="icon-btn icon-btn-plain"
              style={{ width: 34, height: 34 }}
            >
              <CircleUserRound size={22} />
            </Link>
          )}
        </div>
      </header>

      <main className="shell-main">{children}</main>

      <nav className="tabbar" aria-label={tApp("name")}>
        {TABS.map(({ href, key, icon: Icon }) => (
          <Link
            key={key}
            href={href}
            className={isActive(pathname, href) ? "is-active" : undefined}
          >
            <Icon size={20} />
            <span>{t(key)}</span>
          </Link>
        ))}
      </nav>
    </div>
  );
}

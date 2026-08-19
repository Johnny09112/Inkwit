import { createServerClient } from "@supabase/ssr";
import { SUPABASE_KEY, SUPABASE_URL } from "@/lib/supabase/env";
import createMiddleware from "next-intl/middleware";
import { NextResponse, type NextRequest } from "next/server";
import { routing } from "./i18n/routing";

const handleI18n = createMiddleware(routing);

/** Cesty dostupné bez přihlášení. Všechno ostatní je herní obrazovka. */
const PUBLIC_PATHS = ["/login"];

/** Odřízne prefix jazyka, ať se cesty porovnávají v jednom tvaru. */
function withoutLocale(pathname: string): string {
  for (const locale of routing.locales) {
    if (pathname === `/${locale}`) return "/";
    if (pathname.startsWith(`/${locale}/`)) return pathname.slice(locale.length + 1);
  }
  return pathname;
}

/** Přilepí prefix jazyka zpátky. Čeština ho podle routingu nemá. */
function withLocale(path: string, pathname: string): string {
  for (const locale of routing.locales) {
    if (pathname === `/${locale}` || pathname.startsWith(`/${locale}/`)) {
      return locale === routing.defaultLocale ? path : `/${locale}${path}`;
    }
  }
  return path;
}

export default async function middleware(request: NextRequest) {
  // next-intl řeší jazyk a musí běžet první — jeho odpověď pak nese cookies,
  // do které Supabase zapisuje obnovenou session.
  const response = handleI18n(request);

  const supabase = createServerClient(
    SUPABASE_URL(),
    SUPABASE_KEY(),
    {
      cookies: {
        getAll: () => request.cookies.getAll(),
        setAll: (cookiesToSet) => {
          for (const { name, value, options } of cookiesToSet) {
            response.cookies.set(name, value, options);
          }
        },
      },
    },
  );

  // getUser(), ne getSession() — ověřuje token u serveru, takže se nedá
  // podvrhnout upravenou cookie.
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const path = withoutLocale(request.nextUrl.pathname);
  const isPublic = PUBLIC_PATHS.some((p) => path === p || path.startsWith(`${p}/`));

  if (!user && !isPublic) {
    const url = request.nextUrl.clone();
    url.pathname = withLocale("/login", request.nextUrl.pathname);
    // Kam se vrátit po přihlášení. Jen cesta v rámci aplikace, nikdy cizí adresa.
    if (path !== "/") url.searchParams.set("dal", path);
    return NextResponse.redirect(url);
  }

  if (user && isPublic) {
    const url = request.nextUrl.clone();
    url.pathname = withLocale("/", request.nextUrl.pathname);
    url.search = "";
    return NextResponse.redirect(url);
  }

  return response;
}

export const config = {
  // Vše kromě api, Next interních cest a souborů s příponou.
  // Pozor: tečka jako [.] — path-to-regexp v Next zbaští zpětné lomítko
  // z \. a lookahead by pak odmítl každou cestu delší než jeden znak.
  matcher: "/((?!api|_next|_vercel|.*[.].*).*)",
};

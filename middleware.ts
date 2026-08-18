import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";

export default createMiddleware(routing);

export const config = {
  // Vše kromě api, Next interních cest a souborů s příponou.
  // Pozor: tečka jako [.] — path-to-regexp v Next zbaští zpětné lomítko
  // z \. a lookahead by pak odmítl každou cestu delší než jeden znak.
  matcher: "/((?!api|_next|_vercel|.*[.].*).*)",
};

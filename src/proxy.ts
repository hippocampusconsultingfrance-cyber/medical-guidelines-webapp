import { type NextRequest } from "next/server";
import { cspPages } from "@/lib/csp";
import { updateSession } from "@/lib/supabase/middleware";

// Pages publiques mises en cache (identiques pour tous les visiteurs) : elles
// gardent la politique de sécurité de base (next.config.ts), sans jeton par
// requête, qui empêcherait toute mise en cache. Elles n'affichent ni
// formulaire ni donnée d'un membre. Toutes les autres pages (compte,
// connexion, inscription, bibliothèque, formulaires…) reçoivent la CSP
// stricte par jeton (src/lib/csp.ts).
const PAGES_EN_CACHE = ["/corrections", "/demarche", "/partenaires", "/cgu", "/cgv", "/confidentialite", "/mentions-legales"];

function enCache(pathname: string) {
  return (
    pathname === "/" ||
    pathname === "/recommandations" ||
    pathname.startsWith("/recommandations/") ||
    PAGES_EN_CACHE.includes(pathname)
  );
}

// Cookie de session Supabase (sb-…-auth-token, éventuellement découpé).
function aUneSession(request: NextRequest) {
  return request.cookies.getAll().some((c) => /^sb-.+-auth-token(\.\d+)?$/.test(c.name));
}

export async function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;
  // Accueil d'un membre connecté : son espace, servi à la même adresse.
  const espace = pathname === "/" && aUneSession(request);

  if (enCache(pathname) && !espace) {
    return updateSession(request);
  }

  // Jeton aléatoire par requête pour la CSP stricte, transmis au rendu par
  // l'en-tête de requête : Next.js l'applique à ses propres scripts.
  const nonce = Buffer.from(crypto.randomUUID()).toString("base64");
  const csp = cspPages(nonce);
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set("x-nonce", nonce);
  requestHeaders.set("Content-Security-Policy", csp);
  const rewrite = espace ? new URL(`/espace${request.nextUrl.search}`, request.url) : undefined;
  const response = await updateSession(request, requestHeaders, rewrite);
  response.headers.set("Content-Security-Policy", csp);
  return response;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|robots.txt|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};

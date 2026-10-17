import { NextResponse, type NextRequest } from "next/server";
import { cspPages } from "@/lib/csp";
import { COOKIE_LANGUE, LANGUE_DEFAUT, chemin, decouper, estOuverte, type Langue } from "@/lib/langues";
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

// Adresses qui ne sont pas des pages (pas de langue) : API, fichiers,
// manifeste, icônes.
function horsPages(pathname: string) {
  return (
    pathname.startsWith("/api/") ||
    pathname.startsWith("/_next/") ||
    pathname.startsWith("/_vercel/") ||
    pathname.startsWith("/icones/") ||
    pathname.startsWith("/.well-known/") ||
    pathname === "/icon.svg" ||
    pathname === "/robots.txt" ||
    pathname === "/sitemap.xml" ||
    pathname === "/manifest.webmanifest"
  );
}

// Cookie de session Supabase (sb-…-auth-token, éventuellement découpé).
function aUneSession(request: NextRequest) {
  return request.cookies.getAll().some((c) => /^sb-.+-auth-token(\.\d+)?$/.test(c.name));
}

export async function proxy(request: NextRequest) {
  const { pathname, search } = request.nextUrl;
  if (horsPages(pathname)) return updateSession(request);

  // Images de partage des pages (opengraph-image), publiques : servies par la
  // route de la langue (/fr/… pour le français), sans redirection.
  if (/\/opengraph-image(-\w+)?$/.test(pathname)) {
    const image = decouper(pathname);
    return image.langue ? NextResponse.next() : NextResponse.rewrite(new URL(`/${LANGUE_DEFAUT}${pathname}${search}`, request.url));
  }

  // Langue de la page (src/lib/langues.ts) : /fr/x redirige vers /x ; une
  // langue pas encore ouverte est traitée comme une adresse française
  // inconnue (404) ; une adresse française demandée par un visiteur qui a
  // choisi une autre langue l'y renvoie.
  const decoupe = decouper(pathname);
  let langue: Langue = LANGUE_DEFAUT;
  let reste = pathname;
  if (decoupe.langue === LANGUE_DEFAUT) {
    const url = request.nextUrl.clone();
    url.pathname = decoupe.reste;
    return NextResponse.redirect(url, 308);
  }
  if (decoupe.langue && estOuverte(decoupe.langue)) {
    langue = decoupe.langue;
    reste = decoupe.reste;
  } else if (!decoupe.langue) {
    const choisie = request.cookies.get(COOKIE_LANGUE)?.value;
    if (choisie !== LANGUE_DEFAUT && estOuverte(choisie)) {
      const url = request.nextUrl.clone();
      url.pathname = chemin(choisie, pathname);
      return NextResponse.redirect(url, 307);
    }
  }

  // Accueil d'un membre connecté : son espace, servi à la même adresse.
  const espace = reste === "/" && aUneSession(request);
  const cible = new URL(`/${langue}${espace ? "/espace" : reste === "/" ? "" : reste}${search}`, request.url);

  if (enCache(reste) && !espace) {
    return updateSession(request, request.headers, cible);
  }

  // Jeton aléatoire par requête pour la CSP stricte, transmis au rendu par
  // l'en-tête de requête : Next.js l'applique à ses propres scripts.
  const nonce = Buffer.from(crypto.randomUUID()).toString("base64");
  const csp = cspPages(nonce);
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set("x-nonce", nonce);
  requestHeaders.set("Content-Security-Policy", csp);
  const response = await updateSession(request, requestHeaders, cible);
  response.headers.set("Content-Security-Policy", csp);
  return response;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|robots.txt|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};

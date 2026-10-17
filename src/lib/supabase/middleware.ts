import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { LANGUE_DEFAUT, chemin, decouper, estOuverte } from "@/lib/langues";

// Premiers segments des pages et routes réservées aux membres connectés.
const ESPACES_MEMBRES = [
  "/abonnement",
  "/alertes",
  "/api",
  "/assistant",
  "/bibliotheque",
  "/compte",
  "/espace",
  "/mfa",
  "/nouveau-mot-de-passe",
  "/suggestions",
];

// requestHeaders : en-têtes transmis au rendu (jeton CSP de la page).
// rewrite : page servie à la place de l'adresse demandée (accueil d'un
// membre connecté, cf. src/proxy.ts).
export async function updateSession(request: NextRequest, requestHeaders: Headers = request.headers, rewrite?: URL) {
  const suite = () =>
    rewrite
      ? NextResponse.rewrite(rewrite, { request: { headers: requestHeaders } })
      : NextResponse.next({ request: { headers: requestHeaders } });
  let supabaseResponse = suite();

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value),
          );
          supabaseResponse = suite();
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options),
          );
        },
      },
    },
  );

  // Refreshes the auth token if needed — required for server components
  // to see a valid session. Do not remove.
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Adresse sans la langue (/en/compte → /compte, cf. src/lib/langues.ts).
  // Une langue pas encore ouverte est traitée comme une adresse française.
  const decoupe = decouper(request.nextUrl.pathname);
  const langue = estOuverte(decoupe.langue) ? decoupe.langue : LANGUE_DEFAUT;
  const pathname = estOuverte(decoupe.langue) ? decoupe.reste : request.nextUrl.pathname;
  const isAuthRoute =
    pathname.startsWith("/connexion") ||
    pathname.startsWith("/inscription") ||
    pathname.startsWith("/auth") ||
    pathname.startsWith("/verifiez-votre-email") ||
    pathname.startsWith("/finaliser-compte") ||
    pathname.startsWith("/cgu") ||
    pathname.startsWith("/confidentialite") ||
    pathname.startsWith("/mentions-legales") ||
    pathname.startsWith("/cgv") ||
    // Pages publiques de résumé des fiches (sans contenu premium).
    pathname.startsWith("/recommandations") ||
    // Journal public des corrections (date, fiche, criticité, résumé).
    pathname === "/corrections" ||
    // Démarche et financement du site (public).
    pathname === "/demarche" ||
    // Offre de partenariat aux sociétés savantes (public).
    pathname === "/partenaires" ||
    // Appel aux médecins relecteurs et formulaire de candidature (public).
    pathname === "/relecteurs" ||
    pathname === "/sitemap.xml" ||
    // Appelé par Stripe (sans session) ; authentifié par sa signature.
    pathname === "/api/stripe/webhook" ||
    // Page de santé de la surveillance (aucune donnée).
    pathname === "/api/sante" ||
    // Tâche planifiée Vercel ; authentifiée par CRON_SECRET.
    pathname.startsWith("/api/cron/") ||
    // Liens de désinscription des e-mails ; authentifiés par leur jeton.
    pathname === "/alertes/desinscription" ||
    pathname === "/api/alertes/desinscription" ||
    pathname.startsWith("/mot-de-passe-oublie");
  const isPublicAsset =
    pathname.startsWith("/_next") ||
    // Script et envoi de la mesure d'audience Vercel.
    pathname.startsWith("/_vercel") ||
    pathname.startsWith("/favicon") ||
    pathname === "/robots.txt" ||
    // Installation sur l'écran d'accueil (manifeste et icônes).
    pathname === "/manifest.webmanifest" ||
    pathname.startsWith("/icones/") ||
    // Image de partage du site (LinkedIn, messageries).
    pathname.startsWith("/opengraph-image") ||
    // Contact de sécurité (RFC 9116).
    pathname === "/.well-known/security.txt";

  // Espaces réservés aux membres : un visiteur y est renvoyé vers la connexion.
  // Toute autre adresse inconnue affiche la page 404 (src/app/[lang]/not-found.tsx)
  // au lieu d'une redirection, pour les visiteurs comme pour les moteurs.
  const isMemberArea = ESPACES_MEMBRES.some(
    (p) => pathname === p || pathname.startsWith(`${p}/`),
  );

  if (!user && isMemberArea && !isAuthRoute && !isPublicAsset) {
    const url = request.nextUrl.clone();
    url.pathname = chemin(langue, "/connexion");
    return NextResponse.redirect(url);
  }

  return supabaseResponse;
}

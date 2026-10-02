import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

// requestHeaders : en-têtes transmis au rendu (jeton CSP de la page).
export async function updateSession(request: NextRequest, requestHeaders: Headers = request.headers) {
  let supabaseResponse = NextResponse.next({ request: { headers: requestHeaders } });

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
          supabaseResponse = NextResponse.next({ request: { headers: requestHeaders } });
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

  const isAuthRoute =
    request.nextUrl.pathname.startsWith("/connexion") ||
    request.nextUrl.pathname.startsWith("/inscription") ||
    request.nextUrl.pathname.startsWith("/auth") ||
    request.nextUrl.pathname.startsWith("/verifiez-votre-email") ||
    request.nextUrl.pathname.startsWith("/finaliser-compte") ||
    request.nextUrl.pathname.startsWith("/cgu") ||
    request.nextUrl.pathname.startsWith("/confidentialite") ||
    request.nextUrl.pathname.startsWith("/mentions-legales") ||
    request.nextUrl.pathname.startsWith("/cgv") ||
    // Pages publiques de résumé des fiches (sans contenu premium).
    request.nextUrl.pathname.startsWith("/recommandations") ||
    // Journal public des corrections (date, fiche, criticité, résumé).
    request.nextUrl.pathname === "/corrections" ||
    // Démarche et financement du site (public).
    request.nextUrl.pathname === "/demarche" ||
    request.nextUrl.pathname === "/sitemap.xml" ||
    // Appelé par Stripe (sans session) ; authentifié par sa signature.
    request.nextUrl.pathname === "/api/stripe/webhook" ||
    // Page de santé de la surveillance (aucune donnée).
    request.nextUrl.pathname === "/api/sante" ||
    // Tâche planifiée Vercel ; authentifiée par CRON_SECRET.
    request.nextUrl.pathname.startsWith("/api/cron/") ||
    // Liens de désinscription des e-mails ; authentifiés par leur jeton.
    request.nextUrl.pathname === "/alertes/desinscription" ||
    request.nextUrl.pathname === "/api/alertes/desinscription" ||
    request.nextUrl.pathname.startsWith("/mot-de-passe-oublie");
  const isPublicAsset =
    request.nextUrl.pathname.startsWith("/_next") ||
    // Script et envoi de la mesure d'audience Vercel.
    request.nextUrl.pathname.startsWith("/_vercel") ||
    request.nextUrl.pathname.startsWith("/favicon") ||
    request.nextUrl.pathname === "/robots.txt" ||
    // Installation sur l'écran d'accueil (manifeste et icônes).
    request.nextUrl.pathname === "/manifest.webmanifest" ||
    request.nextUrl.pathname.startsWith("/icones/") ||
    // Image de partage du site (LinkedIn, messageries).
    request.nextUrl.pathname.startsWith("/opengraph-image") ||
    // Contact de sécurité (RFC 9116).
    request.nextUrl.pathname === "/.well-known/security.txt";

  if (!user && !isAuthRoute && !isPublicAsset && request.nextUrl.pathname !== "/") {
    const url = request.nextUrl.clone();
    url.pathname = "/connexion";
    return NextResponse.redirect(url);
  }

  return supabaseResponse;
}

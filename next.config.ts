import type { NextConfig } from "next";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
const supabaseWs = supabaseUrl.replace(/^https:/, "wss:");

// Politique de base, pour toutes les réponses (fichiers, API). Les pages
// reçoivent en plus une CSP stricte par jeton (src/proxy.ts, src/lib/csp.ts),
// qui s'ajoute à celle-ci : un script doit satisfaire les deux.
const contentSecurityPolicy = [
  "default-src 'self'",
  "script-src 'self' 'unsafe-inline'",
  "style-src 'self' 'unsafe-inline'",
  "font-src 'self'",
  "img-src 'self' data: blob:",
  // Envoi des erreurs à Sentry (région UE), cf. src/lib/sentry.ts.
  `connect-src 'self' ${supabaseUrl} ${supabaseWs} https://*.ingest.de.sentry.io`.trim(),
  "frame-ancestors 'none'",
  "form-action 'self'",
  "base-uri 'self'",
  "object-src 'none'",
].join("; ");

const nextConfig: NextConfig = {
  poweredByHeader: false,
  // Sentry n'envoie que les erreurs (tracesSampleRate 0, sans enregistrement
  // de session) : le code de suivi de performance, de rejeu et de débogage
  // est retiré du JavaScript envoyé au navigateur.
  compiler: {
    define: {
      __SENTRY_DEBUG__: false,
      __SENTRY_TRACING__: false,
      __RRWEB_EXCLUDE_IFRAME__: true,
      __RRWEB_EXCLUDE_SHADOW_DOM__: true,
      __SENTRY_EXCLUDE_REPLAY_WORKER__: true,
    },
  },
  // Justificatifs des médecins en formation (3 Mo max, cf. src/lib/etudiants.ts) :
  // la limite par défaut des actions serveur (1 Mo) est trop basse.
  experimental: { serverActions: { bodySizeLimit: "4mb" } },
  // Ancienne page des fiches (un seul fichier avec tout le contenu),
  // remplacée par la bibliothèque et ses crédits.
  // Icône demandée d'office par les navigateurs et les moteurs : le logo du
  // site en PNG (src/app/icones), servi à l'adresse classique.
  async rewrites() {
    return [{ source: "/favicon.ico", destination: "/icones/48.png" }];
  },
  async redirects() {
    return [{ source: "/fiches/:path*", destination: "/bibliotheque", permanent: false }];
  },
  async headers() {
    return [
      {
        source: "/:path*",
        headers: [
          { key: "Content-Security-Policy", value: contentSecurityPolicy },
          { key: "X-Frame-Options", value: "DENY" },
          { key: "Cross-Origin-Opener-Policy", value: "same-origin" },
          { key: "X-DNS-Prefetch-Control", value: "off" },
          { key: "X-Permitted-Cross-Domain-Policies", value: "none" },
          { key: "Origin-Agent-Cluster", value: "?1" },
          { key: "X-Content-Type-Options", value: "nosniff" },
          { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
          {
            key: "Permissions-Policy",
            value: "camera=(), microphone=(), geolocation=(), payment=()",
          },
          {
            key: "Strict-Transport-Security",
            value: "max-age=63072000; includeSubDomains; preload",
          },
        ],
      },
    ];
  },
};

export default nextConfig;

import type { NextConfig } from "next";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
const supabaseWs = supabaseUrl.replace(/^https:/, "wss:");

// Next.js injecte des scripts et des styles en ligne : d'où 'unsafe-inline'
// pour script-src/style-src. Les polices sont hébergées par le site.
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
  // Justificatifs des médecins en formation (3 Mo max, cf. src/lib/etudiants.ts) :
  // la limite par défaut des actions serveur (1 Mo) est trop basse.
  experimental: { serverActions: { bodySizeLimit: "4mb" } },
  // Ancienne page des fiches (un seul fichier avec tout le contenu),
  // remplacée par la bibliothèque et ses crédits.
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

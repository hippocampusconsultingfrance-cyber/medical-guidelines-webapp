// Politique de sécurité du contenu des pages (CSP stricte, par requête) :
// seuls les scripts portant le jeton (nonce) de la page, et ceux qu'ils
// chargent eux-mêmes ('strict-dynamic'), peuvent s'exécuter. Un script
// injecté dans le contenu (attaque XSS) ne s'exécute donc pas, même avec
// un attribut d'événement (onclick, onerror…). Les styles en ligne restent
// permis (attributs style des composants), sans risque d'exécution de code.
export function cspPages(nonce: string) {
  const supabase = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
  const dev = process.env.NODE_ENV === "development";
  return [
    "default-src 'self'",
    `script-src 'self' 'nonce-${nonce}' 'strict-dynamic'${dev ? " 'unsafe-eval'" : ""}`,
    "style-src 'self' 'unsafe-inline'",
    "font-src 'self'",
    "img-src 'self' data: blob:",
    `connect-src 'self' ${supabase} ${supabase.replace(/^https:/, "wss:")} https://*.ingest.de.sentry.io`,
    "frame-ancestors 'none'",
    "form-action 'self'",
    "base-uri 'none'",
    "object-src 'none'",
    ...(dev ? [] : ["upgrade-insecure-requests"]),
  ].join("; ");
}

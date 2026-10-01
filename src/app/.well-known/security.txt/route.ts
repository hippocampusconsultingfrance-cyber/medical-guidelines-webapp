// Signalement responsable des failles de sécurité (RFC 9116) :
// https://www.medical-guidelines.net/.well-known/security.txt
export function GET() {
  const expire = new Date(Date.now() + 365 * 24 * 3600 * 1000).toISOString();
  const texte = [
    "Contact: mailto:contact@medical-guidelines.net",
    `Expires: ${expire}`,
    "Preferred-Languages: fr, en",
    "Canonical: https://www.medical-guidelines.net/.well-known/security.txt",
    "Policy: https://www.medical-guidelines.net/mentions-legales",
    "",
  ].join("\n");
  return new Response(texte, { headers: { "Content-Type": "text/plain; charset=utf-8", "Cache-Control": "public, max-age=86400" } });
}

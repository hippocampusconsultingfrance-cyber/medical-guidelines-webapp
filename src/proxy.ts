import { type NextRequest } from "next/server";
import { cspPages } from "@/lib/csp";
import { updateSession } from "@/lib/supabase/middleware";

// Jeton aléatoire par requête pour la CSP stricte des pages (src/lib/csp.ts),
// transmis au rendu par l'en-tête de requête : Next.js l'applique à ses
// propres scripts.
export async function proxy(request: NextRequest) {
  const nonce = Buffer.from(crypto.randomUUID()).toString("base64");
  const csp = cspPages(nonce);
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set("x-nonce", nonce);
  requestHeaders.set("Content-Security-Policy", csp);
  const response = await updateSession(request, requestHeaders);
  response.headers.set("Content-Security-Policy", csp);
  return response;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|robots.txt|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};

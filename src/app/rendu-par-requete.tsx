import { headers } from "next/headers";

// Force le rendu à chaque requête d'une page sans lecture de cookies, pour
// qu'elle reçoive le jeton CSP stricte (src/proxy.ts) : une page pré-générée
// n'aurait pas le jeton, et ses scripts seraient bloqués.
export default async function RenduParRequete({ children }: { children: React.ReactNode }) {
  await headers();
  return <>{children}</>;
}

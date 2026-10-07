import RenduParRequete from "../rendu-par-requete";

// Retour des liens de connexion (e-mail, mot de passe oublié) : rendu à chaque
// requête, avec la CSP stricte par jeton (src/proxy.ts).
export default function Layout({ children }: { children: React.ReactNode }) {
  return <RenduParRequete>{children}</RenduParRequete>;
}

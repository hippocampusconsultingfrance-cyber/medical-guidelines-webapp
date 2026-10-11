import EnteteSimple from "../entete-simple";
import RenduParRequete from "../rendu-par-requete";

// Mon compte et double authentification : logo et retour à l'accueil.
// Rendu à chaque requête : CSP stricte par jeton (src/proxy.ts).
export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <RenduParRequete>
      <div className="border-b border-slate-200 bg-white">
        <EnteteSimple />
      </div>
      <main>{children}</main>
    </RenduParRequete>
  );
}

import type { Metadata } from "next";
import CadreAuth from "../cadre-auth";
import RenduParRequete from "../rendu-par-requete";

export const metadata: Metadata = { title: "Finaliser mon compte — medical-guidelines.net" };

export default function Layout({ children }: { children: React.ReactNode }) {
  // Rendu à chaque requête : CSP stricte par jeton (src/proxy.ts).
  return (
    <RenduParRequete>
      <CadreAuth>{children}</CadreAuth>
    </RenduParRequete>
  );
}

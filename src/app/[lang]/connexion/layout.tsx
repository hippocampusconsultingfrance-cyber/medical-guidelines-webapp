import type { Metadata } from "next";
import { textes } from "@/i18n/serveur";
import CadreAuth from "../cadre-auth";
import RenduParRequete from "../rendu-par-requete";
import { AUTH } from "../textes-auth";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(AUTH);
  return { title: t.connexion.titreMeta };
}

export default function Layout({ children }: { children: React.ReactNode }) {
  // Rendu à chaque requête : CSP stricte par jeton (src/proxy.ts).
  return (
    <RenduParRequete>
      <CadreAuth>{children}</CadreAuth>
    </RenduParRequete>
  );
}

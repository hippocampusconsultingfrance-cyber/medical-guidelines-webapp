import type { Metadata } from "next";
import { textes } from "@/i18n/serveur";
import CadreAuth from "../../cadre-auth";
import { AUTH } from "../../textes-auth";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(AUTH);
  return { title: t.retour.titreMeta };
}

export default function Layout({ children }: { children: React.ReactNode }) {
  return <CadreAuth>{children}</CadreAuth>;
}

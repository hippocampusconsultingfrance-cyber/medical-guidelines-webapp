import type { Metadata } from "next";
import { textes } from "@/i18n/serveur";
import Reglage from "./reglage";
import { SECURITE } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(SECURITE);
  return { title: t.titreMeta };
}

export default async function SecuritePage() {
  const { t } = await textes(SECURITE);
  return <Reglage t={t} />;
}

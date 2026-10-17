import { Suspense } from "react";
import { textes } from "@/i18n/serveur";
import { AUTH } from "../textes-auth";
import ConnexionForm from "./formulaire";

export default async function ConnexionPage() {
  const { t } = await textes(AUTH);
  return (
    <Suspense fallback={null}>
      <ConnexionForm t={t.connexion} />
    </Suspense>
  );
}

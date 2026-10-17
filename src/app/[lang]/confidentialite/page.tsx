import type { Metadata } from "next";
import type { ComponentType } from "react";
import { AvisTraduction, JURIDIQUE } from "@/i18n/juridique";
import { textes, type Traductions } from "@/i18n/serveur";
import ConfidentialiteAr from "./contenu-ar";
import ConfidentialiteDe from "./contenu-de";
import ConfidentialiteEn from "./contenu-en";
import ConfidentialiteEs from "./contenu-es";
import ConfidentialiteFr from "./contenu-fr";
import ConfidentialiteZh from "./contenu-zh";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(JURIDIQUE);
  return { title: t.confidentialite };
}

// Texte français, ou sa traduction d'information (le français fait foi).
const CONTENUS: Traductions<ComponentType> = {
  fr: ConfidentialiteFr,
  en: ConfidentialiteEn,
  es: ConfidentialiteEs,
  de: ConfidentialiteDe,
  ar: ConfidentialiteAr,
  zh: ConfidentialiteZh,
};

export default async function Page() {
  const { t, langue } = await textes(JURIDIQUE);
  const Contenu = CONTENUS[langue];
  return (
    <>
      <AvisTraduction texte={t.avis} />
      <Contenu />
    </>
  );
}

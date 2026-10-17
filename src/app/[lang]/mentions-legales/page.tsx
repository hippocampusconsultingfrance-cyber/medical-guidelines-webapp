import type { Metadata } from "next";
import type { ComponentType } from "react";
import { AvisTraduction, JURIDIQUE } from "@/i18n/juridique";
import { textes, type Traductions } from "@/i18n/serveur";
import MentionsLegalesAr from "./contenu-ar";
import MentionsLegalesDe from "./contenu-de";
import MentionsLegalesEn from "./contenu-en";
import MentionsLegalesEs from "./contenu-es";
import MentionsLegalesFr from "./contenu-fr";
import MentionsLegalesZh from "./contenu-zh";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(JURIDIQUE);
  return { title: t.mentions };
}

// Texte français, ou sa traduction d'information (le français fait foi).
const CONTENUS: Traductions<ComponentType> = {
  fr: MentionsLegalesFr,
  en: MentionsLegalesEn,
  es: MentionsLegalesEs,
  de: MentionsLegalesDe,
  ar: MentionsLegalesAr,
  zh: MentionsLegalesZh,
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

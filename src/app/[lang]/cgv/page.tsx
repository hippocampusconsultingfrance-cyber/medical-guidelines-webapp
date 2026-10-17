import type { Metadata } from "next";
import type { ComponentType } from "react";
import { AvisTraduction, JURIDIQUE } from "@/i18n/juridique";
import { textes, type Traductions } from "@/i18n/serveur";
import CgvAr from "./contenu-ar";
import CgvDe from "./contenu-de";
import CgvEn from "./contenu-en";
import CgvEs from "./contenu-es";
import CgvFr from "./contenu-fr";
import CgvZh from "./contenu-zh";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(JURIDIQUE);
  return { title: t.cgv };
}

// Texte français, ou sa traduction d'information (le français fait foi).
const CONTENUS: Traductions<ComponentType> = {
  fr: CgvFr,
  en: CgvEn,
  es: CgvEs,
  de: CgvDe,
  ar: CgvAr,
  zh: CgvZh,
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

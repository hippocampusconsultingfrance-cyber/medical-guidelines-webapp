import type { Metadata } from "next";
import type { ComponentType } from "react";
import { AvisTraduction, JURIDIQUE } from "@/i18n/juridique";
import { textes, type Traductions } from "@/i18n/serveur";
import CguEn from "./contenu-en";
import CguFr from "./contenu-fr";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(JURIDIQUE);
  return { title: t.cgu };
}

// Texte français, ou sa traduction d'information (le français fait foi).
const CONTENUS: Traductions<ComponentType> = { fr: CguFr, en: CguEn };

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

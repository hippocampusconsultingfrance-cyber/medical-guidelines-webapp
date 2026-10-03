import "./fiches.css";

// Bibliothèque : feuille de style propre aux fiches ; polices et couleurs du
// site (Geist, bleu marine), déjà chargées par la mise en page racine.
export default function BibliothequeLayout({ children }: LayoutProps<"/bibliotheque">) {
  return <>{children}</>;
}

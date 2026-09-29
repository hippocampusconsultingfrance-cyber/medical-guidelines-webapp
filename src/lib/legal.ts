// Médiateur de la consommation (art. L612-1 du code de la consommation),
// obligatoire avant toute vente à un consommateur. À compléter après
// adhésion auprès d'un médiateur référencé par la CECMC
// (www.economie.gouv.fr/mediation-conso) ; tant que le nom et le site sont
// vides, la vente en mode réel reste fermée (voir checkoutOpen, lib/stripe).
export const MEDIATEUR = {
  nom: "",
  site: "",
  adresse: "",
};

export function mediateurRenseigne() {
  return Boolean(MEDIATEUR.nom.trim() && MEDIATEUR.site.trim());
}

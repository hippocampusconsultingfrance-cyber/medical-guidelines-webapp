// Médiateur de la consommation (art. L612-1 du code de la consommation),
// obligatoire avant toute vente à un consommateur ; la mention doit figurer
// sur le site et dans les CGV (art. L616-1, sanction art. L641-1). Tant que
// le nom et le site sont vides, la vente en mode réel reste fermée (voir
// checkoutOpen, lib/stripe).
export const MEDIATEUR = {
  nom: "CM2C",
  adresse: "49 rue de Ponthieu, 75008 Paris",
  telephone: "01 89 47 00 14",
  site: "https://www.cm2c.net/declarer-un-litige.php",
  email: "litiges@cm2c.net",
};

export function mediateurRenseigne() {
  return Boolean(MEDIATEUR.nom.trim() && MEDIATEUR.site.trim());
}

// Version des conditions générales d'utilisation, enregistrée avec chaque
// inscription (profiles.cgu_version). Toute modification du texte de
// src/app/[lang]/cgu/page.tsx s'accompagne d'une nouvelle version.
export const CGU_VERSION = "2026-10-17";

"use client";

import { useSyncExternalStore, type ReactNode } from "react";

// Pages publiques mises en cache (identiques pour tous les visiteurs) : les
// éléments qui dépendent de la connexion (« Ma bibliothèque » au lieu de
// « Créer un compte ») sont choisis dans le navigateur, d'après la présence
// du cookie de session Supabase (sb-…-auth-token, lisible par la page). Le
// serveur rend toujours la version visiteur ; le contenu réservé, lui, reste
// contrôlé par la base, jamais par ce composant.
const SESSION = /(?:^|;\s*)sb-[^=]+-auth-token(?:\.\d+)?=/;

function connecte() {
  return SESSION.test(document.cookie);
}

export function useConnecte() {
  return useSyncExternalStore(
    () => () => {},
    connecte,
    () => false,
  );
}

export default function SelonConnexion({ connecte: siConnecte, visiteur }: { connecte: ReactNode; visiteur: ReactNode }) {
  return <>{useConnecte() ? siConnecte : visiteur}</>;
}

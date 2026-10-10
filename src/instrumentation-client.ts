import { SENTRY_ENABLED } from "@/lib/sentry";

// Erreurs du navigateur → Sentry (sans enregistrement de session). Le client
// Sentry est chargé une fois la page affichée, quand le navigateur est
// disponible : le premier affichage ne l'attend plus. Une erreur survenue
// avant son chargement n'est pas remontée (les erreurs serveur le restent).
if (SENTRY_ENABLED) {
  const demarrer = () => {
    import("@/lib/sentry-client").then((m) => m.demarrerSentry()).catch(() => {});
  };
  if (typeof window.requestIdleCallback === "function") window.requestIdleCallback(demarrer, { timeout: 4000 });
  else window.setTimeout(demarrer, 2000);
}

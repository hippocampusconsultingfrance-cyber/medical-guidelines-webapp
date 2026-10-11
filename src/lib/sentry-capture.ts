import { captureException, getClient, init } from "@sentry/nextjs";
import { SENTRY_OPTIONS } from "@/lib/sentry";

// Import isolé : chargé à la demande par src/app/error.tsx, il n'entraîne que
// captureException (et non tout le module Sentry) dans le JavaScript du site.
// Si l'erreur survient avant le chargement différé du client Sentry
// (src/instrumentation-client.ts), il est démarré ici.
export function signalerErreur(error: unknown) {
  if (!getClient()) init(SENTRY_OPTIONS);
  captureException(error);
}

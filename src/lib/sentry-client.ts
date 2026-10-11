import { init } from "@sentry/nextjs";
import { SENTRY_OPTIONS } from "@/lib/sentry";

// Import isolé, chargé à la demande par src/instrumentation-client.ts : un
// import dynamique de « @sentry/nextjs » entier téléchargerait tout le module.
export function demarrerSentry() {
  init(SENTRY_OPTIONS);
}

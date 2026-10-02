import { captureException } from "@sentry/nextjs";

// Import isolé : chargé à la demande par src/app/error.tsx, il n'entraîne que
// captureException (et non tout le module Sentry) dans le JavaScript du site.
export function signalerErreur(error: unknown) {
  captureException(error);
}

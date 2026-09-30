import * as Sentry from "@sentry/nextjs";
import { SENTRY_OPTIONS } from "@/lib/sentry";

// Erreurs du serveur (pages, actions, routes) et du runtime edge → Sentry.
export function register() {
  Sentry.init(SENTRY_OPTIONS);
}

export const onRequestError = Sentry.captureRequestError;

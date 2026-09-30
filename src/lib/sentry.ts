// Remontée des erreurs techniques vers Sentry (région UE, Francfort) —
// checklist 6.1 « Une erreur simulée remonte dans Sentry ». Erreurs
// seulement : ni suivi de performance, ni enregistrement de session, ni
// donnée personnelle (adresse IP, cookies, e-mail, corps des requêtes).
// Actif uniquement en production (Vercel). Le DSN n'est pas un secret : il
// ne permet que d'envoyer des erreurs ; NEXT_PUBLIC_SENTRY_DSN le remplace.
import type { ErrorEvent } from "@sentry/nextjs";

export const SENTRY_DSN =
  process.env.NEXT_PUBLIC_SENTRY_DSN ??
  "https://6bbe5780eae90b76dc9a99dfea55a607@o4512176697769984.ingest.de.sentry.io/4512176706027600";

export const SENTRY_ENABLED = process.env.NEXT_PUBLIC_VERCEL_ENV === "production";

// Retire tout ce qui pourrait identifier un membre ou révéler un contenu.
export function scrub(event: ErrorEvent): ErrorEvent {
  delete event.user;
  if (event.request) {
    delete event.request.cookies;
    delete event.request.data;
    delete event.request.headers;
    if (event.request.url) event.request.url = event.request.url.split("?")[0];
    delete event.request.query_string;
  }
  return event;
}

export const SENTRY_OPTIONS = {
  dsn: SENTRY_DSN,
  enabled: SENTRY_ENABLED,
  environment: process.env.NEXT_PUBLIC_VERCEL_ENV ?? "development",
  sendDefaultPii: false,
  tracesSampleRate: 0,
  beforeSend: scrub,
};

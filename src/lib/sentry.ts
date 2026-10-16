// Remontée des erreurs techniques vers Sentry (région UE, Francfort) —
// checklist 6.1 « Une erreur simulée remonte dans Sentry ». Erreurs
// seulement : ni suivi de performance, ni enregistrement de session, ni
// donnée personnelle (adresse IP, cookies, e-mail, corps des requêtes).
// Actif uniquement en production (Vercel). Le DSN n'est pas un secret : il
// ne permet que d'envoyer des erreurs ; NEXT_PUBLIC_SENTRY_DSN le remplace.
import type { Breadcrumb, ErrorEvent } from "@sentry/nextjs";

export const SENTRY_DSN =
  process.env.NEXT_PUBLIC_SENTRY_DSN ??
  "https://6bbe5780eae90b76dc9a99dfea55a607@o4512176697769984.ingest.de.sentry.io/4512176706027600";

export const SENTRY_ENABLED = process.env.NEXT_PUBLIC_VERCEL_ENV === "production";

// Adresses e-mail et jetons (sessions, clés Stripe, Resend, Supabase)
// masqués dans tout texte libre d'un événement.
const EMAIL = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/gi;
const JETON = /\b(?:eyJ[\w-]+\.[\w-]+\.[\w-]+|(?:sk|rk|pk)_(?:live|test)_\w+|whsec_\w+|re_\w{8,}|sb_(?:secret|publishable)_\w+)/g;
export function masquer(texte: string | undefined) {
  return texte?.replace(EMAIL, "[e-mail]").replace(JETON, "[jeton]");
}

// Contextes techniques gardés (navigateur, système, exécution, trace) ; les
// autres peuvent porter des données d'application.
const CONTEXTES = new Set(["app", "browser", "cloud_resource", "culture", "device", "os", "runtime", "trace"]);

function nettoyerFil(b: Breadcrumb): Breadcrumb | null {
  // Messages de console : contenu libre, jamais envoyé.
  if (b.category === "console") return null;
  const url = typeof b.data?.url === "string" ? b.data.url.split("?")[0] : undefined;
  return {
    ...b,
    message: masquer(b.message),
    data: url ? { url, method: b.data?.method, status_code: b.data?.status_code } : undefined,
  };
}

// Retire tout ce qui pourrait identifier un membre ou révéler un contenu :
// utilisateur, requête (cookies, corps, en-têtes, paramètres), données
// ajoutées, contextes d'application, messages de console ; e-mails et jetons
// masqués dans les messages et le fil des événements.
export function scrub(event: ErrorEvent): ErrorEvent {
  delete event.user;
  delete event.extra;
  if (event.request) {
    delete event.request.cookies;
    delete event.request.data;
    delete event.request.headers;
    if (event.request.url) event.request.url = event.request.url.split("?")[0];
    delete event.request.query_string;
  }
  if (event.contexts) {
    for (const k of Object.keys(event.contexts)) if (!CONTEXTES.has(k)) delete event.contexts[k];
  }
  event.message = masquer(event.message);
  for (const v of event.exception?.values ?? []) v.value = masquer(v.value);
  if (event.breadcrumbs) {
    event.breadcrumbs = event.breadcrumbs.map(nettoyerFil).filter((b): b is Breadcrumb => b !== null);
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
  beforeBreadcrumb: nettoyerFil,
};

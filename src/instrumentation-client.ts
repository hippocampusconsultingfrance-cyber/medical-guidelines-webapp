import * as Sentry from "@sentry/nextjs";
import { SENTRY_OPTIONS } from "@/lib/sentry";

// Erreurs du navigateur → Sentry (sans enregistrement de session).
Sentry.init(SENTRY_OPTIONS);

export const onRouterTransitionStart = Sentry.captureRouterTransitionStart;

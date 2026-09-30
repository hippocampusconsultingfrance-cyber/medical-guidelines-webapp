import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { emailEnabled } from "@/lib/email";
import { checkoutOpen, stripeMode } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";

export const metadata: Metadata = {
  title: "Tableau de bord — medical-guidelines.net",
};

const DAY = 24 * 3600 * 1000;

// Heure de la requête (lue une fois, hors du rendu).
function clock() {
  const now = Date.now();
  const mois = new Intl.DateTimeFormat("fr-CA", { timeZone: "Europe/Paris", year: "numeric", month: "2-digit" })
    .format(new Date(now))
    .slice(0, 7);
  return {
    iso: new Date(now).toISOString(),
    since7: new Date(now - 7 * DAY).toISOString(),
    since30: new Date(now - 30 * DAY).toISOString(),
    mois,
  };
}

type Tache = { label: string; n: number | null; href: string; detail: string };

// Tableau de bord du porteur de projet (administrateurs) : chiffres clés,
// tâches en attente, état du site et raccourcis. Pensé pour le téléphone.
// Comptes lus avec la clé service_role (nombres seulement, aucune donnée
// personnelle affichée).
export default async function AdminPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const lib = await loadLibrary(supabase, user.id);
  const admin = createAdminClient();
  const { iso, since7, since30, mois } = clock();
  const count = async (q: PromiseLike<{ count: number | null; error: unknown }>) => {
    const { count: n, error } = await q;
    return error ? null : (n ?? 0);
  };
  const head = { count: "exact" as const, head: true };

  const [
    membres,
    nouveaux7,
    nouveaux30,
    finalises,
    premium,
    deblocages7,
    consultations7,
    signalements,
    brouillons,
    revision,
    traductions,
    lettre,
    justificatifs,
    suspensions,
  ] = await Promise.all([
    count(admin.from("profiles").select("id", head).is("editorial_role", null)),
    count(admin.from("profiles").select("id", head).is("editorial_role", null).gte("created_at", since7)),
    count(admin.from("profiles").select("id", head).is("editorial_role", null).gte("created_at", since30)),
    count(admin.from("profiles").select("id", head).is("editorial_role", null).eq("setup_completed", true)),
    count(admin.from("subscriptions").select("user_id", head).eq("status", "actif").or(`current_period_end.is.null,current_period_end.gt."${iso}"`)),
    count(admin.from("document_unlocks").select("user_id", head).gte("unlocked_at", since7)),
    count(admin.from("consultation_history").select("user_id", head).gte("viewed_at", since7)),
    count(admin.from("error_reports").select("id", head).eq("status", "nouveau")),
    count(admin.from("documents").select("id", head).is("published_at", null).neq("freshness_status", "retiree")),
    count(admin.from("documents").select("id", head).eq("freshness_status", "revision_detectee")),
    count(admin.from("document_translations").select("document_id", head).eq("status", "brouillon")),
    count(admin.from("notifications_log").select("id", head).eq("body", `lettre:${mois}`)),
    count(admin.from("student_discount_requests").select("id", head).eq("status", "en_attente")),
    count(admin.from("access_blocks").select("id", head).gt("blocked_until", iso)),
  ]);

  const mode = stripeMode();
  const venteOuverte = checkoutOpen(false);
  const conversion = membres && premium !== null ? Math.round((100 * premium) / membres) : 0;

  const chiffres: [string, string, string?][] = [
    ["Membres inscrits", String(membres ?? "?"), nouveaux7 !== null ? `+${nouveaux7} en 7 j · +${nouveaux30 ?? "?"} en 30 j` : undefined],
    ["Comptes finalisés", String(finalises ?? "?"), membres ? `${Math.round((100 * (finalises ?? 0)) / membres)} % des inscrits` : undefined],
    ["Abonnés PREMIUM", String(premium ?? "?"), `${conversion} % des inscrits`],
    ["Fiches débloquées", String(deblocages7 ?? "?"), "7 derniers jours"],
    ["Lectures de fiches", String(consultations7 ?? "?"), "7 derniers jours"],
    ["Fiches en ligne", String(lib.docs.length - (brouillons ?? 0)), `${brouillons ?? "?"} en brouillon`],
  ];

  const taches: Tache[] = [
    { label: "Signalements d'erreur à traiter", n: signalements, href: "/bibliotheque/signalements", detail: "Erreurs signalées par les membres depuis une fiche." },
    {
      label: "Justificatifs professionnels en formation",
      n: justificatifs,
      href: "/bibliotheque/etudiants",
      detail:
        justificatifs === null
          ? "Migration des justificatifs pas encore appliquée dans Supabase."
          : "Étudiants médicaux et paramédicaux : à valider pour le −30 %.",
    },
    {
      label: "Comptes suspendus (anti-extraction)",
      n: suspensions,
      href: "/bibliotheque/acces",
      detail:
        suspensions === null
          ? "Migration anti-extraction pas encore appliquée dans Supabase."
          : "Trop de fiches ouvertes trop vite : vérifier, lever si usage normal.",
    },
    { label: "Fiches en brouillon", n: brouillons, href: "/bibliotheque", detail: "À relire puis publier (bouton « Publier » de la fiche)." },
    { label: "Fiches « révision détectée »", n: revision, href: "/bibliotheque", detail: "Nouvelle version de la source : à mettre à jour (bloc « Veille » de la fiche)." },
    {
      label: "Traductions anglaises à relire",
      n: traductions,
      href: "/bibliotheque/traductions",
      detail: traductions === null ? "Migration des traductions pas encore appliquée dans Supabase." : "Brouillons de l'atelier, non publiés.",
    },
    {
      label: `Lettre de veille de ${mois.slice(5)}/${mois.slice(0, 4)}`,
      n: null,
      href: "/bibliotheque/veille",
      detail: lettre ? `Envoyée à ${lettre} abonné(s).` : "Pas encore envoyée ce mois-ci.",
    },
  ];

  const etat: [string, boolean | null, string][] = [
    ["Base de données", membres !== null, membres !== null ? "Répond normalement." : "Lecture impossible : vérifier Supabase."],
    [
      "Paiement",
      mode === "live" ? venteOuverte : null,
      mode === "live"
        ? venteOuverte
          ? "Mode réel : vente ouverte."
          : "Mode réel, vente fermée (médiateur manquant)."
        : mode === "test"
          ? "Mode test : vente réservée à l'équipe (jour J à faire)."
          : "Stripe non configuré.",
    ],
    ["E-mails", emailEnabled(), emailEnabled() ? "Envoi actif (Resend)." : "RESEND_API_KEY absente : aucun e-mail ne part."],
  ];

  const liens: [string, string][] = [
    ["Statistiques détaillées", "/bibliotheque/statistiques"],
    ["Signalements", "/bibliotheque/signalements"],
    ["Lettre de veille", "/bibliotheque/veille"],
    ["Traductions", "/bibliotheque/traductions"],
    ["Professionnels en formation", "/bibliotheque/etudiants"],
    ["Accès anormaux", "/bibliotheque/acces"],
    ["Vérification du paiement", "/abonnement/verification"],
    ["Santé du site", "/api/sante"],
  ];
  const externes: [string, string][] = [
    ["Stripe", "https://dashboard.stripe.com"],
    ["Supabase", "https://supabase.com/dashboard/project/gafoerloysumhzccvgdm"],
    ["Vercel", "https://vercel.com"],
    ["Surveillance et sauvegardes (GitHub)", "https://github.com/hippocampusconsultingfrance-cyber/medical-guidelines-webapp/actions"],
  ];

  const card = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "14px 16px" };
  const aFaire = taches.filter((t) => t.n !== null && t.n > 0).length;

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Tableau de bord</h1>
        <div className="doc-header__meta">
          <span>Membres hors équipe éditoriale · chiffres en temps réel</span>
        </div>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(150px, 1fr))", gap: 10, marginTop: 16 }}>
        {chiffres.map(([label, n, sub]) => (
          <div key={label} style={card}>
            <div style={{ fontFamily: "var(--font-display)", fontSize: "1.7rem", fontWeight: 800, color: "var(--brand-ink)", lineHeight: 1.1 }}>{n}</div>
            <div style={{ fontSize: "0.82rem", color: "var(--ink)", fontWeight: 600, marginTop: 4 }}>{label}</div>
            {sub && <div style={{ fontSize: "0.76rem", color: "var(--ink-muted)", marginTop: 2 }}>{sub}</div>}
          </div>
        ))}
      </div>

      <h2 className="block-section" style={{ marginTop: 28 }}>
        À faire {aFaire ? `(${aFaire})` : "— rien d'urgent"}
      </h2>
      <div style={{ display: "grid", gap: 8 }}>
        {taches.map((t) => (
          <Link key={t.label} href={t.href} style={{ ...card, display: "flex", gap: 12, alignItems: "center", textDecoration: "none", color: "inherit" }}>
            <span
              className={`state-pill ${t.n ? "state-draft" : "state-open"}`}
              style={{ minWidth: 36, justifyContent: "center", textAlign: "center" }}
            >
              {t.n === null ? (t.detail.startsWith("Migration") ? "!" : "·") : t.n}
            </span>
            <span style={{ minWidth: 0 }}>
              <b style={{ display: "block" }}>{t.label}</b>
              <span style={{ fontSize: "0.82rem", color: "var(--ink-muted)" }}>{t.detail}</span>
            </span>
            <span aria-hidden="true" style={{ marginLeft: "auto", color: "var(--ink-muted)" }}>
              →
            </span>
          </Link>
        ))}
      </div>

      <h2 className="block-section" style={{ marginTop: 28 }}>État du site</h2>
      <div style={{ display: "grid", gap: 8 }}>
        {etat.map(([label, ok, detail]) => (
          <div key={label} style={{ ...card, display: "flex", gap: 12, alignItems: "center" }}>
            <span className={`state-pill ${ok === true ? "state-open" : "state-draft"}`}>
              {ok === true ? "✓ OK" : ok === false ? "✗ À voir" : "• Info"}
            </span>
            <span>
              <b>{label}</b> — <span style={{ fontSize: "0.88rem" }}>{detail}</span>
            </span>
          </div>
        ))}
      </div>

      <h2 className="block-section" style={{ marginTop: 28 }}>Raccourcis</h2>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: 8 }}>
        {liens.map(([label, href]) => (
          <Link key={href} href={href} style={{ ...card, textDecoration: "none", fontWeight: 600 }}>
            {label} →
          </Link>
        ))}
        {externes.map(([label, href]) => (
          <a key={href} href={href} target="_blank" rel="noopener noreferrer" style={{ ...card, textDecoration: "none", fontWeight: 600 }}>
            {label} ↗
          </a>
        ))}
      </div>
    </Shell>
  );
}

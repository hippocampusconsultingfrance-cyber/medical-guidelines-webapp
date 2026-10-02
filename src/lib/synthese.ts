import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";
import { chargerPropositions } from "@/lib/actualisations";
import type { OutgoingEmail } from "@/lib/email";
import { cadreEmail } from "@/lib/email-gabarit";
import { escapeHtml } from "@/lib/fiches";

// Synthèse hebdomadaire au porteur de projet (cahier des charges §14 ;
// checklist 6.2 « Rendez-vous hebdomadaire en place, avec synthèse ») :
// chiffres des 7 derniers jours et décisions en attente, envoyée le lundi
// matin aux administrateurs (tâche planifiée /api/cron/synthese).

const DAY = 24 * 3600 * 1000;

export type Synthese = {
  semaine: string;
  chiffres: [string, number | null][];
  taches: [string, number | null, string][];
  lettre: string;
};

// Semaine ISO « AAAA-Sww » (clé d'envoi unique).
export function semaineIso(d: Date) {
  const t = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));
  const jour = t.getUTCDay() || 7;
  t.setUTCDate(t.getUTCDate() + 4 - jour);
  const debut = new Date(Date.UTC(t.getUTCFullYear(), 0, 1));
  const n = Math.ceil(((t.getTime() - debut.getTime()) / DAY + 1) / 7);
  return `${t.getUTCFullYear()}-S${String(n).padStart(2, "0")}`;
}

export async function calculerSynthese(admin: SupabaseClient, now: Date): Promise<Synthese> {
  const iso = now.toISOString();
  const since7 = new Date(now.getTime() - 7 * DAY).toISOString();
  const mois = iso.slice(0, 7);
  const head = { count: "exact" as const, head: true };
  const count = async (q: PromiseLike<{ count: number | null; error: unknown }>) => {
    const { count: n, error } = await q;
    return error ? null : (n ?? 0);
  };
  const [membres, nouveaux, premium, nouveauxPremium, lectures, signalements, justificatifs, suspensions, traductions, revision, lettre, fichesMois, roles, suggestions] =
    await Promise.all([
      count(admin.from("profiles").select("id", head).is("editorial_role", null)),
      count(admin.from("profiles").select("id", head).is("editorial_role", null).gte("created_at", since7)),
      count(admin.from("subscriptions").select("user_id", head).eq("status", "actif").or(`current_period_end.is.null,current_period_end.gt."${iso}"`)),
      count(admin.from("subscriptions").select("user_id", head).eq("status", "actif").gte("created_at", since7)),
      count(admin.from("consultation_history").select("user_id", head).gte("viewed_at", since7)),
      count(admin.from("error_reports").select("id", head).eq("status", "nouveau")),
      count(admin.from("student_discount_requests").select("id", head).eq("status", "en_attente")),
      count(admin.from("access_blocks").select("id", head).gte("blocked_at", since7)),
      count(admin.from("document_translations").select("document_id", head).eq("status", "brouillon")),
      count(admin.from("documents").select("id", head).eq("freshness_status", "revision_detectee")),
      count(admin.from("notifications_log").select("id", head).eq("body", `lettre:${mois}`)),
      count(admin.from("documents").select("id", head).gte("published_at", `${mois}-01`)),
      count(admin.from("audit_log").select("id", head).eq("entity_type", "profiles").gte("created_at", since7)),
      count(admin.from("site_suggestions").select("id", head).eq("status", "nouveau")),
    ]);
  const actualisations = (await chargerPropositions(admin)).length;
  return {
    semaine: semaineIso(now),
    chiffres: [
      ["Membres inscrits", membres],
      ["Nouveaux membres (7 j)", nouveaux],
      ["Abonnés PREMIUM", premium],
      ["Nouveaux PREMIUM (7 j)", nouveauxPremium],
      ["Lectures de fiches (7 j)", lectures],
    ],
    taches: [
      ["Signalements d'erreur à traiter", signalements, "/bibliotheque/signalements"],
      ["Suggestions des membres à traiter", suggestions, "/bibliotheque/suggestions"],
      ["Justificatifs de formation à valider", justificatifs, "/bibliotheque/etudiants"],
      ["Actualisations à valider", actualisations, "/bibliotheque/actualisations"],
      ["Fiches « révision détectée »", revision, "/bibliotheque"],
      ["Traductions à relire", traductions, "/bibliotheque/traductions"],
      ["Suspensions anti-extraction (7 j)", suspensions, "/bibliotheque/acces"],
      // Sécurité : tout changement de rôle d'équipe doit être reconnu.
      ["Rôles d'équipe modifiés (7 j) — à vérifier", roles, "/bibliotheque/journal"],
    ],
    lettre: lettre
      ? `Lettre de veille du mois envoyée à ${lettre} abonné(s).`
      : fichesMois
        ? `Lettre de veille du mois pas encore envoyée (${fichesMois} fiche(s) publiée(s) ce mois-ci).`
        : "Aucune nouvelle fiche ce mois-ci : pas de lettre de veille à envoyer aux membres.",
  };
}

export function composerSynthese(s: Synthese, to: string, site: string): OutgoingEmail {
  const aFaire = s.taches.filter(([, n]) => (n ?? 0) > 0);
  const subject = aFaire.length
    ? `Synthèse ${s.semaine} : ${aFaire.length} point(s) à valider`
    : `Synthèse ${s.semaine} : rien d'urgent`;
  const val = (n: number | null) => (n === null ? "?" : String(n));
  const ligne = (a: string, b: string) =>
    `<tr><td style="padding:6px 0;border-bottom:1px solid #E2E8F0">${escapeHtml(a)}</td><td style="padding:6px 0;border-bottom:1px solid #E2E8F0;text-align:right;font-weight:700">${escapeHtml(b)}</td></tr>`;
  const taches = aFaire.length
    ? aFaire
        .map(([l, n, href]) => `<li style="margin:6px 0"><a href="${site}${href}" style="color:#0E3A78">${escapeHtml(l)}</a> : <b>${n}</b></li>`)
        .join("")
    : `<li>Rien d'urgent cette semaine.</li>`;
  const html = cadreEmail(
    subject,
    `<p style="font-size:18px;font-weight:700;color:#0E3A78;margin:0 0 8px">Synthèse de la semaine — ${escapeHtml(s.semaine)}</p>` +
    `<h2 style="font-size:16px;margin:20px 0 6px">À valider</h2><ul style="padding-left:18px;font-size:15px">${taches}</ul>` +
    `<h2 style="font-size:16px;margin:20px 0 6px">Chiffres</h2><table style="width:100%;border-collapse:collapse;font-size:15px">${s.chiffres.map(([l, n]) => ligne(l, val(n))).join("")}</table>` +
    `<p style="font-size:14px;margin-top:18px">${escapeHtml(s.lettre)}</p>` +
    `<p style="margin:22px 0"><a href="${site}/bibliotheque/admin" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">Ouvrir le tableau de bord</a></p>`,
    "E-mail de service destiné à l'équipe de medical-guidelines.net.",
  );
  const text =
    `Synthèse de la semaine — ${s.semaine}\n\nÀ valider :\n` +
    (aFaire.length ? aFaire.map(([l, n, href]) => `- ${l} : ${n} (${site}${href})`).join("\n") : "- Rien d'urgent cette semaine.") +
    `\n\nChiffres :\n${s.chiffres.map(([l, n]) => `- ${l} : ${val(n)}`).join("\n")}\n\n${s.lettre}\n\nTableau de bord : ${site}/bibliotheque/admin\n`;
  return { to, subject, html, text };
}

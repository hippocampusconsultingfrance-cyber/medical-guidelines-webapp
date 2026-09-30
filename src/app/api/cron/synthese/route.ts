import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { calculerSynthese, composerSynthese } from "@/lib/synthese";
import { createAdminClient } from "@/lib/supabase/admin";

// Synthèse hebdomadaire aux administrateurs (tâche planifiée Vercel, le
// lundi matin, vercel.json). Authentifiée par CRON_SECRET ; une seule
// synthèse par semaine et par administrateur (notifications_log, body
// « synthese:AAAA-Sww »). ?apercu=1 renvoie le contenu sans rien envoyer.
export async function GET(request: Request) {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return Response.json({ error: "Non autorisé" }, { status: 401 });
  }
  const admin = createAdminClient();
  const synthese = await calculerSynthese(admin, new Date());
  if (new URL(request.url).searchParams.get("apercu") === "1") return Response.json(synthese);
  if (!emailEnabled()) return Response.json({ envoyes: 0, info: "RESEND_API_KEY manquant : aucun envoi" });

  const log = `synthese:${synthese.semaine}`;
  const [{ data: admins }, { data: deja }] = await Promise.all([
    admin.from("profiles").select("id").eq("editorial_role", "admin"),
    admin.from("notifications_log").select("user_id").eq("body", log),
  ]);
  const recus = new Set((deja ?? []).map((d) => d.user_id as string));
  const envois: { id: string; email: string }[] = [];
  for (const a of admins ?? []) {
    if (recus.has(a.id as string)) continue;
    const { data } = await admin.auth.admin.getUserById(a.id as string);
    if (data?.user?.email) envois.push({ id: a.id as string, email: data.user.email });
  }
  if (!envois.length) return Response.json({ envoyes: 0 });

  const emails = envois.map((e) => composerSynthese(synthese, e.email, siteUrl()));
  const sent = await sendBatch(emails, `synthese-${synthese.semaine}`);
  if (!sent.ok) {
    console.error("Synthèse hebdomadaire", sent.error);
    return Response.json({ error: "Envoi impossible" }, { status: 502 });
  }
  await admin
    .from("notifications_log")
    .insert(envois.map((e, i) => ({ user_id: e.id, subject: emails[i].subject, body: log, channel: "email" })));
  return Response.json({ envoyes: envois.length, semaine: synthese.semaine });
}

import { createHash } from "node:crypto";
import type { Card } from "@/lib/fiches";
import { buildDigests, type AlertDocument, type PendingAlert } from "@/lib/alertes";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { createAdminClient } from "@/lib/supabase/admin";

// Envoi quotidien des alertes e-mail (tâche planifiée Vercel, vercel.json).
// Vercel appelle cette adresse avec « Authorization: Bearer CRON_SECRET » ;
// sans ce secret, rien n'est fait. ?apercu=1 renvoie ce qui serait envoyé,
// sans rien envoyer (adresses masquées).
//
// Destinataires, motifs et déduplication sont décidés par la base
// (pending_email_alerts) ; chaque fiche signalée est inscrite dans
// notifications_log, ce qui empêche de la signaler deux fois.
export async function GET(request: Request) {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return Response.json({ error: "Non autorisé" }, { status: 401 });
  }
  const apercu = new URL(request.url).searchParams.get("apercu") === "1";
  if (!apercu && !emailEnabled()) {
    return Response.json({ envoyes: 0, info: "RESEND_API_KEY manquant : aucun envoi" });
  }

  const admin = createAdminClient();
  const { data, error } = await admin.rpc("pending_email_alerts");
  if (error) {
    console.error("Alertes : pending_email_alerts", error);
    return Response.json({ error: "Lecture des alertes impossible" }, { status: 500 });
  }
  const rows = (data ?? []) as PendingAlert[];
  if (!rows.length) return Response.json({ destinataires: 0, envoyes: 0 });

  const ids = [...new Set(rows.map((r) => r.document_id))];
  const [{ data: documents, error: docError }, { data: versions }] = await Promise.all([
    admin
      .from("documents")
      .select("id, title, card_json, publication_date, source_url, document_societies(societies(acronym))")
      .in("id", ids),
    admin
      .from("document_versions")
      .select("document_id, version_label, diff_summary, published_at")
      .in("document_id", ids)
      .not("published_at", "is", null)
      .order("published_at", { ascending: false }),
  ]);
  if (docError) {
    console.error("Alertes : documents", docError);
    return Response.json({ error: "Lecture des fiches impossible" }, { status: 500 });
  }

  type Row = {
    id: string;
    title: string;
    card_json: Card | null;
    publication_date: string | null;
    source_url: string | null;
    document_societies: { societies: { acronym: string } | { acronym: string }[] | null }[] | null;
  };
  type Version = { document_id: string; version_label: string; diff_summary: string | null };
  const latest = new Map<string, Version>();
  for (const v of (versions ?? []) as Version[]) if (!latest.has(v.document_id)) latest.set(v.document_id, v);
  const docs = new Map<string, AlertDocument>(
    ((documents ?? []) as unknown as Row[]).map(({ document_societies, ...d }) => [
      d.id,
      {
        ...d,
        societies: (document_societies ?? [])
          .flatMap((l) => (Array.isArray(l.societies) ? l.societies : l.societies ? [l.societies] : []))
          .map((s) => s.acronym),
        version: latest.get(d.id) ?? null,
      },
    ]),
  );

  const digests = buildDigests(rows, docs, siteUrl());
  if (apercu) {
    return Response.json({
      destinataires: digests.length,
      apercu: digests.map((d) => ({
        email: d.email.to.replace(/^(.).*(@.*)$/, "$1…$2"),
        objet: d.email.subject,
        fiches: d.items.length,
      })),
    });
  }

  let envoyes = 0;
  const echecs: string[] = [];
  const day = new Date().toISOString().slice(0, 10);
  for (let i = 0; i < digests.length; i += 100) {
    const batch = digests.slice(i, i + 100);
    // Même lot rejoué le même jour : même clé, Resend n'envoie pas deux fois.
    const key = createHash("sha256")
      .update(day + JSON.stringify(batch.map((d) => [d.userId, d.items.map((it) => it.documentId)])))
      .digest("hex");
    const sent = await sendBatch(
      batch.map((d) => d.email),
      `alertes-${key}`,
    );
    if (!sent.ok) {
      console.error("Alertes : envoi", sent.error);
      echecs.push(sent.error);
      continue;
    }
    envoyes += batch.length;
    const { error: logError } = await admin.from("notifications_log").insert(
      batch.flatMap((d) =>
        d.items.map((it) => ({
          user_id: d.userId,
          subject: d.email.subject,
          body: it.motif,
          document_id: it.documentId,
          channel: "email",
        })),
      ),
    );
    if (logError) console.error("Alertes : journal", logError);
  }

  return Response.json({ destinataires: digests.length, envoyes, echecs: echecs.length }, { status: echecs.length ? 502 : 200 });
}

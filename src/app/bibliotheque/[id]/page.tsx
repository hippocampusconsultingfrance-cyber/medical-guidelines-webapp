import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { formatDate, FREE_QUOTA } from "@/lib/fiches";
import { unlockDocument } from "./actions";

export const metadata: Metadata = {
  title: "Fiche — Medical Guidelines",
};

const UUID = /^[0-9a-f-]{36}$/i;

const MESSAGES: Record<string, string> = {
  quota_atteint: `Vous avez utilisé vos ${FREE_QUOTA} fiches gratuites. L'abonnement PREMIUM donne accès à toutes les fiches de votre spécialité.`,
  indisponible: "Cette fiche n'est pas disponible pour votre compte.",
  erreur: "Le déblocage n'a pas abouti. Réessayez dans un instant.",
};

type Recommendation = {
  id: string;
  recommendation_code: string;
  statement: string;
  grade: string | null;
  evidence_level: string | null;
  source_section: string | null;
  source_page: number | null;
  status: string;
};

export default async function FichePage({
  params,
  searchParams,
}: PageProps<"/bibliotheque/[id]">) {
  const { id } = await params;
  if (!UUID.test(id)) notFound();

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const { data: doc } = await supabase
    .from("documents")
    .select("id, title, doc_type, publication_date, revision_date, source_url, grading_system")
    .eq("id", id)
    .maybeSingle();
  if (!doc) notFound();

  const { data: canRead } = await supabase.rpc("can_read_document", { doc_id: id });
  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;

  const header = (
    <>
      <p className="text-sm">
        <Link href="/bibliotheque" className="text-teal-700 underline">
          ← Bibliothèque
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">{doc.title}</h1>
      <p className="mt-1 text-sm text-slate-500">
        {[doc.doc_type, formatDate(doc.publication_date)].filter(Boolean).join(" · ")}
        {doc.revision_date && ` · révisée le ${formatDate(doc.revision_date)}`}
      </p>
      <p className="mt-2 text-sm">
        <a
          href={doc.source_url}
          target="_blank"
          rel="noopener noreferrer"
          className="text-teal-700 underline"
        >
          Document source officiel ↗
        </a>
      </p>
    </>
  );

  if (!canRead) {
    const { count } = await supabase
      .from("document_unlocks")
      .select("document_id", { count: "exact", head: true });
    const used = count ?? 0;
    const remaining = Math.max(FREE_QUOTA - used, 0);

    return (
      <div className="mx-auto max-w-3xl px-6 py-12">
        {header}
        <div className="mt-8 rounded-md border border-slate-200 bg-slate-50 p-5 text-sm text-slate-700">
          {message && <p className="mb-3 font-medium text-slate-900">{message}</p>}
          {remaining > 0 ? (
            <>
              <p>
                Débloquer cette fiche utilisera <strong>1</strong> de vos{" "}
                {FREE_QUOTA} fiches gratuites. Il vous en reste{" "}
                <strong>{remaining}</strong>. Une fiche débloquée le reste
                définitivement.
              </p>
              <form action={unlockDocument} className="mt-4">
                <input type="hidden" name="id" value={doc.id} />
                <button className="rounded-md bg-teal-700 px-5 py-2.5 font-medium text-white hover:bg-teal-800">
                  Confirmer le déblocage
                </button>
              </form>
            </>
          ) : (
            !message && <p>{MESSAGES.quota_atteint}</p>
          )}
        </div>
      </div>
    );
  }

  const { data: recs } = await supabase
    .from("recommendations")
    .select(
      "id, recommendation_code, statement, grade, evidence_level, source_section, source_page, status",
    )
    .eq("document_id", id)
    .order("recommendation_code");

  await supabase
    .from("consultation_history")
    .insert({ user_id: user.id, document_id: id });

  // Regroupement par section de la source, dans l'ordre des codes.
  const sections: { title: string; items: Recommendation[] }[] = [];
  for (const rec of (recs ?? []) as Recommendation[]) {
    const title = rec.source_section ?? "Recommandations";
    const last = sections[sections.length - 1];
    if (last?.title === title) last.items.push(rec);
    else sections.push({ title, items: [rec] });
  }

  const watermark = `${user.email} · ${new Date().toLocaleString("fr-FR", { timeZone: "Europe/Paris" })}`;

  return (
    <div className="fiche-premium relative mx-auto max-w-3xl px-6 py-12">
      <div
        aria-hidden="true"
        className="pointer-events-none fixed inset-0 z-10 flex select-none flex-wrap content-start gap-x-24 gap-y-28 overflow-hidden p-8 text-xs text-slate-400/25"
        style={{ transform: "rotate(-24deg) scale(1.4)" }}
      >
        {Array.from({ length: 60 }, (_, i) => (
          <span key={i}>{watermark}</span>
        ))}
      </div>

      {header}
      {doc.grading_system && (
        <p className="mt-4 rounded-md bg-slate-50 p-3 text-xs text-slate-600">
          <strong>Système de gradation :</strong> {doc.grading_system}
        </p>
      )}

      {sections.map((s) => (
        <section key={s.title} className="mt-8">
          <h2 className="text-base font-semibold text-slate-900">{s.title}</h2>
          <ul className="mt-3 space-y-3">
            {s.items.map((rec) => (
              <li key={rec.id} className="rounded-md border border-slate-200 p-3 text-sm">
                <p className="text-slate-800">{rec.statement}</p>
                <p className="mt-1 text-xs text-slate-500">
                  {[
                    rec.grade && `Grade : ${rec.grade}`,
                    rec.evidence_level && `Niveau de preuve : ${rec.evidence_level}`,
                    rec.source_page && `p. ${rec.source_page}`,
                    rec.recommendation_code,
                  ]
                    .filter(Boolean)
                    .join(" · ")}
                  {rec.status !== "active" && (
                    <span className="ml-2 rounded bg-amber-100 px-1.5 py-0.5 text-amber-800">
                      {rec.status}
                    </span>
                  )}
                </p>
              </li>
            ))}
          </ul>
        </section>
      ))}

      <p className="mt-10 text-xs text-slate-500">
        Synthèse indépendante : elle ne remplace pas le texte intégral de la
        recommandation officielle.
      </p>
    </div>
  );
}

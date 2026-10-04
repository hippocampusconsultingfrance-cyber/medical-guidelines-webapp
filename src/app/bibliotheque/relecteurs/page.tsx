import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { STATUTS_CANDIDATURE } from "@/lib/relecteurs";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { deciderCandidature } from "./actions";

export const metadata: Metadata = {
  title: "Médecins relecteurs — medical-guidelines.net",
};

type Candidature = {
  id: string;
  nom: string;
  prenom: string;
  telephone: string;
  email: string;
  profession: string;
  specialite: string;
  message: string | null;
  status: string;
  admin_note: string | null;
  created_at: string;
};

const PILULE: Record<string, string> = { nouvelle: "nouveau", contactee: "nouveau", acceptee: "valide", refusee: "rejete" };

// Candidatures des médecins relecteurs (page publique /relecteurs).
// Administrateur : coordonnées pour recontacter le médecin, puis statut.
export default async function RelecteursAdminPage({ searchParams }: PageProps<"/bibliotheque/relecteurs">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const [lib, { data: isAdmin }] = await Promise.all([loadLibrary(supabase, user.id), supabase.rpc("is_admin")]);
  if (!isAdmin) redirect("/bibliotheque");

  const params = await searchParams;
  const filtre = params.voir === "tout" ? "tout" : "a_traiter";
  let q = createAdminClient()
    .from("candidatures_relecteurs")
    .select("id, nom, prenom, telephone, email, profession, specialite, message, status, admin_note, created_at")
    .order("created_at", { ascending: false })
    .limit(300);
  if (filtre === "a_traiter") q = q.in("status", ["nouvelle", "contactee"]);
  const { data, error } = await q;
  const candidatures = (data ?? []) as Candidature[];

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Médecins relecteurs</h1>
        <div className="doc-header__meta">
          <span>
            {filtre === "a_traiter" ? (
              <>
                <b>{candidatures.length}</b> à traiter · <a href="?voir=tout">Tout afficher</a>
              </>
            ) : (
              <>
                {candidatures.length} au total · <a href="?">Seulement celles à traiter</a>
              </>
            )}
            {" · "}
            <a href="/relecteurs">Page publique</a>
          </span>
        </div>
      </div>
      {params.r === "erreur" && (
        <div className="credit-strip" role="status">
          <b>L&apos;enregistrement n&apos;a pas abouti.</b>
        </div>
      )}
      {error ? (
        <div className="empty-state">Migration des candidatures pas encore appliquée dans Supabase.</div>
      ) : candidatures.length === 0 ? (
        <div className="empty-state">Aucune candidature à traiter.</div>
      ) : (
        candidatures.map((c) => (
          <div key={c.id} className="report-card">
            <div className="report-card__top">
              <div>
                <div className="report-card__where">
                  {c.prenom} {c.nom} · {c.profession}
                </div>
                <div className="report-card__date">
                  Reçue le {new Date(c.created_at).toLocaleString("fr-FR", { timeZone: "Europe/Paris" })}
                </div>
              </div>
              <span className={`status-pill status-${PILULE[c.status] ?? c.status}`}>
                {STATUTS_CANDIDATURE[c.status] ?? c.status}
              </span>
            </div>
            <div className="report-card__desc">
              Spécialité à corriger : <b>{c.specialite}</b>
              <br />
              <a href={`mailto:${c.email}`}>{c.email}</a> · <a href={`tel:${c.telephone.replace(/[^+0-9]/g, "")}`}>{c.telephone}</a>
              {c.message && (
                <>
                  <br />
                  {c.message}
                </>
              )}
            </div>
            {c.admin_note && <p className="block-p is-note">Note : {c.admin_note}</p>}
            <form action={deciderCandidature} className="report-card__actions" style={{ flexWrap: "wrap" }}>
              <input type="hidden" name="id" value={c.id} />
              <input name="note" maxLength={1000} placeholder="Note (facultatif)" defaultValue={c.admin_note ?? ""} />
              {Object.entries(STATUTS_CANDIDATURE)
                .filter(([s]) => s !== c.status)
                .map(([s, libelle]) => (
                  <button key={s} name="status" value={s} className="btn btn-ghost btn-sm">
                    {s === "nouvelle" ? "Rouvrir" : libelle}
                  </button>
                ))}
            </form>
          </div>
        ))
      )}
    </Shell>
  );
}

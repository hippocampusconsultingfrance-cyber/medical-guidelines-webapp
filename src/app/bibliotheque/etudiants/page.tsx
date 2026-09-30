import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { STATUTS } from "@/lib/etudiants";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { deciderEtudiant } from "./actions";

export const metadata: Metadata = {
  title: "Justificatifs professionnels en formation — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  validee: "Demande validée : le membre est prévenu par e-mail ; −30 % s'appliquent automatiquement à son paiement (ou à son renouvellement s'il est déjà abonné).",
  refusee: "Demande refusée : le membre a été prévenu par e-mail avec le motif.",
  motif_requis: "Indiquez le motif du refus : il est envoyé au membre.",
  deja_traitee: "Cette demande a déjà été traitée.",
  coupon_absent: "Coupon étudiant non configuré (STRIPE_STUDENT_COUPON_ID) : validation impossible pour l'instant.",
  stripe_erreur: "Stripe n'a pas pu créer le code : rien n'a été modifié, réessayez.",
  erreur: "L'enregistrement n'a pas abouti.",
};

type Demande = {
  id: string;
  user_id: string;
  statut: string;
  annee_universitaire: string;
  file_path: string | null;
  file_name: string | null;
  status: string;
  decision_note: string | null;
  decided_at: string | null;
  promotion_code: string | null;
  applied_to_subscription: boolean;
  created_at: string;
};

const date = (v: string | null) =>
  v ? new Date(v).toLocaleDateString("fr-FR", { day: "numeric", month: "short", year: "numeric", timeZone: "Europe/Paris" }) : "";

// Demandes de tarif professionnel en formation (administrateurs) : justificatif
// consultable par un lien signé de 10 minutes, puis validation ou refus.
export default async function EtudiantsPage({ searchParams }: PageProps<"/bibliotheque/etudiants">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const lib = await loadLibrary(supabase, user.id);
  const admin = createAdminClient();
  const { data } = await admin
    .from("student_discount_requests")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(100);
  const demandes = (data ?? []) as Demande[];
  const attente = demandes.filter((d) => d.status === "en_attente").reverse();
  const traitees = demandes.filter((d) => d.status !== "en_attente").slice(0, 30);

  const ids = [...new Set(demandes.map((d) => d.user_id))];
  const { data: profiles } = ids.length
    ? await admin.from("profiles").select("id, prenom, nom, profession").in("id", ids)
    : { data: [] };
  const personne = new Map(
    ((profiles ?? []) as { id: string; prenom: string | null; nom: string | null; profession: string | null }[]).map((p) => [p.id, p]),
  );
  const emails = new Map<string, string>();
  const liens = new Map<string, string>();
  await Promise.all(
    attente.map(async (d) => {
      const [{ data: u }, signed] = await Promise.all([
        admin.auth.admin.getUserById(d.user_id),
        d.file_path ? admin.storage.from("justificatifs").createSignedUrl(d.file_path, 600) : Promise.resolve({ data: null }),
      ]);
      if (u?.user?.email) emails.set(d.user_id, u.user.email);
      if (signed.data?.signedUrl) liens.set(d.id, signed.data.signedUrl);
    }),
  );

  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;
  const card = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "14px 16px" };
  const nom = (id: string) => {
    const p = personne.get(id);
    return [p?.prenom, p?.nom].filter(Boolean).join(" ") || "Membre";
  };

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Professionnels en formation</h1>
        <div className="doc-header__meta">
          <span>−30 % la première année sur justificatif de l&apos;année universitaire en cours (CGV §4)</span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}

      <h2 className="block-section" style={{ marginTop: 20 }}>
        À valider ({attente.length})
      </h2>
      {attente.length === 0 ? (
        <div className="lib-empty">Aucun justificatif en attente.</div>
      ) : (
        <div style={{ display: "grid", gap: 12 }}>
          {attente.map((d) => (
            <div key={d.id} style={card}>
              <b>{nom(d.user_id)}</b>
              <div style={{ fontSize: "0.86rem", color: "var(--ink-muted)", marginTop: 2 }}>
                {emails.get(d.user_id) ?? ""} · {STATUTS[d.statut] ?? d.statut} · année {d.annee_universitaire} · déposé le{" "}
                {date(d.created_at)}
                {personne.get(d.user_id)?.profession ? ` · profession déclarée : ${personne.get(d.user_id)?.profession}` : ""}
              </div>
              {liens.get(d.id) ? (
                <p style={{ margin: "10px 0" }}>
                  <a href={liens.get(d.id)} target="_blank" rel="noopener noreferrer" className="btn btn-ghost">
                    Voir le justificatif ({d.file_name ?? "fichier"}) ↗
                  </a>
                  <span style={{ fontSize: "0.78rem", color: "var(--ink-muted)", marginLeft: 8 }}>lien valable 10 min</span>
                </p>
              ) : (
                <p style={{ fontSize: "0.86rem" }}>Justificatif introuvable.</p>
              )}
              <form action={deciderEtudiant}>
                <input type="hidden" name="id" value={d.id} />
                <div className="field">
                  <label htmlFor={`note-${d.id}`}>Motif (obligatoire en cas de refus, envoyé au membre)</label>
                  <input id={`note-${d.id}`} name="note" maxLength={1000} placeholder="ex. document d'une année antérieure" />
                </div>
                <div style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
                  <button className="btn btn-primary" name="decision" value="valide">
                    Valider (−30 %)
                  </button>
                  <button className="btn btn-ghost" name="decision" value="refuse">
                    Refuser
                  </button>
                </div>
              </form>
            </div>
          ))}
        </div>
      )}

      <h2 className="block-section" style={{ marginTop: 28 }}>Décisions récentes</h2>
      {traitees.length === 0 ? (
        <div className="lib-empty">Aucune décision pour l&apos;instant.</div>
      ) : (
        <div className="table-scroll">
          <table className="rfe">
            <thead>
              <tr>
                <th>Membre</th>
                <th>Statut</th>
                <th>Décision</th>
                <th>Détail</th>
              </tr>
            </thead>
            <tbody>
              {traitees.map((d) => (
                <tr key={d.id}>
                  <td>{nom(d.user_id)}</td>
                  <td>{STATUTS[d.statut] ?? d.statut}</td>
                  <td>
                    <span className={`state-pill ${d.status === "valide" ? "state-open" : "state-draft"}`}>
                      {d.status === "valide" ? "Validée" : "Refusée"}
                    </span>{" "}
                    {date(d.decided_at)}
                  </td>
                  <td>
                    {d.status === "valide"
                      ? d.applied_to_subscription
                        ? "Remise sur le renouvellement"
                        : `Code ${d.promotion_code ?? ""}`
                      : (d.decision_note ?? "")}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </Shell>
  );
}

import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";

export const metadata: Metadata = {
  title: "Membres inscrits — medical-guidelines.net",
};

const DAY = 24 * 3600 * 1000;

// Heure de la requête (lue une fois, hors du rendu).
function clock() {
  return Date.now();
}

const jour = (v: string | null | undefined) =>
  v ? new Date(v).toLocaleDateString("fr-FR", { day: "numeric", month: "short", year: "numeric", timeZone: "Europe/Paris" }) : "—";

type Statut = "premium" | "retard" | "ancien" | "gratuit" | "equipe";
const STATUTS: Record<Statut, [string, string]> = {
  premium: ["PREMIUM", "state-open"],
  retard: ["Paiement en retard", "state-draft"],
  ancien: ["Ancien abonné", "state-draft"],
  gratuit: ["Gratuit", ""],
  equipe: ["Équipe", "state-open"],
};

type Membre = {
  id: string;
  nom: string;
  email: string;
  profession: string;
  specialite: string;
  inscrit: string;
  derniere: string | null;
  finalise: boolean;
  statut: Statut;
  finAbonnement: string | null;
  fiches: number;
  lectures30: number;
  etudiant: string | null;
};

// Liste des membres inscrits (administrateurs seulement) : identité, métier,
// date d'inscription, dernière connexion, statut d'abonnement et activité.
// Lue avec la clé service_role ; un clic sur le nom ouvre la fiche du membre
// (modification, PREMIUM offert).
export default async function MembresPage({ searchParams }: PageProps<"/[lang]/bibliotheque/membres">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const now = clock();
  const since30 = new Date(now - 30 * DAY).toISOString();
  const lib = await loadLibrary(supabase, user.id);
  const admin = createAdminClient();
  const [profils, abonnements, deblocages, lectures, etudiants, comptes] = await Promise.all([
    admin
      .from("profiles")
      .select("id, nom, prenom, profession, profession_autre, created_at, setup_completed, editorial_role, specialty:specialties(name_i18n)")
      .order("created_at", { ascending: false })
      .limit(1000),
    admin.from("subscriptions").select("user_id, status, current_period_end, created_at").order("created_at", { ascending: false }).limit(2000),
    admin.from("document_unlocks").select("user_id").limit(10000),
    admin.from("consultation_history").select("user_id").gte("viewed_at", since30).limit(10000),
    admin.from("student_discount_requests").select("user_id, status, created_at").order("created_at", { ascending: false }).limit(1000),
    admin.auth.admin.listUsers({ perPage: 1000 }),
  ]);

  const compter = (rows: { user_id: unknown }[] | null) => {
    const m = new Map<string, number>();
    for (const r of rows ?? []) m.set(r.user_id as string, (m.get(r.user_id as string) ?? 0) + 1);
    return m;
  };
  const nbFiches = compter(deblocages.data);
  const nbLectures = compter(lectures.data);
  // Abonnement le plus récent de chaque membre.
  const abo = new Map<string, { status: string; current_period_end: string | null }>();
  for (const s of abonnements.data ?? []) if (!abo.has(s.user_id as string)) abo.set(s.user_id as string, s as { status: string; current_period_end: string | null });
  const etu = new Map<string, string>();
  for (const e of etudiants.data ?? []) if (!etu.has(e.user_id as string)) etu.set(e.user_id as string, e.status as string);
  const auth = new Map((comptes.data?.users ?? []).map((u) => [u.id, u]));

  const membres: Membre[] = (profils.data ?? []).map((p) => {
    const s = p.specialty as { name_i18n: { fr?: string } | null } | { name_i18n: { fr?: string } | null }[] | null;
    const a = abo.get(p.id as string);
    const valide = a && (!a.current_period_end || new Date(a.current_period_end).getTime() > now);
    const statut: Statut = p.editorial_role
      ? "equipe"
      : a?.status === "actif" && valide
        ? "premium"
        : a?.status === "en_retard"
          ? "retard"
          : a
            ? "ancien"
            : "gratuit";
    const u = auth.get(p.id as string);
    return {
      id: p.id as string,
      nom: [p.prenom, p.nom].filter(Boolean).join(" ") || "(nom non renseigné)",
      email: u?.email ?? "",
      profession: (p.profession === "Autre" && p.profession_autre ? p.profession_autre : p.profession) || "—",
      specialite: (Array.isArray(s) ? s[0] : s)?.name_i18n?.fr ?? "",
      inscrit: p.created_at as string,
      derniere: u?.last_sign_in_at ?? null,
      finalise: Boolean(p.setup_completed),
      statut,
      finAbonnement: a?.current_period_end ?? null,
      fiches: nbFiches.get(p.id as string) ?? 0,
      lectures30: nbLectures.get(p.id as string) ?? 0,
      etudiant: etu.get(p.id as string) ?? null,
    };
  });

  const sp = await searchParams;
  const q = typeof sp.q === "string" ? sp.q.trim() : "";
  const filtre = typeof sp.statut === "string" ? sp.statut : "tous";
  const sansAccents = (t: string) => t.toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
  const visibles = membres.filter(
    (m) =>
      (filtre === "tous" ? m.statut !== "equipe" : m.statut === filtre) &&
      (!q || sansAccents(`${m.nom} ${m.email} ${m.profession} ${m.specialite}`).includes(sansAccents(q))),
  );

  const horsEquipe = membres.filter((m) => m.statut !== "equipe");
  const recents = (jours: number) => horsEquipe.filter((m) => now - new Date(m.inscrit).getTime() < jours * DAY).length;
  const chiffres: [string, number, string][] = [
    ["Membres inscrits", horsEquipe.length, "hors équipe éditoriale"],
    ["Nouveaux", recents(7), `cette semaine · ${recents(30)} en 30 j`],
    ["PREMIUM", horsEquipe.filter((m) => m.statut === "premium").length, "abonnement actif"],
    ["Actifs", horsEquipe.filter((m) => m.lectures30 > 0).length, "au moins 1 lecture en 30 j"],
  ];
  const filtres: [string, string][] = [
    ["tous", "Tous"],
    ["premium", "PREMIUM"],
    ["gratuit", "Gratuits"],
    ["retard", "En retard"],
    ["ancien", "Anciens abonnés"],
    ["equipe", "Équipe"],
  ];
  const lien = (statut: string) => {
    const p = new URLSearchParams();
    if (statut !== "tous") p.set("statut", statut);
    if (q) p.set("q", q);
    const s = p.toString();
    return `/bibliotheque/membres${s ? `?${s}` : ""}`;
  };
  const card = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "14px 16px" };

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Membres inscrits</h1>
        <div className="doc-header__meta">
          <span>Données personnelles : à consulter pour la gestion du site uniquement, ne pas exporter ni partager.</span>
        </div>
      </div>

      {profils.error ? (
        <div className="panel warn">Lecture des membres impossible : vérifier Supabase.</div>
      ) : (
        <>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(140px, 1fr))", gap: 10, marginTop: 16 }}>
            {chiffres.map(([label, n, sub]) => (
              <div key={label} style={card}>
                <div style={{ fontFamily: "var(--font-display)", fontSize: "1.7rem", fontWeight: 800, color: "var(--brand-ink)", lineHeight: 1.1 }}>{n}</div>
                <div style={{ fontSize: "0.82rem", fontWeight: 600, marginTop: 4 }}>{label}</div>
                <div style={{ fontSize: "0.76rem", color: "var(--ink-muted)", marginTop: 2 }}>{sub}</div>
              </div>
            ))}
          </div>

          <form method="get" style={{ display: "flex", gap: 8, flexWrap: "wrap", marginTop: 20 }}>
            {filtre !== "tous" && <input type="hidden" name="statut" value={filtre} />}
            <input
              type="search"
              name="q"
              defaultValue={q}
              placeholder="Nom, e-mail, profession…"
              aria-label="Rechercher un membre"
              style={{ flex: "1 1 220px", minWidth: 0 }}
            />
            <button className="btn btn-ghost btn-sm">Rechercher</button>
          </form>
          <div style={{ display: "flex", gap: 6, flexWrap: "wrap", marginTop: 10 }}>
            {filtres.map(([v, label]) => (
              <Link key={v} href={lien(v)} className={`btn btn-sm ${filtre === v ? "" : "btn-ghost"}`}>
                {label}
              </Link>
            ))}
          </div>

          <p style={{ fontSize: "0.85rem", color: "var(--ink-muted)", marginTop: 12 }}>
            {visibles.length} membre(s) affiché(s){profils.data && profils.data.length >= 1000 ? " (1 000 premiers comptes seulement)" : ""}.
          </p>

          {visibles.length === 0 ? (
            <div className="lib-empty">Aucun membre ne correspond.</div>
          ) : (
            <div className="table-scroll">
              <table className="rfe">
                <thead>
                  <tr>
                    <th>Membre</th>
                    <th>Profession</th>
                    <th>Statut</th>
                    <th>Inscrit le</th>
                    <th>Dernière connexion</th>
                    <th>Activité</th>
                  </tr>
                </thead>
                <tbody>
                  {visibles.map((m) => (
                    <tr key={m.id}>
                      <td>
                        <Link href={`/bibliotheque/membres/${m.id}`} style={{ fontWeight: 700 }}>
                          {m.nom}
                        </Link>
                        <br />
                        <span style={{ fontSize: "0.82rem", color: "var(--ink-muted)", wordBreak: "break-all" }}>{m.email}</span>
                      </td>
                      <td>
                        {m.profession}
                        {m.specialite && (
                          <>
                            <br />
                            <span style={{ fontSize: "0.82rem", color: "var(--ink-muted)" }}>{m.specialite}</span>
                          </>
                        )}
                        {m.etudiant && (
                          <>
                            <br />
                            <span style={{ fontSize: "0.78rem", color: "var(--ink-muted)" }}>
                              En formation : {m.etudiant === "valide" ? "justificatif validé" : m.etudiant === "refuse" ? "justificatif refusé" : "justificatif à vérifier"}
                            </span>
                          </>
                        )}
                      </td>
                      <td>
                        <span className={`state-pill ${STATUTS[m.statut][1]}`}>{STATUTS[m.statut][0]}</span>
                        {m.statut === "premium" && m.finAbonnement && (
                          <div style={{ fontSize: "0.78rem", color: "var(--ink-muted)", marginTop: 4 }}>jusqu&apos;au {jour(m.finAbonnement)}</div>
                        )}
                        {!m.finalise && <div style={{ fontSize: "0.78rem", color: "var(--ink-muted)", marginTop: 4 }}>Compte non finalisé</div>}
                      </td>
                      <td>{jour(m.inscrit)}</td>
                      <td>{m.derniere ? jour(m.derniere) : "Jamais"}</td>
                      <td style={{ fontSize: "0.85rem" }}>
                        {m.fiches} fiche(s) débloquée(s)
                        <br />
                        {m.lectures30} lecture(s) en 30 j
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </>
      )}
    </Shell>
  );
}

"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useRef, useState } from "react";
import { ETATS, type Etat, type LigneTableau } from "@/lib/demandes-accord-etats";
import { envoyerDemande, genererDemande, releverDemande, validerDemande } from "./actions";

type Operation = "relever" | "generer" | "valider" | "envoyer";

const OPERATIONS: Record<Operation, { libelle: string; eligible: (l: LigneTableau) => boolean; fn: (id: string) => Promise<{ ok: boolean; message: string }> }> = {
  relever: { libelle: "Relever les adresses", eligible: (l) => Boolean(l.site), fn: releverDemande },
  // En lot, seulement les courriels pas encore générés : un texte relu n'est
  // jamais écrasé (régénération une par une, sur la fiche de la société).
  generer: { libelle: "Générer les courriels", eligible: (l) => l.etat === "a_preparer", fn: genererDemande },
  valider: { libelle: "Valider", eligible: (l) => l.etat === "pret" || l.etat === "erreur", fn: validerDemande },
  envoyer: { libelle: "Envoyer", eligible: (l) => l.etat === "valide", fn: envoyerDemande },
};

const date = (v: string | null) =>
  v ? new Date(v).toLocaleDateString("fr-FR", { day: "numeric", month: "short", year: "numeric", timeZone: "Europe/Paris" }) : "";

// Liste des sociétés : filtres, sélection, opérations groupées (une société
// à la fois, avec une pause entre deux envois).
export default function Tableau({ lignes, plafond, envoisJour }: { lignes: LigneTableau[]; plafond: number; envoisJour: number }) {
  const router = useRouter();
  const [etat, setEtat] = useState<Etat | "tous">("tous");
  const [specialite, setSpecialite] = useState("");
  const [recherche, setRecherche] = useState("");
  const [avecAdresse, setAvecAdresse] = useState(false);
  const [choix, setChoix] = useState<Set<string>>(new Set());
  const [pause, setPause] = useState(30);
  const [journal, setJournal] = useState<{ ok: boolean; message: string }[]>([]);
  const [enCours, setEnCours] = useState<Operation | null>(null);
  const arret = useRef(false);

  const specialites = useMemo(() => [...new Set(lignes.map((l) => l.specialite ?? "À préciser"))].sort((a, b) => a.localeCompare(b, "fr")), [lignes]);
  const filtrees = useMemo(() => {
    const q = recherche.trim().toLowerCase();
    return lignes.filter(
      (l) =>
        (etat === "tous" || l.etat === etat) &&
        (!specialite || (l.specialite ?? "À préciser") === specialite) &&
        (!avecAdresse || l.nb_adresses > 0) &&
        (!q || `${l.sigle} ${l.nom ?? ""} ${l.destinataires.join(" ")}`.toLowerCase().includes(q)),
    );
  }, [lignes, etat, specialite, recherche, avecAdresse]);
  const comptes = useMemo(() => {
    const c: Record<string, number> = {};
    for (const l of lignes) c[l.etat] = (c[l.etat] ?? 0) + 1;
    return c;
  }, [lignes]);

  const selection = lignes.filter((l) => choix.has(l.id));
  const basculer = (id: string) =>
    setChoix((s) => {
      const n = new Set(s);
      if (n.has(id)) n.delete(id);
      else n.add(id);
      return n;
    });

  async function lancer(op: Operation) {
    const cibles = selection.filter(OPERATIONS[op].eligible);
    if (!cibles.length) {
      setJournal([{ ok: false, message: `${OPERATIONS[op].libelle} : aucune société sélectionnée ne s'y prête.` }]);
      return;
    }
    if (op === "envoyer") {
      const reste = Math.max(0, plafond - envoisJour);
      if (!window.confirm(`Envoyer ${cibles.length} demande(s) validée(s), une toutes les ${pause} s ?\n(${reste} envoi(s) encore possible(s) sur 24 h.)`)) return;
    }
    arret.current = false;
    setEnCours(op);
    setJournal([]);
    let erreursSuite = 0;
    for (const [i, l] of cibles.entries()) {
      if (arret.current) {
        setJournal((j) => [...j, { ok: false, message: "Arrêté à la demande." }]);
        break;
      }
      const r = await OPERATIONS[op].fn(l.id);
      setJournal((j) => [...j, r]);
      erreursSuite = r.ok ? 0 : erreursSuite + 1;
      if (op === "envoyer" && (erreursSuite >= 3 || r.message.startsWith("Plafond"))) {
        setJournal((j) => [...j, { ok: false, message: "Envois arrêtés (plafond ou 3 erreurs de suite)." }]);
        break;
      }
      if (op === "envoyer" && i < cibles.length - 1) await new Promise((res) => setTimeout(res, pause * 1000));
    }
    setEnCours(null);
    router.refresh();
  }

  const carte = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "12px 14px" };

  return (
    <div style={{ display: "grid", gap: 14 }}>
      <div style={{ display: "flex", gap: 6, flexWrap: "wrap" }}>
        <button type="button" className={`chip ${etat === "tous" ? "chip-accent" : "chip-neutral"}`} onClick={() => setEtat("tous")}>
          Toutes ({lignes.length})
        </button>
        {(Object.keys(ETATS) as Etat[])
          .filter((e) => comptes[e])
          .map((e) => (
            <button key={e} type="button" className={`chip ${etat === e ? "chip-accent" : "chip-neutral"}`} onClick={() => setEtat(e)}>
              {ETATS[e].libelle} ({comptes[e]})
            </button>
          ))}
      </div>

      <div style={{ display: "flex", gap: 10, flexWrap: "wrap", alignItems: "center" }}>
        <input
          className="lib-search"
          style={{ flex: "1 1 220px", minWidth: 180 }}
          placeholder="Rechercher un sigle, un nom, une adresse"
          value={recherche}
          onChange={(e) => setRecherche(e.target.value)}
          aria-label="Rechercher"
        />
        <select value={specialite} onChange={(e) => setSpecialite(e.target.value)} aria-label="Spécialité">
          <option value="">Toutes les spécialités</option>
          {specialites.map((s) => (
            <option key={s} value={s}>
              {s}
            </option>
          ))}
        </select>
        <label style={{ display: "inline-flex", gap: 6, alignItems: "center", fontSize: "0.9rem" }}>
          <input type="checkbox" checked={avecAdresse} onChange={(e) => setAvecAdresse(e.target.checked)} />
          Avec adresse
        </label>
      </div>

      <div style={{ ...carte, display: "grid", gap: 10 }}>
        <div style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "center" }}>
          <b>{selection.length} sélectionnée(s)</b>
          <button type="button" className="btn btn-ghost btn-sm" onClick={() => setChoix(new Set(filtrees.map((l) => l.id)))}>
            Sélectionner la liste affichée ({filtrees.length})
          </button>
          <button type="button" className="btn btn-ghost btn-sm" onClick={() => setChoix(new Set())}>
            Vider la sélection
          </button>
        </div>
        <div style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "center" }}>
          {(Object.keys(OPERATIONS) as Operation[]).map((op) => (
            <button
              key={op}
              type="button"
              className={`btn btn-sm ${op === "envoyer" ? "btn-primary" : "btn-ghost"}`}
              disabled={Boolean(enCours) || !selection.some(OPERATIONS[op].eligible)}
              onClick={() => void lancer(op)}
            >
              {OPERATIONS[op].libelle} ({selection.filter(OPERATIONS[op].eligible).length})
            </button>
          ))}
          <label style={{ display: "inline-flex", gap: 6, alignItems: "center", fontSize: "0.86rem" }}>
            Pause entre deux envois
            <input type="number" min={10} max={600} value={pause} onChange={(e) => setPause(Math.max(10, Number(e.target.value) || 30))} style={{ width: 70 }} />s
          </label>
          {enCours && (
            <button type="button" className="btn btn-ghost btn-sm" onClick={() => (arret.current = true)}>
              Arrêter
            </button>
          )}
        </div>
        <div style={{ fontSize: "0.82rem", color: "var(--ink-muted)" }}>
          Envois sur 24 h : {envoisJour} / {plafond}. Seules les demandes validées partent ; chacune une seule fois.
        </div>
        {journal.length > 0 && (
          <ol style={{ margin: 0, paddingLeft: 20, fontSize: "0.86rem", maxHeight: 220, overflow: "auto" }} aria-live="polite">
            {journal.map((j, i) => (
              <li key={i} style={{ color: j.ok ? "inherit" : "var(--crit, #B42318)" }}>
                {j.message}
              </li>
            ))}
            {enCours && <li>…</li>}
          </ol>
        )}
      </div>

      <div className="table-scroll">
        <table className="rfe" style={{ width: "100%", fontSize: "0.88rem" }}>
          <thead>
            <tr>
              <th style={{ width: 28 }} aria-label="Sélection" />
              <th>Société</th>
              <th>Spécialité</th>
              <th>État</th>
              <th>Destinataires</th>
              <th>Pièce jointe</th>
              <th>Fiches</th>
              <th>Envoyée</th>
            </tr>
          </thead>
          <tbody>
            {filtrees.map((l) => (
              <tr key={l.id}>
                <td>
                  <input type="checkbox" checked={choix.has(l.id)} onChange={() => basculer(l.id)} aria-label={`Sélectionner ${l.sigle}`} />
                </td>
                <td>
                  <Link href={`/bibliotheque/demandes-accord/${l.societe_slug}`} style={{ fontWeight: 700 }}>
                    {l.sigle}
                  </Link>
                  {l.priorite ? <span className="chip chip-warn" style={{ marginLeft: 6 }}>n° {l.priorite}</span> : null}
                  <div style={{ color: "var(--ink-muted)", fontSize: "0.8rem" }}>{l.nom}</div>
                </td>
                <td style={{ fontSize: "0.8rem" }}>{l.specialite}</td>
                <td>
                  <span className={`chip chip-${ETATS[l.etat].ton}`}>{ETATS[l.etat].libelle}</span>
                </td>
                <td style={{ fontSize: "0.8rem" }}>
                  {l.destinataires.length ? l.destinataires.join(", ") : l.nb_adresses ? `${l.nb_adresses} adresse(s), aucune choisie` : "—"}
                </td>
                <td style={{ fontSize: "0.8rem" }}>{l.piece_jointe === "propre" ? "Propre" : l.piece_jointe === "defaut" ? "Par défaut" : "—"}</td>
                <td>{l.nb_fiches || ""}</td>
                <td style={{ fontSize: "0.8rem" }}>{date(l.envoye_le)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {!filtrees.length && <div className="lib-empty">Aucune société ne correspond à ces filtres.</div>}
    </div>
  );
}

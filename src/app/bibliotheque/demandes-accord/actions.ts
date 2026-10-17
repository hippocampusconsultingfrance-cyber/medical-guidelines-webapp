"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import {
  ADRESSE,
  BUCKET,
  choisirDestinataires,
  debutFenetreEnvois,
  envoyerCourriel,
  genererCourriel,
  genererRelance,
  piedDePage,
  plafondJour,
  texteVersHtml,
  type Demande,
  type Modele,
} from "@/lib/demandes-accord";
import { ETATS_PARTIS, estEtat, type Adresse } from "@/lib/demandes-accord-etats";
import { releverAdresses } from "@/lib/demandes-accord-releve";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

type Resultat = { ok: boolean; message: string };
type Admin = ReturnType<typeof createAdminClient>;

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const RACINE = "/bibliotheque/demandes-accord";
const RELANCE_DELAI_JOURS = 7;

// Chaque action vérifie le compte (administrateur, double authentification
// faite : public.is_admin) avant d'écrire avec la clé service_role.
async function exigerAdmin() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) throw new Error("Connexion requise.");
  const { data: estAdmin } = await supabase.rpc("is_admin");
  if (!estAdmin) throw new Error("Réservé aux administrateurs (double authentification faite).");
  return user.id;
}

async function charger(admin: Admin, id: string) {
  if (!UUID.test(id)) return null;
  const { data } = await admin.from("demandes_accord").select("*").eq("id", id).maybeSingle();
  return (data as Demande | null) ?? null;
}

async function chargerModele(admin: Admin) {
  const { data, error } = await admin.from("demandes_accord_modele").select("*").eq("id", 1).single();
  if (error || !data) throw new Error("Modèle de courriel introuvable (migration appliquée ?).");
  return data as Modele;
}

async function noter(admin: Admin, demandeId: string, evenement: string, detail: string, auteur: string) {
  await admin.from("demandes_accord_journal").insert({ demande_id: demandeId, evenement, detail: detail.slice(0, 2000), auteur });
}

async function enCours(fn: () => Promise<Resultat>): Promise<Resultat> {
  try {
    return await fn();
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : "Erreur inattendue." };
  }
}

// Relève les adresses publiées sur le site de la société et les ajoute à
// celles déjà connues ; propose des destinataires s'il n'y en a pas.
export async function releverDemande(id: string): Promise<Resultat> {
  return enCours(async () => {
    const auteur = await exigerAdmin();
    const admin = createAdminClient();
    const d = await charger(admin, id);
    if (!d) return { ok: false, message: "Demande introuvable." };
    if (!d.site) return { ok: false, message: `${d.sigle} : pas de site connu, rien à relever.` };
    const r = await releverAdresses(d.site, d.sigle);
    const connues = new Map(d.adresses.map((a) => [a.adresse, a]));
    let nouvelles = 0;
    for (const a of r.adresses) {
      if (!connues.has(a.adresse)) {
        connues.set(a.adresse, a);
        nouvelles++;
      }
    }
    const adresses = [...connues.values()];
    const destinataires =
      d.destinataires.length || ETATS_PARTIS.includes(d.etat) ? d.destinataires : choisirDestinataires(adresses);
    await admin
      .from("demandes_accord")
      .update({ adresses, destinataires, releve_le: new Date().toISOString(), modifie_le: new Date().toISOString() })
      .eq("id", id);
    const detail = `${r.pages} page(s) lue(s), ${r.adresses.length} adresse(s) de la société, dont ${nouvelles} nouvelle(s)${
      r.formulaire ? ` ; formulaire de contact : ${r.formulaire}` : ""
    }`;
    await noter(admin, id, "releve", detail, auteur);
    return { ok: true, message: `${d.sigle} : ${detail}.` };
  });
}

// (Re)génère le courriel depuis le modèle. Refusé une fois parti.
export async function genererDemande(id: string): Promise<Resultat> {
  return enCours(async () => {
    const auteur = await exigerAdmin();
    const admin = createAdminClient();
    const d = await charger(admin, id);
    if (!d) return { ok: false, message: "Demande introuvable." };
    if (ETATS_PARTIS.includes(d.etat)) return { ok: false, message: `${d.sigle} : déjà envoyée ou close, courriel non modifié.` };
    const { corps } = genererCourriel(await chargerModele(admin), d);
    const etat = d.destinataires.length ? "pret" : "a_preparer";
    await admin.from("demandes_accord").update({ corps, etat, erreur: null, modifie_le: new Date().toISOString() }).eq("id", id);
    await noter(admin, id, "generation", "Courriel généré depuis le modèle", auteur);
    return {
      ok: true,
      message: d.destinataires.length ? `${d.sigle} : courriel prêt à relire.` : `${d.sigle} : courriel généré, mais aucun destinataire.`,
    };
  });
}

// Validation après relecture : destinataires, texte complet, pièce jointe.
export async function validerDemande(id: string): Promise<Resultat> {
  return enCours(async () => {
    const auteur = await exigerAdmin();
    const admin = createAdminClient();
    const d = await charger(admin, id);
    if (!d) return { ok: false, message: "Demande introuvable." };
    if (!["pret", "erreur"].includes(d.etat)) return { ok: false, message: `${d.sigle} : à générer et relire d'abord.` };
    if (!d.destinataires.length) return { ok: false, message: `${d.sigle} : aucun destinataire.` };
    if (d.destinataires.some((a) => !ADRESSE.test(a))) return { ok: false, message: `${d.sigle} : adresse invalide.` };
    if (!d.corps?.trim()) return { ok: false, message: `${d.sigle} : courriel vide.` };
    if (/\{\{|\[(Madame|Monsieur|à compléter|adresse)/i.test(d.corps)) {
      return { ok: false, message: `${d.sigle} : le courriel contient encore un repère à compléter ({{…}} ou [...]).` };
    }
    const m = await chargerModele(admin);
    if (!d.piece_jointe_chemin && !m.piece_jointe_chemin) {
      return { ok: false, message: `${d.sigle} : aucune pièce jointe (propre à la société ou par défaut, page Modèle).` };
    }
    await admin.from("demandes_accord").update({ etat: "valide", erreur: null, modifie_le: new Date().toISOString() }).eq("id", id);
    await noter(admin, id, "validation", `Destinataires : ${d.destinataires.join(", ")}`, auteur);
    return { ok: true, message: `${d.sigle} : validée, prête à partir.` };
  });
}

async function envoisRecents(admin: Admin) {
  const depuis = debutFenetreEnvois();
  const { count } = await admin
    .from("demandes_accord_journal")
    .select("id", { count: "exact", head: true })
    .in("evenement", ["envoi", "relance"])
    .gte("cree_le", depuis);
  return count ?? 0;
}

async function pieceJointe(admin: Admin, d: Demande, m: Modele) {
  const chemin = d.piece_jointe_chemin ?? m.piece_jointe_chemin;
  if (!chemin) return null;
  const { data, error } = await admin.storage.from(BUCKET).download(chemin);
  if (error || !data) throw new Error("Pièce jointe introuvable dans le stockage.");
  const nom = (d.piece_jointe_chemin ? d.piece_jointe_nom : m.piece_jointe_nom) ?? "piece-jointe.pdf";
  return { nom, contenu: new Uint8Array(await data.arrayBuffer()) };
}

// Envoi d'une demande validée : réservée d'abord (une seule fois, même si
// le bouton est cliqué deux fois), puis envoyée avec sa pièce jointe.
export async function envoyerDemande(id: string): Promise<Resultat> {
  return enCours(async () => {
    const auteur = await exigerAdmin();
    const admin = createAdminClient();
    if (!UUID.test(id)) return { ok: false, message: "Demande introuvable." };
    const plafond = plafondJour();
    if ((await envoisRecents(admin)) >= plafond) {
      return { ok: false, message: `Plafond atteint : ${plafond} envois sur 24 h (DEMANDES_PLAFOND_JOUR). Reprenez demain.` };
    }
    const { data: reserve } = await admin
      .from("demandes_accord")
      .update({ etat: "envoi_en_cours", modifie_le: new Date().toISOString() })
      .eq("id", id)
      .eq("etat", "valide")
      .select("*")
      .maybeSingle();
    const d = reserve as Demande | null;
    if (!d) return { ok: false, message: "Demande non validée, ou déjà envoyée." };
    let resultat: Resultat = { ok: false, message: `${d.sigle} : envoi interrompu.` };
    try {
      const m = await chargerModele(admin);
      const objet = d.objet?.trim() || m.objet;
      const corps = d.corps ?? "";
      const pied = piedDePage(d);
      const envoi = await envoyerCourriel({
        a: d.destinataires,
        objet,
        texte: `${corps}\n\n—\n${pied}`,
        html: texteVersHtml(corps, pied),
        pieceJointe: await pieceJointe(admin, d, m),
        cle: `demande-${d.id}-${d.nb_envois + 1}`,
      });
      if (envoi.ok) {
        await admin
          .from("demandes_accord")
          .update({
            etat: "envoye",
            envoye_le: new Date().toISOString(),
            envoi_id: envoi.id || null,
            nb_envois: d.nb_envois + 1,
            erreur: null,
            modifie_le: new Date().toISOString(),
          })
          .eq("id", d.id);
        await noter(admin, d.id, "envoi", `À ${d.destinataires.join(", ")}`, auteur);
        resultat = { ok: true, message: `${d.sigle} : envoyée à ${d.destinataires.join(", ")}.` };
      } else {
        resultat = { ok: false, message: `${d.sigle} : ${envoi.erreur}` };
      }
    } catch (e) {
      resultat = { ok: false, message: `${d.sigle} : ${e instanceof Error ? e.message : "erreur inattendue"}` };
    } finally {
      if (!resultat.ok) {
        await admin
          .from("demandes_accord")
          .update({ etat: "erreur", erreur: resultat.message, modifie_le: new Date().toISOString() })
          .eq("id", d.id)
          .eq("etat", "envoi_en_cours");
        await noter(admin, d.id, "erreur", resultat.message, auteur);
      }
    }
    return resultat;
  });
}

// Relance d'une demande envoyée depuis au moins 7 jours, sans réponse : un
// court message, le courriel initial cité dessous, la même pièce jointe.
export async function relancerDemande(id: string): Promise<Resultat> {
  return enCours(async () => {
    const auteur = await exigerAdmin();
    const admin = createAdminClient();
    const d0 = await charger(admin, id);
    if (!d0) return { ok: false, message: "Demande introuvable." };
    if (d0.etat !== "envoye" || !d0.envoye_le) return { ok: false, message: `${d0.sigle} : seule une demande envoyée, sans réponse, se relance.` };
    const jours = (Date.now() - new Date(d0.envoye_le).getTime()) / 86_400_000;
    if (jours < RELANCE_DELAI_JOURS) {
      return { ok: false, message: `${d0.sigle} : envoyée il y a ${Math.floor(jours)} jour(s) ; relance possible après ${RELANCE_DELAI_JOURS} jours.` };
    }
    const plafond = plafondJour();
    if ((await envoisRecents(admin)) >= plafond) return { ok: false, message: `Plafond atteint : ${plafond} envois sur 24 h.` };
    const { data: reserve } = await admin
      .from("demandes_accord")
      .update({ etat: "envoi_en_cours", modifie_le: new Date().toISOString() })
      .eq("id", id)
      .eq("etat", "envoye")
      .select("*")
      .maybeSingle();
    const d = reserve as Demande | null;
    if (!d) return { ok: false, message: "Demande déjà en cours d'envoi." };
    let resultat: Resultat = { ok: false, message: `${d.sigle} : relance interrompue.` };
    try {
      const m = await chargerModele(admin);
      const { objet, corps } = genererRelance(m, d);
      const pied = piedDePage(d);
      const envoi = await envoyerCourriel({
        a: d.destinataires,
        objet,
        texte: `${corps}\n\n—\n${pied}`,
        html: texteVersHtml(corps, pied),
        pieceJointe: await pieceJointe(admin, d, m),
        cle: `demande-${d.id}-${d.nb_envois + 1}`,
      });
      if (envoi.ok) {
        await admin
          .from("demandes_accord")
          .update({ etat: "relance", relance_le: new Date().toISOString(), nb_envois: d.nb_envois + 1, erreur: null, modifie_le: new Date().toISOString() })
          .eq("id", d.id);
        await noter(admin, d.id, "relance", `À ${d.destinataires.join(", ")}`, auteur);
        resultat = { ok: true, message: `${d.sigle} : relance envoyée.` };
      } else {
        resultat = { ok: false, message: `${d.sigle} : ${envoi.erreur}` };
      }
    } catch (e) {
      resultat = { ok: false, message: `${d.sigle} : ${e instanceof Error ? e.message : "erreur inattendue"}` };
    } finally {
      if (!resultat.ok) {
        // Le premier courriel est bien parti : la demande reste « envoyée ».
        await admin.from("demandes_accord").update({ etat: "envoye", erreur: resultat.message }).eq("id", d.id).eq("etat", "envoi_en_cours");
        await noter(admin, d.id, "erreur", resultat.message, auteur);
      }
    }
    return resultat;
  });
}

const retour = (slug: string, r: Resultat) =>
  `${RACINE}/${encodeURIComponent(slug)}?${r.ok ? "ok" : "ko"}=${encodeURIComponent(r.message.slice(0, 300))}`;

// Boutons de la fiche d'une société (un formulaire, un bouton par opération).
export async function operationFiche(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const slug = String(formData.get("slug") ?? "");
  const op = String(formData.get("op") ?? "");
  const ops: Record<string, (id: string) => Promise<Resultat>> = {
    relever: releverDemande,
    generer: genererDemande,
    valider: validerDemande,
    envoyer: envoyerDemande,
    relancer: relancerDemande,
  };
  const fn = ops[op];
  const r = fn ? await fn(id) : { ok: false, message: "Opération inconnue." };
  revalidatePath(RACINE);
  redirect(retour(slug, r));
}

const texte = (formData: FormData, nom: string, max: number) => {
  const v = String(formData.get(nom) ?? "").replace(/\r\n/g, "\n").trim();
  return v ? v.slice(0, max) : null;
};

// Enregistre les réglages et le texte d'une demande. Une demande validée
// repasse « à relire » si son contenu change ; une demande partie ne garde
// modifiables que ses notes.
export async function enregistrerDemande(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const slug = String(formData.get("slug") ?? "");
  const r = await enCours(async () => {
    const auteur = await exigerAdmin();
    const admin = createAdminClient();
    const d = await charger(admin, id);
    if (!d) return { ok: false, message: "Demande introuvable." };
    const notes = texte(formData, "notes", 4000);
    if (ETATS_PARTIS.includes(d.etat)) {
      await admin.from("demandes_accord").update({ notes, modifie_le: new Date().toISOString() }).eq("id", id);
      return { ok: true, message: "Notes enregistrées (la demande est partie : le reste n'est plus modifiable)." };
    }
    const cochees = formData.getAll("destinataires").map((v) => String(v).trim().toLowerCase());
    const ajoutees = String(formData.get("autres_destinataires") ?? "")
      .split(/[\s,;]+/)
      .map((v) => v.trim().toLowerCase())
      .filter(Boolean);
    const invalides = ajoutees.filter((a) => !ADRESSE.test(a));
    if (invalides.length) return { ok: false, message: `Adresse invalide : ${invalides.join(", ")}` };
    const destinataires = [...new Set([...cochees.filter((a) => ADRESSE.test(a)), ...ajoutees])].slice(0, 4);
    const adresses: Adresse[] = [...d.adresses];
    for (const a of ajoutees) {
      if (!adresses.some((x) => x.adresse === a)) adresses.push({ adresse: a, nature: "ajoutée à la main", page: "" });
    }
    const maj = {
      destinataires,
      adresses,
      designation: texte(formData, "designation", 120),
      formule_appel: texte(formData, "formule_appel", 200),
      objet: texte(formData, "objet", 300),
      corps: texte(formData, "corps", 30000),
      exemple: texte(formData, "exemple", 4000),
      revues: texte(formData, "revues", 300),
      paragraphe_specifique: texte(formData, "paragraphe_specifique", 4000),
      notes,
    };
    const change = (["destinataires", "designation", "formule_appel", "objet", "corps"] as const).some(
      (k) => JSON.stringify(maj[k] ?? null) !== JSON.stringify(d[k] ?? null),
    );
    const etat = d.etat === "valide" && change ? "pret" : d.etat;
    await admin.from("demandes_accord").update({ ...maj, etat, modifie_le: new Date().toISOString() }).eq("id", id);
    await noter(admin, id, "modification", etat !== d.etat ? "Modifiée après validation : à valider de nouveau" : "Réglages enregistrés", auteur);
    return { ok: true, message: etat !== d.etat ? "Enregistré ; la demande est à valider de nouveau." : "Enregistré." };
  });
  revalidatePath(RACINE);
  redirect(retour(slug, r));
}

const ETATS_MANUELS = ["reponse", "accord", "refus", "ne_pas_contacter", "pret"] as const;

// Suivi : réponse reçue, accord, refus, ne plus contacter, ou réouverture
// d'une demande non partie.
export async function changerEtat(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const slug = String(formData.get("slug") ?? "");
  const etat = String(formData.get("etat") ?? "");
  const note = texte(formData, "note", 1000);
  const r = await enCours(async () => {
    const auteur = await exigerAdmin();
    const admin = createAdminClient();
    const d = await charger(admin, id);
    if (!d) return { ok: false, message: "Demande introuvable." };
    if (!estEtat(etat) || !(ETATS_MANUELS as readonly string[]).includes(etat)) return { ok: false, message: "État non reconnu." };
    if (etat === "pret" && !["valide", "erreur", "ne_pas_contacter", "a_preparer"].includes(d.etat)) {
      return { ok: false, message: "Seule une demande non partie se rouvre." };
    }
    if (d.etat === "envoi_en_cours") return { ok: false, message: "Envoi en cours : attendez la fin." };
    const reponse = ["reponse", "accord", "refus"].includes(etat) ? { reponse_le: new Date().toISOString() } : {};
    await admin.from("demandes_accord").update({ etat, ...reponse, modifie_le: new Date().toISOString() }).eq("id", id);
    await noter(admin, id, `etat:${etat}`, note ?? "", auteur);
    return { ok: true, message: "Suivi enregistré." };
  });
  revalidatePath(RACINE);
  redirect(retour(slug, r));
}

const NOM_FICHIER = /[^A-Za-z0-9._-]+/g;

// Dépôt d'une pièce jointe (PDF) : lien de dépôt signé, le navigateur envoie
// le fichier directement au stockage (pas de limite de taille des actions).
export async function preparerDepot(cible: string, nomFichier: string) {
  try {
    await exigerAdmin();
  } catch (e) {
    return { ok: false as const, message: e instanceof Error ? e.message : "Accès refusé." };
  }
  if (cible !== "modele" && !UUID.test(cible)) return { ok: false as const, message: "Cible inconnue." };
  if (!/\.pdf$/i.test(nomFichier)) return { ok: false as const, message: "PDF seulement." };
  const chemin = `${cible}/${Date.now()}-${nomFichier.replace(NOM_FICHIER, "_").slice(-120)}`;
  const { data, error } = await createAdminClient().storage.from(BUCKET).createSignedUploadUrl(chemin);
  if (error || !data) return { ok: false as const, message: "Dépôt impossible (bucket « demandes-accord » créé ?)." };
  return { ok: true as const, chemin, jeton: data.token };
}

export async function enregistrerPieceJointe(cible: string, chemin: string, nom: string): Promise<Resultat> {
  return enCours(async () => {
    const auteur = await exigerAdmin();
    if (cible !== "modele" && !UUID.test(cible)) return { ok: false, message: "Cible inconnue." };
    if (!chemin.startsWith(`${cible}/`) || chemin.includes("..")) return { ok: false, message: "Chemin refusé." };
    const admin = createAdminClient();
    const fichier = chemin.slice(cible.length + 1);
    const { data: liste } = await admin.storage.from(BUCKET).list(cible, { search: fichier });
    if (!liste?.some((f) => f.name === fichier)) return { ok: false, message: "Fichier non trouvé dans le stockage." };
    const nomPropre = nom.replace(/[\\/]/g, "_").slice(0, 160) || "piece-jointe.pdf";
    if (cible === "modele") {
      await admin.from("demandes_accord_modele").update({ piece_jointe_chemin: chemin, piece_jointe_nom: nomPropre, modifie_le: new Date().toISOString() }).eq("id", 1);
    } else {
      const d = await charger(admin, cible);
      if (!d) return { ok: false, message: "Demande introuvable." };
      if (ETATS_PARTIS.includes(d.etat)) return { ok: false, message: "Demande partie : pièce jointe non modifiable." };
      await admin
        .from("demandes_accord")
        .update({
          piece_jointe_chemin: chemin,
          piece_jointe_nom: nomPropre,
          etat: d.etat === "valide" ? "pret" : d.etat,
          modifie_le: new Date().toISOString(),
        })
        .eq("id", cible);
      await noter(admin, cible, "piece_jointe", nomPropre, auteur);
    }
    revalidatePath(RACINE, "layout");
    return { ok: true, message: `Pièce jointe enregistrée : ${nomPropre}.` };
  });
}

// Modèle de courriel et de relance.
export async function enregistrerModele(formData: FormData) {
  const r = await enCours(async () => {
    await exigerAdmin();
    const champs = {
      objet: texte(formData, "objet", 300),
      corps: texte(formData, "corps", 30000),
      exemple_defaut: texte(formData, "exemple_defaut", 4000),
      relance_objet: texte(formData, "relance_objet", 300),
      relance_corps: texte(formData, "relance_corps", 10000),
    };
    if (Object.values(champs).some((v) => !v)) return { ok: false, message: "Tous les champs sont obligatoires." };
    await createAdminClient()
      .from("demandes_accord_modele")
      .update({ ...champs, modifie_le: new Date().toISOString() })
      .eq("id", 1);
    return { ok: true, message: "Modèle enregistré. Les courriels déjà générés ne changent pas : régénérez-les si besoin." };
  });
  revalidatePath(RACINE, "layout");
  redirect(`${RACINE}/modele?${r.ok ? "ok" : "ko"}=${encodeURIComponent(r.message)}`);
}

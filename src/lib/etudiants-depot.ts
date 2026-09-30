import "server-only";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import {
  anneeUniversitaire,
  emailNouveauJustificatif,
  JUSTIFICATIF_MAX,
  JUSTIFICATIF_TYPES,
  signatureValide,
  STATUTS,
} from "@/lib/etudiants";
import { createAdminClient } from "@/lib/supabase/admin";

// Dépôt d'un justificatif de médecin en formation (PDF, JPEG ou PNG, 3 Mo au
// plus) dans le bucket privé « justificatifs », avec la clé service_role,
// pour le membre déjà authentifié par l'appelant. Une seule demande en
// attente à la fois. Utilisé à la finalisation du compte (case « en
// formation » cochée à l'inscription) et depuis la page Abonnement.
// Résultat : « etudiant_envoye » ou le motif du refus (clé de message).
export async function deposerJustificatif(
  userId: string,
  formData: FormData,
): Promise<string> {
  const statut = String(formData.get("statut") ?? "");
  const file = formData.get("justificatif");
  if (!(statut in STATUTS)) return "etudiant_statut";
  if (formData.get("atteste") !== "1") return "etudiant_atteste";
  if (!(file instanceof File) || file.size === 0) return "etudiant_fichier";
  const ext = JUSTIFICATIF_TYPES[file.type];
  if (!ext) return "etudiant_format";
  if (file.size > JUSTIFICATIF_MAX) return "etudiant_taille";
  const bytes = new Uint8Array(await file.arrayBuffer());
  if (!signatureValide(bytes, file.type)) return "etudiant_format";

  const admin = createAdminClient();
  const { count } = await admin
    .from("student_discount_requests")
    .select("id", { count: "exact", head: true })
    .eq("user_id", userId)
    .eq("status", "en_attente");
  if ((count ?? 0) > 0) return "etudiant_deja";

  const path = `${userId}/${crypto.randomUUID()}.${ext}`;
  const { error: upError } = await admin.storage
    .from("justificatifs")
    .upload(path, bytes, { contentType: file.type });
  if (upError) {
    console.error("Justificatif : dépôt", upError);
    return "etudiant_erreur";
  }
  const { data: created, error } = await admin
    .from("student_discount_requests")
    .insert({
      user_id: userId,
      statut,
      annee_universitaire: anneeUniversitaire(new Date()),
      file_path: path,
      file_name: file.name.slice(0, 200),
    })
    .select("id")
    .single();
  if (error || !created) {
    console.error("Justificatif : demande", error);
    await admin.storage.from("justificatifs").remove([path]);
    return "etudiant_erreur";
  }
  await prevenirAdmins(admin, statut, created.id as string);
  return "etudiant_envoye";
}

// Avertit les administrateurs d'un nouveau justificatif, sans bloquer le
// membre si l'envoi échoue (la tâche reste visible au tableau de bord).
async function prevenirAdmins(
  admin: ReturnType<typeof createAdminClient>,
  statut: string,
  id: string,
) {
  if (!emailEnabled()) return;
  try {
    const { data: admins } = await admin
      .from("profiles")
      .select("id")
      .eq("editorial_role", "admin");
    const emails: string[] = [];
    for (const a of admins ?? []) {
      const { data } = await admin.auth.admin.getUserById(a.id as string);
      if (data?.user?.email) emails.push(data.user.email);
    }
    if (!emails.length) return;
    const sent = await sendBatch(
      emails.map((to) => emailNouveauJustificatif(to, statut, siteUrl())),
      `justificatif-${id}`,
    );
    if (!sent.ok) console.error("Justificatif : alerte admin", sent.error);
  } catch (e) {
    console.error("Justificatif : alerte admin", e);
  }
}

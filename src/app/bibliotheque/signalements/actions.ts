"use server";

import { redirect } from "next/navigation";
import { CRITICITES } from "@/lib/corrections";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Publie une correction au journal public (administrateurs), depuis un
// signalement (qui passe alors « validé ») ou directement depuis la fiche.
export async function publierCorrection(formData: FormData) {
  const documentId = String(formData.get("document_id") ?? "");
  const reportId = String(formData.get("report_id") ?? "");
  const criticite = String(formData.get("criticite") ?? "");
  const resume = String(formData.get("resume") ?? "").trim().slice(0, 1000);
  const retour = String(formData.get("retour") ?? "") === "fiche" ? `/bibliotheque/${documentId}` : "/bibliotheque/signalements";
  const back = (r: string) => redirect(`${retour}?r=${r}#corrections`);
  if (!UUID.test(documentId)) redirect("/bibliotheque/signalements");
  if (!(criticite in CRITICITES) || resume.length < 5) back("correction_incomplete");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const admin = createAdminClient();
  const { error } = await admin.from("corrections_log").insert({
    document_id: documentId,
    criticite,
    resume,
    error_report_id: UUID.test(reportId) ? reportId : null,
    created_by: user.id,
  });
  if (error) {
    console.error("Journal des corrections", error);
    back("correction_erreur");
  }
  if (UUID.test(reportId)) {
    await admin
      .from("error_reports")
      .update({ status: "valide", decided_at: new Date().toISOString(), decided_by: user.id })
      .eq("id", reportId);
  }
  back("correction_publiee");
}

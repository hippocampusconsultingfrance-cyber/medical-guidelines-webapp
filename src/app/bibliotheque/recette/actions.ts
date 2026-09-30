"use server";

import { redirect } from "next/navigation";
import { RECETTE } from "@/lib/recette";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

// Coche (ou décoche) un critère de recette, daté et signé par
// l'administrateur connecté.
export async function cocherCritere(formData: FormData) {
  const code = String(formData.get("code") ?? "");
  const verifie = formData.get("verifie") === "1";
  const note = String(formData.get("note") ?? "").trim().slice(0, 500) || null;
  if (!RECETTE.some((c) => c.code === code)) redirect("/bibliotheque/recette");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const admin = createAdminClient();
  const { error } = verifie
    ? await admin
        .from("recette_validations")
        .upsert({ code, validated_by: user.id, validated_at: new Date().toISOString(), note })
    : await admin.from("recette_validations").delete().eq("code", code);
  redirect(`/bibliotheque/recette?r=${error ? "erreur" : "ok"}#c-${code}`);
}

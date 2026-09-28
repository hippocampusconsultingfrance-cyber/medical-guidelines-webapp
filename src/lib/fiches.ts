// Doit rester égal à public.free_unlock_quota() (migration 20260928220000) :
// la base fait foi, cette valeur ne sert qu'à l'affichage.
export const FREE_QUOTA = 5;

export function formatDate(value: string | null) {
  if (!value) return null;
  return new Date(`${value}T00:00:00Z`).toLocaleDateString("fr-FR", {
    day: "numeric",
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  });
}

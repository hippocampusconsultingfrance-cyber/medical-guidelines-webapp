// Doit rester égal à public.free_unlock_quota() (migration 20260928220000) :
// la base fait foi, cette valeur ne sert qu'à l'affichage.
export const FREE_QUOTA = 5;

// Les scripts d'import enregistrent au 1er janvier une source dont seule
// l'année est connue : on n'affiche alors que l'année, sans fausse précision.
export function formatDate(value: string | null) {
  if (!value) return null;
  if (value.endsWith("-01-01")) return value.slice(0, 4);
  return new Date(`${value}T00:00:00Z`).toLocaleDateString("fr-FR", {
    day: "numeric",
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  });
}

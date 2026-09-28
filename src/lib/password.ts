// Règle de robustesse des mots de passe, partagée par la finalisation du
// compte et la réinitialisation.
export const PASSWORD_RULE =
  "10 caractères, avec une majuscule, une minuscule et un chiffre";

export function passwordAssezFort(pw: string) {
  return (
    pw.length >= 10 && /[a-z]/.test(pw) && /[A-Z]/.test(pw) && /[0-9]/.test(pw)
  );
}

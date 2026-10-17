import { useId } from "react";

// Logo medical-guidelines.net redessiné en vectoriel (net à toutes les
// tailles) : livre ouvert, pages turquoise et bleu ciel, croix bleu marine.
export const LOGO_COLORS = {
  navy: "#0E3A78",
  teal: "#2BB5A6",
  sky: "#3AA8E0",
};

export function LogoMark({ className }: { className?: string }) {
  const id = useId();
  return (
    <svg viewBox="0 0 120 84" className={className} aria-hidden="true" focusable="false">
      <defs>
        <linearGradient id={`${id}-l`} x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor={LOGO_COLORS.teal} />
          <stop offset="1" stopColor="#35A9C9" />
        </linearGradient>
        <linearGradient id={`${id}-r`} x1="1" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor={LOGO_COLORS.sky} />
          <stop offset="1" stopColor="#3C9FD8" />
        </linearGradient>
      </defs>
      <path
        fill={LOGO_COLORS.navy}
        d="M3 24h7v34c19 0 36 4 50 13 14-9 31-13 50-13V24h7v41c-20 0-38 5-54 15h-6C41 70 23 65 3 65z"
      />
      <path fill={`url(#${id}-l)`} d="M15 13c22 3 38 17 43 45v14c-12-8-27-12-43-12z" />
      <path fill={`url(#${id}-r)`} d="M105 13c-22 3-38 17-43 45v14c12-8 27-12 43-12z" />
      <rect x="54.5" y="1" width="11" height="31" rx="2.5" fill={LOGO_COLORS.navy} />
      <rect x="44.5" y="11" width="31" height="11" rx="2.5" fill={LOGO_COLORS.navy} />
    </svg>
  );
}

// tagline : sous-titre, dans la langue de la page.
export default function Logo({ tagline, className = "" }: { tagline?: string; className?: string }) {
  return (
    <span className={`inline-flex items-center gap-2.5 ${className}`}>
      <LogoMark className="h-7 w-auto shrink-0 sm:h-10" />
      <span className="leading-none">
        <span className="block whitespace-nowrap text-[0.95rem] font-bold tracking-tight sm:text-xl" style={{ color: LOGO_COLORS.navy }}>
          medical-guidelines<span style={{ color: LOGO_COLORS.sky }}>.net</span>
        </span>
        {tagline && (
          <span className="mt-1 block text-[0.7rem] font-medium tracking-wide text-slate-500 sm:text-xs">
            {tagline}
          </span>
        )}
      </span>
    </span>
  );
}

import { MediationTraduite } from "../mediation";
import { CGV_VERSION } from "@/lib/stripe";

// Traduction d'information des CGV (contenu-fr.tsx fait seul foi).
export default function CgvDe() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Verkaufsbedingungen</h1>
      <p className="mt-2 text-slate-500">
        Fassung vom {CGV_VERSION.slice(0, 10).split("-").reverse().join(".")}
        {CGV_VERSION.length > 10 ? ` (Revision ${CGV_VERSION.slice(11)})` : ""}.
      </p>

      <h2 className={h2}>1. Verkäufer</h2>
      <p className="mt-2">
        Hippocampus Consulting, SARL (Gesellschaft mit beschränkter Haftung) mit einem Stammkapital von 1.000 €, 6 rue
        d&apos;Armaillé, 75017 Paris, Frankreich, RCS Paris 999 259 252, Umsatzsteuer-Identifikationsnummer FR43 999 259
        252, Herausgeber der Website medical-guidelines.net. Telefon: +33 9 72 15 24 13. Kontakt:
        contact@medical-guidelines.net.
      </p>

      <h2 className={h2}>2. Angebot</h2>
      <p className="mt-2">
        Das PREMIUM-Abonnement gewährt für die Dauer des Abonnements Zugang zu allen Zusammenfassungen des bei der
        Registrierung gewählten Fachgebiets, ausschließlich zum Online-Lesen. Download, Export oder Druck werden nicht
        angeboten. Die Zusammenfassungen sind unabhängige Zusammenfassungen, die weder die offiziellen Leitlinien noch das
        klinische Urteil ersetzen (siehe{" "}
        <a href="/de/cgu" className="underline">
          Nutzungsbedingungen
        </a>
        ).
      </p>
      <p className="mt-2">
        Das Abonnement vergütet den Dienst: Erstellung und ärztliche Prüfung der Zusammenfassungen, Suchwerkzeuge,
        Benachrichtigungen und Hosting. Die offiziellen Leitliniendokumente werden von der Website weder verkauft noch
        verbreitet: Sie bleiben Werk und Eigentum ihrer Autoren und sind auf deren Websites frei zugänglich, auf die jede
        Zusammenfassung verweist.
      </p>

      <h2 className={h2}>3. Preis</h2>
      <p className="mt-2">
        50 € einschließlich aller Steuern pro Jahr, davon französische Mehrwertsteuer von 20 % (also 41,67 € netto). Der
        zu zahlende Preis, etwaige Rabatte und das Verlängerungsdatum werden vor der Zahlung angezeigt; die Rechnung weist
        die Mehrwertsteuer aus.
      </p>

      <h2 className={h2}>4. Rabatte</h2>
      <p className="mt-2">
        Angebot für Gründungsmitglieder: −30 % im ersten Jahr für die ersten 100 Abonnenten. Tarif für
        Gesundheitsfachpersonen in Ausbildung (Studierende der Medizin oder der Gesundheitsberufe, Ärztinnen und Ärzte in
        Weiterbildung): −30 % im ersten Jahr gegen Vorlage einer Immatrikulationsbescheinigung für das laufende
        Studienjahr, die vom Herausgeber bestätigt wird. Nach Bestätigung des Nachweises wird der persönliche, einmalig
        nutzbare Rabatt automatisch bei der Zahlung angewendet. Bei jeder Verlängerung wird ein neuer Nachweis verlangt.
        Rabatte sind nicht kombinierbar. Der Nachweis wird nur vom Herausgeber eingesehen und gelöscht, sobald die
        Entscheidung getroffen ist; aufbewahrt werden nur der angegebene Status, das Studienjahr und die Entscheidung.
      </p>

      <h2 className={h2}>5. Laufzeit, Verlängerung und Kündigung</h2>
      <p className="mt-2">
        Das Abonnement wird für ein Jahr abgeschlossen und verlängert sich automatisch zum dann geltenden Preis. Der
        Abonnent wird ein bis drei Monate vorher per E-Mail über das Verlängerungsdatum und die Möglichkeit, nicht zu
        verlängern, informiert (Artikel L215-1 des französischen Verbrauchergesetzbuchs). Er kann jederzeit auf der Seite
        „Abonnement“ über die Schaltfläche „Mein Abonnement kündigen“ kündigen; der Zugang bleibt bis zum Ende des
        bezahlten Jahres bestehen, danach ist das Konto wieder kostenlos, ohne die mit den kostenlosen Guthaben
        freigeschalteten Zusammenfassungen zu verlieren. Bei einer Preisänderung wird der Abonnent mindestens 30 Tage vor
        der Verlängerung per E-Mail informiert, mit der Möglichkeit zu kündigen.
      </p>

      <h2 className={h2}>6. Zahlung und Rechnung</h2>
      <p className="mt-2">
        Die Zahlung erfolgt per Bankkarte über Stripe, einen Zahlungsdienstleister; der Herausgeber hat keinen Zugriff auf
        die Kartendaten. Für jede Zahlung wird eine Rechnung ausgestellt und per E-Mail versandt.
      </p>

      <h2 className={h2}>7. Widerrufsrecht</h2>
      <p className="mt-2">
        Verbraucher haben grundsätzlich 14 Tage Zeit für einen Widerruf. Da der Zugang zu den Inhalten sofort erfolgt,
        verlangt der Abonnent beim Abschluss ausdrücklich die sofortige Ausführung des Dienstes und verzichtet ab Beginn
        des Zugangs auf sein Widerrufsrecht; dieses Verlangen wird mit dem Datum des Abschlusses und der Fassung dieser
        Bedingungen gespeichert.
      </p>

      <h2 className={h2}>8. Haftung</h2>
      <p className="mt-2">
        Der Herausgeber achtet mit größter Sorgfalt auf die Treue der Zusammenfassungen gegenüber ihren Quellen, ohne
        Fehlerfreiheit zu garantieren. Jeder Fehler kann direkt in der Zusammenfassung gemeldet werden. Der Herausgeber
        haftet nicht für eine klinische Entscheidung, die allein in der Verantwortung der Gesundheitsfachperson liegt.
      </p>

      <h2 className={h2}>9. Schlichtung und anwendbares Recht</h2>
      <MediationTraduite langue="de" />
      <p className="mt-2">Diese Bedingungen unterliegen französischem Recht.</p>
    </div>
  );
}

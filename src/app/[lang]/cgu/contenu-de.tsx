import { CGU_VERSION } from "@/lib/legal";
import { MediationTraduite } from "../mediation";

// Traduction d'information des CGU (contenu-fr.tsx fait seul foi).
export default function CguDe() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Nutzungsbedingungen</h1>
      <p className="mt-2 text-slate-500">Fassung vom {CGU_VERSION.split("-").reverse().join(".")}.</p>

      <h2 className={h2}>1. Gegenstand und Zugang zum Dienst</h2>
      <p className="mt-2">
        Medical Guidelines ist eine Website mit Zusammenfassungen französischer Fachleitlinien in mehreren Fachgebieten
        (Anästhesiologie und Intensivmedizin, Intensivmedizin, Notfallmedizin, Pädiatrie…). Der Zugang zu den Inhalten
        ist Gesundheitsfachpersonen sowie Studierenden der Medizin und der Gesundheitsberufe vorbehalten und setzt die
        Erstellung eines Kontos voraus. Das kostenlose Konto gewährt Zugang zu insgesamt 5 vollständigen
        Zusammenfassungen, dauerhaft und ohne Kreditkarte, die aus dem bei der Registrierung angegebenen Fachgebiet
        gewählt werden oder, solange der Katalog dieses Fachgebiet noch wenig abdeckt (weniger als 20 veröffentlichte
        Zusammenfassungen), aus allen veröffentlichten Zusammenfassungen. Das PREMIUM-Abonnement (alle
        Zusammenfassungen des gewählten Fachgebiets), das für die vom Katalog abgedeckten Fachgebiete angeboten wird,
        kostet 50 € inkl. MwSt. pro Jahr, jährlich im Voraus zahlbar; es verlängert sich automatisch zum Jahrestag und
        kann jederzeit gekündigt werden, wobei der Zugang bis zum Ende des bezahlten Jahres bestehen bleibt. Der Preis
        des laufenden Jahres ist garantiert; eine Erhöhung gilt erst bei der Verlängerung, nach einer Ankündigung
        mindestens 30 Tage im Voraus mit einem Kündigungslink. Die Bedingungen des Abonnements (Rabatte, Widerrufsrecht,
        Rechnungsstellung) sind in den Verkaufsbedingungen festgelegt, die von diesen Bedingungen getrennt sind und bei
        jedem Abschluss akzeptiert werden.
      </p>

      <h2 className={h2}>2. Art des Dienstes und der Inhalte — kein verbindlicher medizinischer Wert</h2>
      <p className="mt-2">
        Medical Guidelines ist ein Dienst zur Nutzung von Fachleitlinien: Er ermöglicht es, sie zu finden, sie in Form von
        Zusammenfassungen zu lesen, die vom Herausgeber verfasst und von seinem ärztlichen Team geprüft wurden (das
        Prüfdatum steht auf jeder Zusammenfassung), sie zu vergleichen und über ihre Aktualisierungen benachrichtigt zu
        werden. Die offiziellen Leitliniendokumente werden von der Website weder verkauft noch verbreitet: Sie bleiben
        Werk und Eigentum ihrer Autoren und sind auf deren Websites frei zugänglich, auf die jede Zusammenfassung
        verweist. Das Abonnement vergütet den Dienst: Erstellung und ärztliche Prüfung der Zusammenfassungen,
        Suchwerkzeuge, Benachrichtigungen und Hosting.
      </p>
      <p className="mt-2">
        Die veröffentlichten Zusammenfassungen sind unabhängige Zusammenfassungen, die als Gedächtnisstütze auf
        Grundlage der von den Fachgesellschaften veröffentlichten Dokumente erstellt wurden. Sie ersetzen nicht die
        Lektüre des vollständigen Textes der offiziellen Leitlinien und begründen keine Haftung der betroffenen
        Fachgesellschaften. Auf dieser Website wird kein Logo, keine Marke und kein geschütztes Element einer
        Fachgesellschaft wiedergegeben. Bei klinischen Zweifeln muss der Nutzer den vollständigen Text der Leitlinie oder
        fachärztlichen Rat heranziehen.
      </p>
      <p className="mt-2">
        <b>Übersetzungen.</b> Einige Zusammenfassungen können in anderen Sprachen angeboten werden (Englisch,
        Spanisch, Deutsch, Arabisch, Chinesisch), nur wenn die Autoren der Leitlinie dies schriftlich genehmigt
        haben. Diese Übersetzungen werden durch künstliche Intelligenz auf Grundlage der von einem Arzt geprüften
        französischen Zusammenfassung erstellt und automatisch kontrolliert (Dosierungen, Einheiten, Schwellenwerte,
        Empfehlungsgrade); sofern auf der Zusammenfassung nicht anders angegeben, werden sie in der Zielsprache nicht
        von einem Arzt geprüft, worauf jede übersetzte Zusammenfassung hinweist. Maßgeblich sind allein die
        französische Fassung der Zusammenfassung und der offizielle Text der Leitlinie.
      </p>

      <h2 className={h2}>3. Geistiges Eigentum und zulässige Nutzung</h2>
      <p className="mt-2">
        Die zitierten Leitlinien (Formulierungen, Empfehlungsgrade, Tabellen, Abbildungen) gehören ihren Autoren und
        Herausgebern; die Zusammenfassungen zitieren sie mit ihrer Quellenangabe und dem Link zum offiziellen Text. Die
        Zusammenfassungen, ihre Auswahl, ihre Gliederung, die Datenbank und die Software der Website gehören dem
        Herausgeber (Artikel L341-1 ff. des französischen Gesetzbuchs über geistiges Eigentum für die Datenbank).
      </p>
      <p className="mt-2">
        Das Konto gewährt ein persönliches Zugangsrecht zur beruflichen Nutzung. Untersagt sind: das systematische
        Kopieren oder Entnehmen der Zusammenfassungen, auch mittels eines Roboters oder Programms; der Weiterverkauf oder
        die Verbreitung der Inhalte; die Umgehung der Schutzmaßnahmen der Website. Erfolgt das Lesen in ungewöhnlichem
        Tempo, wird es automatisch für begrenzte Zeit ausgesetzt und ein Administrator benachrichtigt (siehe{" "}
        <a href="/de/confidentialite" className="underline">
          Datenschutzerklärung
        </a>
        ).
      </p>

      <h2 className={h2}>4. Benutzerkonto</h2>
      <p className="mt-2">
        Die Erstellung eines Kontos erfordert die Angabe von Identifikationsdaten (Nachname, Vorname, Telefon, E-Mail,
        Beruf) und die Bestätigung der E-Mail-Adresse. Das Konto ist persönlich: Die Zugangsdaten dürfen weder geteilt
        noch verliehen werden. Der Nutzer ist für die Vertraulichkeit seines Passworts und für jede über sein Konto
        ausgeführte Aktivität verantwortlich.
      </p>

      <h2 className={h2}>5. Personenbezogene Daten</h2>
      <p className="mt-2">
        Die Verarbeitung personenbezogener Daten ist vollständig in unserer{" "}
        <a href="/de/confidentialite" className="underline">
          Datenschutzerklärung
        </a>{" "}
        beschrieben, einem gesonderten Dokument, das Sie vor der Registrierung lesen sollten. Die Einwilligung in die
        Weitergabe von Daten an kommerzielle Partner ist von der Annahme dieser Nutzungsbedingungen getrennt und wird für
        die Erstellung eines Kontos nie verlangt.
      </p>

      <h2 className={h2}>6. Löschung, Sperrung und Schließung des Kontos</h2>
      <p className="mt-2">
        Der Nutzer kann sein Konto jederzeit auf der Seite „Mein Konto“ löschen; seine personenbezogenen Daten werden dann
        sofort gelöscht, vorbehaltlich gesetzlicher Aufbewahrungspflichten (Buchhaltungsunterlagen).
      </p>
      <p className="mt-2">
        Der Herausgeber kann den Zugang zu einem Konto sperren, nachdem er den Nutzer per E-Mail benachrichtigt und zur
        Stellungnahme aufgefordert hat, wenn gegen diese Bedingungen verstoßen wird: systematische Entnahme oder Kopie der
        Inhalte, Teilen oder Verleihen der Zugangsdaten, Umgehung der Schutzmaßnahmen, falsche Angabe des beruflichen
        Status. Bei einem schweren oder wiederholten Verstoß kann das Konto geschlossen werden; ein laufendes Abonnement
        wird dann anteilig für den verbleibenden Zeitraum erstattet, außer im Betrugsfall. Die automatische und
        vorübergehende Aussetzung des Lesens bei ungewöhnlichem Tempo (Artikel 3) ist keine Sanktion.
      </p>

      <h2 className={h2}>7. Haftung und Verfügbarkeit</h2>
      <p className="mt-2">
        Die Zusammenfassungen und der Suchassistent sind Lesehilfen für Gesundheitsfachpersonen. Sie ersetzen weder den
        offiziellen Text der Leitlinien noch die Untersuchung des Patienten noch das klinische Urteil: Jede diagnostische
        oder therapeutische Entscheidung liegt allein in der Verantwortung der Fachperson, die sie trifft. Der Herausgeber
        achtet mit größter Sorgfalt auf die Treue der Zusammenfassungen gegenüber ihren Quellen und korrigiert jeden
        gemeldeten Fehler (öffentliches Korrekturprotokoll), ohne Fehlerfreiheit oder Vollständigkeit der Inhalte zu
        garantieren.
      </p>
      <p className="mt-2">
        Der Herausgeber bemüht sich, die Website jederzeit zugänglich zu halten, ohne Erfolgsgarantie: Unterbrechungen
        wegen Wartung, Aktualisierungen oder technischer Störungen können auftreten. Für Links zu den Websites der
        Fachgesellschaften und anderer Anbieter sind deren jeweilige Herausgeber verantwortlich.
      </p>

      <h2 className={h2}>8. Suchassistent (künstliche Intelligenz)</h2>
      <p className="mt-2">
        Der Suchassistent, der PREMIUM-Abonnenten vorbehalten ist, nutzt ein Modell der künstlichen Intelligenz, um die
        Passagen der Zusammenfassungen zu finden, die eine Frage beantworten. Seine Antworten werden automatisch erzeugt:
        Sie können Fehler oder Auslassungen enthalten, und jede Passage muss vor jeder Entscheidung in der Zusammenfassung
        und in der angegebenen offiziellen Quelle überprüft werden. Der Assistent gibt keine Einschätzung zu einem
        Patienten. Es ist untersagt, Daten einzugeben, die einen Patienten identifizieren könnten. Die Fragen werden von
        der Website nicht gespeichert; ihre Verarbeitung ist in der Datenschutzerklärung beschrieben.
      </p>

      <h2 className={h2}>9. Änderung der Bedingungen</h2>
      <p className="mt-2">
        Der Herausgeber kann diese Bedingungen ändern, insbesondere um Entwicklungen des Dienstes oder der Vorschriften
        Rechnung zu tragen. Jede wesentliche Änderung wird mindestens 30 Tage vor ihrem Inkrafttreten per E-Mail
        mitgeteilt. Ein Nutzer, der sie nicht akzeptiert, kann sein Konto vor diesem Datum löschen; die weitere Nutzung
        der Website nach diesem Datum gilt als Annahme. Die bei der Registrierung akzeptierte Fassung wird gespeichert.
      </p>

      <h2 className={h2}>10. Anwendbares Recht, Streitigkeiten und Schlichtung</h2>
      <p className="mt-2">
        Diese Nutzungsbedingungen unterliegen französischem Recht. Im Streitfall wird der Nutzer gebeten, sich zunächst
        unter contact@medical-guidelines.net an den Herausgeber zu wenden. Kommt keine gütliche Einigung zustande, wird
        der Streit vor die zuständigen Gerichte in Paris gebracht, wenn der Nutzer in beruflicher Eigenschaft handelt;
        ein Nutzer, der Verbraucher ist, kann das Gericht seiner Wahl unter den gesetzlich vorgesehenen Bedingungen
        anrufen und kostenlos die Verbraucherschlichtung in Anspruch nehmen:
      </p>
      <MediationTraduite langue="de" />
    </div>
  );
}

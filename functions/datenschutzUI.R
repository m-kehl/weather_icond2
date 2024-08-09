## User Interface for the impressum part
#  -> text about contact details, disclaimer and copyright declaration.
#  -> picture of laubfrosch which turns red if clicked.
datenschutzUI <- function(id) {
  tagList(
    #pictre of laubfrosch
    uiOutput(NS(id,"laubfrosch"),style="float:right"),
    #contact details
    h2("Datenschutzerklärung"),
    br(),
    h3("1 Datenschutzerklärung"),
    h4("Die vorliegende Datenschutzerklärung klärt Sie über die Art, den Umfang
       und den Zweck der Erhebung und Verwendung personenbezogener Daten auf
       der Website https://laubfrosch.shinyapps.io/weather-icond2/ (im Folgenden
       „Website“) durch die Inhaber der Website (im Folgenden „wir“ oder „uns“) 
       auf."),
    h3("2 Verantwortlicher für die Datenbearbeitung"),
    h4("Verantwortlicher für die Datenbearbeitung auf dieser Website und 
    Ansprechpartner für Datenschutzanliegen ist:\n
       M. Kehl (mkehl.laubfrosch@gmail.com)."),
    h3("3 Datenerfassung auf dieser Website"),
    h4("3.1 Logfiles"),
    h4("Diese Website wird von Posit Software, PBC (https://www.shinyapps.io/) gehostet.\n
       Zur Optimierung und Aufrechterhaltung unserer Website protokollieren wir
       technische Fehler, die beim Aufrufen unserer Website allenfalls auftreten.
       Ferner werden bei der Nutzung dieser Website automatisch Informationen
       erhoben, die der Browser Ihres Endgeräts an unseren Host-Provider
       übermittelt. Dies sind: \n
        IP-Adresse und Betriebssystem Ihres Endgeräts; Browsertyp, Version, Sprache;
        Datum und Uhrzeit der Serveranfrage; 
        aufgerufene Datei; 
        die Website, von der aus der Zugriff erfolgte (Referrer URL);
        den Status-Code (z.B. 404) und
        das verwendete Übertragungsprotokoll (z.B. HTTP/2).
       Diese Daten werden von unserem Host-Provider erhoben und gespeichert, um 
       Prozesse und Abläufe insbesondere in Zusammenhang mit der Nutzung unserer
       Website und der Sicherheit und Stabilität des Computersystems optimieren
       zu können."),
    h4("Weitere Informationen finden Sie in der Datenschutzerklärung von Posit
       Software, PBC unter https://posit.co/about/privacy-policy/. Sofern die
       DSGVO anwendbar ist, sind Grundlage für diese Datenbearbeitung
       Art. 6 Abs. 1 lit. f DSGVO."),
    h4("3.2 Kontaktformular"),
    h4("Wenn Sie mit uns Kontakt aufnehmen, werden Ihre Angaben zur Bearbeitung
    der Anfrage und für den Fall von Anschlussfragen
    von uns bearbeitet.
    Wir verwenden die von Ihnen mitgeteilten Daten, um Ihre Anfrage zu beantworten.
       Sofern die DSGVO anwendbar ist, sind Grundlage für diese Datenbearbeitung
       Art. 6 Abs. 1 lit. f DSGVO."),
    h4("3.3 Cookies"),
    h4("Wir setzen auf unserer Website Cookies ein. Cookies sind kleine Dateien,
    die auf Ihrem Endgerät abgelegt werden und die Ihr Browser speichert. Einige
    der von uns verwendeten Cookies werden automatisch gelöscht, wenn Sie unsere
    Website verlassen. Andere Cookies bleiben auf Ihrem Endgerät gespeichert, bis
    Sie diese löschen oder bis sie ablaufen. Diese Cookies ermöglichen es, Ihren
    Browser beim nächsten Besuch unserer Website wiederzuerkennen.
    In Ihrem Browser können Sie einstellen, dass Sie über das Setzen von Cookies
    vorab informiert werden und im Einzelfall entscheiden können, ob Sie die
    Annahme von Cookies für bestimmte Fälle oder generell ausschliessen, oder 
    dass Cookies komplett verhindert werden. Dadurch kann die Funktionalität der
    Website eingeschränkt werden.
    Cookies, die für den elektronischen Kommunikationsvorgang oder von Ihnen 
       gewünschte Funktionen erforderlich sind oder Ihr Benutzererlebnis
       optimieren, werden – sofern die DSGVO anwendbar ist – auf Grundlage
       von Art. 6 Abs. 1 lit. f DSGVO gespeichert."),
    h3("4 Links"),
    h4("Auf unserer Website finden Sie Links auf Seiten von Drittanbietern. Wir 
       sind nicht verantwortlich für die Inhalte und Datenschutzvorkehrungen auf
       externen Websites, welche Sie über die Links erreichen können. Bitte 
       informieren Sie sich über den Datenschutz direkt auf den entsprechenden
       Websites."),
    h3("5 Weitergabe von Daten an Dritte"),
    h4("Damit wir Ihnen die Informationen auf unserer Website anbieten können, 
       arbeiten wir mit verschiedenen Dienstleistern zusammen, namentlich mit
       IT-Dienstleistern, um Ihnen eine zeitgemässe Website anbieten zu können.
       Diese verwenden Ihre Daten nur im Rahmen der Auftragsabwicklungen für uns.
       Mit Ausnahme der Bestimmungen in Ziffer 3.4 dieser Datenschutzerklärung,
       nehmen wir eine Datenübermittlung an Stellen ausserhalb der Schweiz und
       der Europäischen Union (Drittstaat) ohne Ihre Einwilligung nur vor,
       sofern dies nach dem jeweiligen Vertrag erforderlich ist, zur Erfüllung 
       gesetzlicher Verpflichtungen oder zur Wahrung unserer berechtigten
       Interessen."),
    h3("6 Aktualität und Änderung dieser Datenschutzerklärung"),
    h4("Wir können diese Datenschutzerklärung jederzeit ändern oder anpassen.
       Die aktuelle Datenschutzerklärung kann auf https://laubfrosch.shinyapps.io/weather-icond2/ 
       abgerufen werden."),
    h3("Quelle Datenschutzerklärung"),
    h4(tags$a(href="https://www.rentschpartner.ch/ict-law/datenschutz/datenschutzerklaerung",
              "Rentsch Partner AG"))
  )
}

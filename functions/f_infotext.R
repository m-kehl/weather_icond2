f_infotext <- function(data_kind){
  ## function to return an information text about opensource data
  # - data_kind: character; defines about what the information text should be
  #                         options: "icond2" -> forecast model ICON D2
  #                                  "mess"   -> measurement surface data
  #                                  "pheno"  -> phenology data
  
  if (data_kind == "icond2"){
    showNotification(tags$p("ICON-D2 ist ein numerisches Modell zur Wetterprognose. Die
    Vorhersagen werden 6x t\u00E4glich durch den Deutschen Wetterdienst berechnet und
    \u00F6ffentlich zur Verf\u00FCgung gestellt. Weitere Informationen zu diesem Wettermodell 
                            finden Sie ", tags$a(href="https://www.dwd.de/DE/forschung/wettervorhersage/num_modellierung/01_num_vorhersagemodelle/regionalmodell_icon_d2.html?nn=512942", "hier."),
                            tags$br(),tags$br(),
                            "In dieser Webapp abrufbar sind Vorhersagen f\u00FCr die 
                            drei von ICON-D2 berechneten Parameter Regen, Schnee
                            und Temperatur. Die Vorhersagen werden sowohl zweidimensional
                            auf der Karte als auch eindimensional als Punktvorhersage
                            dargestellt. Der Ort f\u00FCr die Punktvorhersage l\u00E4sst
                            sich auf drei verschiedene Arten bestimmen. Die erste
                            Option 'Mausklick' bedeutet, dass die Punktvorhersage
                            f\u00FCr einen beliebigen auf der Karte angeklickten Punkt
                            erstellt wird. Die zweite Option 'Landeshauptstadt'
                            erstellt die Punktvorhersage f\u00FCr die Landeshauptstadt
                            des ausgew\u00E4hlten Bundeslandes. Bei der dritten Option
                            'freie Koordinatenwahl' kann das Koordinatenpaar f\u00FCr
                            die Punktvorhersage manuell eingegeben werden.",
                            tags$br(),tags$br(),
                            "Der Prognosebereich von ICON-D2 umfasst Deutschland
                            sowie Teile der angrenzenden L\u00E4nder. Die genaue Begrenzung
                            ist auf der Karte durch die blaue Markierung ersichtlich.")
                     ,duration = NULL)
  }else if (data_kind == "mess"){
    showNotification(tags$p("Die Messdaten der Bodenparameter, wie beispielsweise
                     Temperatur oder Niederschlag, werden f\u00FCr Deutschland vom 
                     Deutschen Wetterdienst durch dessen Bodenmessnetz erfasst und
                     \u00F6ffentlich zur Verf\u00FCgung gestellt. Die Messstationen laufen
                     nach den internationalen Richtlinien der WMO (World Meteorological
                     Organization). Weiter Informationen dazu finden Sie ", tags$a(href="https://www.dwd.de/DE/derdwd/messnetz/bodenbeobachtung/_functions/Teasergroup/bodenmessnetz.html?nn=452720", "hier."),
                            tags$br(),tags$br(),
                            "In dieser Webapp abrufbar sind die Messwerte des akutellen Tages
                            (Aufl\u00F6sung 10-Minuten), die Tageswerte und die Monatswerte.
                            Es k\u00F6nnen hier die Messwerte f\u00FCr maximal f\u00FCnf Messstationen
                            gleichzeitig dargestellt werden. \u00DCber die Eingabe 'Parameter
                            f\u00FCr Plot 1' und 'Parameter f\u00FCr Plot 2' l\u00E4sst sich einstellen,
                            welche Parameter in welchem Plot dargestellt werden.")
                     ,duration = NULL)
  } else if (data_kind == "pheno"){
    showNotification(tags$p("Das Ph\u00E4nologische Messnetz des Deutschen Wetterdienstes erfasst
                     die Entwicklungsstufen einiger Pflanzenarten und stellt diese
                     \u00F6ffentlich zur Verf\u00FCgung. Weitere Informationen dazu finden Sie ", tags$a(href="https://www.dwd.de/DE/klimaumwelt/klimaueberwachung/phaenologie/phaenologie_node.html", "hier"),
                     "oder", tags$a(href="https://www.dwd.de/DE/derdwd/messnetz/bodenbeobachtung/_functions/Teasergroup/phaenologie.html;jsessionid=E0C5A71A618B415EB6FE934E7E579586.live21062?nn=452720", "hier."),
                     tags$br(),tags$br(),
                     "Je nach Pflanzenart werden unterschiedliche Entwicklungsstufen
                      (ph\u00E4nologische Phasen) registiert. Hier dargestellt werden k\u00F6nnen
                      alle aufgenommenen Pflanzenarten und Phasen je Station. Erscheint eine
                      Station trotz deren Auswahl nicht im Plot, sind f\u00FCr die
                      ausgew\u00E4hlte Station, Pflanzenart und Phase keine
                      Daten vorhanden.",
                     tags$br(),tags$br(),
                     "Es k\u00F6nnen die Daten f\u00FCr mehrere Stationen gleichzeitig angezeigt werden,
                      indem unter Stationsname/n mehrere Stationen ausgew\u00E4hlt werden. 
                      Mit setzen von H\u00E4ckchen bei 'Hilfslinien' werden zus\u00E4tzliche
                     Linien zur besseren Lesbarkeit im Plot angezeigt. 
                     In der Karte unter dem Plot wird die genaue Lage der Station/en
                     gekennzeichnet."),
                     duration = NULL)
  }
}
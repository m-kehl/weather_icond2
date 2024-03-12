f_infotext <- function(data_kind){
  ## function to return an information text about opensource data
  # - data_kind: character; defines about what the information text should be
  #                         options: "icond2" -> forecast model ICON D2
  #                                  "mess"   -> measurement surface data
  #                                  "pheno"  -> phenology data
  
  if (data_kind == "icond2"){
    showNotification(tags$p("ICON-D2 ist ein numerisches Modell zur Wetterprognose. Die
    Vorhersagen werden 6x t\u00E4glich durch den Deutschen Wetterdienst berechnet und
    \u00F6ffentlich zur Verf\u00FCgung gestellt. Weiter Informationen finden Sie ", tags$a(href="https://www.dwd.de/DE/forschung/wettervorhersage/num_modellierung/01_num_vorhersagemodelle/regionalmodell_icon_d2.html?nn=512942", "hier."),
                            tags$br(),tags$br(),
                            "Mit ICON-D2 werden Vorhersagen f\u00FCr unerschiedlichste
                            Parameter erstellt. Hier abrufbar sind die drei Parameter
                            Regen, Schnee und Temperatur als Karte f\u00FCr die Bundesl\u00E4nder
                            sowie als Punktvorhersage f\u00FCr die jeweilige Landeshauptstadt
                            oder ein frei w\u00E4hlbares Koordinatenpaar.")
                     ,duration = NULL)
  }else if (data_kind == "mess"){
    showNotification(tags$p("Die Messdaten der Bodenparameter, wie beispielsweise
                     Temperatur oder Niederschlag, werden f\u00FCr Deutschland vom 
                     Deutschen Wetterdienst durch dessen Bodenmessnetz erfasst und
                     \u00F6ffentlich zur Verf\u00FCgung gestellt. Die Messstationen laufen
                     nach den internationalen Richtlinien der WMO (World Meteorological
                     Organisazion). Weiter Informationen finden Sie ", tags$a(href="https://www.dwd.de/DE/derdwd/messnetz/bodenbeobachtung/_functions/Teasergroup/bodenmessnetz.html?nn=452720", "hier."),
                            tags$br(),tags$br(),
                            "Hier abrufbar sind die Messwerte des akutellen Tages
                            (Aufl\u00F6sung 10-Minuten), die Tageswerte und die Monatswerte
                            f\u00FCr maximal f\u00FCnf Stationen gleichzeitig.")
                     ,duration = NULL)
  } else if (data_kind == "pheno"){
    showNotification(tags$p("Das Ph\u00E4nologische Messnetz des Deutschen Wetterdienstes erfasst
                     die Entwicklungsstufen einiger Pflanzenarten und stellt diese
                     \u00F6ffentlich zur Verf\u00FCgung. Weiter Informationen finden Sie ", tags$a(href="https://www.dwd.de/DE/klimaumwelt/klimaueberwachung/phaenologie/phaenologie_node.html", "hier"),
                     "oder", tags$a(href="https://www.dwd.de/DE/derdwd/messnetz/bodenbeobachtung/_functions/Teasergroup/phaenologie.html;jsessionid=E0C5A71A618B415EB6FE934E7E579586.live21062?nn=452720", "hier."),
                     tags$br(),tags$br(),
                     "Je nach Pflanzenart werden unterschiedliche Entwicklungsstufen
                      (ph\u00E4nologische Phasen) registiert. Hier dargestellt werden k\u00F6nnen
                      alle aufgenommenen Pflanzenarten und Phasen je Station."),
                     duration = NULL)
  }
}
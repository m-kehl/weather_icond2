f_infotext <- function(tabset){
  if (tabset == "icond2"){
    showNotification("ICON-D2 ist ein numerisches Modell zur Wetterprognose. Die
    Vorhersagen werden 6x täglich durch den Deutschen Wetterdienst berechnet und
    öffentlich zur Verfügung gestellt. Weiter Informationen finden Sie ", tags$a(href="https://www.dwd.de/DE/forschung/wettervorhersage/num_modellierung/01_num_vorhersagemodelle/regionalmodell_icon_d2.html?nn=512942", "hier.")
                     ,duration = NULL)
  }else if (tabset == "mess"){
    showNotification("Die Messdaten der Bodenparameter, wie beispielsweise
                     Temperatur oder Niederschlag, werden für Deutschland vom 
                     Deutschen Wetterdienst durch dessen Bodenmessnetz erfasst und
                     öffentlich zur Verfügung gestellt. Die Messstationen laufen
                     nach den internationalen Richtlinien der WMO (World Meteorological
                     Organisazion). Weiter Informationen finden Sie ", tags$a(href="https://www.dwd.de/DE/derdwd/messnetz/bodenbeobachtung/_functions/Teasergroup/bodenmessnetz.html?nn=452720", "hier.")
                     ,duration = NULL)
  } else if (tabset == "pheno"){
    showNotification(tags$p("Das Phänologische Messnetz des Deutschen Wetterdienst erfasst
                     die Entwicklungsstufen einiger Pflanzenarten und stellt diese
                     öffentlich zur Verfügung. Weiter Informationen finden Sie ", tags$a(href="https://www.dwd.de/DE/klimaumwelt/klimaueberwachung/phaenologie/phaenologie_node.html", "hier"),
                     "oder", tags$a(href="https://www.dwd.de/DE/derdwd/messnetz/bodenbeobachtung/_functions/Teasergroup/phaenologie.html;jsessionid=E0C5A71A618B415EB6FE934E7E579586.live21062?nn=452720", "hier.")),
                     
                     duration = NULL)
  }

  
}

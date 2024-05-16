#ShinyApp to visualise measurement and forecast weather data provided
#to the public by DWD (Deutscher Wetterdienst; opendata.dwd.de)
#
#20.02.2024 - ShinyApp created by m-kehl (mkehl.laubfrosch@gmail.com)


## -- A -- Preparation ---------------------------------------------------------
rm(list = ls())

## required packages
library(shiny)
library(shinybrowser)
library(shinydashboard)
library(shinyjs)
library(waiter)
library(miceadds)
library(rdwd)
library(terra)
library(lubridate)
library(RCurl)
library(curl)
library(R.utils)
library(dplyr)
library(leaflet)

## source functions and input
source.all(paste0(getwd(),"/functions/"))
source(paste0(getwd(),"/input.R"),local = TRUE)

##set local system
#Sys.setlocale("LC_TIME", "German")

## -- B -- User Interface ------------------------------------------------------
ui <- fluidPage(
  tags$head(
    ## define superordinate settings 
    # HTML/CSS style for different elements (tabsets, plots, text, etc)
    tags$style(HTML(
      "body {
          max-width: 1320px;
          margin: auto;
          background-color: white}
          
      .mobile_info {
          color: red;
          background-color: #39f40b;}
          
      .title {
          color: black;
          float: left; width: 50%}
          
      .tabbable > .nav {background-color:	 #3dc296;}
      .tabbable > .nav > li {float: right;  padding-top: 65px;}
      .tabbable > .nav > li                 > a  {font-weight: bold; 
                                                  background-color: aquamarine; 
                                                  color:black}
      .tabbable > .nav > li[class=active]    > a {background-color: HoneyDew; 
                                                  color:black}

      .shiny-notification {position:fixed;
                            top: calc(20%);
                            left: calc(30%);
                            max-width: 450px;
                            background-color: HoneyDew;
                            color: black;
                            border-color: aquamarine}
                            
      .intro {background-color: aquamarine;
              font-size: 30px;}
              
      .map_plot {max-width: 800px;
                  padding: 16px}

      .slider {padding-left: 16px}
      
      .subtitle {padding-left: 8px;}
      
      .helplines {border-style: solid;
                  border-color: #3dc296;
                  border-width: 2px;
                  border-radius: 5px;
                  padding: 5px;
                  width: 150px;
                  }

      .impressum_style {padding: 32px}
      
      #map_title {padding-left: 16px;
      }
      
      .main {background-color: white;}
                  
      .footer {background-color: HoneyDew;
                }
              
      a {color: #3dc296;}
      
      .hidekontakt {
          display: none;
      }
              
      .kontakt:hover {
       color: red;
      }
        
      .kontakt {display: inline-block;
                color: #3dc296;}

      .kontakt:hover + .hidekontakt {
        display: initial;
        color: red;
      }

      
      "
    ))
  ),
  # use shiny waiter
  useWaiter(),
  # use shinybrowser
  shinybrowser::detect(),
  span(textOutput("browser_info"),style = "color:red"),

  ## Main Panel
  fluidRow(
    mainPanel(
      useShinyjs(),
      ## Title
      titlePanel(title=div(class = "title",img(class = "title_pic",src="laubfrosch.png",width = 100,height = 100),
                           "Prognose- und Messdaten"), windowTitle = "ICON-D2"),
        # define main_tabsets (ICON D2, measurement data, phenology, impressum)
        tabsetPanel(
          id = "main_tabsets",
          selected = "icond2",

## -- B.1 --  TabPanel 1: Impressum --------------------------------------------
          tabPanel("Impressum",
                   value = "impressum",
            div(class = "impressum_style",
            uiOutput("laubfrosch",style="float:right"),
            h3("Kontakt"),
            h4("M. Kehl"),
            h4("mkehl.laubfrosch@gmail.com"),
            h4("Quellcode auf", tags$a(href="https://github.com/m-kehl/weather_icond2",
                                       "GitHub")),
            h3("Haftungsausschluss"),
            h4("Der Autor übernimmt keine Gewähr für die Richtigkeit, Genauigkeit,
            Aktualität, Zuverlässigkeit und Vollständigkeit der Informationen.
            Haftungsansprüche gegen den Autor wegen Schäden materieller oder
               immaterieller Art, die aus dem Zugriff oder der Nutzung bzw.
               Nichtnutzung der veröffentlichten Informationen, durch Missbrauch
               der Verbindung oder durch technische Störungen entstanden sind,
               werden ausgeschlossen."),
            p(),
            h4("Alle Angebote sind freibleibend. Der Autor behält es sich
               ausdrücklich vor, Teile der Seiten oder das gesamte Angebot ohne 
               gesonderte Ankündigung zu verändern, zu ergänzen, zu löschen oder
               die Veröffentlichung zeitweise oder endgültig einzustellen."),
            h3("Haftungsausschluss für Inhalte und Links"),
            h4("Verweise und Links auf Webseiten Dritter liegen ausserhalb
               unseres Verantwortungsbereichs. Es wird jegliche Verantwortung
               für solche Webseiten abgelehnt. Der Zugriff und die Nutzung
               solcher Webseiten erfolgen auf eigene Gefahr des jeweiligen Nutzers."),
            h3("Urheberrechtserklärung"),
            h4("Die Urheber- und alle anderen Rechte an Inhalten, Bildern, Fotos
               oder anderen Dateien auf dieser Website, gehören ausschliesslich
               den genannten Rechteinhabern. Für die Reproduktion jeglicher 
               Elemente ist die schriftliche Zustimmung des Urheberrechtsträgers
               im Voraus einzuholen."),
            h3("Quelle Impressum"),
            h4(tags$a(href="https://brainbox.swiss/impressum-generator-schweiz/",
                      "BrainBox Solutions")))
          ),
## -- B.2 --  TabPanel 2: phenology  -------------------------------------------

          tabPanel("Phänologie", 
                   value = "pheno",
            column(3, 
               br(),
               column(1,
                   actionButton("info_pheno", label = NULL, icon = icon("info"),
                                       style="color: black; 
                                              background-color: HoneyDew; 
                                              border-color: #3dc296",
                                       widht = "10%")),
               column(10,
                      div(class = "subtitle",h4("Phänologie",width = "90%"))),
               br(),
               br(),
               hr(),
               selectInput(
                inputId = "pflanzen",
                label = "Pflanzenart",
                choices = pflanzen_arten,
                multiple = FALSE),
               radioButtons(
                inputId = "phase",
                label = "phänologische Phase",
                choiceNames = phenology_phases$phase,
                choiceValues = phenology_phases$phase_id,
                selected = character(0)),
               selectInput(
                inputId = "bl_plant",
                label = "Bundesland",
                choices = c(""),
                multiple = FALSE),
               selectizeInput(
                inputId = "station_name",
                label = "Stationsname/n",
                choices = c("Adelsheim"),
                selected = c("Adelsheim"),
                multiple = TRUE),
               p("Datenbasis: \u00A9 Deutscher Wetterdienst (opendata.dwd.de)")
            ),
            column(9,
               column(10,
                      div(class = "map_plot",plotOutput("plant_out")),
                      textOutput("no_plant")),
              #p("In Bearbeitung..")
               column(2,
                      br(),
                      br(),
                      br(),
                      br(),
                      div(class = "helplines",
                      p("Hilfslinien:"),
                      checkboxInput("trendline", "lin. Regression"),
                      checkboxInput("mtline","Monatslinien"),
                      checkboxInput("grid","Gitternetz"))),
               column(6,plotOutput("plant_map")),
               #column(6,tableOutput("plant_table"))
            ),
          ),

## -- B.3 --  TabPanel 3: measurement data -------------------------------------

          tabPanel("Messdaten",
                   value = "mess",
            column(3, 
               br(),
               column(1,       
                   actionButton("info_mess", label = NULL, icon = icon("info"),
                                 style="color: black;
                                        background-color: HoneyDew;
                                        border-color: #3dc296",
                                 widht = "10%")),
               column(10,
                      div(class = "subtitle",h4("Messdaten",width = "90%"))),
               br(),
               br(),
               hr(),
               selectizeInput(
                inputId = "mess_name",
                label = "Stationsname/n (max. 5)",
                choices = c(""),
                multiple = TRUE,
                options = list(maxItems = 5)),
               selectizeInput(
                inputId = "parameter_plot1",
                label = "Parameter für Plot 1 (max. 2)",
                choices = c(meteo_parameters$parameter),
                multiple = TRUE,
                options = list(maxItems = 2),
                selected = c("Temperatur")
               ),
               selectizeInput(
                 inputId = "parameter_plot2",
                 label = "Parameter für Plot 2 (max. 2)",
                 choices = c(meteo_parameters$parameter),
                 multiple = TRUE,
                 options = list(maxItems = 2),
                 selected = c("Niederschlag","relative Feuchte")
               ),
               box(id = "box_sincetill",
                width = '800px',
                sliderInput("sincetill",
                "Zeitspanne für Plot",
                min = Sys.Date()-61,
                max = Sys.Date(),
                value = c(Sys.Date()-60,Sys.Date()-1),
                step = 1)), #1day
               p("Datenbasis: \u00A9 Deutscher Wetterdienst (opendata.dwd.de)")
            ),
            column(9,
              # define second-level tabsets (now, daily, monthly)
              tabsetPanel(id = "mess_tabsets",
                tabPanel("aktuelle Messungen",
                  value = "now",
                  div(class = "map_plot",plotOutput("mess_plot")),
                  div(class = "map_plot",plotOutput("mess_plot_prec"))),
                tabPanel("Tageswerte",
                  value = "daily",
                  div(class = "map_plot",plotOutput("mess_plot_daily")),
                  div(class = "map_plot",plotOutput("mess_plot_daily_prec"))),
                tabPanel("Monatswerte",
                  value = "monthly",
                  div(class = "map_plot",plotOutput("mess_plot_monthly")),
                  div(class = "map_plot",plotOutput("mess_plot_monthly_prec"))),
                  #p("in Bearbeitung.."))
              )
            )
          ),
## -- B.4 --  TabPanel 4: ICON D2 --------------------------------------------------------------
          tabPanel("Modell ICON-D2",
                   value = "icond2",
                   column(3, 
                          br(),
                          column(1,
                                 actionButton("info_icond2", label = NULL, icon = icon("info"),
                                              style="color: black; 
                                              background-color: HoneyDew;
                                              border-color: #3dc296",
                                              widht = "5%")),
                          column(10,
                                 div(class = "subtitle",h4("Regionalmodell ICON-D2",width = "95%"))),
                          br(),
                          br(),
                          hr(),
                          radioButtons(
                            inputId = "parameter",
                            label = "Parameter",
                            selected = character(0),
                            choiceNames = c("Regen","Schnee","Temperatur"),
                            choiceValues = c("rain_gsp","snow_gsp","t_2m")),
                          selectInput(
                            inputId = "bundesland",
                            label = "Bundesland",
                            choices = bundeslaender_coord$bundesland,
                            multiple = FALSE),
                          radioButtons(
                            inputId = "point_forecast",
                            label = "Punktvorhersage",
                            choiceNames = c("Mausklick","Landeshauptstadt","freie Koordinatenwahl"),
                            choiceValues = c("mouse","bhs","free")),
                          box(id = "box_free_coord",
                              width = '800px',
                              numericInput("free_lon",label = "longitude", value = 9.05222,
                                           step = 0.5, width = "50%"),
                              numericInput("free_lat",label = "latitude", value = 48.52266,
                                           step = 0.5, width = "50%")),
                          p("Datenbasis: \u00A9 Deutscher Wetterdienst (opendata.dwd.de)")
                   ),
                   column(9,
                          br(),
                          h4(textOutput("map_title")),
                          #uiOutput("leaf"),
                          #uiOutput("leaf"),
                          div(class = "map_plot",leafletOutput("map_out")),
                          div(class = "slider", sliderInput("slider_time", 
                                      "Zeit", 
                                      min = ceiling_date(Sys.time(),unit = "hour"),
                                      max = ceiling_date(Sys.time(),unit = "hour") + 6 * 60 * 60,
                                      step = 3600,
                                      value = c(ceiling_date(Sys.time(),unit = "hour")),
                                      timeFormat = "%a %H:%M", ticks = T, animate = T,
                                      width = "750px")),
                          div(class = "map_plot",plotOutput("bar_out"))
                   )
          ),
        ),
      width = 12,
      
    )
  ),tags$footer(class = "footer","\u00A9 2024 - M. Kehl      ",br(), actionLink("link_to_impressum", "Impressum"),
                "|", div(class = "kontakt", "Kontakt"), div(class="hidekontakt","mkehl.laubfrosch@gmail.com"))
)



## -- C --  server -------------------------------------------------------------
server <- function(input, output, session) {
  ## read device infos to make app reactive to it
  output$browser_info <- renderText({
    device <- shinybrowser::get_device()
    if (device == "Mobile"){
      paste0("Achtung: Die Darstellung dieser Webapp kann auf mobilen Geräten fehlerhaft sein,
    da sie für den Desktop und nicht für mobile Geräte entwickelt wurde.")
    }
  })
  
  # make link to impressum reactive
  observeEvent(input$link_to_impressum, {
    updateTabItems(session, "main_tabsets", "impressum")
  })
  
  # show infobox with contact details
  observeEvent(input$kontakt, {
    showNotification(h4("Kontakt"),
                      p("mkehl.laubfrosch@gmail.com", tags$br(),
                        "GitHub:", tags$a(href = "https://github.com/m-kehl/weather_icond2",
                                          "https://github.com/m-kehl/weather_icond2"))
      ,duration = NULL)
  })
  
  #device_width <- reactive(shinybrowser::get_width() -40)
  
## -- C.1 --  TabPanel 1: Impressum --------------------------------------------
  
  # picture of laubfrosch
  output$laubfrosch <- renderUI({
        tags$img(src="laubfrosch_blau.png", height=250)
  })
  
  # change picture of laubfrosch on click
  onclick(
    "laubfrosch", {
      #on click -> changing color
      output$laubfrosch <- renderUI({
            tags$img(src="laubfrosch_rot.png", height=250)
      })
  })
## -- C.2 --  TabPanel 2: phenology  -------------------------------------------
  ## read and process phenology data
  # read meta data
  plant_meta <- reactive({
    if (input$main_tabsets == "pheno"){
      f_read_plants_meta()
    }
  })
  
  # read phenology data
  plant_data <- reactive(
      if (input$pflanzen != ""){
        f_read_plants(input$pflanzen)
      }else{
        #show all federal states as options in UI
        updateSelectInput(session,"bl_plant",
                            choices = unique(plant_meta()$Bundesland))
      }
  )
  #update UI for specific phases
  update_pheno_phases <- reactive(phenology_phases[phenology_phases$phase_id %in% unique(plant_data()$Phase_id),])
  observe({
    updateRadioButtons(session, "phase",
                       choiceNames = update_pheno_phases()$phase,
                       choiceValues = update_pheno_phases()$phase_id,
                       selected = c(5))
  })
  # limit stations in UI to those which host species chosen in UI
  bl_meta <- reactive(plant_meta()$Stationsname[plant_meta()$Bundesland == input$bl_plant])
  observe({
    updateSelectizeInput(session,"station_name",
                      choices = c(bl_meta(),input$station_name),
                      selected = input$station_name)
  })
  # postprocess phenology data
  plant_data_processed <- reactive(
    f_process_plants(plant_data(),input$phase,input$station_name,plant_meta())
    )

  ## show information box
  observeEvent(input$info_pheno, {
    f_infotext(input$main_tabsets)
  })
  
  ## plot phenology data
  observe({
    #placeholder-plot if no species or stationname is chosen in UI
    if (input$pflanzen == "" | length(input$station_name) == 0){
      output$plant_out <- renderPlot(f_plot_placeholder())
    }else{
      #plot phenology data for species chosen in UI
      output$plant_out <- renderPlot(f_plot_plants(plant_data_processed()[[1]],
                                                   input$pflanzen,plant_meta(),
                                                   input$station_name,input$trendline,
                                                   input$mtline,input$grid))
      output$plant_table <- renderTable(f_table_plants(plant_meta(),input$station_name))
      output$plant_map <- renderPlot(f_map_plants(plant_meta(),input$station_name))
      if (length(plant_data_processed()[[2]]) == 0){
        output$no_plant <- renderText("")
      } else{
        output$no_plant <- renderText(paste0("Keine Daten vorhanden für: ",paste(plant_data_processed()[[2]],collapse = ', ')))
      }
    }
  })

## -- C.3 --  TabPanel 3: measurement data ----------------------------------------------------------------
  # update UI
  shinyjs::hideElement("box_sincetill")

  ## read and process measurement data
  # read meta data
  mess_meta <- f_read_mess_meta()
  # update UI based on meta data
  updateSelectizeInput(session,"mess_name",
                    choices = base::unique(mess_meta$Stationsname),
                    options = list(maxItems = 5))
  # read measurement data
  mess_data <- reactive(f_read_mess(input$mess_name,mess_meta,input$mess_tabsets))

  ## show information box
  observeEvent(input$info_mess, {
    f_infotext(input$main_tabsets)
  })
  
  ## update UI
  observeEvent(input$mess_tabsets,{
    f_updateselectize_parameters(session,"parameter_plot1",input$mess_tabsets,input$parameter_plot1)
    f_updateselectize_parameters(session,"parameter_plot2",input$mess_tabsets,input$parameter_plot2)
  })
  
  ## plot measurement data
  observe({
    # placeholder-plot if no station is chosen in UI
    if (length(input$mess_name) == 0){
      output$mess_plot <- renderPlot(f_plot_placeholder())
      output$mess_plot_daily <- renderPlot(f_plot_placeholder())
      output$mess_plot_monthly <- renderPlot(f_plot_placeholder())
    } else if (input$mess_tabsets == "now"){
      # plot measurement data for recent measurements
      output$mess_plot <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets,input$parameter_plot1,"Plot 1: "))
      output$mess_plot_prec <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets,input$parameter_plot2,"Plot 2: "))
      shinyjs::hideElement("box_sincetill")
    } else if (input$mess_tabsets == "daily"){
      # update UI
      updateSliderInput(session,"sincetill",
                        min = mess_data()$MESS_DATUM[1],
                        max = mess_data()$MESS_DATUM[nrow(mess_data())],
                        timeFormat = "%d.%m.%Y")
      shinyjs::showElement("box_sincetill")
      # plot measurement data for daily measurements
      output$mess_plot_daily <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets,input$parameter_plot1,"Plot 1: ",input$sincetill))
      output$mess_plot_daily_prec <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets,input$parameter_plot2,"Plot 2: ",input$sincetill))
    } else if (input$mess_tabsets == "monthly"){
      # plot measurement data for monthly measurements
      output$mess_plot_monthly <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets,input$parameter_plot1,"Plot 1: "))
      output$mess_plot_monthly_prec <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets,input$parameter_plot2,"Plot 2: "))
      # update UI
      shinyjs::hideElement("box_sincetill")
    }
  })


## -- C.4 --  TabPanel 4: ICON d2  ----------------------------------------------------------------
  
  ## read and process icon d2 forecast data
  # read icon d2 forecast data
  icond2_data <- reactive(f_read_icond2(f_forecast_time(),input$parameter))
  # postprocess icon d2 forecast data
  icond2_processed <- reactive(f_process_icond2(icond2_data(),input$parameter))
  # take needed layer out of forecast data (according to user input)
  icond2_layer <- reactive(f_subset_icond2(input$slider_time,icond2_processed(),input$parameter))
  
  # read coordinates for point forecast
  point_coord <- reactive(f_point_coord(input$bundesland, input$point_forecast,
                                        input$free_lon, input$free_lat, input$map_out_click))
  
  # produce point forecast out of icon d2 forecast data
  point_forecast <- reactive(
    terra::extract(icond2_processed(), point_coord(), raw = TRUE, ID = FALSE)
  )
  
  # specify when forecast data was calculated
  #output$forecast_time <- renderText(paste0("Forecast time is: ", f_forecast_time()))

  ## show information box
  observeEvent(input$info_icond2, {
    f_infotext(input$main_tabsets)
  })
  
  ## plot forecast data
  # setup leaflet map
  output$map_out <- renderLeaflet(
    f_leaflet_basic()
  )
  
  # make leaflet UI reactive to device width
  # output$leaf=renderUI({
  #   leafletOutput('map_out', width = min(800,device_width()))
  # })
  
  # adapt displayed layer on map according to user time input
  observe({
    f_leaflet_layer(input$parameter,icond2_processed(),icond2_layer(),session)
    if (length(input$parameter) != 0){
      if (input$parameter == "rain_gsp"){
        map_text <- "Niederschlag [mm/h] - "
      } else if (input$parameter == "snow_gsp"){
        map_text <- "Schnee [mm/h] - "
      } else if (input$parameter == "t_2m"){
        map_text <- "Temperatur [\u00B0C] - "
      }
      output$map_title <- renderText(paste0(map_text,format(as.POSIXct(time(icond2_layer(), format= ""),"CET"),
                                                            "%d.%m.%Y %H:%M")))
    }

  })
  
  # adapt legend on map if parameter input changes
  observeEvent(input$parameter,{
    f_leaflet_legend(input$parameter,icond2_processed(),session)
  })
  
  # adapt shown leaflet map section according to user input
  observeEvent(input$bundesland,{
    f_leaflet_setview(input$bundesland,session)
  })
  
  # add markers on leaflet map according to user input
  observe({
    f_leaflet_markers(input$point_forecast,input$free_lon,input$free_lat,input$bundesland,
                      input$map_out_click,session)
  })
  
  ## plot point forecast data
  observe({
    if (is.null(input$parameter)){
      output$bar_out <- renderPlot(
        plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
      )
    } else if (is.null(input$map_out_click) && input$point_forecast == "mouse"){
      output$bar_out <- renderPlot(
        plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
      )
    } else if ((is.na(input$free_lon) | is.na(input$free_lat)) & input$point_forecast == "free"){
      output$bar_out <- renderPlot(
        f_barplot_icond2_placeholder(),
        # make plot size reactive to device width
        #width = min(800,device_width())
      )
    } else{
      output$bar_out <- renderPlot(
        f_barplot_icond2(point_forecast(),input$slider_time,input$parameter,
                         input$point_forecast,
                         bundeslaender_coord$landeshauptstadt[bundeslaender_coord$bundesland == input$bundesland]),
        # make plot size reactive to device width
        #width = min(800,device_width())
      )
    }
  })

  ## adapt UI if user wishes free coordinates
  observeEvent(input$point_forecast,{
    if (input$point_forecast == "free"){
      shinyjs::show("box_free_coord")
    } else{
      shinyjs::hide("box_free_coord")
    }
  })

}
shinyApp(ui, server)

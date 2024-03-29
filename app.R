#ShinyApp to visualise measurement and forecast weather data provided
#to the public by DWD (Deutscher Wetterdienst; opendata.dwd.de)
#
#20.02.2024 - ShinyApp created by m-kehl (mkehl.laubfrosch@gmx.ch)


## -- A -- Preparation ---------------------------------------------------------
rm(list = ls())

## required packages
library(shiny)
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
library(r2symbols)

## source functions and input
source.all(paste0(getwd(),"/functions/"))
source(paste0(getwd(),"/input.R"),local = TRUE)

##set local system
Sys.setlocale("LC_TIME", "German")

## -- B -- User Interface ------------------------------------------------------
ui <- fluidPage(
  tags$head(
    ## define superordinate settings 
    # HTML style for tabsets and notifications
    tags$style(HTML(
      ".tabbable > .nav > li                 > a  {font-weight: bold; 
                                                  background-color: aquamarine; 
                                                  color:black}
      .tabbable > .nav > li[class=active]    > a {background-color: HoneyDew; 
                                                  color:black}
      .tabbable ul li:nth-child(1) { float: right; }
      .tabbable ul li:nth-child(2) { float: right; }
      .tabbable ul li:nth-child(3) { float: right; }
      .tabbable ul li:nth-child(4) { float: right; }
      .shiny-notification {position:fixed;
                            top: calc(13%);
                            left: calc(18%);
                            max-width: 450px;
                            background-color: HoneyDew;
                            color: black;
                            border-color: aquamarine}"
    ))
  ),
  # use shiny waiter
  useWaiter(),
  ## Title
  titlePanel(title=div(img(src="laubfrosch.jpg",width = 100,height = 100),
                       "Prognose- und Messdaten"), windowTitle = "ICON-D2"),

  ## Main Panel
  fluidRow(
    mainPanel(
      useShinyjs(),
        # define main_tabsets (ICON D2, measurement data, phenology, impressum)
        tabsetPanel(
          id = "main_tabsets",
          selected = "icond2",

## -- B.1 --  TabPanel 1: Impressum --------------------------------------------
          tabPanel("Impressum",
                   value = "impressum",
            uiOutput("laubfrosch",style="float:right"),
            h3("Kontakt"),
            h4("M. Kehl"),
            h4("mkehl.laubfrosch@gmx.ch"),
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
                      "BrainBox Solutions"))
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
                                              border-color: aquamarine",
                                       widht = "10%")),
               column(10,
                  h4("Phänologie",width = "90%")),
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
               p("Datenbasis: ",
                symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)")
            ),
            column(9,
               plotOutput("plant_out"),
               textOutput("no_plant"),
               column(6,plotOutput("plant_map")),
               column(6,tableOutput("plant_table"))
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
                                        border-color: aquamarine",
                                 widht = "10%")),
               column(10,
                   h4("Messdaten",width = "90%")),
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
               p("Datenbasis: ",
                symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)")
            ),
            column(9,
              # define second-level tabsets (now, daily, monthly)
              tabsetPanel(id = "mess_tabsets",
                tabPanel("aktuelle Messungen",
                  value = "now",
                  plotOutput("mess_plot"),
                  plotOutput("mess_plot_prec")),
                tabPanel("Tageswerte",
                  value = "daily",
                  plotOutput("mess_plot_daily"),
                  plotOutput("mess_plot_daily_prec")),
                tabPanel("Monatswerte",
                  value = "monthly",
                  plotOutput("mess_plot_monthly"),
                  plotOutput("mess_plot_monthly_prec"),
                  p("in Bearbeitung.."))
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
                                              border-color: aquamarine",
                                       widht = "10%")),
               column(10,
                   h4("Regionalmodell ICON-D2",width = "90%")),
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
                choiceNames = c("Landeshauptstadt","freie Koordinatenwahl"),
                choiceValues = c("bhs","free")),
               box(id = "box_free_coord",
                width = '800px',
                numericInput("free_lon",label = "longitude", value = 9.05222,
                                 step = 0.5, width = "50%"),
                numericInput("free_lat",label = "latitude", value = 48.52266,
                                 step = 0.5, width = "50%")),
               p("Datenbasis: ",
                symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)")
            ),
            column(5,
               plotOutput("map_out"),
               sliderInput("slider_time", 
                "Zeit", 
                min = ceiling_date(Sys.time(),unit = "hour"),
                max = ceiling_date(Sys.time(),unit = "hour") + 6 * 60 * 60,
                step = 3600,
                value = c(ceiling_date(Sys.time(),unit = "hour")),
                timeFormat = "%a %H:%M", ticks = T, animate = T,
                width = "95%")
            ),
            column(4,
               plotOutput("bar_out")
            )
          )
        )
    )
  )
)



## -- C --  server -------------------------------------------------------------
server <- function(input, output, session) {

## -- C.1 --  TabPanel 1: Impressum --------------------------------------------
  
  # picture of laubfrosch
  output$laubfrosch <- renderUI({
        tags$img(src="laubfrosch_blau.jpg", height=250)
  })
  
  # change picture of laubfrosch on click
  onclick(
    "laubfrosch", {
      #on click -> changing color
      output$laubfrosch <- renderUI({
            tags$img(src="laubfrosch_rot.jpg", height=250)
      })
  })
## -- C.2 --  TabPanel 2: phenology  -------------------------------------------
  ## read and process phenology data
  # read meta data
  plant_meta <- f_read_plants_meta()
  # read phenology data for specific species
  plant_data <- reactive(
      if (input$pflanzen != ""){
        f_read_plants(input$pflanzen)
      }else{
        #update SelectInput for Bundesland chosen in UI
        updateSelectInput(session,"bl_plant",
                            choices = unique(plant_meta$Bundesland))
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
  bl_meta <- reactive(plant_meta$Stationsname[plant_meta$Bundesland == input$bl_plant])
  observe({
    updateSelectizeInput(session,"station_name",
                      choices = c(bl_meta(),input$station_name),
                      selected = input$station_name)
  })
  # postprocess phenology data
  plant_data_processed <- reactive(
    f_process_plants(plant_data(),input$phase,input$station_name,plant_meta)
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
      output$plant_out <- renderPlot(f_plot_plants(plant_data_processed()[[1]],input$pflanzen,plant_meta,input$station_name))
      output$plant_table <- renderTable(f_table_plants(plant_meta,input$station_name))
      output$plant_map <- renderPlot(f_map_plants(plant_meta,input$station_name))
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
  # read boundary-coordinates for specified Bundesland
  square_coord <- reactive(f_spatvector(input$bundesland))
  # postprocess icon d2 forecast data
  icond2_processed <- reactive(f_process_icond2(icond2_data(),input$parameter))
  # adapt forecast data for specified Bundesland
  icond2_state <- reactive(f_cut_forecast(icond2_processed(),square_coord()))
  # read coordinates for point forecast
  point_coord <- reactive(f_point_coord(input$bundesland, input$point_forecast,
                                        input$free_lon, input$free_lat))
  # produce point forecast out of icon d2 forecast data
  point_forecast <- reactive(
    terra::extract(icond2_processed(), point_coord()[[1]], raw = TRUE, ID = FALSE)
  )
  # specify when forecast data was calculated
  output$forecast_time <- renderText(paste0("Forecast time is: ", f_forecast_time()))

  ## show information box
  observeEvent(input$info_icond2, {
    f_infotext(input$main_tabsets)
  })

  ## plot forecast data
  observe({
    # placeholder-plot if no parameter is chosen in UI
    if (length(input$parameter) == 0){
      output$map_out <- renderPlot(
        f_plot_placeholder()
      )
    } else{
      # plot parameter chosen in UI on map
      output$map_out <- renderPlot(
        f_map_icond2(input$slider_time,icond2_state(),input$parameter,
                     point_coord()[[2]], input$point_forecast)
      )
      # plot point forecast
      if (!is.na(input$free_lon) && !is.na(input$free_lat)){
        output$bar_out <- renderPlot(
          f_barplot_icond2(point_forecast(),input$slider_time,input$parameter,
                           input$point_forecast,
                           bundeslaender_coord$landeshauptstadt[bundeslaender_coord$bundesland == input$bundesland])
        )
      } else{
        # placeholder-barplot if no parameter is chosen in UI
        output$bar_out <- renderPlot(
          f_barplot_icond2_placeholder()
        )
      }
    }
  })

  ## adapt UI if user wishes free coordinates
  observeEvent(input$point_forecast,{
    shinyjs::toggle("box_free_coord")
  })

}
shinyApp(ui, server)

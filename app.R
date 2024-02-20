#ShinyApp to visualise measurement and forecast weather data provided
#to the public by DWD (opendata.dwd.de)
#
#20.02.2024 - ShinyApp created by m-kehl (rudolfsinger36@gmail.com)


## -- A -- Preparation -----------------------------------------------------
rm(list = ls())

## required packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(waiter)

library(rdwd)
library(terra)
library(miceadds)
library(lubridate)
library(RCurl)
library(curl)
library(R.utils)
library(dplyr)
library(r2symbols)

## options
options(encoding = "latin1")

## source functions and input
source.all(paste0(getwd(),"/functions/"))
source(paste0(getwd(),"/input.R"),local = TRUE)


## -- B -- User Inferface --------------------------------------------------


ui <- fluidPage(
  tags$head(
    ## define color and position for tabsets
    tags$style(HTML(
      ".tabbable > .nav > li                 > a  {font-weight: bold; background-color: aquamarine;  color:black}
      .tabbable > .nav > li[class=active]    > a {background-color: HoneyDew; color:black}
      .tabbable ul li:nth-child(1) { float: right; }
      .tabbable ul li:nth-child(2) { float: right; }
      .tabbable ul li:nth-child(3) { float: right; }
      .tabbable ul li:nth-child(4) { float: right; }"
    ))
  ),
  ## Shiny waiter
  useWaiter(),
  ## Title
  titlePanel(title = "ICON D2 forecast", windowTitle = "ICON-D2"),# style="background-color:red"),

  ## Main Panel
  fluidRow(
    mainPanel(
      useShinyjs(),
        # define main_tabsets (icond2, measurement data, phenology, impressum)
        tabsetPanel(
          id = "main_tabsets",
          selected = "icond2",

## -- B.1 --  TabPanel 1: Impressum ---------------------------------------------------------------
          tabPanel("Impressum",
                   value = "impressum",
            p("in Bearbeitung")
          ),
## -- B.2 --  TabPanel 2: phenology  --------------------------------------------------------------

          tabPanel("Phänologie", 
                   value = "pheno",
            column(3, 
               selectInput(
                inputId = "pflanzen",
                label = "Pflanzenart",
                choices = pflanzen_arten,
                multiple = FALSE),
               radioButtons(
                inputId = "phase",
                label = "phaenologische Phase",
                choiceNames = phenology_phases$phase,
                choiceValues = phenology_phases$phase_id,
                selected = character(0)),
               selectInput(
                inputId = "bl_plant",
                label = "Bundesland",
                choices = c(""),
                multiple = FALSE),
               selectInput(
                inputId = "station_name",
                label = "Stationsname",
                choices = c(""),
                multiple = FALSE),
               p("Datenbasis: ",
                symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)")
            ),
            column(9,
               plotOutput("plant_out")
              #textOutput("plant_text")
            ),
          ),

## -- B.3 --  TabPanel 3: measurement data --------------------------------------------------------------


          tabPanel("Messdaten",
                   value = "mess",
            column(3, 
              selectizeInput(
               inputId = "mess_name",
               label = "Stationsname/n (max. 5)",
               choices = c(""),
               multiple = TRUE,
               options = list(maxItems = 5)),
              box(id = "box_sincetill",
                  width = '800px',
                  sliderInput("sincetill",
                   "Zeitspanne für Plot",
                   min = Sys.Date()-61,
                   max = Sys.Date(),
                   value = c(Sys.Date()-60,Sys.Date()-1),
                   step = 1), #1day
              ),
                          
              p("Datenbasis: ",
                symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)" )),
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
## -- B.4 --  TabPanel 4: ICON d2 --------------------------------------------------------------
          tabPanel("Vorhersage ICON d2",
                   value = "icond2",
            column(3, 
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
                                 step = NA, width = "50%"),
                  numericInput("free_lat",label = "latitude", value = 48.52266,
                                 step = NA, width = "50%")),
              p("Datenbasis: ", symbol("copyright"),
                "Deutscher Wetterdienst (opendata.dwd.de)"),

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
             #textOutput("forecast_time")
            )
          )
        )
    )
  )
)



## -- C --  server ------------------------------------------------------------------
server <- function(input, output, session) {

## -- C.1 --  TabPanel 1: Impressum -------------------------------------
  #coming soon
## -- C.2 --  TabPanel 2: phenology  ----------------------------------------------------------------
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
    updateSelectInput(session,"station_name",
                      choices = c(bl_meta()))
  })
  # postprocess phenology data
  plant_data_processed <- reactive(
    f_process_plants(plant_data(),input$phase,input$station_name,plant_meta)
    )
  
  ## plot phenology data
  observe({
    #text-plot if no species is chosen in UI
    if (input$pflanzen == ""){
      output$plant_out <- renderPlot(f_plot_spaceholder())
      #plot phenology data for species chosen in UI
    }else{
      output$plant_out <- renderPlot(f_plot_plants(plant_data_processed(),input$pflanzen))
      #extract data of station-closure (if it is closed)
      end_data <- plant_meta$`Datum Stationsaufloesung`[plant_meta$Stationsname==input$station_name][1]
      end_data <- ifelse(is.na(end_data),"",end_data)
      if (end_data == ""){
        output$plant_text <- renderText("")
      }else{
        output$plant_text <- renderText(paste0("Stationsauflösung: ",end_data))
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

  ## plot measurement data
  observe({
    # text-plot if no station is chosen in UI
    if (length(input$mess_name) == 0){
      output$mess_plot <- f_plot_spaceholder()
      output$mess_plot_prec <- f_plot_spaceholder()
      # plot measurement data for recent measurements
    } else if (input$mess_tabsets == "now"){
      output$mess_plot <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets))
      output$mess_plot_prec <- renderPlot(f_plot_mess_prec(mess_data(),input$mess_tabsets))
      shinyjs::hideElement("box_sincetill")
      # plot measurement data for daily measurements and update UI
    } else if (input$mess_tabsets == "daily"){
      # update UI
      updateSliderInput(session,"sincetill",
                        min = mess_data()$MESS_DATUM[1],
                        max = mess_data()$MESS_DATUM[nrow(mess_data())],
                        timeFormat = "%d.%m.%Y")
      shinyjs::showElement("box_sincetill")
      # plot measurement data for daily measurements
      output$mess_plot_daily <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets,input$sincetill))
      output$mess_plot_daily_prec <- renderPlot(f_plot_mess_prec(mess_data(),input$mess_tabsets,input$sincetill))
      # plot measurement data for monthly measurements
    } else if (input$mess_tabsets == "monthly"){
      output$mess_plot_monthly <- renderPlot(f_plot_mess(mess_data(),input$mess_tabsets))
      output$mess_plot_monthly_prec <- renderPlot(f_plot_mess_prec(mess_data(),input$mess_tabsets))
      shinyjs::hideElement("box_sincetill")
    }
  })
  
  
## -- C.4 --  TabPanel 4: ICON d2  ----------------------------------------------------------------
  ## read and process forecast data
  # read icon d2 forecast data
  nwp_data <- reactive(f_read_icond2(f_forecast_time(),input$parameter))
  # read boundary-coordinates for specified Bundesland
  square_coord <- reactive(f_square_coord(input$bundesland))
  # postprocess icon d2 forecast data
  whole_forecast <- reactive(f_process_icond2(nwp_data(),input$parameter))
  # adapt forecast data for specified Bundesland
  state_forecast <- reactive(f_state_forecast(whole_forecast(),square_coord()))
  # read coordinates for point forecast
  point_coord <- reactive(f_point_coord(input$bundesland, input$point_forecast,
                                        input$free_lon, input$free_lat))
  # produce point forecast out of icon d2 forecast data
  point_forecast <- reactive(
    terra::extract(whole_forecast(), point_coord()[[1]], raw = TRUE, ID = FALSE)
  )
  # specify when forecast data was calculated
  output$forecast_time <- renderText(paste0("Forecast time is: ", f_forecast_time()))
  
  ## plot forecast data
  observe({
    # text-plot if no parameter is chosen in UI
    if (length(input$parameter) == 0){
      output$map_out <- renderPlot(
        f_plot_spaceholder()
      )
      # plot parameter chosen in UI on map
    } else{
      output$map_out <- renderPlot(
        f_map_icond2(input$slider_time,state_forecast(),input$parameter,
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

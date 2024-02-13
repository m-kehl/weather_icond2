#https://statsandr.com/blog/how-to-publish-shiny-app-example-with-shinyapps-io/
#https://datasciencegenie.com/how-to-embed-a-shiny-app-on-website/
#https://happygitwithr.com
#https://rstudio.github.io/shinydashboard/get_started.html
library(shiny)
library(shinydashboard)
library(shinyjs)
library(waiter)

rm(list = ls())
#todo: change so that path lies in input.R

##load required libraries
library(rdwd)
library(terra)
library(miceadds)
library(lubridate)
library(RCurl)
library(curl)
library(R.utils)
library(dplyr)
library(r2symbols)

#Sys.setlocale("LC_TIME", "de")
options(encoding = "latin1")

#todo: source.all withouth miceadds library
source.all(paste0(getwd(),"/functions/"))
source(paste0(getwd(),"/input.R"),local = TRUE)



ui <- fluidPage(
  tags$head(
    tags$style(HTML(
      ".tabbable ul li:nth-child(1) { float: right;}
      .tabbable ul li:nth-child(2) { float: right; }
      .tabbable ul li:nth-child(3) { float: right; }"
      # .tabbable ul li:nth-child(4) { float: left; }
      # .tabbable ul li:nth-child(5) { float: left; }
      # .tabbable ul li:nth-child(6) { float: left; }"
    ))
  ),
  useWaiter(), # dependencies
  #autoWaiter("map_out"),
  #waiterShowOnLoad(spin_fading_circles()),
  titlePanel(title = "ICON D2 forecast", windowTitle = "ICON-D2"),
  fluidRow(
    mainPanel(
      useShinyjs(),
        tabsetPanel(
          id = "main_tabsets",
          
          # tabPanel 1 --------------------------------------------------------------
          tabPanel("Vorhersage ICON d2",
                   value = "icond2",
                   
                   column(3, 
                          radioButtons(
                            inputId = "parameter",
                            label = "Parameter",
                            selected = character(0),
                            choiceNames = c("Regen","Schnee","Temperatur"),
                            choiceValues = c("rain_gsp","snow_gsp","t_2m")
                          ),
                          selectInput(
                            inputId = "bundesland",
                            label = "Bundesland",
                            choices = bundeslaender_coord$bundesland,
                            multiple = FALSE
                          ),
                          radioButtons(
                            inputId = "point_forecast",
                            label = "point forecast",
                            choiceNames = c("Landeshauptstadt","freie Koordinatenwahl"),
                            choiceValues = c("bhs","free")
                          ),
                          box(id = "box_free_coord", width = '800px',
                              numericInput("free_lon",label = "longitude", value = 9.05222,
                                           step = NA, width = "50%"),
                              numericInput("free_lat",label = "latitude", value = 48.52266,
                                           step = NA, width = "50%"),
                          ),
                          p("Datenbasis: ", symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)" ),

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
                                      # loop = T, interval = 1,
                                      width = "95%"
                          )),
                   column(4,
                          plotOutput("bar_out"),
                          textOutput("forecast_time"))
          

  ),

# TabPanel 2 --------------------------------------------------------------

          tabPanel("Phänologie", 
                   value = "pheno",
            column(3, 
                   selectInput(
                inputId = "pflanzen",
                label = "Pflanzenart",
                choices = pflanzen_arten,
                multiple = FALSE
             ),
             
             radioButtons(
               inputId = "phase",
               label = "phaenologische Phase",
               choiceNames = phenology_phases$phase,
               choiceValues = phenology_phases$phase_id,
               selected = character(0)
             ),selectInput(
               inputId = "bl_plant",
               label = "Bundesland",
               choices = c(""),
               multiple = FALSE
             ),
             
             selectInput(
               inputId = "station_name",
               label = "Stationsname",
               choices = c(""),
               multiple = FALSE
             ),
             p("Datenbasis: ", symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)" )
             ),
            column(9,
                   plotOutput("plant_out"),
                   textOutput("plant_text")
                   ),
             

          ),

# tabpanel 3 --------------------------------------------------------------


          tabPanel("Messdaten",
                   value = "mess",
                   column(3, 
                          selectizeInput(
                            inputId = "mess_name",
                            label = "Stationsname",
                            choices = c(""),
                            multiple = TRUE,
                            options = list(maxItems = 2)
                          ),    
                          
                          p("Datenbasis: ", symbol("copyright"), "Deutscher Wetterdienst (opendata.dwd.de)" )
                   ),
                   column(9,
                          # tags$head(
                          #   tags$style(HTML(
                          #     ".tabbable ul li:nth-child(1) { float: left;}
                          #     .tabbable ul li:nth-child(2) { float: left; }
                          #     .tabbable ul li:nth-child(3) { float: left; }"
                          #   ))
                          # ),
                          tabsetPanel(id = "mess_tabsets",
                            tabPanel("aktuelle Messungen",
                                     value = "now",
                                     #textOutput("mess_text"),
                                     plotOutput("mess_plot"),
                                     plotOutput("mess_plot_prec")
                                     ),
                            tabPanel("Tageswerte",
                                     value = "daily",
                                     p("in Bearbeitung..")),
                            tabPanel("Monatswerte",
                                     value = "monthly",
                                     p("in Bearbeitung.."))
                          )
                          
                   ),
                   
                   
          

                   
                   )
        )))
      

)
#todo: terra::extract for point_forecast -> take point from whole germany instead of only square_coord -> how much
#more time does this take?
#todo: point_coordinate -> barplot only for landeshauptstadt

# server ------------------------------------------------------------------


server <- function(input, output, session) {

# Tabset 1 ----------------------------------------------------------------

  
  nwp_data <- reactive(f_read_icond2(f_forecast_time(),input$parameter))



  square_coord <- reactive(f_square_coord(input$bundesland))

  whole_forecast <- reactive(f_process_icond2(nwp_data(),input$parameter))
  state_forecast <- reactive(f_state_forecast(whole_forecast(),square_coord()))

  point_coord <- reactive(f_point_coord(input$bundesland, input$point_forecast,
                                        input$free_lon, input$free_lat))
  point_forecast <- reactive(
    terra::extract(whole_forecast(), point_coord()[[1]], raw = TRUE, ID = FALSE)
    )

  output$forecast_time <- renderText(paste0("Forecast time is: ", f_forecast_time()))

  observe({
    if (length(input$parameter) == 0){
      output$map_out <- renderPlot(
        f_plot_spaceholder()
      )
    } else{
      output$map_out <- renderPlot(
        f_map_icond2(input$slider_time,state_forecast(),input$parameter,
              point_coord()[[2]], input$point_forecast)
      )

      if (!is.na(input$free_lon) && !is.na(input$free_lat)){
        output$bar_out <- renderPlot(

          f_barplot_icond2(point_forecast(),input$slider_time,input$parameter)
        )
      } else{
        output$bar_out <- renderPlot(
          f_barplot_icond2_placeholder()
        )
      }

    }
  })

  output$test <- renderText(paste0("your time is: ",with_tz(input$slider_time, "CET")))
  output$time_out <- renderText(paste0("your time is: ",input$time))

  observeEvent(input$point_forecast,{
    shinyjs::toggle("box_free_coord")

  })
# Tabset 2 ----------------------------------------------------------------
  plant_meta <- f_read_plants_meta()
  
    plant_data <- reactive(
      if (input$pflanzen != ""){
        f_read_plants(input$pflanzen)
      }else{
        updateSelectInput(session,"bl_plant",
                            choices = unique(plant_meta$Bundesland)
                              )
        }
      )
  update_pheno_phases <- reactive(phenology_phases[phenology_phases$phase_id %in% unique(plant_data()$Phase_id),])
  
  observe({
    updateRadioButtons(session, "phase",
                       choiceNames = update_pheno_phases()$phase,
                       choiceValues = update_pheno_phases()$phase_id,
                       selected = c(5))
  })
  
  
  bl_meta <- reactive(plant_meta$Stationsname[plant_meta$Bundesland == input$bl_plant])
  observe({
    updateSelectInput(session,"station_name",
                      choices = c(bl_meta()))
  })
  
  plant_data_processed <- reactive(
    f_process_plants(plant_data(),input$phase,input$station_name,plant_meta)
    )
  
  observe({
    
      if (input$pflanzen == ""){
        output$plant_out <- renderPlot(f_plot_spaceholder())
      }else{
        output$plant_out <- renderPlot(f_plot_plants(plant_data_processed()))
        end_data <- plant_meta$`Datum Stationsaufloesung`[plant_meta$Stationsname==input$station_name][1]
        end_data <- ifelse(is.na(end_data),"",end_data)
        if (end_data == ""){
          output$plant_text <- renderText("")
        }else{
          output$plant_text <- renderText(paste0("Stationsaufloesung: ",end_data))
        }
      }
    
  })

# tabset 3 ----------------------------------------------------------------
  observe({ if (input$mess_tabsets == "now"){
      print("monthly")
    }
  })
  
  mess_meta <- f_read_mess_meta()
  updateSelectizeInput(session,"mess_name",
                    choices = base::unique(mess_meta$Stationsname),
                    options = list(maxItems = 5)
  )
  mess_data <- reactive(f_read_mess(input$mess_name,mess_meta))
  #availability <- reactive(f_check_data_availability(input$mess_name,mess_meta))
  
  observe({
    if (length(input$mess_name) == 0){
      output$mess_plot <- f_plot_spaceholder()
      output$mess_plot_prec <- f_plot_spaceholder()
    }
    # else if(length(availability()) > 0){
    #   output$mess_plot <- f_plot_spaceholder()
    #   output$mess_plot_prec <- f_plot_spaceholder()
    #   output$mess_text <- renderText(paste0("Keine Daten für ",availability()," vorhanden"))
    # }
    else{
      output$mess_plot <- renderPlot(f_plot_mess(mess_data(),input$mess_name))
      output$mess_plot_prec <- renderPlot(f_plot_mess_prec(mess_data(),input$mess_name))
      output$mess_text <- renderText("")
    }
  })

}
shinyApp(ui, server)

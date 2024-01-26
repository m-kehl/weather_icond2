#https://statsandr.com/blog/how-to-publish-shiny-app-example-with-shinyapps-io/
#https://datasciencegenie.com/how-to-embed-a-shiny-app-on-website/
#https://happygitwithr.com
library(shiny)
library(shinydashboard)
library(shinyjs)
library(waiter)

rm(list = ls())
#todo: change so that path lies in input.R
path <- "/Users/Manuela/Documents/tubingen/"

##load required libraries
library(rdwd)
library(terra)
library(miceadds)
library(lubridate)

#Sys.setlocale("LC_TIME", "de")
options(encoding = "latin1")

#todo: source.all withouth miceadds library
source.all(paste0(path,"scripts_V3/functions/"))
source(paste0(path,"scripts_V3/input.R"))


ui <- fluidPage(
  useWaiter(), # dependencies
  #autoWaiter("map_out"),
  #waiterShowOnLoad(spin_fading_circles()),
  titlePanel(title = "ICON D2 forecast", windowTitle = "ICON-D2"),
  fluidRow(
    mainPanel(
      useShinyjs(),    

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
      # tabsetPanel(
      #   id = "free_coord",
      #   type = "hidden",
      #   tabPanel(numericInput("free_lon",label = "longitude", value = 9.05222,
      #                         step = NA, width = "50%")),
      #   tabPanel(numericInput("free_lat",label = "latitude", value = 48.52266,
      #                         step = NA, width = "50%")),
      # 
      # ),
      # numericInput("time", label = "Please enter the timestep", min = 1,
      #              max = 48, step = 1,
      #              value = 5)
    ),
    column(5, 
           plotOutput("map_out"),
           sliderInput("slider_time", 
                       "Zeit", 
                       min = f_forecast_time(),
                       max = f_forecast_time() + 48 * 60 * 60,
                       step = 3600,
                       value = c(ceiling_date(Sys.time(),unit = "hour")),
                       timeFormat = "%a %H:%M", ticks = T, animate = T,
                       # loop = T, interval = 1,
                       width = "95%"
           )),
    column(4,
           plotOutput("bar_out"),
           textOutput("forecast_time"),
           textOutput("test"))
           )
  )
)
#todo: terra::extract for point_forecast -> take point from whole germany instead of only square_coord -> how much
#more time does this take?
#todo: point_coordinate -> barplot only for landeshauptstadt
server <- function(input, output, session) {
  
  nwp_data <- reactive(f_read_data(f_forecast_time(),input$parameter))



  square_coord <- reactive(f_square_coord(input$bundesland))
  #diff_forecasts <- reactive(f_process_data(nwp_data(),square_coord(),input$parameter))

  whole_forecast <- reactive(f_process_data(nwp_data(),input$parameter))
  state_forecast <- reactive(f_state_forecast(whole_forecast(),square_coord()))

  point_coord <- reactive(f_point_coord(input$bundesland, input$point_forecast,
                                        input$free_lon, input$free_lat))
  point_forecast <- reactive(
    terra::extract(whole_forecast(), point_coord()[[1]], raw = TRUE, ID = FALSE)
    )

  output$forecast_time <- renderText(paste0("Forecast time is: ", f_forecast_time()))

  # observeEvent(input$parameter,{
  #
  # })

  observe({
    if (length(input$parameter) == 0){
      output$map_out <- renderPlot(
        f_map_start()
      )
    } else{
      output$map_out <- renderPlot(
        f_map(input$slider_time,state_forecast(),input$parameter,
              point_coord()[[2]], input$point_forecast)
      )

      if (!is.na(input$free_lon) && !is.na(input$free_lat)){
        output$bar_out <- renderPlot(

          f_barplot(point_forecast(),input$slider_time,input$parameter)
        )
      } else{
        output$bar_out <- renderPlot(
          f_barplot_placeholder()
        )
      }

    }
  })

  output$test <- renderText(paste0("your time is: ",with_tz(input$slider_time, "CET")))
  output$time_out <- renderText(paste0("your time is: ",input$time))

  observeEvent(input$point_forecast,{
    shinyjs::toggle("box_free_coord")
    # if (input$point_forecast == "free"){
    #   updateTabsetPanel(session,
    #     inputId = "free_coord")
    # 
    # } else{
    #   updateTabsetPanel(session,
    #                     inputId = "free_coord")
    # 
    #   
    # }
  })

}
shinyApp(ui, server)

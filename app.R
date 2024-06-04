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
  ## define superordinate settings 
  # HTML/CSS style for different elements (tabsets, plots, text, etc)

  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  # use shiny waiter and shinybrowser
  useWaiter(),
  shinybrowser::detect(),
  
  ## show warning text if webapp is used on mobile device
  span(class = "mobile_info", textOutput("browser_info")),

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
                impressumUI("impressum")
            )
          ),
## -- B.2 --  TabPanel 2: phenology  -------------------------------------------

          tabPanel("Phänologie", 
                   value = "pheno",
                   phenologyUI("phenology")
        ),

## -- B.3 --  TabPanel 3: measurement data -------------------------------------

          tabPanel("Messdaten",
                   value = "mess",
            messdataUI("messdata")
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
                            choiceNames = c("Niederschlag","Temperatur","Bewölkung","Druck"),
                            choiceValues = c("tot_prec","t_2m","clct","pmsl")),
                          selectInput(
                            inputId = "bundesland",
                            label = "Bundesland",
                            choices = bundeslaender_coord$bundesland,
                            multiple = FALSE),
                          radioButtons(
                            inputId = "point_forecast",
                            label = "Punktvorhersage",
                            choiceNames = c("Mausklick","Landeshauptstadt","freie Koordinatenwahl"),
                            choiceValues = c("mouse","bhs","free"),
                            selected = "bhs"),
                          box(id = "box_free_coord",
                              width = '800px',
                              numericInput("free_lon",label = "longitude", value = 9.05222,
                                           step = 0.5, width = "50%"),
                              numericInput("free_lat",label = "latitude", value = 48.52266,
                                           step = 0.5, width = "50%")),
                          f_copyright_DWD()
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
  ),tags$footer(class = "footer","\u00A9 2024 - M. Kehl",br(), actionLink("link_to_impressum", "Impressum"),
                "|", div(class = "kontakt", a(href="mailto:mkehl.laubfrosch@gmail.com","Kontakt")), div(class="hidekontakt","mkehl.laubfrosch@gmail.com"))
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
  impressumServer("impressum")
## -- C.2 --  TabPanel 2: phenology  -------------------------------------------
  phenologyServer("phenology",reactive(input$main_tabsets))

## -- C.3 --  TabPanel 3: measurement data ----------------------------------------------------------------
  messdataServer("messdata",reactive(input$main_tabsets))
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

  ## show information box
  observeEvent(input$info_icond2, {
    f_infotext(input$main_tabsets)
  })
  
  ## plot forecast data
  # setup leaflet map
  output$map_out <- renderLeaflet(
    f_leaflet_basic()
  )

  # adapt displayed layer on map according to user time input
  observe({
    f_leaflet_layer(input$parameter,icond2_processed(),icond2_layer(),session)
    if (length(input$parameter) != 0){
      if (input$parameter == "tot_prec"){
        map_text <- "Niederschlag [mm/h] - "
      } else if (input$parameter == "t_2m"){
        map_text <- "Temperatur [\u00B0C] - "
      } else if (input$parameter == "clct"){
        map_text <- "Bewölkung [%] - "
      } else if (input$parameter == "pmsl"){
        map_text <- "Druck [hPa] - "
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
      )
    } else{
      output$bar_out <- renderPlot(
        f_barplot_icond2(point_forecast(),input$slider_time,input$parameter,
                         input$point_forecast,
                         bundeslaender_coord$landeshauptstadt[bundeslaender_coord$bundesland == input$bundesland]),
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

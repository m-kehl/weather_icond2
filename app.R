#ShinyApp to visualize measurement and forecast weather data provided
#to the public by DWD (Deutscher Wetterdienst; opendata.dwd.de)
#
#20.02.2024 - ShinyApp created by m-kehl (mkehl.laubfrosch@gmail.com)
#             code available via GitHub (https://github.com/m-kehl/weather_icond2)
#
#This ShinyApp is belongs to the Laubfrosch project by m-kehl and is publicly
#accessible via https://laubfrosch.shinyapps.io/weather-icond2/. The Laubfrosch
#project aims to show and explore the possibilities with OGD (open governmental data),
#in example with its visualization or representation in a generally comprehensible format.


## -- A -- Preparation ---------------------------------------------------------
rm(list = ls())

## required packages
library(shiny)
library(shinybrowser)
#library(shinydashboard)
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
                   icond2UI("icond2")
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
  icond2Server("icond2",reactive(input$main_tabsets))
}
shinyApp(ui, server)

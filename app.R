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
library(shiny)               #to create ShinyApp
library(shinybrowser)        #to detect screen size
library(shinydashboard)      #to create boxes for UI
library(shinyjs)             #to use css style
library(waiter)              #to show waiters while data is downloaded/processed
library(rdwd)                #to access data provided by DWD (opendata.dwd.de)
library(R.utils)             #neede by readDWD() when used online via shinyapp.io
library(terra)               #to visualize Raster Data
library(lubridate)           #to handle date and time
library(RCurl)               #to download data provided by DWD
library(curl)                #to read meta data
library(dplyr)               #to handle data frames
library(leaflet)             #to represents data on a map
library(miceadds)

## source functions and input
sapply(list.files(pattern="[.]R$", path=paste0(getwd(),"/functions/"), full.names=TRUE), source)
source(paste0(getwd(),"/input.R"),local = TRUE)

## -- B -- User Interface ------------------------------------------------------
ui <- fluidPage(
  ## define superordinate settings 
  # load CSS style for the different elements (tabsets, plots, text, etc)
  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  
  # activate shiny waiter,shinybrowser and shinyjs
  useWaiter(),
  shinybrowser::detect(),
  useShinyjs(),
  
  ## show warning text if ShinyApp is used on mobile device
  span(class = "mobile_info", textOutput("browser_info")),

  ## Main Panel for ShinyApp
  fluidRow(
    mainPanel(
      # Title
      titlePanel(title=div(class = "title",img(class = "title_pic",src="laubfrosch.png",width = 100,height = 100),
                           "Prognose- und Messdaten"), windowTitle = "Laubfrosch"),
        # define main tabsets (ICON D2, measurement data, phenology, impressum)
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
  ),
  ## footer
  tags$footer(class = "footer","\u00A9 2024 - M. Kehl",br(), actionLink("link_to_impressum", "Impressum"),
                "|", div(class = "kontakt", a(href="mailto:mkehl.laubfrosch@gmail.com","Kontakt")),
                div(class="hidekontakt","mkehl.laubfrosch@gmail.com"))
)

## -- C --  Server -------------------------------------------------------------
server <- function(input, output, session) {
  ## define superordinate elements
  # read device information to make app reactive to it
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
  
## -- C.1 --  TabPanel 1: Impressum --------------------------------------------
  impressumServer("impressum")
## -- C.2 --  TabPanel 2: phenology  -------------------------------------------
  phenologyServer("phenology",reactive(input$main_tabsets))
## -- C.3 --  TabPanel 3: measurement data ----------------------------------------------------------------
  messdataServer("messdata",reactive(input$main_tabsets))
## -- C.4 --  TabPanel 4: ICON D2  ----------------------------------------------------------------
  icond2Server("icond2",reactive(input$main_tabsets))
}
shinyApp(ui, server)

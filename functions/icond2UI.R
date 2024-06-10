## User Interface for the forecast part
#  -> left hand side: Buttons/Input fields to select what should be plotted
#  -> middle/right hand side: space for leaflet map/barplot
icond2UI <- function(id) {
  tagList(
    #left hand side
    column(3, 
           br(),
           #info-button
           column(1,
                  actionButton(NS(id,"info_icond2"), label = NULL, icon = icon("info"),
                               style="color: black; 
                                              background-color: HoneyDew;
                                              border-color: #3dc296")),
           #subtitle
           column(10,div(class = "subtitle",h4("Regionalmodell ICON-D2"))),
           br(),
           br(),
           hr(),
           #which parameter should be mapped/plotted
           radioButtons(
             inputId = NS(id,"parameter"),
             label = "Parameter",
             selected = character(0),
             choiceNames = c("Niederschlag","Temperatur","Bewölkung","Druck"),
             choiceValues = c("tot_prec","t_2m","clct","pmsl")),
           #which federal state should be in focus on the map
           selectInput(
             inputId = NS(id,"bundesland"),
             label = "Bundesland",
             choices = bundeslaender_coord$bundesland,
             multiple = FALSE),
           #how should coordinates for point forecast be selected
           radioButtons(
             inputId = NS(id,"point_forecast"),
             label = "Punktvorhersage",
             choiceNames = c("Mausklick","Landeshauptstadt","freie Koordinatenwahl"),
             choiceValues = c("mouse","bhs","free"),
             selected = "bhs"),
           #input field for coordinates
           box(id = NS(id,"box_free_coord"),
               width = '800px',
               numericInput(NS(id,"free_lon"),label = "longitude", value = 9.05222,
                            step = 0.5, width = "50%"),
               numericInput(NS(id,"free_lat"),label = "latitude", value = 48.52266,
                            step = 0.5, width = "50%")),
           #copyright DWD
           f_copyright_DWD()
    ),
    #middle/right hand side
    column(9,
           br(),
           #map title
           h4(textOutput(NS(id,"map_title"))),
           #leaflet map
           div(class = "map_plot",leafletOutput(NS(id,"map_out"))),
           #time slider (which time should be mapped on leaflet map)
           div(class = "slider", sliderInput(NS(id,"slider_time"), 
                                             "Zeit", 
                                             min = ceiling_date(Sys.time(),unit = "hour"),
                                             max = ceiling_date(Sys.time(),unit = "hour") + 6 * 60 * 60,
                                             step = 3600,
                                             value = c(ceiling_date(Sys.time(),unit = "hour")),
                                             timeFormat = "%a %H:%M", ticks = T, animate = T,
                                             width = "750px")),
           #barplot for point forecast
           div(class = "map_plot",plotOutput(NS(id,"bar_out")))
    )
  )
}
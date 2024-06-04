icond2UI <- function(id) {
  tagList(
    column(3, 
           br(),
           column(1,
                  actionButton(NS(id,"info_icond2"), label = NULL, icon = icon("info"),
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
             inputId = NS(id,"parameter"),
             label = "Parameter",
             selected = character(0),
             choiceNames = c("Niederschlag","Temperatur","Bewölkung","Druck"),
             choiceValues = c("tot_prec","t_2m","clct","pmsl")),
           selectInput(
             inputId = NS(id,"bundesland"),
             label = "Bundesland",
             choices = bundeslaender_coord$bundesland,
             multiple = FALSE),
           radioButtons(
             inputId = NS(id,"point_forecast"),
             label = "Punktvorhersage",
             choiceNames = c("Mausklick","Landeshauptstadt","freie Koordinatenwahl"),
             choiceValues = c("mouse","bhs","free"),
             selected = "bhs"),
           box(id = NS(id,"box_free_coord"),
               width = '800px',
               numericInput(NS(id,"free_lon"),label = "longitude", value = 9.05222,
                            step = 0.5, width = "50%"),
               numericInput(NS(id,"free_lat"),label = "latitude", value = 48.52266,
                            step = 0.5, width = "50%")),
           f_copyright_DWD()
    ),
    column(9,
           br(),
           h4(textOutput(NS(id,"map_title"))),
           div(class = "map_plot",leafletOutput(NS(id,"map_out"))),
           div(class = "slider", sliderInput(NS(id,"slider_time"), 
                                             "Zeit", 
                                             min = ceiling_date(Sys.time(),unit = "hour"),
                                             max = ceiling_date(Sys.time(),unit = "hour") + 6 * 60 * 60,
                                             step = 3600,
                                             value = c(ceiling_date(Sys.time(),unit = "hour")),
                                             timeFormat = "%a %H:%M", ticks = T, animate = T,
                                             width = "750px")),
           div(class = "map_plot",plotOutput(NS(id,"bar_out")))
    )
    
  )
  
}
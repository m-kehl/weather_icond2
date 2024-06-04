messdataUI <- function(id) {
  tagList(
    # tags$head(
    #   ## define superordinate settings 
    #   # HTML style for tabsets and notifications
    #   
    #   tags$style(HTML(
    #     "    
    #       #mess_tabsets > li {
    #         padding-top: 5px;
    #   }
    #     "))),
    useWaiter(),
    column(3, 
           br(),
           column(1,       
                  actionButton(NS(id,"info_mess"), label = NULL, icon = icon("info"),
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
             inputId = NS(id,"mess_name"),
             label = "Stationsname/n (max. 5)",
             choices = c(""),
             multiple = TRUE,
             options = list(maxItems = 5)),
           selectizeInput(
             inputId = NS(id,"parameter_plot1"),
             label = "Parameter für Plot 1 (max. 2)",
             choices = c(meteo_parameters$parameter),
             multiple = TRUE,
             options = list(maxItems = 2),
             selected = c("Temperatur")
           ),
           selectizeInput(
             inputId = NS(id,"parameter_plot2"),
             label = "Parameter für Plot 2 (max. 2)",
             choices = c(meteo_parameters$parameter),
             multiple = TRUE,
             options = list(maxItems = 2),
             selected = c("Niederschlag","relative Feuchte")
           ),
           box(id = NS(id,"box_sincetill"),
               width = '800px',
               sliderInput(NS(id,"sincetill"),
                           "Zeitspanne für Plot",
                           min = Sys.Date()-61,
                           max = Sys.Date(),
                           value = c(Sys.Date()-60,Sys.Date()-1),
                           step = 1)), #1day
           f_copyright_DWD(),
           textOutput(NS(id,"test"))),
    column(9,
           # define second-level tabsets (now, daily, monthly)
           # useShinyjs(),
           # runjs("#mess_tabsets{padding-top: 5px"),
           tabsetPanel(id = NS(id,"mess_tabsets"),
                       tabPanel("aktuelle Messungen",
                                value = NS(id,"now"),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot"))),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_prec")))),
                       tabPanel("Tageswerte",
                                value = NS(id,"daily"),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_daily"))),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_daily_prec")))),
                       tabPanel("Monatswerte",
                                value = NS(id,"monthly"),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_monthly"))),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_monthly_prec"))))
           )
    )
  )
}
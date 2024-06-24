## User Interface for the measurement data part
#  -> left hand side: Buttons/Input fields to select what should be plotted
#  -> middle/right hand side: space for plots
messdataUI <- function(id) {
  #load basic fixed data (ie meteorological parameter abbreviations)
  source(paste0(getwd(),"/input.R"),local = TRUE)
  tagList(
    #left hand side
    column(3, 
           br(),
           #info-button
           column(1,       
                  actionButton(NS(id,"info_mess"), label = NULL, icon = icon("info"),
                               style="color: black;
                                        background-color: HoneyDew;
                                        border-color: #3dc296",
                               widht = "10%")),
           #subtitle
           column(10,div(class = "subtitle",h4("Messdaten"))),
           br(),
           br(),
           hr(),
           #measurement data of which measurement station should be plotted
           selectizeInput(
             inputId = NS(id,"mess_name"),
             label = "Stationsname/n (max. 5)",
             choices = c(""),
             multiple = TRUE,
             options = list(maxItems = 5)),
           #which parameter/s should be plotted in first plot
           selectizeInput(
             inputId = NS(id,"parameter_plot1"),
             label = "Parameter für Plot 1 (max. 2)",
             choices = c(meteo_parameters$parameter),
             multiple = TRUE,
             options = list(maxItems = 2),
             selected = c("Temperatur")
           ),
           #which parameter/s should be plotted in second plot
           selectizeInput(
             inputId = NS(id,"parameter_plot2"),
             label = "Parameter für Plot 2 (max. 2)",
             choices = c(meteo_parameters$parameter),
             multiple = TRUE,
             options = list(maxItems = 2),
             selected = c("Niederschlag","relative Feuchte")
           ),
           #which time period should be plotted
           box(id = NS(id,"box_sincetill"),
               width = '800px',
               sliderInput(NS(id,"sincetill"),
                           "Zeitspanne für Plot",
                           min = Sys.Date()-61,
                           max = Sys.Date(),
                           value = c(Sys.Date()-60,Sys.Date()-1),
                           step = 1)), #1day
           #copyright DWD
           f_copyright_DWD()
    ),
    #middle/right hand side
    column(9,
           #create tabsets for current measurements (10'-granularity), daily
           #measurements and monthly measurements
           tabsetPanel(id = NS(id,"mess_tabsets"),
                       #current measurement data
                       tabPanel("aktuelle Messungen",
                                value = NS(id,"now"),
                                #plots for current measurement data
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot"))),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_prec")))),
                       #daily measurement data
                       tabPanel("Tageswerte",
                                value = NS(id,"daily"),
                                #plots for daily measurement data
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_daily"))),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_daily_prec")))),
                       #monthly measurement data
                       tabPanel("Monatswerte",
                                value = NS(id,"monthly"),
                                #plots for monthly measurement data
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_monthly"))),
                                div(class = "map_plot",plotOutput(NS(id,"mess_plot_monthly_prec"))))
           )
    )
  )
}
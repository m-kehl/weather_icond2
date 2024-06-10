## User Interface for the phenology part
#  -> left hand side: Buttons/Input fields to select what should be plotted
#  -> middle: space for plots
#  -> right hand side: checkboxes to select which help lines should be shown in plot
phenologyUI <- function(id) {
  tagList(
    # left hand side
    column(3, 
            br(),
            #info-button
            column(1,
                   actionButton(NS(id,"info_pheno"), label = NULL, icon = icon("info"),
                                style="color: black; 
                                              background-color: HoneyDew; 
                                              border-color: #3dc296")),
            #subtitle
            column(10,div(class = "subtitle",h4("Phänologie"))),
            br(),
            br(),
            hr(),
            #which kind of plant should be plotted
            selectInput(
              inputId = NS(id,"pflanzen"),
              label = "Pflanzenart",
              choices = pflanzen_arten,
              multiple = FALSE),
            #which phase of plant should be plotted
            radioButtons(
              inputId = NS(id,"phase"),
              label = "phänologische Phase",
              choiceNames = phenology_phases$phase,
              choiceValues = phenology_phases$phase_id,
              selected = character(0)),
            #station names for which federal state should be selectable
            selectInput(
              inputId = NS(id,"bl_plant"),
              label = "Bundesland",
              choices = c(""),
              multiple = FALSE),
            #data of which station should be plotted
            selectizeInput(
              inputId = NS(id,"station_name"),
              label = "Stationsname/n",
              choices = c("Adelsheim"),
              selected = c("Adelsheim"),
              multiple = TRUE),
            #copyright DWD
            f_copyright_DWD()
    ),
    #middle and right hand side
    column(9,
           #middle -> phenology plot
           column(10,
                  div(class = "map_plot",plotOutput(NS(id,"plant_out"))),
                  textOutput(NS(id,"no_plant"))),
           #right hand side -> checkboxes for helplines
           column(2,
                  br(),
                  br(),
                  br(),
                  br(),
                  div(class = "helplines",
                      p("Hilfslinien:"),
                      checkboxInput(NS(id,"trendline"), "lin. Regression"),
                      checkboxInput(NS(id,"mtline"),"Monatslinien"),
                      checkboxInput(NS(id,"grid"),"Gitternetz")
                      )),
           #middle -> map showing where phenology station/s is/are
           column(6,plotOutput(NS(id,"plant_map")))
    ),
  )
}
phenologyUI <- function(id) {
  tagList(
    column(3, 
            br(),
            column(1,
                   actionButton(NS(id,"info_pheno"), label = NULL, icon = icon("info"),
                                style="color: black; 
                                              background-color: HoneyDew; 
                                              border-color: #3dc296")),
            column(10,div(class = "subtitle",h4("Phänologie"))),
            br(),
            br(),
            hr(),
            selectInput(
              inputId = NS(id,"pflanzen"),
              label = "Pflanzenart",
              choices = pflanzen_arten,
              multiple = FALSE),
            radioButtons(
              inputId = NS(id,"phase"),
              label = "phänologische Phase",
              choiceNames = phenology_phases$phase,
              choiceValues = phenology_phases$phase_id,
              selected = character(0)),
            selectInput(
              inputId = NS(id,"bl_plant"),
              label = "Bundesland",
              choices = c(""),
              multiple = FALSE),
            selectizeInput(
              inputId = NS(id,"station_name"),
              label = "Stationsname/n",
              choices = c("Adelsheim"),
              selected = c("Adelsheim"),
              multiple = TRUE),
            f_copyright_DWD()),
    column(9,
           column(10,
                  div(class = "map_plot",plotOutput(NS(id,"plant_out"))),
                  textOutput(NS(id,"no_plant"))),
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
           column(6,plotOutput(NS(id,"plant_map")))),
           
           #column(6,tableOutput("plant_table"))
    
  )
}
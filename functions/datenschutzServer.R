## Server part for the impressum (according User Interface: impressumUI.R)
datenschutzServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # picture of laubfrosch
    output$laubfrosch <- renderUI({
      tags$img(src="laubfrosch_blau.png", height=250)
    })
    
    # change picture of laubfrosch on click
    onclick("laubfrosch", {
      #on click -> changing color
      output$laubfrosch <- renderUI({
        tags$img(src="laubfrosch_rot.png", height=250)
      })
    })
  })
}
library(shiny)
library(waiter)

ui <- fluidPage(
  useWaiter(), # dependencies
  waiterShowOnLoad(spin_fading_circles()), # shows before anything else 
  actionButton("show", "Show loading for 5 seconds")
)

server <- function(input, output, session){
  waiter_hide() # will hide *on_load waiter
  
  observeEvent(input$show, {
    waiter_show(
      html = tagList(
        spin_fading_circles(),
        "Loading ..."
      )
    )
    Sys.sleep(3)
    waiter_hide()
  })
}

if(interactive()) shinyApp(ui, server)
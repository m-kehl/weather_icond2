messdataServer <- function(id,active) {
  moduleServer(id, function(input, output, session) {
    
    # update UI
    shinyjs::hideElement("box_sincetill")

    ## read and process measurement data
    # read meta data
    mess_meta <- f_read_mess_meta()
    # update UI based on meta data
    updateSelectizeInput(session,"mess_name",
                         choices = base::unique(mess_meta$Stationsname),
                         #selected = base::unique(mess_meta$Stationsname)[1],
                         options = list(maxItems = 5))
    # read measurement data
    mess_data <- reactive(f_read_mess(input$mess_name,mess_meta,sub(paste0(id,"-"),"",input$mess_tabsets),id))

    ## show information box
    observeEvent(input$info_mess, {
      f_infotext(active())
    })

    ## update UI
    observeEvent(sub(paste0(id,"-"),"",input$mess_tabsets),{
      f_updateselectize_parameters(session,"parameter_plot1",sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1)
      f_updateselectize_parameters(session,"parameter_plot2",sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2)
    })

    ## plot measurement data
    observe({
      # placeholder-plot if no station is chosen in UI
      if (length(input$mess_name) == 0){
        output$mess_plot <- renderPlot(f_plot_placeholder())
        output$mess_plot_daily <- renderPlot(f_plot_placeholder())
        output$mess_plot_monthly <- renderPlot(f_plot_placeholder())
      } else if (sub(paste0(id,"-"),"",input$mess_tabsets) == "now"){
        # plot measurement data for recent measurements
        output$mess_plot <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1,"Plot 1: "))
        output$mess_plot_prec <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2,"Plot 2: "))
        shinyjs::hideElement("box_sincetill")
      } else if (sub(paste0(id,"-"),"",input$mess_tabsets) == "daily"){
        # update UI
        updateSliderInput(session,"sincetill",
                          min = mess_data()$MESS_DATUM[1],
                          max = mess_data()$MESS_DATUM[nrow(mess_data())],
                          timeFormat = "%d.%m.%Y")
        shinyjs::showElement("box_sincetill")
        # plot measurement data for daily measurements
        output$mess_plot_daily <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1,"Plot 1: ",input$sincetill))
        output$mess_plot_daily_prec <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2,"Plot 2: ",input$sincetill))
      } else if (sub(paste0(id,"-"),"",input$mess_tabsets) == "monthly"){
        # plot measurement data for monthly measurements
        output$mess_plot_monthly <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1,"Plot 1: "))
        output$mess_plot_monthly_prec <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2,"Plot 2: "))
        # update UI
        shinyjs::hideElement("box_sincetill")
      }
      })
    
    
  })
}

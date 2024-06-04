phenologyServer <- function(id,active) {
  moduleServer(id, function(input, output, session) {
    ## read and process phenology data
    # read meta data

    # observe({
    #   if (active() == "pheno"){
    #     output$test <- renderText(paste0(active(),"1"))
    # 
    #   } else{
    #     output$test <- renderText(paste0(active(),"2"))
    #     
    #   }
    # })
    plant_meta <- reactive({
      f_read_plants_meta()
    })
    
    # read phenology data
    plant_data <- reactive(
      if (input$pflanzen != ""){
        f_read_plants(input$pflanzen)
      }else{
        #show all federal states as options in UI
        updateSelectInput(session,"bl_plant",
                          choices = unique(plant_meta()$Bundesland))
      }
    )
    #update UI for specific phases
    update_pheno_phases <- reactive(phenology_phases[phenology_phases$phase_id %in% unique(plant_data()$Phase_id),])
    observe({
      updateRadioButtons(session, "phase",
                         choiceNames = update_pheno_phases()$phase,
                         choiceValues = update_pheno_phases()$phase_id,
                         selected = c(5))
    })
    # limit stations in UI to those which host species chosen in UI
    bl_meta <- reactive(plant_meta()$Stationsname[plant_meta()$Bundesland == input$bl_plant])
    observe({
      updateSelectizeInput(session,"station_name",
                           choices = c(bl_meta(),input$station_name),
                           selected = input$station_name)
    })
    # postprocess phenology data
    plant_data_processed <- reactive(
      f_process_plants(plant_data(),input$phase,input$station_name,plant_meta())
    )

    ## show information box
    observeEvent(input$info_pheno, {
      f_infotext(active())
    })

    ## plot phenology data
    observe({
      #placeholder-plot if no species or stationname is chosen in UI
      if (input$pflanzen == "" | length(input$station_name) == 0){
        output$plant_out <- renderPlot(f_plot_placeholder())
      }else{
        #plot phenology data for species chosen in UI
        output$plant_out <- renderPlot(f_plot_plants(plant_data_processed()[[1]],
                                                     input$pflanzen,plant_meta(),
                                                     input$station_name,input$trendline,
                                                     input$mtline,input$grid))
        output$plant_table <- renderTable(f_table_plants(plant_meta(),input$station_name))
        output$plant_map <- renderPlot(f_map_plants(plant_meta(),input$station_name))
        if (length(plant_data_processed()[[2]]) == 0){
          output$no_plant <- renderText("")
        } else{
          output$no_plant <- renderText(paste0("Keine Daten vorhanden für: ",paste(plant_data_processed()[[2]],collapse = ', ')))
        }
      }
    })


  })
}
## Server part for the icon-d2 forecast data (according User Interface: icond2UI.R)
icond2Server <- function(id,active) {
  # - id:     character; namespace id
  # - active: character; name of active tabset
  
  moduleServer(id, function(input, output, session) {
    #load basic fixed data (ie coordinates of federal states)
    source(paste0(getwd(),"/input.R"),local = TRUE)
    
    ## read and process icon d2 forecast data
    # read icon d2 forecast data
    icond2_data <- reactive(f_read_icond2(f_forecast_time(),input$parameter,id))
    # postprocess icon d2 forecast data
    icond2_processed <- reactive(f_process_icond2(icond2_data(),input$parameter))
    # take layer to visualize out of forecast data (according to user input)
    icond2_layer <- reactive(f_subset_icond2(input$slider_time,icond2_processed()))
    
    # read coordinates for point forecast
    point_coord <- reactive(f_point_coord(input$bundesland, input$point_forecast,
                                          input$free_lon, input$free_lat, input$map_out_click))
    
    # produce point forecast out of postprocessed icon d2 forecast data
    point_forecast <- reactive(
      terra::extract(icond2_processed(), point_coord(), raw = TRUE, ID = FALSE)
    )
    
    ## show information box
    observeEvent(input$info_icond2, {
      f_infotext(active())
    })
    
    ## plot forecast data
    # setup leaflet map
    output$map_out <- renderLeaflet(
      f_leaflet_basic()
    )
    
    # adapt displayed layer on map according to user time input
    observe({
      f_leaflet_layer(input$parameter,icond2_processed(),icond2_layer(),session,id)
      # add title to map
      if (length(input$parameter) != 0){
        if (input$parameter == "tot_prec"){
          map_text <- "Niederschlag [mm/h] - "
        } else if (input$parameter == "t_2m"){
          map_text <- "Temperatur [\u00B0C] - "
        } else if (input$parameter == "clct"){
          map_text <- "Bewölkung [%] - "
        } else if (input$parameter == "pmsl"){
          map_text <- "Druck [hPa] - "
        }
        output$map_title <- renderText(paste0(map_text,format(as.POSIXct(time(icond2_layer(), format= ""),"CET"),
                                                              "%d.%m.%Y %H:%M")))
      }
    })
    
    # adapt map legend if parameter input changes
    observeEvent(input$parameter,{
      f_leaflet_legend(input$parameter,icond2_processed(),session)
    })
    
    # adapt shown leaflet map section according to user input
    observeEvent(input$bundesland,{
      f_leaflet_setview(input$bundesland,session)
    })
    
    # add marker on leaflet map according to user input
    observe({
      f_leaflet_markers(input$point_forecast,input$free_lon,input$free_lat,input$bundesland,
                        input$map_out_click,session)
    })
    
    ## plot point forecast data
    observe({
      if (is.null(input$parameter)){
        # empty plot if no input parameter is given
        output$bar_out <- renderPlot(
          plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
        )
      } else if (is.null(input$map_out_click) && input$point_forecast == "mouse"){
        # empty plot if no mouse input value is given but "mouse" is chosen 
        # by user
        output$bar_out <- renderPlot(
          plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
        )
      } else if ((is.na(input$free_lon) | is.na(input$free_lat)) & input$point_forecast == "free"){
        # empty plot if faulty free_lon or free_lat is given but "free" is chosen
        # by user
        output$bar_out <- renderPlot(
          f_barplot_icond2_placeholder(),
        )
      } else{
        # plot
        output$bar_out <- renderPlot(
          f_barplot_icond2(point_forecast(),input$slider_time,input$parameter,
                           input$point_forecast,
                           bundeslaender_coord$landeshauptstadt[bundeslaender_coord$bundesland == input$bundesland]),
        )
      }
    })
    
    ## adapt UI if user wishes free coordinates
    observeEvent(input$point_forecast,{
      if (input$point_forecast == "free"){
        shinyjs::show("box_free_coord")
      } else{
        shinyjs::hide("box_free_coord")
      }
    })
  })
}
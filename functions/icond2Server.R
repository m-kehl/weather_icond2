icond2Server <- function(id,active) {
  moduleServer(id, function(input, output, session) {
    ## read and process icon d2 forecast data
    # read icon d2 forecast data
    icond2_data <- reactive(f_read_icond2(f_forecast_time(),input$parameter,id))
    # postprocess icon d2 forecast data
    icond2_processed <- reactive(f_process_icond2(icond2_data(),input$parameter))
    # take needed layer out of forecast data (according to user input)
    icond2_layer <- reactive(f_subset_icond2(input$slider_time,icond2_processed(),input$parameter))
    
    # read coordinates for point forecast
    point_coord <- reactive(f_point_coord(input$bundesland, input$point_forecast,
                                          input$free_lon, input$free_lat, input$map_out_click))
    
    # produce point forecast out of icon d2 forecast data
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
      f_leaflet_layer(input$parameter,icond2_processed(),icond2_layer(),session)
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
    
    # adapt legend on map if parameter input changes
    observeEvent(input$parameter,{
      f_leaflet_legend(input$parameter,icond2_processed(),session)
    })
    
    # adapt shown leaflet map section according to user input
    observeEvent(input$bundesland,{
      f_leaflet_setview(input$bundesland,session)
    })
    
    # add markers on leaflet map according to user input
    observe({
      f_leaflet_markers(input$point_forecast,input$free_lon,input$free_lat,input$bundesland,
                        input$map_out_click,session)
    })
    
    ## plot point forecast data
    observe({
      if (is.null(input$parameter)){
        output$bar_out <- renderPlot(
          plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
        )
      } else if (is.null(input$map_out_click) && input$point_forecast == "mouse"){
        output$bar_out <- renderPlot(
          plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
        )
      } else if ((is.na(input$free_lon) | is.na(input$free_lat)) & input$point_forecast == "free"){
        output$bar_out <- renderPlot(
          f_barplot_icond2_placeholder(),
        )
      } else{
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
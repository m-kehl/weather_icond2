f_leaflet_layer <- function(parameter,icond2_processed,icond2_layer,session){
  ## function to exchange plotted layer on leaflet map
  # - parameter:      character; icon d2 abbreviation for forecasted parameter
  #                        options: "tot_prec" for precipitation
  #                                 "t_2m"     for temperature 2m above ground
  #                                 "clct"     for cloud cover
  #                                 "pmsl"     for sea level pressure
  # - icond2_processed: SpatRaster; processed icon d2 data (result of
  #                                 f_process_icond2())
  # - icond2_layer: SpatRaster; layer of icond2_processed which is to be plotted
  #                             on the map
  # - session: Shiny Session
  
  ## layer preparations
  # load meta data (colours)
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  # set min and max values for colorbar
  # process icon d2 data -> NA if precipitation smaller 0.1
  if (length(parameter) != 0){
    if (parameter == "tot_prec"){
      colorpal <- colorNumeric(colours_precipitation,
                               domain = c(min(terra::values(icond2_processed),na.rm = T),
                                          max(terra::values(icond2_processed),na.rm = T)),
                               na.color = "transparent")
      iconlayer <- ifel(icond2_layer < 0.1, NA, icond2_layer)        
    } else if (parameter == "t_2m"){
      colorpal <- colorNumeric(colours_temperature,
                               domain = c(min(terra::values(icond2_processed),na.rm = T),
                                          max(terra::values(icond2_processed),na.rm = T)),
                               na.color = "transparent")
      iconlayer <- icond2_layer
    } else if (parameter == "clct"){
      colorpal <- colorNumeric(colours_cloud,
                               domain = c(min(terra::values(icond2_processed),na.rm = T),
                                          max(terra::values(icond2_processed),na.rm = T)),
                               na.color = "transparent")
      
      iconlayer <- ifel(icond2_layer < 10, NA, icond2_layer)  
    } else if (parameter == "pmsl"){
      colorpal <- colorNumeric(colours_pressure,
                               domain = c(min(terra::values(icond2_processed),na.rm = T),
                                          max(terra::values(icond2_processed),na.rm = T)),
                               na.color = "transparent")
      
      iconlayer <- icond2_layer  
    }
    
    ## add layer to map
    mapModifier <- leafletProxy(
      "map_out", session)
    
    mapModifier %>%
      clearImages() %>%
      removeControl(layerId = "intro") %>%
      addRasterImage(iconlayer, col = colorpal,opacity = 0.8)
    waiter_hide()
  }
}
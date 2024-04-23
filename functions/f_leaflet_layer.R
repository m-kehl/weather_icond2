f_leaflet_layer <- function(parameter,icond2_processed,icond2_layer,session){
  ## layer preparations
  # load meta legend data (colours)
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  if (length(parameter) != 0){
    if (parameter != "t_2m"){
      colorpal <- colorNumeric(colours_temperature,
                               domain = c(min(terra::values(icond2_processed),na.rm = T),
                                          max(terra::values(icond2_processed),na.rm = T)),
                               na.color = "transparent")
      iconlayer <- ifel(icond2_layer < 0.1, NA, icond2_layer)        
    } else{
      colorpal <- colorNumeric(colours_precipitation,
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
f_leaflet_layer <- function(parameter,icond2_processed,icond2_layer,session){
  if (length(parameter) != 0){
    if (parameter != "t_2m"){
      colorpal <- colorNumeric(c("peachpuff1","maroon1","red","orange","gold","gold4","darkgreen","lawngreen"),
                               domain = c(min(terra::values(icond2_processed),na.rm = T),
                                          max(terra::values(icond2_processed),na.rm = T)),
                               na.color = "transparent")
      iconlayer <- ifel(icond2_layer < 0.1, NA, icond2_layer)        
    } else{
      colorpal <- colorNumeric(c("blue","cyan4","lightblue","lavender","gold","orange","maroon","red4"),
                               domain = c(min(terra::values(icond2_processed),na.rm = T),
                                          max(terra::values(icond2_processed),na.rm = T)),
                               na.color = "transparent")
      iconlayer <- icond2_layer
    }
    
    mapModifier <- leafletProxy(
      "map_out", session)
    
    mapModifier %>%
      clearImages() %>%
      removeControl(layerId = "intro") %>%
      addRasterImage(iconlayer, col = colorpal,opacity = 0.8)
    waiter_hide()
    
  }
}
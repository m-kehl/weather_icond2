f_leaflet_legend <- function(parameter,icond2_processed,session){
  if (parameter == "rain_gsp"){
    map_legend <- "Regen [mm/h]"
  } else if (parameter == "snow_gsp"){
    map_legend <- "Schnee [mm/h]"
  } else if (parameter == "t_2m"){
    map_legend <- "Temperatur [\u2103]"
  }
  if (parameter != "t_2m"){
    colorpal <- colorNumeric(c("peachpuff1","maroon1","red","orange","gold","gold4","darkgreen","lawngreen"),
                             domain = c(min(terra::values(icond2_processed),na.rm = T),
                                        max(terra::values(icond2_processed),na.rm = T)),
                             na.color = "transparent")
  } else{
    colorpal <- colorNumeric(c("blue","cyan4","lightblue","lavender","gold","orange","maroon","red4"),
                             domain = c(min(terra::values(icond2_processed),na.rm = T),
                                        max(terra::values(icond2_processed),na.rm = T)),
                             na.color = "transparent")
  }
  
  mapModifier <- leafletProxy(
    "map_out", session)
  mapModifier %>%    
    clearControls() %>%
    addLegend(pal = colorpal, values = values(icond2_processed),title = map_legend)
  
  return(mapModifier)
}
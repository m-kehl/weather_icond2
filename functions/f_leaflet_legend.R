f_leaflet_legend <- function(parameter,icond2_processed,session){
  ## legend preparations
  # load meta legend data (colours)
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  if (parameter == "rain_gsp"){
    map_legend <- "Regen [mm/h]"
  } else if (parameter == "snow_gsp"){
    map_legend <- "Schnee [mm/h]"
  } else if (parameter == "t_2m"){
    map_legend <- "Temperatur [\u2103]"
  }
  if (parameter != "t_2m"){
    colorpal <- colorNumeric(colours_temperature,
                             domain = c(min(terra::values(icond2_processed),na.rm = T),
                                        max(terra::values(icond2_processed),na.rm = T)),
                             na.color = "transparent")
  } else{
    colorpal <- colorNumeric(colours_precipitation,
                             domain = c(min(terra::values(icond2_processed),na.rm = T),
                                        max(terra::values(icond2_processed),na.rm = T)),
                             na.color = "transparent")
  }
  
  ## add legend to map
  
  mapModifier <- leafletProxy(
    "map_out", session)
  mapModifier %>%    
    clearControls() %>%
    addLegend(pal = colorpal, values = values(icond2_processed),title = map_legend)
  
  return(mapModifier)
}
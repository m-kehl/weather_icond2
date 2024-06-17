f_leaflet_legend <- function(parameter,icond2_processed,session){
  ## function to add legend to leaflet map
  # - parameter:      character; icon d2 abbreviation of forecasted parameter
  #                        options: "tot_prec" for precipitation
  #                                 "t_2m"     for temperature 2m above ground
  #                                 "clct"     for cloud cover
  #                                 "pmsl"     for sea level pressure
  # - icond2_processed: SpatRaster; processed icon d2 forecast data (result of
  #                                 f_process_icond2())
  # - session: Shiny Session
  
  ## legend preparations
  # load meta legend data (colours)
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  # select title of legend as well as according color bar
  if (parameter == "tot_prec"){
    map_legend <- "Niederschlag [mm/h]"
    legend_col <- colours_precipitation
  } else if (parameter == "t_2m"){
    map_legend <- "Temperatur [\u2103]"
    legend_col <- colours_temperature
  } else if (parameter == "clct"){
    map_legend <- "Bewölkung [%]"
    legend_col <- colours_cloud
  } else if (parameter == "pmsl"){
    map_legend <- "Druck [hPa]"
    legend_col <- colours_pressure
  }
  
  #create continuous color palette for legend
  colorpal <- colorNumeric(legend_col,
                           domain = c(min(terra::values(icond2_processed),na.rm = T),
                                      max(terra::values(icond2_processed),na.rm = T)),
                           na.color = "transparent")
  
  ## add legend to map
  #  load pre-existing map
  mapModifier <- leafletProxy(
    "map_out", session)
  
  # delete old legend, add new legend
  mapModifier %>%    
    clearControls() %>%
    addLegend(pal = colorpal, values = values(icond2_processed),title = map_legend)
  
  return(mapModifier)
}
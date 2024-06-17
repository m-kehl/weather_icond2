f_leaflet_setview<- function(state,session){
  ## function to change shown leaflet map section to federal state given in input
  # - state: character; german name of federal state which should be shwon on map
  #                     (attention: umlaute must be written out, ie ä = ae)
  # - session: Shiny session
  
  ## preparations
  # load coordinates for different federal states
  source(paste0(getwd(),"/input.R"))
  
  ## set view of map
  #  load pre-existing map
  mapModifier <- leafletProxy(
    "map_out", session)
  
  # set view to coordinates of chosen federal state
  mapModifier %>%
    setView(zoom = bundeslaender_coord$zoom[bundeslaender_coord$bundesland == state],
            lng = bundeslaender_coord$mittel_lon[bundeslaender_coord$bundesland == state],
            lat = bundeslaender_coord$mittel_lat[bundeslaender_coord$bundesland == state])
}
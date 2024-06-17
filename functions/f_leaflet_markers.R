f_leaflet_markers <- function(type,free_lon,free_lat,state,
                              map_out_click,session){
  ## function to add a marker on leaflet map to indicate place of coordinate pair
  #  used for point forecast (see also f_point_coord() for further information)
  # - type: character; with which method coordinate pair for point forecast is
  #                    chosen, options:
  #                     -> "bhs":  coordinates of federal capitol of input
  #                                federal state are taken
  #                     -> "free": coordinates of input free_lon and free_lat are
  #                                taken
  #                     -> "mouse": coordinates given via input map_out_click are taken
  #                                (in this variable, the coordinates chosen
  #                                 by mouse click on a map are saved)
  # - free_lon: double; longitude, only needed if type = "free"
  # - free_lat: double; latitude, only needed if type = "free"
  # - state: character; german name of federal state (attention: umlauts must be
  #                     written out, ie ä = ae)
  # - map_out_click:    array; two doubles with longitude and latitude, only needed if type = "mouse"
  # - session: shiny session
  
  ## add marker on leaflet map
  # load pre-existing map
  mapModifier <- leafletProxy(
    "map_out", session)
  
  # clear old marker and add new marker
  if (type == "free" & !is.na(free_lon) & !is.na(free_lat)){
    mapModifier %>%
      clearMarkers()  %>%
      addMarkers(lng = free_lon,lat = free_lat)
  } else if (type == "bhs"){
    mapModifier %>%
      clearMarkers()  %>%
      addMarkers(lng = bundeslaender_coord$lon_point[bundeslaender_coord$bundesland == state],
                 lat = bundeslaender_coord$lat_point[bundeslaender_coord$bundesland == state])
  } else if (type == "mouse" & !is.null(map_out_click)){
    mapModifier %>%
      clearMarkers()  %>%
      addMarkers(lng = map_out_click$lng,lat = map_out_click$lat)
  }
}
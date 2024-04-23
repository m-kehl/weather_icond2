f_leaflet_markers <- function(point_forecast,free_lon,free_lat,bundesland,
                              map_out_click,session){
  mapModifier <- leafletProxy(
    "map_out", session)
  
  if (point_forecast == "free" & !is.na(free_lon) & !is.na(free_lat)){
    mapModifier %>%
      clearMarkers()  %>%
      addMarkers(lng = free_lon,lat = free_lat)
  } else if (point_forecast == "bhs"){
    mapModifier %>%
      clearMarkers()  %>%
      addMarkers(lng = bundeslaender_coord$lon_point[bundeslaender_coord$bundesland == bundesland],
                 lat = bundeslaender_coord$lat_point[bundeslaender_coord$bundesland == bundesland])
  } else if (point_forecast == "mouse" & !is.null(map_out_click)){
    mapModifier %>%
      clearMarkers()  %>%
      addMarkers(lng = map_out_click$lng,lat = map_out_click$lat)
  }
}
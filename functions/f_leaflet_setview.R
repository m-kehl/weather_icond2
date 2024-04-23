f_leaflet_setview<- function(bland,session){
  
  source(paste0(getwd(),"/input.R"))
  
  mapModifier <- leafletProxy(
    "map_out", session)
  mapModifier %>%
    setView(zoom = bundeslaender_coord$zoom[bundeslaender_coord$bundesland == bland],
            lng = bundeslaender_coord$mittel_lon[bundeslaender_coord$bundesland == bland],
            lat = bundeslaender_coord$mittel_lat[bundeslaender_coord$bundesland == bland])
}
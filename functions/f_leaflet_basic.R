f_leaflet_basic <- function(){
  leaflet() %>% 
    #addTiles() %>%
    addProviderTiles(providers$CartoDB.Positron,layerId = "map_click") %>% 
    setMaxBounds(lng1 = -3.834759, lat1 = 43.170241, lng2=20.219425, lat2=58.052226) %>%
    # borders of forecast area
    addPolygons(lng = c(-0.326501,5.470697,10.331397,13.519183,17.628903,20.219425,13.030434,7.577484,-3.834759),
                lat = c(43.170241,43.535726,43.646881,43.600792,43.362164,57.637294,58.032444,58.052226,57.333792),
                fill =FALSE) %>%
    addControl("Bitte wähle einen Parameter.","topleft",className = "intro",layerId = "intro")
}
f_leaflet_basic <- function(){
  ## function to set up leaflet map (define kind of map, displayed map section,
  #  borders etc)
  
  leaflet() %>% 
    addProviderTiles(providers$CartoDB.Positron,layerId = "map_click") %>% 
    setMaxBounds(lng1 = -3.834759, lat1 = 43.170241, lng2=20.219425, lat2=58.052226) %>%
    setView(zoom = 7,lng = 9,lat = 48.5) %>% #setView to Baden-Württemberg as beginning
    # borders of forecast area
    addPolygons(lng = c(-0.326501,5.470697,10.331397,13.519183,17.628903,20.219425,13.030434,7.577484,-3.834759),
                lat = c(43.170241,43.535726,43.646881,43.600792,43.362164,57.637294,58.032444,58.052226,57.333792),
                fill =FALSE) %>%
    addControl("Bitte wählen Sie einen Parameter.","topleft",className = "map_intro",layerId = "map_intro")
}
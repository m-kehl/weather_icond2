f_map_plants <- function(meta_data,station_name){
  ## function to plot map with points for all selected stations
  # - meta_data:     data.table; meta data with coordinates of meteorological stations
  # - station_name:  array; station name/s (character/s)
  
  point_coord <- vect(data.frame(lon = meta_data$geograph.Laenge[meta_data$Stationsname %in% station_name],
                                       lat = meta_data$geograph.Breite[meta_data$Stationsname %in% station_name]),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  map_col <- rainbow(length(station_name))
  terra::plot(point_coord, xlim=c(5, 15),ylim = c(47,55),pch = 20,col = map_col)
  addBorders()
}

f_map_plants <- function(meta_data,station_name){
  ## function to plot map with points for all selected stations
  # - meta_data:     data.table; meta data with coordinates of meteorological stations
  # - station_name:  array; station name/s (character/s)
  
  ## map preparations
  # load meta plot data
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  #select coordinates of stations in station_name
  lon_station <- c()
  lat_station <- c()
  
  for (ii in station_name){
    lon_station <- rbind(lon_station,meta_data$geograph.Laenge[meta_data$Stationsname == ii])
    lat_station <- rbind(lat_station,meta_data$geograph.Breite[meta_data$Stationsname == ii])
  }

  #turn coordinates into SpatVector
  point_coord <- vect(data.frame(lon = lon_station,lat = lat_station),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  #take colour for points according to the ones used in f_plot_plants.R
  map_col <- colours_phenology[1:length(station_name)]
  
  #plot map with borders of federal states of germany
  terra::plot(point_coord, xlim=c(5, 15),ylim = c(47,55),pch = 20,col = map_col)
  addBorders()
}

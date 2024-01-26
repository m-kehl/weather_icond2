library(shiny)
library(waiter)
f_square_coord <- function(bundesland){

  #read in tubingen coord
  #todo: read directly from web
  path <- "/Users/Manuela/Documents/tubingen/"
  source(paste0(path,"scripts_V3/input.R"))

  
  ## coord square for forecast
  lon1 <- bundeslaender_coord$lon1[bundeslaender_coord$bundesland == bundesland]
  lon2 <- bundeslaender_coord$lon2[bundeslaender_coord$bundesland == bundesland]
  lat1 <- bundeslaender_coord$lat1[bundeslaender_coord$bundesland == bundesland]
  lat2 <- bundeslaender_coord$lat2[bundeslaender_coord$bundesland == bundesland]
  square <- data.frame(lon = c(lon1,lon2,lon1,lon2),lat = c(lat1,lat1,lat2,lat2))
  square_vect <- vect(square, geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  #print(square_vect)
  ##city borders tubingen
  # f <- "C:/Users/Manuela/Documents/Tubingen/data/KLGL_Stadtteile_Shape.shp"
  # stadtgrenze <- terra::vect(f)
  # #into lonlat
  # stadtgrenze_lonlat <- project(stadtgrenze, "+proj=longlat +datum=WGS84")
  return(square_vect)
}
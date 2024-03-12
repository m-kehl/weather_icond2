f_spatvector <- function(bundesland){
  ##function to convert coordinate boundaries of a federal state into SpatVector
  # - bundesland:  character; name of federal state (attention: umlauts must be
  #                           written out, ie ä = ae)
  
  #source script/variables where coordinate boundaries are defined
  source(paste0(getwd(),"/input.R"))

  ## extract coordinates and convert into SpatVector
  lon1 <- bundeslaender_coord$lon1[bundeslaender_coord$bundesland == bundesland]
  lon2 <- bundeslaender_coord$lon2[bundeslaender_coord$bundesland == bundesland]
  lat1 <- bundeslaender_coord$lat1[bundeslaender_coord$bundesland == bundesland]
  lat2 <- bundeslaender_coord$lat2[bundeslaender_coord$bundesland == bundesland]
  square <- data.frame(lon = c(lon1,lon2,lon1,lon2),lat = c(lat1,lat1,lat2,lat2))
  square_vect <- vect(square, geom=c("lon", "lat"), crs="", keepgeom=FALSE)

  return(square_vect)
}

f_point_coord <- function(state,type,free_lon = 9.05222, free_lat = 48.52266){
  ## function to form SpatVector out of coordinates for federal capital/s or
  #   out of free coordinate pair
  # - state: character; name of federal state (attention: umlauts must be
  #                     written out, ie ä = ae)
  # - type: character; either "bhs" (abbreviation for Bundeshauptstadt) or "free"
  #                     -> "bhs":  point coordinates for federal capital of input
  #                                state are loaded
  #                     -> "free": coordinate pair of free_lon and free_lat are
  #                                taken
  # - free_lon: double; longitude, only needed if type = "free"
  # - free_lat: double; latitude, only needed if type = "free"
  
  #source script/variables where coordinates for federal capitals are defined
  source(paste0(getwd(),"/input.R"))
  
  # read coordinates for federal capital of input state
  #bhs = bundeshauptstadt
  if (type == "bhs"){
    state_point_coord <- vect(data.frame(lon = bundeslaender_coord$lon_point[bundeslaender_coord$bundesland == state],
                                      lat = bundeslaender_coord$lat_point[bundeslaender_coord$bundesland == state]),
                           geom=c("lon", "lat"), crs="", keepgeom=FALSE)
    all_point_coord <- vect(data.frame(lon = bundeslaender_coord$lon_point,
                                       lat = bundeslaender_coord$lat_point),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else if (!is.na(free_lon) && !is.na(free_lat)){
    state_point_coord <- vect(data.frame(lon = free_lon,
                                      lat = free_lat),
                           geom=c("lon", "lat"), crs="", keepgeom=FALSE)
    all_point_coord <- vect(data.frame(lon = c(free_lon,bundeslaender_coord$lon_point),
                                       lat = c(free_lat,bundeslaender_coord$lat_point)),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else{
    state_point_coord <- NA
    all_point_coord <- vect(data.frame(lon = c(free_lon,bundeslaender_coord$lon_point),
                                       lat = c(free_lat,bundeslaender_coord$lat_point)),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  }
  

  return(list(state_point_coord, all_point_coord))
}

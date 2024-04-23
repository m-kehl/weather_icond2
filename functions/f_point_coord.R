f_point_coord <- function(state,type,free_lon = 9.05222, free_lat = 48.52266, mouse = c(9.05222,48.52266)){
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
  # - mouse:    array; two doublues with longitude and latitude, only needed if type = "mouse"
  
  #source script/variables where coordinates for federal capitals are defined
  source(paste0(getwd(),"/input.R"))
  
  # read coordinates for federal capital of input state
  #bhs = bundeshauptstadt
  if (type == "bhs"){
    point_coord <- vect(data.frame(lon = bundeslaender_coord$lon_point[bundeslaender_coord$bundesland == state],
                                   lat = bundeslaender_coord$lat_point[bundeslaender_coord$bundesland == state]),
                        geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else if (type == "free" && !is.na(free_lon) && !is.na(free_lat)){
    point_coord <- vect(data.frame(lon = free_lon,
                                   lat = free_lat),
                        geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else if (type == "mouse"){
    point_coord <- vect(data.frame(lon = mouse$lng,
                                   lat = mouse$lat),
                        geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else{
    point_coord <- NA
  }
  
  
  return(point_coord)
}
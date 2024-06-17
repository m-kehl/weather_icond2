f_point_coord <- function(state,type,free_lon = 9.05222, free_lat = 48.52266, map_out_click){
  ## function to form SpatVector out of coordinate pair. Depending on input, 
  #  coordinate pair is either given explicitly by input, taken for capitals of
  #  federal states or the positon of the mouse-click on a map
  # - state: character; german name of federal state (attention: umlauts must be
  #                     written out, ie ä = ae)
  # - type: character; with which method coordinate pair is given, options:
  #                     -> "bhs":  coordinates of federal capitol of input
  #                                federal state are taken
  #                     -> "free": coordinates of input free_lon and free_lat are
  #                                taken
  #                     -> "mouse": coordinates given via input map_out_click are taken
  #                                (in this variable, the coordinates chosen
  #                                 by mouse click on a map are saved)
  # - free_lon: double; longitude, only needed if type = "free"
  # - free_lat: double; latitude, only needed if type = "free"
  # - map_out_click:    array; two doubles with longitude and latitude, only needed if type = "mouse"
  
  #source script/variables where coordinates for federal capitals are defined
  source(paste0(getwd(),"/input.R"))
  
  # read coordinate pair for specified input type
  if (type == "bhs"){
    point_coord <- vect(data.frame(lon = bundeslaender_coord$lon_point[bundeslaender_coord$bundesland == state],
                                   lat = bundeslaender_coord$lat_point[bundeslaender_coord$bundesland == state]),
                        geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else if (type == "free" && !is.na(free_lon) && !is.na(free_lat)){
    point_coord <- vect(data.frame(lon = free_lon,
                                   lat = free_lat),
                        geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else if (type == "mouse" && !is.null(map_out_click)){
    point_coord <- vect(data.frame(lon = map_out_click$lng,
                                   lat = map_out_click$lat),
                        geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else{
    point_coord <- NA
  }
  
  return(point_coord)
}
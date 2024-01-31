#function to get point coordinates of cities in question
f_point_coord <- function(bl,point_forecast,free_lon = 9.05222, free_lat = 48.52266){
  source(paste0(getwd(),"/input.R"))
  
  #bhs = bundeshauptstadt
  if (point_forecast == "bhs"){
    bl_point_coord <- vect(data.frame(lon = bundeslaender_coord$lon_point[bundeslaender_coord$bundesland == bl],
                                      lat = bundeslaender_coord$lat_point[bundeslaender_coord$bundesland == bl]),
                           geom=c("lon", "lat"), crs="", keepgeom=FALSE)
    all_point_coord <- vect(data.frame(lon = bundeslaender_coord$lon_point,
                                       lat = bundeslaender_coord$lat_point),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else if (!is.na(free_lon) && !is.na(free_lat)){
    bl_point_coord <- vect(data.frame(lon = free_lon,
                                      lat = free_lat),
                           geom=c("lon", "lat"), crs="", keepgeom=FALSE)
    all_point_coord <- vect(data.frame(lon = c(free_lon,bundeslaender_coord$lon_point),
                                       lat = c(free_lat,bundeslaender_coord$lat_point)),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  } else{
    bl_point_coord <- NA
    all_point_coord <- vect(data.frame(lon = c(free_lon,bundeslaender_coord$lon_point),
                                       lat = c(free_lat,bundeslaender_coord$lat_point)),
                            geom=c("lon", "lat"), crs="", keepgeom=FALSE)
  }
  

  return(list(bl_point_coord, all_point_coord))
}

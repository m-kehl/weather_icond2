#function to crop SpatRaster to field of interest
f_crop_spatraster <- function(spatraster_list,layers,square_coord){
  new_spatraster <- crop(x = subset(spatraster_list, layers),square_coord)
  return(new_spatraster)
}
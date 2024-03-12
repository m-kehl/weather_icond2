f_cut_forecast <- function(forecast,coord){
  ## function to cut forecast for partial area out of forecast for larger area
  # - forecast: SpatRaster; forecast data for larger area
  # - coord:    SpatVector; coordinates for partial area
  
  crop_forecast <- crop(forecast,coord)

  return(crop_forecast)
}

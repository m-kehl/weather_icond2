f_state_forecast <- function(diff_forecast,square_coord){
  # 3. process data ---------------------------------------------------------

  crop_forecast <- crop(diff_forecast,square_coord)

  return(crop_forecast)
}

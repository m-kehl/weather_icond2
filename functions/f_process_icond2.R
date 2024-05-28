f_process_icond2 <- function(icond2_data,parameter){
  ##function to postprocess icon d2 forecast data for visualization
  # - icond2_data:  SpatRaster; icon d2 data, result of f_read_icond2.R
  # - parameter:    character;  icon d2 abbreviations for forecasted parameters
  #                        options: "tot_prec" for precipitation
  #                                 "t_2m"     for temperature 2m above ground
  #                                 "clct"     for cloud cover
  #                                 "pmsl"     for sea level pressure
  
  #take out forecasts for full hours and convert into SpatRaster
  icond2_subset <- lapply(icond2_data,terra::subset,subset = c(1))
  all_forecasts <- rast(icond2_subset)
  
  #get difference between SpatRaster layers for rain and snow
  # -> results in moment forecast not sum over all forecasts
  if (parameter %in% c("tot_prec")){
    diff_forecasts <- diff(all_forecasts)
  } else if (parameter %in% c("pmsl")){
    #change Pa into hPa
    diff_forecasts <- all_forecasts /100
  } else{
    diff_forecasts <- all_forecasts
  }
  
  return(diff_forecasts)
}

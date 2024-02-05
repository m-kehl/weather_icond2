# library(shiny)
# library(waiter)
f_process_icond2 <- function(nwp_data,parameter){
  # 3. process data ---------------------------------------------------------

  nwp_subset <- lapply(nwp_data,terra::subset,subset = c(1))
  all_forecasts <- rast(nwp_subset)
  
  if (parameter %in% c("rain_gsp", "snow_gsp")){
    #calculate difference between to spatraster layers
    diff_forecasts <- diff(all_forecasts)
  } else{
    diff_forecasts <- all_forecasts
  }
  return(diff_forecasts)
}

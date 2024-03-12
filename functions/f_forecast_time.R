f_forecast_time <- function(){
  ## function to extract date/time of latest icon d2 forecast calculation

  Sys.setenv(TZ="CET")
  current_hour <- as.integer(format(Sys.time(), "%H"))
  forecast_time <- as.POSIXct(ifelse(current_hour %% 3 == 2, floor_date(Sys.time(),"hour") - 5 * 60 * 60,
                            ifelse(current_hour %% 3 == 1,
                                   floor_date(Sys.time(),"hour") - 4 * 60 * 60,
                                   floor_date(Sys.time(),"hour") - 3 * 60 * 60)))
                                  
  return(forecast_time)
}



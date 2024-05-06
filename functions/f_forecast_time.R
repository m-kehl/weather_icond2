f_forecast_time <- function(){
  ## function to extract date/time of latest icon d2 forecast calculation

  current_time <- Sys.time()
  current_UTC <- floor_date(as.POSIXct(current_time,"UTC"),"hour")
  current_UTC_hour <- as.integer(format(current_UTC, "%H"))
  forecast_time <- as.POSIXct(ifelse(current_UTC_hour %% 3 == 2, current_UTC - 5 * 60 * 60,
                            ifelse(current_UTC_hour %% 3 == 1,
                                   current_UTC - 4 * 60 * 60,
                                   current_UTC - 3 * 60 * 60)),"UTC")
  return(forecast_time)
}



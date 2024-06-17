f_forecast_time <- function(){
  ## function to extract date/time of most recent available icon d2 forecast calculation

  current_time <- Sys.time()
  current_UTC <- floor_date(as.POSIXct(current_time,"UTC"),"hour")
  current_UTC_hour <- as.integer(format(current_UTC, "%H"))
  #get most recent available forecast calculation (icon d2 forecast is recalculated every
  #three hours (starting at 00.00 UTC, 03.00 UTC, 06.00 UTC, etc), it takes up to three hours
  #to complete recalculation and its publication at opendata.dwd.de). Thus, if current time
  #is ie 6UTC, 7UTC or 8 UTC, the forecast calculation which started at 3.00UTC 
  #is the most recent available forecast
  forecast_time <- as.POSIXct(ifelse(current_UTC_hour %% 3 == 2, current_UTC - 5 * 60 * 60,
                            ifelse(current_UTC_hour %% 3 == 1,
                                   current_UTC - 4 * 60 * 60,
                                   current_UTC - 3 * 60 * 60)),"UTC")
  return(forecast_time)
}



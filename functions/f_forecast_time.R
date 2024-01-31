f_forecast_time <- function(){
  #get UTC hour/time of most recent forecast generation
  current_hour <- as.integer(format(Sys.time(), "%H"))
  # forecast_time <- ifelse(current_hour %% 3 == 2, current_hour - 5, ifelse(
  #   current_hour %% 3 == 1, current_hour - 4, current_hour - 3))
  forecast_time <- as.POSIXct(ifelse(current_hour %% 3 == 2, floor_date(Sys.time(),"hour") - 5 * 60 * 60,
                            ifelse(current_hour %% 3 == 1,
                                   floor_date(Sys.time(),"hour") - 4 * 60 * 60,
                                   floor_date(Sys.time(),"hour") - 3 * 60 * 60)))
                                  
  return(forecast_time)
}



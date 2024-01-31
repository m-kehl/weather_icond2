f_time_converter <- function(){
  
  
  start <- f_forecast_time()
  interval <- 1 * 60 * 60
  end <- f_forecast_time() + 48 * 60 * 60
  #end <- start + as.difftime(2, units="days")
  
  
  converter <- data.frame(time = seq(from=start, by=interval, to=end),
                          rain_gsp = c(0:48), snow_gsp = c(0:48), t_2m = c(1:49))
  
  return(converter)
}

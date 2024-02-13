f_time_converter <- function(){
  
  Sys.setenv(TZ="CET")
  start <- ceiling_date(Sys.time(),unit = "hour") - 1 * 60 * 60
  interval <- 1 * 60 * 60
  end <- ceiling_date(Sys.time(),unit = "hour") + 6 * 60 * 60
  #end <- start + as.difftime(2, units="days")
  
  
  converter <- data.frame(time = seq(from=start, by=interval, to=end),
                          rain_gsp = c(0:7), snow_gsp = c(0:7), t_2m = c(1:8))
  
  return(converter)
}

f_time_converter <- function(){
  ## specific function to assign date and time to icon d2 forecasts for mapping
  #  them by f_map_icond2.R
  
  Sys.setenv(TZ="CET")
  start <- ceiling_date(Sys.time(),unit = "hour") - 1 * 60 * 60
  interval <- 1 * 60 * 60
  end <- ceiling_date(Sys.time(),unit = "hour") + 6 * 60 * 60
  
  converter <- data.frame(time = seq(from=start, by=interval, to=end),
                          tot_prec = c(0:7), t_2m = c(1:8), clct = c(1:8),
                          pmsl = c(1:8))
  
  return(converter)
}

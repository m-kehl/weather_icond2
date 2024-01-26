#library(shiny)
#library(waiter)
f_read_data <- function(forecast_time,parameter){
  ##read forecast data
  #---- forecast_time:  time for last created forecast
  #---- parameter:      icon d2 abbreviation for parameters like rain, snow, etc.
  waiter_show( # show the waiter
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ), # use a spinner
    id = c("map_out")
  )
  
  #forecast_time <- as.integer()
  # waiter_show( # show the waiter
  #   html = spin_rotating_plane(), # use a spinner
  #   id = c("bar_out")
  # )
  # convert forecast_time into character
  #forecast_time_char <- ifelse(nchar(forecast_time) == 1,paste0("0",forecast_time),forecast_time)
  #path to dwd open data - icon-d2
  nwp_base_rain_gsp <- paste0("ftp://opendata.dwd.de/weather/nwp/icon-d2/grib/",
                              format(forecast_time, '%H'),"/",parameter,"/")
  nwp_urls <- indexFTP("", base=nwp_base_rain_gsp, dir=tempdir())
  nwp_urls <- nwp_urls[grepl("lat-lon",nwp_urls)]
  
  #todo: make own altorithm with only terra, not rDWD?
  #downlaod
  nwp_file <- dataDWD(nwp_urls, base=nwp_base_rain_gsp, dir=tempdir(), 
                      joinbf=TRUE, dbin=TRUE, read=F, browse = F)
  waiter_hide()
  waiter_show( # show the waiter
    html = tagList(
      spin_fading_circles(),
      "Postprocess data for visualization.."
    ), # use a spinner
    id = c("map_out")
  )
  #read
  nwp_data <- readDWD(nwp_file)
  #waiter_hide()
  return(nwp_data)
  
}

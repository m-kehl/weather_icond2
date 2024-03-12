f_read_icond2 <- function(date,parameter){
  ## function to read icon d2 forecast data
  # - date:  POSIXct; date and time of forecast calculation, most recent
  #                   forecast calculation is result of f_forecast_time.R
  # - parameter: character; icon d2 abbreviations for forecasted parameters
  #                         options: "rain_gsp" for rain
  #                                  "snow_gsp" for snow
  #                                  "t_2m"     for temperature 2m above ground

  # show waiter while searching for data
  waiter_show(
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ),
    id = c("map_out")
  )
  
  # define source/path for download
  nwp_base <- paste0("ftp://opendata.dwd.de/weather/nwp/icon-d2/grib/",
                              format(date, '%H'),"/",parameter,"/")
  nwp_urls <- indexFTP("", base=nwp_base, dir=tempdir())
  nwp_urls <- nwp_urls[grepl("lat-lon",nwp_urls)]
  nwp_urls <- nwp_urls[as.numeric(ceiling_date(Sys.time(),unit = "hour") - date):
                         (as.numeric(ceiling_date(Sys.time(),unit = "hour") - date) + 7)]
  
  #downlaod
  nwp_file <- dataDWD(nwp_urls, base=nwp_base, dir=tempdir(), 
                      joinbf=TRUE, dbin=TRUE, read=F, browse = F, quiet = TRUE)
  # show other waiter while reading data
  waiter_hide()
  waiter_show(
    html = tagList(
      spin_fading_circles(),
      "Postprocess data for visualization.."
    ),
    id = c("map_out")
  )
  
  #read
  nwp_data <- readDWD(nwp_file)

  return(nwp_data)
}

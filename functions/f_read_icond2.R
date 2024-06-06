f_read_icond2 <- function(date,parameter,id){
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
    id = c(NS(id,"map_out"))
  )
  
  #determine size of tempdir() folder
  files<-list.files(tempdir(), full.names = TRUE, recursive = TRUE)
  vect_size <- sapply(files, file.size)
  size_files <- sum(vect_size)
  
  if (size_files > 140000000){
    file.remove(list.files(tempdir(), full.names = T, pattern = "icon"))
  }
  
  # define source/path for download
  nwp_base <- paste0("ftp://opendata.dwd.de/weather/nwp/icon-d2/grib/",
                     format(date, '%H'),"/",parameter,"/")
  nwp_urls <- indexFTP("", base=nwp_base, dir=tempdir())
  nwp_urls <- nwp_urls[grepl("lat-lon",nwp_urls)]
  
  current_time <- Sys.time()
  current_UTC <- as.POSIXct(current_time,"UTC")
  ceiling_current_UTC <- ceiling_date(current_UTC,unit = "hour")
  time_diff <- as.integer(ceiling_current_UTC - date)
  
  nwp_urls <- nwp_urls[time_diff:(time_diff + 7)]
  
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
    id = c(NS(id,"map_out"))
  )
  
  #read
  nwp_data <- readDWD(nwp_file)
  
  return(nwp_data)
}

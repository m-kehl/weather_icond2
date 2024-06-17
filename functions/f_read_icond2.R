f_read_icond2 <- function(date,parameter,id){
  ## function to read icon d2 forecast data
  # - date:  POSIXct; date and time of forecast calculation, date/time of most recent
  #                   available forecast calculation is result of f_forecast_time.R
  # - parameter: character; icon d2 abbreviation for forecasted parameter
  #                         options: "tot_prec" for precipitation
  #                                  "t_2m"     for temperature 2m above ground
  #                                  "clct"     for cloud cover
  #                                  "pmsl"     for sea level pressure
  # - id: character; namespace id
  
  # show waiter while searching for data
  # waiter_show(
  #   html = tagList(
  #     spin_fading_circles(),
  #     "Download data from opendata.dwd.de .."
  #   ),
  #   id = c(NS(id,"map_out"))
  # )
  
  #determine size of tempdir() folder
  files<-list.files(tempdir(), full.names = TRUE, recursive = TRUE)
  vect_size <- sapply(files, file.size)
  size_files <- sum(vect_size)
  
  #delete icon forecasts if folder size is too large -> otherwise performance
  #is getting too poor
  if (size_files > 140000000){
    file.remove(list.files(tempdir(), full.names = T, pattern = "icon"))
  }
  
  #define source/path for download
  nwp_base <- paste0("ftp://opendata.dwd.de/weather/nwp/icon-d2/grib/",
                     format(date, '%H'),"/",parameter,"/")
  nwp_urls <- indexFTP("", base=nwp_base, dir=tempdir())
  nwp_urls <- nwp_urls[grepl("lat-lon",nwp_urls)]
  
  #retrieve files of eight forecast hours starting from last full hour
  current_time <- Sys.time()
  current_UTC <- as.POSIXct(current_time,"UTC")
  ceiling_current_UTC <- ceiling_date(current_UTC,unit = "hour")
  time_diff <- as.integer(ceiling_current_UTC - date)
  
  nwp_urls <- nwp_urls[time_diff:(time_diff + 7)]
  
  #downlaod
  nwp_file <- dataDWD(nwp_urls, base=nwp_base, dir=tempdir(), 
                      joinbf=TRUE, dbin=TRUE, read=F, browse = F, quiet = TRUE)
  
  # show other waiter while reading data
  # waiter_hide()
  # waiter_show(
  #   html = tagList(
  #     spin_fading_circles(),
  #     "Postprocess data for visualization.."
  #   ),
  #   id = c(NS(id,"map_out"))
  # )
  
  #read
  nwp_data <- readDWD(nwp_file)
  
  return(nwp_data)
}

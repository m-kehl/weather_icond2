f_map_icond2 <- function(input_time,forecast_data,parameter,point_coord,type){
  ## function to visualize forecast data on a map
  # - input_time:    POSIXct; date/time of forecast data to map
  # - forecast_data: SpatRaster; forecast data to map
  # - parameter:     character; abbreviation for forecasted parameter
  #                            options: "rain_gsp" for rain
  #                                     "snow_gsp" for snow
  #                                     "t_2m"     for temperature 2m above ground
  # - point_coord:   SpatVector; coordinate pairs of all places which should be
  #                              represented on the map by points
  # - type: character; if "free": place of freely chosen coordinate pair in app
  #                               is mapped as a red point
  
  ## preparation for map
  # assign date/time to mapped forecast
  converter <- f_time_converter()
  ii <- converter[[parameter]][converter$time == input_time]
  # assign title name
  if (parameter %in% c("rain_gsp", "snow_gsp")){
    if (parameter == "rain_gsp"){
      title_name = "Regen"
    }else{
      title_name = "Schnee"
    }
    
    # define colors for rain/snow
    df_col <- data.frame(from = c(0.3,1,2,4,8,15,30,60), to = c(1,2,4,8,15,30,60,120), color = c("peachpuff1","pink","plum3","maroon1","red","red4","gold","lawngreen"))

    ##map rain/snow
    terra::plot(x = subset(forecast_data, c(ii)), main = paste0(title_name," [mm/h] - ",
                                format(as.POSIXct(time(subset(forecast_data, c(ii)), format= ""),"CET"),
                                       "%d.%m.%Y %H:%M")),
                col = df_col)
  } else{
    ## map temperature
    terra::plot(x = subset(forecast_data, c(ii)), main = paste0("Temperatur [\u00B0C] - ",
                                format(as.POSIXct(time(subset(forecast_data, c(ii)), format= ""),"CET"),
                                        "%d.%m.%Y %H:%M")),
                 range = c(min(minmax(forecast_data)),max(minmax(forecast_data))))
  }
  
  # add borders of federal states to map
  addBorders()
  # add points of federal states (black) and of freely chosen coordinate pair (red)
  points(point_coord, col = "black", cex=0.7, pch=16, alpha=1)
  if (type == "free"){
    points(point_coord[1], col = "red", cex=0.7, pch=16, alpha=1)
  }
}
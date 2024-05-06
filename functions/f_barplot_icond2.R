f_barplot_icond2 <- function(point_forecast,input_time,parameter,
                             type,state){
  ## function to create barplot with icon d2 point forecast data
  # - point_forecast: matrix; data of icon d2 point forecast
  # - input_time:     POSIXct; date/time to focus on in barplot
  # - parameter:      character; icon d2 abbreviation for forecasted parameter
  #                        options: "rain_gsp" for rain
  #                                 "snow_gsp" for snow
  #                                 "t_2m"     for temperature 2m above ground
  # - type:           character; either "bhs" (abbreviation for Bundeshauptstadt),
  #                              "free" (free entry of coodrinate pair) or
  #                              "mouse" (mouse cick on map to define coordinates)
  #                    -> needed to specify barplot title
  # - state:          character; name of federal state in which place for point
  #                    forecast lies
  
  ##plot basics
  # title specification
  if (type == "free"){
    title_help = "nach Koord."
  }else if (type == "bhs"){
    title_help = state
  }else if (type == "mouse"){
    title_help = "nach Mausklick"
  }
  
  # define on which time barplot starts
  converter <- f_time_converter()
  ii <- converter[[parameter]][converter$time == input_time]
  
  ## placeholder plot -> is shown if no point forecast data is available
  if (is.na(point_forecast[1])){
    plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
    
    text(x = 0.5, y = 0.5, paste("No data for chosen coordinates."), 
         cex = 1.6, col = "black")
  } else{
    ## plot rain/snow
    if (parameter %in% c("rain_gsp", "snow_gsp")){
      color <- rep("blue",ncol(point_forecast))
      color[ii] <- "cadetblue"
      barplot(point_forecast[1,], col = color, axis.lty = 1, las = 2,
              names.arg = format(converter$time[2:nrow(converter)],format ="%a %H:%M" ),
              ylab = "[mm / h]", ylim = c(0,max(2,point_forecast[1,]+0.5)))
      title(paste0("Punktvorhersage: ",title_help))
    } else{
      # plot temperature
      color <- rep("violet",ncol(point_forecast))
      color[ii] <- "darkviolet"
      plot(converter$time,point_forecast[1,], col = color, pch = 16, xaxt="n",
           panel.first = rect(c(converter$time[ii] - 30 * 60), -1e6,
                              c(converter$time[ii] + 30 * 60), 1e6,
                              col='gray', border=NA),
           ylab = "Temperatur [\u00B0C]", xlab = "", type = "b")
      axis.POSIXct(1,converter$time,format ="%a %H:%M")
      title(paste0("Punktvorhersage: ",title_help))
    }
  }
}
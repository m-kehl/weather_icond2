f_barplot_icond2 <- function(point_forecast,input_time,parameter,
                             input_pf,bl){

  if (input_pf == "free"){
    title_help = "nach Koord."
  }else{
    title_help = bl
  }
  
  converter <- f_time_converter()
  ii <- converter[[parameter]][converter$time == input_time]
  
  if (is.na(point_forecast[1])){
    plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
    
    text(x = 0.5, y = 0.5, paste("Chosen coordinates are outside\n",
                                 "of the available range."), 
         cex = 1.6, col = "black")
  } else{
    if (parameter %in% c("rain_gsp", "snow_gsp")){
      color <- rep("blue",ncol(point_forecast))
      color[ii] <- "cadetblue"
      barplot(point_forecast[1,], col = color, axis.lty = 1, las = 2,
              names.arg = format(converter$time[2:nrow(converter)],format ="%a %H:%M" ),
              ylab = "[mm / h]", ylim = c(0,max(2,point_forecast[1,]+0.5)))
      title(paste0("Punktvorhersage: ",title_help))
      #axis.POSIXct(1,converter$time[2:49],format ="%a %H:%M")
    } else{
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
  # point_forecast_rain <- terra::extract(diff_forecasts_rain, point_coord, raw = TRUE, ID = FALSE)
  # point_forecast_temp <- terra::extract(temp, point_coord, raw = TRUE, ID = FALSE)

  # barplot(point_forecast_rain[1,], col = "blue", names.arg = c(7:29))
  # plot(point_forecast_temp[1,], col = "red")
  
  #barplot for rain and snow together
  # point_forecast_together <- t(as.matrix(data.frame(A = point_forecast[2,],B=point_forecast_rain[2,])))                
  # barplot(point_forecast_together, names.arg = c(7:23,0:5), col = c("cyan","blue"),
  #         legend = c("snow","rain"))
  # par(new = TRUE)
  # plot(point_forecast_temp[2,],axes = FALSE, type = "l", col = "red")
  # axis(side=4, col = "red", at = pretty(range(point_forecast_temp[2,])))
}
f_plot_mess_prec <- function(mess_data,names){
  par(mar = c(5, 5, 4, 6))
  station_ids <- base::unique(mess_data$STATIONS_ID)

  colours <- c("black","red","green","blue","cyan")
  more_plots <- TRUE
  count <- 1
  while(more_plots){
    plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
         mess_data$RF_10[mess_data$STATIONS_ID == station_ids[count]],
         pch = 8, type = "p",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
         ylim <- c(min(mess_data$RF_10)-10,max(mess_data$RF_10)),
         col = colours[count], xlab = "Messzeit", ylab = "relative Feuchte [%]")
    par(new = TRUE)
    plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]] + (count-1)*60,
         mess_data$RWS_10[mess_data$STATIONS_ID == station_ids[count]],
         axes = FALSE, type = "h", col = colours[count], 
         xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
         ylim = c(0,1),xlab = "Messzeit (UTC)",ylab = "")
    axis(side=4, col = "black", ylim = c(0,1))
    mtext("Niederschlag [mm]", side = 4, line = 3)   
    par(new= TRUE)
    more_plots <- ifelse(count < length(names),TRUE,FALSE)
    count <- count + 1
  }
  # point_forecast_together <- t(as.matrix(data.frame(A = point_forecast[2,],B=point_forecast_rain[2,])))                
  # barplot(point_forecast_together)
  # par(new = TRUE)
  # plot(point_forecast_temp[2,],axes = FALSE, type = "l", col = "red")
  # axis(side=4, col = "red", at = pretty(range(point_forecast_temp[2,])))
}
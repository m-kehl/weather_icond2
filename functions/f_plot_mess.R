f_plot_mess <- function(mess_data,names){
  par(mar = c(5, 5, 4, 6))
  # mess_data$STATIONS_ID <- as.factor(mess_data$STATIONS_ID)
  # plot(mess_data$MESS_DATUM,mess_data$TT_10,col = mess_data$STATIONS_ID,
  #      ylab = "Temperatur",xlab = "Messzeit",pch = 17)

  
  
  station_ids <- base::unique(mess_data$STATIONS_ID)
  
  colours <- c("black","red","green","blue","cyan")
  more_plots <- TRUE
  count <- 1
  while(more_plots){
    plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
         mess_data$TT_10[mess_data$STATIONS_ID == station_ids[count]],
         pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
         ylim <- c(min(mess_data$TT_10),max(mess_data$TT_10)),
         col = colours[count], xlab = "Messzeit", ylab = "Temperatur")
    par(new = TRUE)
    more_plots <- ifelse(count < length(names),TRUE,FALSE)
    count <- count + 1
  }
  legend(x="bottomleft",legend = names, col = c(1:length(names)),
          pch = 16)
}
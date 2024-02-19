f_plot_mess <- function(mess_data,panel,timespan = c(-999,999)){
  par(mar = c(5, 5, 4, 6))
  station_ids <- base::unique(mess_data$STATIONS_ID)
  station_names <- base::unique(mess_data$station_name)
  colours <- c("black","red","green","blue","cyan")
  # 
  # plot_start <- nrow(mess_data) - anzahl + 1
  # plot_end <- nrow(mess_data)
  # 
  more_plots <- TRUE
  count <- 1
  
  if (panel == "now"){
    while(more_plots){
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
           mess_data$TT_10[mess_data$STATIONS_ID == station_ids[count]],
           pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$TT_10),max(mess_data$TT_10)),
           col = colours[count], xlab = "Messzeit (UTC)", ylab = "Temperatur [\u00B0C]")
      par(new = TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
    legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
           pch = 16)
    title(format(mess_data$MESS_DATUM[1],"%d.%m.%y"), adj = 0)
  } else if (panel == "daily"){
    mess_data <- mess_data[mess_data$MESS_DATUM>=timespan[1] & mess_data$MESS_DATUM<=timespan[2],]
    while(more_plots){
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
           mess_data$TMK.Lufttemperatur[mess_data$STATIONS_ID == station_ids[count]],
           pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$TMK.Lufttemperatur),max(mess_data$TMK.Lufttemperatur)),
           col = colours[count], xlab = "Messdatum", ylab = "Temperatur [\u00B0C]")
      par(new = TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
    legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
           pch = 16)
    title("Tageswerte", adj = 0)
  } else if (panel == "monthly"){
    while(more_plots){
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
           mess_data$MO_TT.Lufttemperatur[mess_data$STATIONS_ID == station_ids[count]],
           pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$MO_TT.Lufttemperatur),max(mess_data$MO_TT.Lufttemperatur)),
           col = colours[count], xlab = "Messmonat", ylab = "Temperatur [\u00B0C]")
      par(new = TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
    legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
           pch = 16)
    title("Monatswerte", adj = 0)
  }
  
  
  
}
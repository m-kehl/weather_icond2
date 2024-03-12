f_plot_mess <- function(mess_data,resolution,timespan = c(-999,999)){
  ## function to plot measurement surface temperature data
  # - mess_data:  data.frame; data for measurement surface data, result of
  #                           f_read_mess.R
  # - resolution: character; to define which measurement data are plotted,
  #                          options: "now" for today's most recent measurement data
  #                                   "daily" for daily measurement data
  #                                   "monthly" for monthly measurement data
  # - timespan: array with two dates (POSIXct); since and till date between which
  #                          measurement data are plotted
  
  #define plot basics
  par(mar = c(5, 5, 4, 6))
  colours <- c("black","red","green","blue","cyan")
  station_ids <- base::unique(mess_data$STATIONS_ID)
  station_names <- base::unique(mess_data$station_name)

  # loop to plot measurement data of multiple stations in one plot
  more_plots <- TRUE
  count <- 1
  
  if (resolution == "now"){
    while(more_plots){
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
           mess_data$TT_10[mess_data$STATIONS_ID == station_ids[count]],
           pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$TT_10,na.rm = T),max(mess_data$TT_10,na.rm = T)),
           col = colours[count], xlab = "Messzeit (UTC)", ylab = "Temperatur [\u00B0C]")
      par(new = TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
    legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
           pch = 16)
    title(format(mess_data$MESS_DATUM[1],"%d.%m.%y"), adj = 0)
  } else if (resolution == "daily"){
    mess_data <- mess_data[mess_data$MESS_DATUM>=timespan[1] & mess_data$MESS_DATUM<=timespan[2],]
    while(more_plots){
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
           mess_data$TMK.Lufttemperatur[mess_data$STATIONS_ID == station_ids[count]],
           pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$TMK.Lufttemperatur,na.rm = T),max(mess_data$TMK.Lufttemperatur,na.rm=T)),
           col = colours[count], xlab = "Messdatum", ylab = "Temperatur [\u00B0C]")
      par(new = TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
    legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
           pch = 16)
    title("Tageswerte", adj = 0)
  } else if (resolution == "monthly"){
    while(more_plots){
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
           mess_data$MO_TT.Lufttemperatur[mess_data$STATIONS_ID == station_ids[count]],
           pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$MO_TT.Lufttemperatur,na.rm = T),max(mess_data$MO_TT.Lufttemperatur,na.rm = T)),
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

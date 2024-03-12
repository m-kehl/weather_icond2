f_plot_mess_prec <- function(mess_data,resolution,timespan = c(-999,999)){
  ## function to plot measurement surface precipitation data
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
           mess_data$RF_10[mess_data$STATIONS_ID == station_ids[count]],
           pch = 8, type = "p",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$RF_10,na.rm = T)-10,max(mess_data$RF_10,na.rm = T)),
           col = colours[count], xlab = "Messzeit (UTC)", ylab = "relative Feuchte [%]")
      par(new = TRUE)
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]] + (count-1)*60,
           mess_data$RWS_10[mess_data$STATIONS_ID == station_ids[count]],
           axes = FALSE, type = "h", col = colours[count], 
           xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim = c(0,1),xlab = "Messzeit (UTC)",ylab = "")
      axis(side=4, col = "black", ylim = c(0,1))
      mtext("Niederschlag [mm]", side = 4, line = 3)   
      par(new= TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
  } else if (resolution == "daily"){
    mess_data <- mess_data[mess_data$MESS_DATUM>=timespan[1] & mess_data$MESS_DATUM<=timespan[2],]
    while(more_plots){
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
           mess_data$UPM.Relative_Feuchte[mess_data$STATIONS_ID == station_ids[count]],
           pch = 8, type = "p",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$UPM.Relative_Feuchte-30,40,na.rm = T),max(mess_data$UPM.Relative_Feuchte,100,na.rm = T)),
           col = colours[count], xlab = "Messdatum", ylab = "relative Feuchte [%]")
      par(new = TRUE)
      plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]] + (count-1)*60*60,
          mess_data$RSK.Niederschlagshoehe[mess_data$STATIONS_ID == station_ids[count]],
           axes = FALSE, type = "h", col = colours[count], 
           xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim = c(0,50),xlab = "Messdatum",ylab = "")
      axis(side=4, col = "black", ylim = c(0,50))
      mtext("Niederschlag [mm]", side = 4, line = 3)   
      par(new= TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
  } else if (resolution == "monthly"){
      while(more_plots){
        plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]] + (count-1)*60*60*24,
             mess_data$MO_RR.Niederschlagshoehe[mess_data$STATIONS_ID == station_ids[count]],
              yaxt = 'n', type = "h", col = colours[count], 
             xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
             ylim = c(0,400),xlab = "Monat",ylab = "")
        axis(side=4, col = "black", ylim = c(0,400))
        mtext("Niederschlag [mm]", side = 4, line = 3)   
        par(new= TRUE)
        more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
        count <- count + 1
    }
  }
}

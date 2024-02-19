f_plot_mess_prec <- function(mess_data,panel,anzahl = 30){
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
           mess_data$RF_10[mess_data$STATIONS_ID == station_ids[count]],
           pch = 8, type = "p",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
           ylim <- c(min(mess_data$RF_10)-10,max(mess_data$RF_10)),
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
  } else if (panel == "daily"){
    while(more_plots){
      plot(tail(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],anzahl),
           tail(mess_data$UPM.Relative_Feuchte[mess_data$STATIONS_ID == station_ids[count]],anzahl),
           pch = 8, type = "p",xlim <- c(min(tail(mess_data$MESS_DATUM,anzahl)),max(tail(mess_data$MESS_DATUM,anzahl))),
           ylim <- c(min(tail(mess_data$UPM.Relative_Feuchte,anzahl))-30,max(tail(mess_data$UPM.Relative_Feuchte,anzahl))),
           col = colours[count], xlab = "Messdatum", ylab = "relative Feuchte [%]")
      par(new = TRUE)
      plot(tail(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]] + (count-1)*60*60,anzahl),
          tail(mess_data$RSK.Niederschlagshoehe[mess_data$STATIONS_ID == station_ids[count]],anzahl),
           axes = FALSE, type = "h", col = colours[count], 
           xlim <- c(min(tail(mess_data$MESS_DATUM,anzahl)),max(tail(mess_data$MESS_DATUM,anzahl))),
           ylim = c(0,50),xlab = "Messdatum",ylab = "")
      axis(side=4, col = "black", ylim = c(0,50))
      mtext("Niederschlag [mm]", side = 4, line = 3)   
      par(new= TRUE)
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
      }
    } else if (panel == "monthly"){
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
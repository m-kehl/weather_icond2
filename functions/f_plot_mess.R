f_plot_mess <- function(mess_data,resolution,parameters, timespan = c(-999,999)){
  ## function to plot measurement surface temperature data
  # - mess_data:   data.frame; data for measurement surface data, result of
  #                           f_read_mess.R
  # - resolution:  character; to define which measurement data are plotted,
  #                          options: "now" for today's most recent measurement data
  #                                   "daily" for daily measurement data
  #                                   "monthly" for monthly measurement data
  # - parameters:  array with up to four characters; meteorological parameter/s
  #                to plot
  # - timespan:    array with two dates (POSIXct); since and till date between which
  #                          measurement data are plotted
  
  # load meta plot data for parameters
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  #define plot basics
  par(mar = c(5, 5, 4, 6))
  colours <- c("black","red","green","blue","cyan")
  station_ids <- base::unique(mess_data$STATIONS_ID)
  station_names <- base::unique(mess_data$station_name)

  # loop to plot measurement data of multiple stations in one plot
  more_plots <- TRUE
  count <- 1
  
  attr(mess_data$MESS_DATUM,"tzone") <- "UTC"
  
  # for (mm in c(1:length(parameters))){
  #   if (!(meteo_parameters$dwd_name_now[meteo_parameters$parameter==parameters[mm]] %in% colnames(mess_data))){
  #     parameters <- parameters[-c(parameters[mm])]
  #   }x <- x[! x %in% c('Mavs', 'Spurs')]
  # }
  
  if (resolution == "now"){
    while(more_plots){
      param <- meteo_parameters$dwd_name_now[meteo_parameters$parameter==parameters[1]]
      print(param)
      if (param != "XX"){
        mess_data_plot <- mess_data[mess_data$STATIONS_ID == station_ids[count],]
        plot(mess_data_plot$MESS_DATUM,
             array(mess_data_plot[param][[1]]),
             pch = meteo_parameters$pch[meteo_parameters$parameter==parameters[1]],
             type = meteo_parameters$type[meteo_parameters$parameter==parameters[1]],
             xlim = c(min(mess_data$MESS_DATUM, na.rm = T),
                       max(mess_data$MESS_DATUM, na.rm = T)),
             ylim = c(min(mess_data[param], meteo_parameters$min_now[meteo_parameters$parameter==parameters[1]]
                           ,na.rm = T),
                       max(mess_data[param], meteo_parameters$max_now[meteo_parameters$parameter==parameters[1]]
                           ,na.rm = T)),
             col = colours[count],
             xlab = "Messzeit (UTC)",
             ylab = paste0(meteo_parameters$parameter[meteo_parameters$parameter==parameters[1]]," [", 
                           meteo_parameters$unit[meteo_parameters$parameter==parameters[1]],"]"))
        par(new = TRUE)
      }

      if (length(parameters) > 1){
        param <- meteo_parameters$dwd_name_now[meteo_parameters$parameter==parameters[2]]
        print(param)
        if (param != "XX"){
          plot(mess_data_plot$MESS_DATUM + (count-1)*60,
               array(mess_data_plot[param][[1]]),
               pch = meteo_parameters$pch[meteo_parameters$parameter==parameters[2]],
               type = meteo_parameters$type[meteo_parameters$parameter==parameters[2]],
               col = colours[count], 
               xlim = c(min(mess_data$MESS_DATUM, na.rm = T),
                         max(mess_data$MESS_DATUM, na.rm = T)),
               ylim = c(min(mess_data[param], meteo_parameters$min_now[meteo_parameters$parameter==parameters[2]]
                             ,na.rm = T),
                         max(mess_data[param], meteo_parameters$max_now[meteo_parameters$parameter==parameters[2]]
                             ,na.rm = T)),
               xlab = "Messzeit (UTC)",
               ylab = "",
               axes = FALSE)
          graphics::box()
          axis(side=4, col = "black", ylim =c(min(mess_data[param],na.rm = T),max(mess_data[param],na.rm = T)))
          axis.POSIXct(side=1, xlim = c(min(mess_data$MESS_DATUM, na.rm = T),
                                        max(mess_data$MESS_DATUM, na.rm = T)),tz = "UTC")
          mtext(paste0(meteo_parameters$parameter[meteo_parameters$parameter==parameters[2]]," [", 
                       meteo_parameters$unit[meteo_parameters$parameter==parameters[2]],"]"),
                side = 4, line = 3)
          title(paste0("Plot 1: ",
                       meteo_parameters$parameter[meteo_parameters$parameter==parameters[1]],
                       " (",
                       meteo_parameters$pch_unicode[meteo_parameters$parameter==parameters[1]],
                       ") und ",
                       meteo_parameters$parameter[meteo_parameters$parameter==parameters[2]],
                       " (",
                       meteo_parameters$pch_unicode[meteo_parameters$parameter==parameters[2]],
                       ") - ",
                       format(mess_data$MESS_DATUM[1],"%d.%m.%y")), adj = 0)
          
          par(new = TRUE)
        }

      } else{
        title(paste0("Plot 1: ",
                     meteo_parameters$parameter[meteo_parameters$parameter==parameters[1]],
                     " (",
                     meteo_parameters$pch_unicode[meteo_parameters$parameter==parameters[1]],
                     ") - ",
                     format(mess_data$MESS_DATUM[1],"%d.%m.%y")), adj = 0)
      }
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
    legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
           pch = 16)

  }
  # else if (resolution == "daily"){
  #   mess_data <- mess_data[mess_data$MESS_DATUM>=timespan[1] & mess_data$MESS_DATUM<=timespan[2],]
  #   while(more_plots){
  #     plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
  #          mess_data$TMK.Lufttemperatur[mess_data$STATIONS_ID == station_ids[count]],
  #          pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
  #          ylim <- c(min(mess_data$TMK.Lufttemperatur,na.rm = T),max(mess_data$TMK.Lufttemperatur,na.rm=T)),
  #          col = colours[count], xlab = "Messdatum", ylab = "Temperatur [\u00B0C]")
  #     par(new = TRUE)
  #     more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
  #     count <- count + 1
  #   }
  #   legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
  #          pch = 16)
  #   title("Tageswerte", adj = 0)
  # } else if (resolution == "monthly"){
  #   while(more_plots){
  #     plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
  #          mess_data$MO_TT.Lufttemperatur[mess_data$STATIONS_ID == station_ids[count]],
  #          pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
  #          ylim <- c(min(mess_data$MO_TT.Lufttemperatur,na.rm = T),max(mess_data$MO_TT.Lufttemperatur,na.rm = T)),
  #          col = colours[count], xlab = "Messmonat", ylab = "Temperatur [\u00B0C]")
  #     par(new = TRUE)
  #     more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
  #     count <- count + 1
  #   }
  #   legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
  #          pch = 16)
  #   title("Monatswerte", adj = 0)
  # }
}

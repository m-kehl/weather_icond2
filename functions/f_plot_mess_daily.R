f_plot_mess_daily <- function(name,mess_meta){
  mess_base_temp <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/recent/"
  #mess_base_prec <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/10_minutes/precipitation/now/"
  #print(length(name))
  data_mess_all <- NULL
  
  for (ii in c(1:length(name))){
    source_temp <- paste0(mess_base_temp,"tageswerte_KL_",mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],"_akt.zip")
    if(url.exists(source_temp)){
      data_temp <- dataDWD(source_temp, force=NA, varnames=TRUE)
    } else{
      data_temp <- NULL
    }
    # source_prec <- paste0(mess_base_prec,"10minutenwerte_nieder_",mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],"_now.zip")
    
    # if(url.exists(source_prec)){
    #   data_prec <- dataDWD(source_prec, force=NA, varnames=TRUE)
    #   
    # }else{
    #   data_prec <- NULL
    # }
    
    # data_mess <- merge(data_temp,data_prec)
    data_mess <- arrange(data_temp,MESS_DATUM)
    data_mess_all <- rbind(data_mess_all,data_mess)
    # data_temp_all <- rbind(data_temp_all,data_temp)
    # data_prec_all <- rbind(data_prec_all,data_prec)
  }
  
  
  
  par(mar = c(5, 5, 4, 6))
  # mess_data$STATIONS_ID <- as.factor(mess_data$STATIONS_ID)
  # plot(mess_data$MESS_DATUM,mess_data$TT_10,col = mess_data$STATIONS_ID,
  #      ylab = "Temperatur",xlab = "Messzeit",pch = 17)
  mess_data <- data_mess_all
  station_ids <- base::unique(mess_data$STATIONS_ID)
  
  colours <- c("black","red","green","blue","cyan")
  more_plots <- TRUE
  count <- 1
  while(more_plots){
    plot(mess_data$MESS_DATUM[mess_data$STATIONS_ID == station_ids[count]],
         mess_data$TMK.Lufttemperatur[mess_data$STATIONS_ID == station_ids[count]],
         pch = 16,type = "b",xlim <- c(min(mess_data$MESS_DATUM),max(mess_data$MESS_DATUM)),
         ylim <- c(min(mess_data$TMK.Lufttemperatur),max(mess_data$TMK.Lufttemperatur)),
         col = colours[count], xlab = "Messdatum", ylab = "Temperatur [\u00B0C]")
    par(new = TRUE)
    more_plots <- ifelse(count < length(name),TRUE,FALSE)
    count <- count + 1
  }
  legend(x="bottomleft",legend = name, col = c(1:length(name)),
         pch = 16)
  title("Tageswerte", adj = 0)
}
f_read_mess <- function(name, mess_meta,resolution){
  ## function to read measurement surface data (like ie temperature, precipitation)
  # - name:       array; names of measurement stations (characters)
  # - mess_meta:  data.frame; meta data for measurement surface data, result of 
  #                           f_read_mess_meta.R
  # - resolution: character; to define which measurement data are downloaded,
  #                          options: "now" for today's most recent measurement data
  #                                   "daily" for daily measurement data
  #                                   "monthly" for monthly measurement data
  
  #path definitions for download source
  url_base <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/"
  
  if (resolution == "now"){
    mess_base <- "10_minutes/air_temperature/now/10minutenwerte_TU_"
    mess_base_prec <- "10_minutes/precipitation/now/10minutenwerte_nieder_"
    mess_end <- "_now"
  } else if (resolution == "daily"){
    mess_base <- paste0(resolution,"/kl/recent/tageswerte_KL_")
    mess_end <- "_akt"
  } else if (resolution == "monthly"){
    mess_base <- paste0(resolution,"/kl/recent/monatswerte_KL_")
    mess_end <- "_akt"
  }
  
  #loop to load and concatenate measurement data for all stations
  data_mess_all <- NULL
  
  for (ii in c(1:length(name))){
    source <- paste0(url_base,mess_base,mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],mess_end,".zip")
    if(url.exists(source)){
      data_mess <- dataDWD(source, force=NA, varnames=TRUE,quiet = T)
      data_mess$station_name <- name[ii]
    } else{
      data_mess <- NULL
    }
    
    if (resolution == "now"){
      source_prec <- paste0(url_base,mess_base_prec,mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],mess_end,".zip")
      
      if(url.exists(source_prec)){
        data_prec <- dataDWD(source_prec, force=NA, varnames=TRUE,quiet = T)
        
      }else{
        data_prec <- NULL
      }
      data_mess <- merge(data_mess,data_prec)
    }
    data_mess <- arrange(data_mess,MESS_DATUM)
    data_mess_all <- rbind(data_mess_all,data_mess)
  }
  return(data_mess_all)
}
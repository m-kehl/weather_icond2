f_read_mess <- function(name, mess_meta,panel){
  url_base <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/"
  
  if (panel == "now"){
    mess_base <- "10_minutes/air_temperature/now/10minutenwerte_TU_"
    mess_base_prec <- "10_minutes/precipitation/now/10minutenwerte_nieder_"
    mess_end <- "_now"
  } else if (panel == "daily"){
    mess_base <- paste0(panel,"/kl/recent/tageswerte_KL_")
    mess_end <- "_akt"
  } else if (panel == "monthly"){
    mess_base <- paste0(panel,"/kl/recent/monatswerte_KL_")
    mess_end <- "_akt"
  }
  
  data_mess_all <- NULL
  
  for (ii in c(1:length(name))){
    source <- paste0(url_base,mess_base,mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],mess_end,".zip")
    if(url.exists(source)){
      data_mess <- dataDWD(source, force=NA, varnames=TRUE,quiet = T)
      data_mess$station_name <- name[ii]
    } else{
      data_mess <- NULL
    }
    
    if (panel == "now"){
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
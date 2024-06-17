f_read_mess_meta <- function(){
  ## function to read measurement meta data
  #source
  mess_base <- "https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/10_minutes/air_temperature/now/"
  mess_meta <- dataDWD(paste0(mess_base,"zehn_now_tu_Beschreibung_Stationen.txt"),read = T,quiet = T)
  #sort
  mess_meta <- arrange(mess_meta,Stationsname, .locale = "de")
  #format stations id
  mess_meta$Stations_id <- sprintf("%0*d", 5, mess_meta$Stations_id)
  return(mess_meta)
}

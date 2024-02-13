f_check_data_availability <- function(name,mess_meta){
  mess_base_temp <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/10_minutes/air_temperature/now/"
  mess_base_prec <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/10_minutes/precipitation/now/"
  name_list <- c()
  
  for (ii in c(1:length(name))){
    source_temp <- paste0(mess_base_temp,"10minutenwerte_TU_",mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],"_now.zip")
    source_prec <- paste0(mess_base_prec,"10minutenwerte_nieder_",mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],"_now.zip")
    if(!url.exists(source_temp) | !url.exists(source_prec)){
      name_list <- append(name_list,name[ii])
    }
  }
  print(name_list)
  return(name_list)
}
f_process_plants <- function(plant_table,phase,station_name, meta_data){
  print(phase)
  station_id <- meta_data$Stations_id[meta_data$Stationsname == station_name]
  
  plant_data_proc <- plant_table[plant_table$Stations_id == station_id & plant_table$Phase_id == phase,]
  plant_data_proc$Eintrittsdatum <- as.POSIXct(as.character(plant_data_proc$Eintrittsdatum), format = "%Y%m%d")
  
  return(plant_data_proc)
}
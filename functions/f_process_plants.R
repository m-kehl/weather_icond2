f_process_plants <- function(plant_table,phase,station_name, meta_data){
  ## function to postprocess phenological data
  #  (get subset of phenological data (created by f_read_plants.R) for chosen
  #   phase and station & format date)
  # - plant_table:  data.table with phenological data; produced by f_read_plants.R
  # - phase:        integer; indicates phase-ID
  # - station_name: character; name of measurement station
  # - meta_data:    data.table with phenological meta data; produced by
  #                 f_read_plants_meta.R
  
  # get station_id which corresponds to station_name
  station_id <- meta_data$Stations_id[meta_data$Stationsname %in% station_name]
  
  # subset plant_table
  plant_data_proc <- plant_table[plant_table$Stations_id %in% station_id & plant_table$Phase_id == phase,]
  # format data.table
  plant_data_proc$Eintrittsdatum <- as.POSIXct(as.character(plant_data_proc$Eintrittsdatum), format = "%Y%m%d")
  plant_data_proc$Stationsname <- sapply(plant_data_proc$Stations_id,
                                         function(x) meta_data$Stationsname[meta_data$Stations_id == x])
  #get stations without data
  #plant_data_proc <- arrange(plant_data_proc,Stationsname)
  plant_data_proc <- plant_data_proc[order(plant_data_proc$Stationsname),]
  no_data <- station_name[!(station_name %in% unique(plant_data_proc$Stationsname))]
  
  return(list(plant_data_proc,no_data))
}

f_table_plants <- function(meta_data,station_name){
  ## function to select important meta columns out of meta_data for
  #  stations defined in station_name
  # - meta_data:    data.table; meta information about meteorological stations like
  #                             surface measurement stations or phenological stations,
  #                             ie result of f_read_plants_meta.R
  # - station_name: array; station name/s (character/s)
  
  meta_selected <- meta_data[meta_data$Stationsname %in% station_name,c("Stationsname","Stationshoehe","Datum Stationsaufloesung")]
  colnames(meta_selected)[colnames(meta_selected) == "Stationshoehe"] <- "Stationshöhe" 
  colnames(meta_selected)[colnames(meta_selected) == "Datum Stationsaufloesung"] <- "Stationsauflösung"
  meta_selected$Stationsauflösung <- ifelse(meta_selected$Stationsauflösung == ""," - ",meta_selected$Stationsauflösung)
  
  return(meta_selected)
}
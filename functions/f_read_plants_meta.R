f_read_plants_meta <- function(){
  phenology_base <- "https://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/"
  meta_plant_data <- data.table::fread(paste0(phenology_base,
                                              "PH_Beschreibung_Phaenologie_Stationen_Jahresmelder.txt"),
                                       encoding = "Latin-1")
  meta_plant_data <- arrange(meta_plant_data,Stationsname)
  return(meta_plant_data)
}
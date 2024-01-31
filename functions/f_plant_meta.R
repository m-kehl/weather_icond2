f_plant_meta <- function(){
  
  pflanzen_arten <- c("Schneegloeckchen","Rosskastanie","Loewenzahn")
  
  phenology_base <- "https://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/"
  help_data <- data.table::fread(paste0(phenology_base,
                                        "PH_Beschreibung_Phaenologie_Stationen_Jahresmelder.txt"),
                                 encoding = "Latin-1")
  
}

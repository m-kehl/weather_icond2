f_read_plants <- function(plant){
  waiter_show( # show the waiter
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ), # use a spinner
    id = c("plant_out")
  )
  
  if (plant == ""){
    plant_data = data.frame()
  } else{
    phenology_base <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/"
    
    all_plants <- indexFTP("", base=phenology_base, dir=tempdir(), overwrite = T)
    
    ui_plant <- all_plants[grepl(plant,all_plants)]
    plant_data <- data.table::fread(paste0(phenology_base,ui_plant))
    
  }
  #print(plant_data)
  # help_data <- data.table::fread(paste0(phenology_base,
  #                                       "PH_Beschreibung_Phaenologie_Stationen_Jahresmelder.txt"))
  
  # # 
  # nwp_base_rain_gsp <- paste0("https://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/")
  # #                               + )
  # # nwp_urls <- indexFTP("", base=nwp_base_rain_gsp, dir=tempdir())
  # 
  # PH_Beschreibung_Phaenologie_Stationen_Jahresmelder.txt
  # 
  # result <- getURL(nwp_base_rain_gsp,
  #                  strsplit(result, "\r*\n")[[1]], sep = "")
  
  return(plant_data)
}

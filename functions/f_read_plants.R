f_read_plants <- function(plant){
  ## function to read phenological  data
  # - plant: character; name of plant species to read
  
  # show waiter while reading data
  waiter_show( 
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ),
    id = c("plant_out")
  )
  
  # read phenological data
  if (plant == ""){
    plant_data = data.frame()
  } else{
    phenology_base <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/"
    
    all_plants <- indexFTP("", base=phenology_base, dir=tempdir(), overwrite = T,
                           quiet = T)
    
    ui_plant <- all_plants[grepl(plant,all_plants)]
    plant_data <- data.table::fread(paste0(phenology_base,ui_plant))
  }
  
  return(plant_data)
}

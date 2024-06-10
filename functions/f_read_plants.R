f_read_plants <- function(plant,id){
  ## function to read phenological measurement data
  # - plant: character; name of plant species to read
  # - id:    character; id of namespace
  
  # show waiter while reading data
  waiter_show(
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ),
    id = c(NS(id,"plant_out"))
  )
  
  # read phenological data
  if (plant == ""){
    #empty dataframe if no plant species is given
    plant_data = data.frame()
  } else{
    #source
    phenology_base <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/"
    #list all files of source folder
    all_plants <- indexFTP("", base=phenology_base, dir=tempdir(), overwrite = T,
                           quiet = T)
    #select file of source folder for wished plant species
    ui_plant <- all_plants[grepl(plant,all_plants)]
    #read
    plant_data <- data.table::fread(paste0(phenology_base,ui_plant))
  }
  
  return(plant_data)
}

f_plot_plants <- function(plant_data,plant,meta_data,station_name){
  ## function to plot postprocessed phenological data
  # - plant_data:   data.table with phenological data; produced by f_process_plants.R
  # - plant:        character; plant species
  # - meta_data:    data.table with phenological meta data, produced by
  #                 f_read_plants_meta.R
  # - station_name: array; name/s of measurement station/s (characters)
  
  ## plot preparations
  # load meta plot data for parameters
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  #define plot basics
  par(mar = c(5, 5, 4, 6))
  station_ids <- base::unique(plant_data$Stations_id)
  station_names_data <- base::unique(plant_data$Stationsname)
  colours <- rainbow(length(station_name))
  
  ##plot  
  # loop to plot measurement data of multiple stations in one plot
  more_plots <- TRUE
  count <- 1
  count_plot <- 1
  
  if (nrow(plant_data) == 0){
    # if data.table is empty -> create empty plot with title telling user that
    # no data is available
    plot(c(0, 1), c(0, 1), bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n',
         xlab = "",ylab = "")
    title(main = "An der Station sind in dieser Phase\nkeine Daten vorhanden.", adj = 0)
  } else{
    while(more_plots){
      if (station_name[count] %in% station_names_data){
        station_data <- plant_data[plant_data$Stations_id == station_ids[count_plot],]
        plot(station_data$Referenzjahr,yday(station_data$Eintrittsdatum),
             ylab = "Tag des Jahres", xlab = "Jahr",
             pch = "\u2600",
             col = colours[count],
             ylim = c(min(yday(plant_data$Eintrittsdatum)),max(yday(plant_data$Eintrittsdatum))),
             xlim = c(min(plant_data$Referenzjahr),max(plant_data$Referenzjahr)),
             main = paste0(plant," (",min(plant_data$Referenzjahr),"-",
                           max(plant_data$Referenzjahr),")"))
        par(new=T)
        
        more_plots <- ifelse(count < length(station_name),TRUE,FALSE)
        count <- count + 1
        count_plot <- count_plot + 1
      } else{
        more_plots <- ifelse(count < length(station_name),TRUE,FALSE)
        count <- count + 1
      }

    }
    legend(x="bottomleft",legend = meta_data$Stationsname[meta_data$Stationsname %in% station_name], col = colours,
           pch = "\u2600")
  }
}
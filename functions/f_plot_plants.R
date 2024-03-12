f_plot_plants <- function(data,plant){
  ## function to plot postprocessed phenological data
  # - data:     data.table with phenological data; produced by f_process_plants.R
  # - plant:    character; plant species

  if (nrow(data) == 0){
    # if data.table is empty -> create empty plot with title telling user that
    # no data is available
    plot(c(0, 1), c(0, 1), bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n',
         xlab = "",ylab = "")
    title(main = "An der Station sind in dieser Phase\nkeine Daten vorhanden.", adj = 0)
  } else{
    plot(data$Referenzjahr,yday(data$Eintrittsdatum),
         ylab = "Tag des Jahres", xlab = "Jahr",
         main = paste0(plant," (",data$Referenzjahr[1],"-",
                       data$Referenzjahr[nrow(data)],")"))
  }
}
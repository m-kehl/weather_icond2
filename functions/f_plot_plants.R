f_plot_plants <- function(data,pflanze){
  if (nrow(data) == 0){
    plot(c(0, 1), c(0, 1), bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n',
         #main = "Bei der Station sind für diese Phase/Pflanze\n keine Daten vorhanden.",
         xlab = "",ylab = "")
    title(main = "An der Station sind in dieser Phase\nkeine Daten vorhanden.", adj = 0)
    # text(x = 0.5, y = 0.5, paste("An dieser Station sind keine Daten\n
    #                               dieser Phase vorhanden."), 
    #      cex = 1.6, col = "black")
    
  } else{
    plot(data$Referenzjahr,yday(data$Eintrittsdatum),
         ylab = "Tag des Jahres", xlab = "Jahr",
         main = paste0(pflanze," (",data$Referenzjahr[1],"-",
                       data$Referenzjahr[nrow(data)],")"))
    
  }
  
  
}
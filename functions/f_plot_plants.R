f_plot_plants <- function(data){
  if (nrow(data) == 0){
    plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
    
    text(x = 0.5, y = 0.5, paste("Bei dieser Station sind keine Daten\n
                                  fuer diese Phase vorhanden."), 
         cex = 1.6, col = "black")
    
  } else{
    plot(data$Referenzjahr,yday(data$Eintrittsdatum),
         ylab = "Tag des Jahres", xlab = "Jahr",
         title = "")
    
  }
  
  
}
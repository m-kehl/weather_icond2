f_plot_plants <- function(data){
  
  plot(data$Referenzjahr,yday(data$Eintrittsdatum),
       ylab = "Tag des Jahres", xlab = "Jahr",
       title = "")
  
  
}
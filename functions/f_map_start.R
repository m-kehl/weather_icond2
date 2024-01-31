f_map_start <- function(){
  plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
  
  text(x = 0.5, y = 0.5, paste("Please select a parameter\n"), 
       cex = 1.6, col = "black")
}


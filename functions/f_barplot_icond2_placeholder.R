f_barplot_icond2_placeholder <- function(){
  ## function to create an empty plot with a text in its middle
  # -> used if input of f_barplot_icond2() is not in the right format
  
  plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
  text(x = 0.5, y = 0.5, paste("Please select valid coordinates\n",
                               "for the point forecast.\n",
                               "Format: 47,123 or 47.123\n",
                               "not allowed: 47."), 
       cex = 1.6, col = "black")
}
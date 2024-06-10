f_plot_placeholder <- function(){
  ## function to create empty plot as placeholder in the Shinyapp
  #  -> the title indicates what the user should do next
  plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
  title("Bitte w\u00E4hlen Sie einen Input.",adj = 0)
}
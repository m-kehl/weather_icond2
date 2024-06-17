f_subset_icond2 <- function(input_time,icond2_processed){
  ## function to retrieve one layer out of SpatRaster for
  #  the time specified with input_time
  sub <- icond2_processed[[time(icond2_processed) == input_time]]
  return(sub)
}
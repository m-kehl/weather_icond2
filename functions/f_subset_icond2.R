f_subset_icond2 <- function(input_time,icond2_processed,parameter){
  converter <- f_time_converter()
  ii <- converter[[parameter]][converter$time == input_time]
  sub <- subset(icond2_processed,c(ii))
  return(sub)
}
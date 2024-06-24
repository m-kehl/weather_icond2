f_text_regression <- function(data,regression){
  ## function to get information why regression line is not printed
  # - data: data.frame; phenological data, result of f_process_plants.R
  # - regression; logical; TRUE or FALSE, whether regression line is asked for or not
  
  #count data points per measurement station
  count_entries <- data %>% group_by(Stationsname) %>% count()
  
  #print infotext if regression line is asked for but at least one station holds
  #not enough data points for calculating reliable regression
  if(min(count_entries$n) <= 10 & regression == TRUE){
    text <- "Die Regressionslinie wird nur für Stationen mit mehr als 10 Datenpunkten angezeigt."
  } else{
    text <- ""
  }
  return(text)
}
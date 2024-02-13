f_map_icond2 <- function(input_time,diff_forecasts,parameter,point_coord,point_forecast){
  # waiter_show( # show the waiter
  #   html = tagList(
  #     spin_fading_circles(),
  #     "Last waiter.."
  #   ), # use a spinner
  #   id = c("map_out")
  # )
  #todo: change so this is taken from input.R
  converter <- f_time_converter()
  ii <- converter[[parameter]][converter$time == input_time]
  if (parameter %in% c("rain_gsp", "snow_gsp")){
    if (parameter == "rain_gsp"){
      title_name = "Regen"
    }else{
      title_name = "Schnee"
    }
    df_col <- data.frame(from = c(0.3,1,2,4,8,15,30,60), to = c(1,2,4,8,15,30,60,120), color = c("peachpuff1","pink","plum3","maroon1","red","red4","gold","lawngreen"))

    terra::plot(x = subset(diff_forecasts, c(ii)), main = paste0(title_name," [mm/h] - ",
                                format(time(subset(diff_forecasts, c(ii)), format= ""),
                                       "%d.%m.%Y %H:%M")),
                col = df_col)
  } else{
    #df_col <- data.frame(from = c(-10,-5,0,5,10,15,20,25), to = c(-5,0,5,10,15,20,25,30), color = c("darkblue","dodgerblue","lightblue","salmon","tomato","red","darkorange","gold"))
    
    terra::plot(x = subset(diff_forecasts, c(ii)), main = paste0("Temperatur [\u00B0C] ",
                        format(time(subset(diff_forecasts, c(ii)), format= ""),
                               "%d.%m.%Y %H:%M - ")),
                 range = c(min(minmax(diff_forecasts)),max(minmax(diff_forecasts))))

  }
  
  addBorders() # the projection seems to be perfectly good :)
  points(point_coord, col = "black", cex=0.7, pch=16, alpha=1)
  if (point_forecast == "free"){
    points(point_coord[1], col = "red", cex=0.7, pch=16, alpha=1)
  }
  # waiter_hide()
}

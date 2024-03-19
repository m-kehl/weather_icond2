f_plot_mess <- function(mess_data,granularity,parameters, title_start, timespan = c(-999,999)){
  ## function to plot measurement surface temperature data
  # - mess_data:   data.frame; data for measurement surface data, result of
  #                           f_read_mess.R
  # - granularity:  character; to define which measurement data are plotted,
  #                          options: "now" for today's most recent measurement data
  #                                   "daily" for daily measurement data
  #                                   "monthly" for monthly measurement data
  # - parameters:  array with up to four characters; meteorological parameter/s
  #                to plot
  # - title_start: character; this character is placed at the beginning of the title
  # - timespan:    array with two dates (POSIXct); since and till date between which
  #                          measurement data are plotted
  
  ## plot preparations
  # load meta plot data for parameters
  source(paste0(getwd(),"/input.R"),local = TRUE)
  
  #define plot basics
  par(mar = c(5, 5, 4, 6))
  colours <- c("black","red","green","blue","cyan")
  station_ids <- base::unique(mess_data$STATIONS_ID)
  station_names <- base::unique(mess_data$station_name)
  
  #set to UTC
  get_zime_zone <- Sys.getenv()
  Sys.setenv(TZ='GMT')
  
  ## setup for different granularities
  dwd_name <- paste0("dwd_name_",granularity)
  
  param_exists <- meteo_parameters$parameter[meteo_parameters[dwd_name][[1]] == "XX"]
  if (length(param_exists) > 0){
    for (ii in c(1:length(param_exists))){
      parameters <- parameters[parameters != param_exists[ii]]
    }
  }
  
  if (granularity == "now"){
    x_label <- "Messzeit (UTC)"
    title_appendix <- format(mess_data$MESS_DATUM[1],"%d.%m.%y")
    date_spacing <- 60 #1min
  } else if (granularity == "daily"){
    x_label <- "Messdatum"
    mess_data <- mess_data[mess_data$MESS_DATUM>=timespan[1] & mess_data$MESS_DATUM<=timespan[2],]
    title_appendix <- paste0(format(min(mess_data$MESS_DATUM),"%d.%m.%y"),
                             " - ",format(max(mess_data$MESS_DATUM),"%d.%m.%y"))
    date_spacing <- 60 * 60 #1h
  } else if (granularity == "monthly"){
    x_label <- "Messmonat"
    title_appendix <- paste0(format(min(mess_data$MESS_DATUM),"%m.%y"),
                             " - ",format(max(mess_data$MESS_DATUM),"%m.%y"))
    date_spacing <- 60*60*24 #1d
  }
  
  ##plot  
  # loop to plot measurement data of multiple stations in one plot
  more_plots <- TRUE
  count <- 1

  # empty plot if no data available
  if (length(parameters) == 0 | nrow(mess_data) == 0){
    plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
  }else{
    #plot (with left y-axis)
    while(more_plots){
      param <- meteo_parameters[dwd_name][[1]][meteo_parameters$parameter==parameters[1]]
      mess_data_plot <- mess_data[mess_data$STATIONS_ID == station_ids[count],]
      plot(mess_data_plot$MESS_DATUM + (count-1)*date_spacing,
           array(mess_data_plot[param][[1]]),
           pch = meteo_parameters$pch[meteo_parameters$parameter==parameters[1]],
           type = meteo_parameters$type[meteo_parameters$parameter==parameters[1]],
           xlim = c(min(mess_data$MESS_DATUM, na.rm = T),
                    max(mess_data$MESS_DATUM, na.rm = T)),
           ylim = c(min(mess_data[param], meteo_parameters$min_now[meteo_parameters$parameter==parameters[1]]
                        ,na.rm = T),
                    max(mess_data[param], meteo_parameters$max_now[meteo_parameters$parameter==parameters[1]]
                        ,na.rm = T)),
           col = colours[count],
           xlab = x_label,
           ylab = paste0(meteo_parameters$parameter[meteo_parameters$parameter==parameters[1]]," [", 
                         meteo_parameters$unit[meteo_parameters$parameter==parameters[1]],"]"))
      par(new = TRUE)
      #plot (with right y-axis)
      if (length(parameters) > 1){
        param <- meteo_parameters[dwd_name][[1]][meteo_parameters$parameter==parameters[2]]
        plot(mess_data_plot$MESS_DATUM + (count-1)*date_spacing,
             array(mess_data_plot[param][[1]]),
             pch = meteo_parameters$pch[meteo_parameters$parameter==parameters[2]],
             type = meteo_parameters$type[meteo_parameters$parameter==parameters[2]],
             col = colours[count], 
             xlim = c(min(mess_data$MESS_DATUM, na.rm = T),
                      max(mess_data$MESS_DATUM, na.rm = T)),
             ylim = c(min(mess_data[param], meteo_parameters$min_now[meteo_parameters$parameter==parameters[2]]
                          ,na.rm = T),
                      max(mess_data[param], meteo_parameters$max_now[meteo_parameters$parameter==parameters[2]]
                          ,na.rm = T)),
             xlab = x_label,
             ylab = "",
             axes = FALSE)
        graphics::box()
        axis(side=4, col = "black", ylim =c(min(mess_data[param],na.rm = T),max(mess_data[param],na.rm = T)))
        axis.POSIXct(side=1, xlim = c(min(mess_data$MESS_DATUM, na.rm = T),
                                      max(mess_data$MESS_DATUM, na.rm = T)))
        mtext(paste0(meteo_parameters$parameter[meteo_parameters$parameter==parameters[2]]," [", 
                     meteo_parameters$unit[meteo_parameters$parameter==parameters[2]],"]"),
              side = 4, line = 3)
        title(paste0(title_start,
                     meteo_parameters$parameter[meteo_parameters$parameter==parameters[1]],
                     " (",
                     meteo_parameters$pch[meteo_parameters$parameter==parameters[1]],
                     ") und ",
                     meteo_parameters$parameter[meteo_parameters$parameter==parameters[2]],
                     " (",
                     meteo_parameters$pch[meteo_parameters$parameter==parameters[2]],
                     ") - ",title_appendix), adj = 0)
        par(new = TRUE)
      } else{
        title(paste0(title_start,
                     meteo_parameters$parameter[meteo_parameters$parameter==parameters[1]],
                     " (",
                     meteo_parameters$pch[meteo_parameters$parameter==parameters[1]],
                     ") - ", title_appendix), adj = 0)
        par(new = TRUE)
      }
      more_plots <- ifelse(count < length(station_names),TRUE,FALSE)
      count <- count + 1
    }
    legend(x="bottomleft",legend = station_names, col = c(1:length(station_names)),
           pch = 16)
  }
  
  ## turn timezone back
  Sys.setenv(TZ="CET")
}

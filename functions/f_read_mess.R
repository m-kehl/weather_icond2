f_read_mess <- function(name, mess_meta,panel){
  url_base <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/"
  
  if (panel == "now"){
    mess_base <- "10_minutes/air_temperature/now/10minutenwerte_TU_"
    mess_base_prec <- "10_minutes/precipitation/now/10minutenwerte_TU_"
    mess_end <- "now"
  } else if (panel == "daily"){
    mess_base <- paste0(panel,"/kl/recent/tageswerte_KL_")
    mess_end <- "akt"
  } else if (panel == "monthly"){
    mess_base <- paste0(panel,"/kl/recent/monatswerte_KL_")
    mess_end <- "akt"
  }
  
  data_mess_all <- NULL
  
  for (ii in c(1:length(name))){
    source_temp <- paste0(mess_base_temp,"10minutenwerte_TU_",mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],"_now.zip")
    if(url.exists(source_temp)){
      data_temp <- dataDWD(source_temp, force=NA, varnames=TRUE)
    } else{
      data_temp <- NULL
    }
    source_prec <- paste0(mess_base_prec,"10minutenwerte_nieder_",mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],"_now.zip")
    
    if(url.exists(source_prec)){
      data_prec <- dataDWD(source_prec, force=NA, varnames=TRUE)
      
      }else{
      data_prec <- NULL
    }
    
    data_mess <- merge(data_temp,data_prec)
    data_mess <- arrange(data_mess,MESS_DATUM)
    data_mess_all <- rbind(data_mess_all,data_mess)
    # data_temp_all <- rbind(data_temp_all,data_temp)
    # data_prec_all <- rbind(data_prec_all,data_prec)
  }
  
  #print(nrow(data_temp_all))

  # 
  # data_mess <- merge(data_temp_all,data_prec_all)
  
  return(data_mess_all)
  
  
  
  
  
  
  
  
  
  # data.table::fread(paste0(mess_base,"tageswerte_KL_00294_akt.zip")) 
  # 
  # 
  # read.table(unzip(zipfile = paste0(mess_base,"tageswerte_KL_00294_akt.zip"), list = TRUE))
  # 
  # oo <- dataDWD(url = paste0(mess_base,"tageswerte_KL_00294_akt.zip"),
  #               read = TRUE)
  # 
  # 
  # myfile <- paste0(mess_base,"tageswerte_KL_00294_akt.zip")
  # temp <- tempfile()
  # download.file(myfile,temp, mode="wb")
  # unzip(temp)
  
}
# 
# link <- selectDWD("Potsdam", res="daily", var="kl", per="recent")
# zz <- dataDWD(link, force=NA, varnames=TRUE)
# 
# 
# 
# 
# produkt_klima_tag_20220806_20240206_00259.txt
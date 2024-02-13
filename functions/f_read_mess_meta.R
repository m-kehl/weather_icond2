f_read_mess_meta <- function(){
  
  mess_base <- "https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/10_minutes/air_temperature/now/"
  # mess_meta <- data.table::fread(paste0(mess_base, "zehn_now_tu_Beschreibung_Stationen.txt"),
  #                    sep = " ", encoding = "Latin-1",fill = TRUE
  #                   )
  # 
  #x <- readLines(paste0(mess_base,"zehn_now_tu_Beschreibung_Stationen.txt"))
  #myHeader <- paste(paste0("V", seq(max(lengths(strsplit(x, " ", fixed = TRUE))))), collapse = " ")
  # myHeader = paste0("V",c(1:15))
  # 
  # write(myHeader, "tmp_file.txt")
  # write(x, "tmp_file.txt", append = TRUE)
  # 
  # 
  mess_meta <- dataDWD(paste0(mess_base,"zehn_now_tu_Beschreibung_Stationen.txt"),read = T)
  mess_meta <- arrange(mess_meta,Stationsname)
  mess_meta$Stations_id <- sprintf("%0*d", 5, mess_meta$Stations_id)
  return(mess_meta)
  # mess_meta$V7 <- ifelse(mess_meta$V9!="", paste(mess_meta$V7,mess_meta$V8), mess_meta$V7)
  # mess_meta$V7 <- ifelse(mess_meta$V10!="", paste(mess_meta$V7,mess_meta$V9), mess_meta$V7)
  # mess_meta$V10 <- NULL
  # mess_meta$V9 <- NULL
  # colnames(mess_meta) <- as.character(mess_meta[1,])
  # mess_meta <- mess_meta[c(-1,-2), ]
  # #mess_meta$V7 <- ifelse(!is.na(mess_meta$V9), paste(mess_meta$V7,mess_meta$V8), mess_meta$V7)
  # mess_meta <- arrange(mess_meta,Stationsname)
}

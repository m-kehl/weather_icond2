icond2_data <- f_read_icond2(f_forecast_time(),"rain_gsp")
icond2_processed <- f_process_icond2(icond2_data,"rain_gsp")

layer_1 <- subset(icond2_processed,c(1))
layer_8 <- subset(icond2_processed,c(7))

cuting <- cut(icond2_processed[,,1],breaks = c(0.3,1,2,4,8,15,30,60,120))

pal <- colorNumeric(c("#FFFFCC", "#41B6C4","#0C2C84"), values(c(1,5,10)),
                    na.color = "transparent")
pal <- colorFactor(c("peachpuff1","pink","plum3","maroon1","red","red4","gold","lawngreen"),
                     levels = levels(cuting),na.color = "transparent")

leaflet() %>% addTiles() %>%
  addRasterImage(layer_1, colors = pal,
                 opacity = 0.8) #%>%  
            #addLegend(pal = pal, values = values(icond2_processed),                                                            title = "Surface temp")

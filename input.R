## file for all fixed data used by app.R
# -> federal states with according state capital and coordinates
# -> names of all plant species for which phenological data are available at
#    opendata.dwd.de
# -> all phase names and according phase ids for which phenological data are
#    available at opendata.dwd.de
# -> meteorological parameters with according names, units, axes for plot, etc
# -> individual list of colours used in graphics

## federal states with according state capital and coordinates
#  bundesland: character; german name of bundesland
#  lon1:       double; longitude giving western limit
#  lon2:       double; longitude giving eastern limit
#  lat1:       double; latitude giving northern limit
#  lat2:       double; latitude giving northern limit
#  mittel_lon: double; longitude of approximately the center of the bundesland
#  mittel_lat: double; latitude of approximately the center of the bundesland
#  zoom:       integer; number indicating the zoom status of the leaflet map to
#                       visualize the bundesland
#  landeshauptstadt: character; german name of landeshauptstadt
#  lon_point:  double; longitude of landeshauptstadt
#  lat_point:  double; latitude of landeshauptstadt

bundeslaender_coord <- data.frame(
  bundesland = c("Baden-Wuerttemberg", "Bayern","Berlin",                
                 "Brandenburg", "Bremen", "Hamburg",               
                 "Hessen", "Mecklenburg-Vorpommern", "Niedersachsen",         
                 "Nordrhein-Westfalen", "Rheinland-Pfalz", "Saarland",        
                 "Sachsen", "Sachsen-Anhalt", "Schleswig-Holstein",
                 "Thueringen"),
  lon1 = c(7,8.5,12,11,7.5,9,7.5,10.5,6,5,5.5,6,11.5,10,8,9),
  lon2 = c(11,14,15,15,9.5,11,10.5,15,12,10,9,7.5,15.5,13.5,11.5,13.5),
  lat1 = c(47,47,52,51,53,53,49,52.5,51,50,48.5,49,50,50.5,53,50),
  lat2 = c(50,51,53,54,54,54.5,52,55,54,53,51,50,52,53.5,55,52),
  mittel_lon =  c(9.00, 11.25, 13.28, 13.00,  8.50, 10.00,  9.00, 12.75, 9.00,  7.50,  7.25,  6.9,
                  13.50, 11.75,  9.75, 11.25),
  mittel_lat = c(48.50, 49.00, 52.50, 52.50, 53.50, 53.6, 50.50, 53.75, 52.50, 51.50, 49.75, 49.4,
                 51.00, 52.00, 54.00, 51.00),
  zoom = c(7,7,9,7,8,9,7,8,7,7,7,9,8,8,7,7),
  landeshauptstadt = c("Stuttgart","Muenchen","Berlin","Potsdam","Bremen","Hamburg",
                       "Wiesbaden","Schwerin","Hannover","Duesseldorf","Mainz",
                       "Saarbruecken","Dresden","Magdeburg","Kiel","Erfurt"),
  lon_point = c(9.182932,11.581981,13.404954,13.064473,8.8016937, 9.993682,8.239761,
                11.401250, 9.732010,6.773456,8.247253,6.996933, 13.737262,11.627624,
                10.122765,11.029880),
  lat_point = c(48.775846,48.135125,52.520007,52.390569,53.0792962,53.551085,50.078218,
                53.635502,52.375892,51.227741,49.992862,49.240157,51.050409,52.120533,
                54.323293,50.984768))

## german names of all plant species for which phenological data are available at
#    opendata.dwd.de
pflanzen_arten <- c("","Beifuss","Busch-Windroeschen","Eberesche","Esche",
                    "Europaeische-Laerche","Falscher_Jasmin","",
                    "Fichte","Flieder","Forsythie","Goldregen","Haenge-Birke",
                    "Hasel","Heidekraut","Herbstzeitlose","Huflattich",
                    "Hunds-Rose","Kiefer","Kornelkirsche","Loewenzahn",
                    "Robinie","Rosskastanie","Rotbuche","Sal-Weide","Schlehe",
                    "Schneebeere","Schneegloeckchen","Schwarz-Erle",
                    "Schwarzer_Holunder","Sommer-Linde","Spitz-Ahorn",
                    "Stiel-Eiche","Tanne","Traubenkirsche","Weissdorn",
                    "Wiesen-Fuchsschwanz",
                    "Wiesen-Knaeuelgras","Winter-Linde")

## all phase names (in german) and according phase ids for which phenological data are
#    available at opendata.dwd.de
#    (source: https://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/PH_Beschreibung_Phasendefinition_Jahresmelder_Wildwachsende_Pflanze.txt)
phenology_phases <- data.frame(phase = c("Beginn der Bluete","Blattfall (Herbst)",
                                         "Beginn Austrieb","Erste reife Fruechte",
                                         "Blattentfaltung","Blattverfaerbung (Herbst)",
                                         "Vollbluete"),
                               phase_id = c(5,32,3,62,4,31,6)) %>% arrange(phenology_phases,phase)

## meteorological parameters with according names, units, axes for plot, etc
#  parameter:      character; german name of parameter
#  unit:           character; unit of parameter
#  dwd_name_now:   character; abbreviation of parameter used by DWD for data with
#                           10'-granularity (XX if not available)
#  dwd_name_daily; character; abbreviation of parameter used by DWD for data with
#                           daily granularity (XX if not available)
#  dwd_name_monthly; character; abbreviation of parameter used by DWD for data with
#                           monthly granularity (XX if not available)
#  min_now;        integer; minimum value used in plot of parameter if no data is available
#  max_now;        integer; maximum value used in plot of parameter if no data is available
#  pch;            character; symbol with which parameter is represented in plot
#  type;           character; plot type how to represent parameter in plot, ie 
#                             "p" for points, "h" for histogram-like, "s" for stair steps
#                             (please google for other possible options known
#                              by R plot())
meteo_parameters <- data.frame(parameter = c("Temperatur","Niederschlag",
                                             "relative Feuchte", "Sonnenscheindauer",
                                             "Druck","Bodentemperatur",
                                             "Taupunkttemperatur","Regendauer",
                                             "Wind(Spitze)","Wind(Mittel)","Schneehöhe",
                                             "Bedeckungsgrad","Dampfdruck","Temperatur(max)",
                                             "Temperatur(min)"),
                               unit = c("\u00B0C", "mm", "%", "h","hPa",
                                        "\u00B0C","\u00B0C","min",
                                        "m/s","m/s","cm","Achtel","hPa","\u00B0C","\u00B0C"),
                               dwd_name_now = c("TT_10","RWS_10","RF_10","XX","PP_10",
                                                "TM5_10","TD_10","RWS_DAU_10","XX","XX","XX",
                                                "XX","XX","XX","XX"),
                               dwd_name_daily = c("TMK.Lufttemperatur","RSK.Niederschlagshoehe",
                                                  "UPM.Relative_Feuchte","SDK.Sonnenscheindauer",
                                                  "PM.Luftdruck","XX","XX","XX",
                                                  "FX.Windspitze","FM.Windgeschwindigkeit","SHK_TAG.Schneehoehe",
                                                  "NM.Bedeckungsgrad","VPM.Dampfdruck","TXK.Lufttemperatur_Max",
                                                  "TNK.Lufttemperatur_Min"),
                               dwd_name_monthly = c("MO_TT.Lufttemperatur","MO_RR.Niederschlagshoehe",
                                                    "XX","MO_SD_S.Sonnenscheindauer",
                                                    "XX","XX","XX","XX","MX_FX.Windspitze","XX","XX","MO_N.Bedeckungsgrad",
                                                    "XX","MX_TX.Lufttemperatur_AbsMax","MX_TN.Lufttemperatur_AbsMin"),
                               min_now = c(50,0,50,0,2000,50,50,0,500,500,0,0,50,50,50),
                               max_now = c(-50,1,40,0,500,-50,-50,0,-5,-5,50,9,-50,-50,-50),
                               pch = c("\u2022","\u007C","\u23F9","\u003D","\u25B2","0","\u0298","--",
                                       "~","\u2248","--","\u0298","\u221E","\u2191","\u2192"),
                               type = c("b","h","p","p","p","b","p","s",
                                        "p","p","s","p","p","p","p"))

## individual list of colours used in graphics
#  phenology plot
colours_phenology <- c("#FF0000","#0000FF","#00FF00",
             "#8000FF","#00FFFF", "darkorange1",
             "orange", "#FF00F5", "black",
             "forestgreen","yellow", "brown4", 
             "mediumorchid4","lavender","aquamarine",
             "beige","chocolate","azure4",
             "azure2", "indianred", "khaki",
             "bisque1","gold1", "lavenderblush"
             ,"mediumorchid","aquamarine4","cadetblue2",
             "cadetblue4","#00E0FF", "#FF0099",
             "#FF006B","#00FFD1","#FFC700",
             "#00FF66","#CCFF00")

# forecast data shown on leaflet map, colours depend on plotted parameter
colours_precipitation <- c("peachpuff1","maroon1","red","orange","gold","gold4","darkgreen","lawngreen")
colours_temperature <- c("blue","cyan4","lightblue","lavender","gold","orange","maroon","red4")
colours_cloud <- c("transparent","lightyellow","lightgreen","forestgreen","darkgreen")
colours_pressure <- c("purple4","transparent","darkorange")

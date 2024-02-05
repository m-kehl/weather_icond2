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
  landeshauptstadt = c("Stuttgart","Muenchen","Berlin","Potsdam","Bremen","Hamburg",
                       "Wiesbaden","Schwerin","Hannover","Duesseldorf","Mainz",
                       "Saarbruecken","Dresden","Magdeburg","Kiel","Erfurt"),
  lon_point = c(9.182932,11.581981,13.404954,13.064473,8.8016937, 9.993682,8.239761,
                11.401250, 9.732010,6.773456,8.247253,6.996933, 13.737262,11.627624,
                10.122765,11.029880),
  lat_point = c(48.775846,48.135125,52.520007,52.390569,53.0792962,53.551085,50.078218,
                53.635502,52.375892,51.227741,49.992862,49.240157,51.050409,52.120533,
                54.323293,50.984768))

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

#https://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/PH_Beschreibung_Phasendefinition_Jahresmelder_Wildwachsende_Pflanze.txt
phenology_phases <- data.frame(phase = c("Beginn der Bluete","Blattfall (Herbst)",
                                         "Beginn Austrieb","Erste reife Fruechte",
                                         "Blattentfaltung","Blattverfaerbung (Herbst)",
                                         "Vollbluete"),
                               phase_id = c(5,32,
                                            3,62,
                                            4,31,
                                            6))

phenology_phases <- arrange(phenology_phases,phase)

phenology_base <- "https://opendata.dwd.de/climate_environment/CDC/observations_germany/phenology/annual_reporters/wild/historical/"
meta_plant_data <- data.table::fread(paste0(phenology_base,
                                      "PH_Beschreibung_Phaenologie_Stationen_Jahresmelder.txt"),
                               encoding = "Latin-1")
meta_plant_data <- arrange(meta_plant_data,Stationsname)

#copy_right
# text_copy_right <- paste0(symbol("copyright"), "hello")
# test <- "Registered\U00AE"

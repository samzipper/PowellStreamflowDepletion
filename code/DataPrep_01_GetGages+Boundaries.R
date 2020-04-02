## MapOfSites.R

## prep workspace
source(file.path("code", "paths+packages.R"))

## read site locations - sites were selected and extracted by Jessi Ayers
sf_gages <- 
  file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "FromJessi", "Sites_information.csv") %>% 
  readr::read_csv() %>% 
  subset(complete.cases(.)) %>%
  subset(dec_lat_va > 24.396308 & dec_lat_va < 49.384358 & dec_long_va > -124.848974 & dec_long_va < -66.885444) %>% 
  sf::st_as_sf(coords = c("dec_long_va", "dec_lat_va"), crs = 4326) %>% 
  dplyr::mutate(SITE_NO = sprintf("%08d", site_no)) %>% 
  dplyr::select(-site_no)

## read watershed boundaries and trim to selected sites
sf_basins_all <-
  sf::st_read("C:/Users/samzipper/OneDrive - The University of Kansas/GIS_GeneralFiles/USGS_GageLoc/basins_all.gpkg",
              stringsAsFactors=F)
sf_basins <- 
  sf_basins_all %>% 
  subset(SITE_NO %in% sf_gages$SITE_NO)

## read in some ancillary datasets
# gages-ii
sf_g2_gages <- 
  sf::st_read("C:/Users/samzipper/OneDrive - The University of Kansas/GIS_GeneralFiles/USGS_GageLoc/GAGES-II/gagesII_9322_sept30_2011.shp",
              stringsAsFactors = F)

g2_basins <- list.files("C:/Users/samzipper/OneDrive - The University of Kansas/GIS_GeneralFiles/USGS_GageLoc/GAGES-II/boundaries-shapefiles-by-aggeco", 
                        pattern = "*.shp", full.names = T)
for (f in g2_basins){
  sf_g2_f <- sf::st_read(f, stringsAsFactors = F) %>% 
    subset(GAGE_ID %in% sf_gages$SITE_NO)
  
  if (f == g2_basins[1]){
    sf_g2_basins <- sf_g2_f
  } else {
    sf_g2_basins <- rbind(sf_g2_basins, sf_g2_f)
  }
  
}

sf_gages[sf_gages$has_basin & !(sf_gages$GAGES2), ]

sf_gages$GAGES2 <- sf_gages$SITE_NO %in% sf_g2_basins$GAGE_ID
sf_gages_nobasin <- subset(sf_gages, !has_basin & !GAGES2)

## save output
sf_gages %>% 
  dplyr::select(-has_basin) %>% 
  sf::st_write(file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_locations.gpkg"),
               delete_dsn = T,
               delete_layer = T)

sf_basins %>% 
  sf::st_write(file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_basins.gpkg"),
               delete_dsn = T,
               delete_layer = T)

sf_gages_nobasin %>% 
  sf::st_write(file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_locations_nobasin.gpkg"),
               delete_dsn = T,
               delete_layer = T)

## make map
ggplot() +
  geom_sf(data = sf_states_CONUS) +
  geom_sf(data = sf_sites, shape = 1) +
  ggsave(file.path("plots", "MapOfSites.png"),
         width = 190, height = 120, units = "mm")

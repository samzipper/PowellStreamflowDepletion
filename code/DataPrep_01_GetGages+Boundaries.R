## DataPrep_01_GetGages+Boundaries.R

## prep workspace
source(file.path("code", "paths+packages.R"))

#### read site locations - sites were selected and extracted by Jessi Ayers
sf_gages <- 
  file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "FromJessi", "Sites_information.csv") %>% 
  readr::read_csv() %>% 
  subset(complete.cases(.)) %>%
  subset(dec_lat_va > 24.396308 & dec_lat_va < 49.384358 & dec_long_va > -124.848974 & dec_long_va < -66.885444) %>% 
  sf::st_as_sf(coords = c("dec_long_va", "dec_lat_va"), crs = 4326) %>% 
  dplyr::mutate(GAGE_ID = sprintf("%08d", site_no)) %>% 
  dplyr::select(-site_no)

sf_gages <- sf_gages[!(duplicated(sf_gages$GAGE_ID)), ]

#### read watershed boundaries and trim to selected sites
## first step: GAGES-II
sf_basins_g2_all <- 
  sf::st_read("C:/Users/samzipper/OneDrive - The University of Kansas/GIS_GeneralFiles/USGS_GageLoc/GAGES-II/GAGESII_basins_all.gpkg",
              stringsAsFactors=F)
sf_basins_g2 <- 
  sf_basins_g2_all %>% 
  subset(GAGE_ID %in% sf_gages$GAGE_ID) %>% 
  dplyr::mutate(source = "GAGES-II")

sf_gages$GAGESII <- sf_gages$GAGE_ID %in% sf_basins_g2$GAGE_ID

## next up: NHDplus
sf_basins_nhd <-
  sf::st_read("C:/Users/samzipper/OneDrive - The University of Kansas/GIS_GeneralFiles/USGS_GageLoc/NHDplus/NHDplus_basins_all.gpkg",
              stringsAsFactors=F) %>% 
  dplyr::rename(GAGE_ID = SITE_NO) %>% 
  subset(GAGE_ID %in% sf_gages$GAGE_ID) %>% 
  subset(!(GAGE_ID %in% sf_basins_g2$GAGE_ID)) %>% 
  dplyr::mutate(source = "NHDplus")

## next up: NLDI
sf_basins_nldi <-
  sf::st_read("C:/Users/samzipper/OneDrive - The University of Kansas/GIS_GeneralFiles/USGS_GageLoc/NLDI/NLDI_basins_all.gpkg",
              stringsAsFactors=F) %>% 
  subset(GAGE_ID %in% sf_gages$GAGE_ID) %>% 
  subset(!(GAGE_ID %in% sf_basins_g2$GAGE_ID) & 
           !(GAGE_ID %in% sf_basins_nhd$GAGE_ID)) %>% 
  dplyr::mutate(source = "NLDI")


## combine all basins into a single file
# first: merge to a common CRS, select common fields
sf_basins_g2_merge <-
  sf_basins_g2 %>% 
  dplyr::select(GAGE_ID, source, geom)

sf_basins_nhd_merge <- 
  sf_basins_nhd %>% 
  dplyr::select(GAGE_ID, source, geom) %>% 
  sf::st_transform(crs = sf::st_crs(sf_basins_g2_merge))

sf_basins_nldi_merge <- 
  sf_basins_nldi %>% 
  dplyr::select(GAGE_ID, source, geom) %>% 
  sf::st_transform(crs = sf::st_crs(sf_basins_g2_merge))

## for gages missing: some should have a 0 added at the beginning and will be in gages-ii
sf_gages$GAGE_ID[sf_gages$missing_basin] <- paste0("0", sf_gages$GAGE_ID[sf_gages$missing_basin])

sf_basins_g2_more <- 
  sf_basins_g2_all %>% 
  subset(GAGE_ID %in% sf_gages$GAGE_ID[sf_gages$missing_basin]) %>% 
  dplyr::mutate(source = "GAGES-II") %>% 
  dplyr::select(GAGE_ID, source, geom)

# any gages still missing basins?
sf_gages$missing_basin <- !(sf_gages$GAGE_ID %in% sf_basins$GAGE_ID)
sum(sf_gages$missing_basin)
gages_missing <- sf_gages$GAGE_ID[sf_gages$missing_basin]

# combine
sf_basins <-
  rbind(sf_basins_g2_merge, sf_basins_g2_more, sf_basins_nhd_merge, sf_basins_nldi_merge)

# test
ggplot(sf_basins[sample(length(sf_basins$GAGE_ID), 200), ]) + geom_sf(aes(color = source))

## save output
sf_gages %>% 
  subset(!missing_basin) %>% 
  dplyr::select(-missing_basin, -state_cd) %>% 
  sf::st_transform(crs = sf::st_crs(sf_basins)) %>% 
  sf::st_write(file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_locations.gpkg"),
               delete_dsn = T,
               delete_layer = T)

sf_basins %>% 
  sf::st_write(file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_basins.gpkg"),
               delete_dsn = T,
               delete_layer = T)

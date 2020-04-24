## DataPrep_01_GetGages+Boundaries.R

## prep workspace
source(file.path("code", "paths+packages.R"))

#### read site locations - sites were selected and extracted by Jessi Ayers
sf_gages <- 
  file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "FromJessi", "Sites_information_trimmed.csv") %>% 
  readr::read_csv() %>% 
  # remove alaska, hawaii, puerto rico, guam
  subset(state_cd != 2 & state_cd != 15 & state_cd != 72 & state_cd != 66 & is.finite(dec_long_va)) %>% 
  sf::st_as_sf(coords = c("dec_long_va", "dec_lat_va"), crs = 4326) %>% 
  dplyr::mutate(GAGE_ID = sprintf("%08d", site_no)) %>% 
  dplyr::select(-site_no)

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
sf_gages$missing_basin <- !(sf_gages$GAGE_ID %in% 
                              c(sf_basins_g2_merge$GAGE_ID, sf_basins_nhd_merge$GAGE_ID, sf_basins_nldi_merge$GAGE_ID))
sum(sf_gages$missing_basin)
sf_gages$GAGE_ID[sf_gages$missing_basin] <- paste0("0", sf_gages$GAGE_ID[sf_gages$missing_basin])

sf_basins_g2_more <- 
  sf_basins_g2_all %>% 
  subset(GAGE_ID %in% sf_gages$GAGE_ID[sf_gages$missing_basin]) %>% 
  dplyr::mutate(source = "GAGES-II") %>% 
  dplyr::select(GAGE_ID, source, geom)

sf_gages$GAGESII[sf_gages$GAGE_ID %in% sf_basins_g2_more$GAGE_ID] <- T

# combine
sf_basins <-
  rbind(sf_basins_g2_merge, sf_basins_g2_more, sf_basins_nhd_merge, sf_basins_nldi_merge)

# any gages still missing basins?
sf_gages$missing_basin <- !(sf_gages$GAGE_ID %in% sf_basins$GAGE_ID)

# calculate area of basins
sf_basins$basin_area_km2 <- as.numeric(sf::st_area(sf_basins))/(1000*1000)  # units returned are m2
sf_gages <- dplyr::left_join(sf_gages, sf::st_drop_geometry(sf_basins[,c("GAGE_ID", "basin_area_km2")]), by = "GAGE_ID")

## trim gage sample
# remove basins smaller than 16 km2 (this = 1 PRISM grid cells) and larger than 100,000 km2
sf_gages$MeetsSizeThreshold <- sf_gages$basin_area_km2 > 16 & sf_gages$basin_area_km2 < 1e5

# remove basins with mismatch between USGS estimated drainage area and calculated drainage area of more than 10%
sf_gages$MeetsAreaDiffThreshold <- abs((sf_gages$drain_area_va*2.58998811 - sf_gages$basin_area_km2)/(sf_gages$drain_area_va*2.58998811)) < 0.2

# subset
sf_gages_final <- 
  sf_gages %>% 
  subset(MeetsSizeThreshold & MeetsAreaDiffThreshold & !missing_basin)

# test
ggplot(sf_gages_final) + geom_sf(aes(color=basin_area_km2))
ggplot(sf_basins[sample(length(sf_basins$GAGE_ID), 200), ]) + geom_sf(aes(color = source))

## save output
sf_gages_final %>% 
  dplyr::select(GAGE_ID, basin_area_km2, GAGESII, dec_coord_datum_cd) %>% 
  sf::st_transform(crs = sf::st_crs(sf_basins)) %>% 
  sf::st_write(file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_locations.gpkg"),
               delete_dsn = T,
               delete_layer = T)

sf_basins %>% 
  subset(GAGE_ID %in% sf_gages_final$GAGE_ID) %>% 
  sf::st_write(file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_basins.gpkg"),
               delete_dsn = T,
               delete_layer = T)

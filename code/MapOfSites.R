## MapOfSites.R

## prep workspace
source(file.path("code", "paths+packages.R"))

## read site locations
sf_sites <- 
  file.path(path_onedrive, "data", "Contiguous US Baseflow", "Sites_information.csv") %>% 
  readr::read_csv() %>% 
  subset(complete.cases(.)) %>%
  subset(dec_lat_va > 24.396308 & dec_lat_va < 49.384358 & dec_long_va > -124.848974 & dec_long_va < -66.885444) %>% 
  sf::st_as_sf(coords = c("dec_long_va", "dec_lat_va"), crs = 4326)

# subset to CONUS based on state_cd: https://www.census.gov/library/reference/code-lists/ansi/ansi-codes-for-states.html
sf_sites_CONUS <- 
  sf_sites %>% 
  subset(!(state_cd %in% c(2, 3, 7, 14, 15, 43, 52)))

## read in state boundaries using tigris
sf_states <- tigris::states(class = "sf")
sf_states_CONUS <- 
  sf_states %>% 
  subset(REGION %in% c("1", "2", "3", "4") & NAME != "Alaska" & NAME != "Hawaii")
  #subset(!(as.numeric(STATEFP) %in% c(2, 3, 7, 14, 15, 43, 52)))

## make map
ggplot() +
  geom_sf(data = sf_states_CONUS) +
  geom_sf(data = sf_sites, shape = 1) +
  ggsave(file.path("plots", "MapOfSites.png"),
         width = 190, height = 120, units = "mm")

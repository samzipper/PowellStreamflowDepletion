## Figure_MapOfGages.R

source(file.path("code", "paths+packages.R"))

## read in gages, selected in script DataPrep_01_...
sf_gages <- 
  file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_locations.gpkg") %>% 
  sf::st_read(stringsAsFactors = F)

# load state map
sf_states <- sf::st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))

# plot
ggplot() + 
  geom_sf(data = sf_states, fill = NA, color = col.gray) +
  geom_sf(data = sf_gages, shape = 1) +
  scale_x_continuous(name = "Longitude") +
  scale_y_continuous(name = "Latitude") +
  coord_sf() +
  theme(panel.border = element_blank()) +
  ggsave(file.path("plots", "Figure_MapOfGages.png"),
         width = 190, height = 110, units= "mm")

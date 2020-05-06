## This script it intended to extract TerraClimate monthly cilmate data averaged over each of our basins.
## It was written/run by John Hammond

# setwd("C:\\Users\\jhammond\\Desktop\\powell_terraclimate")
# geom <- st_read("gage_basins.shp")%>%
# 
# st_crs(geom)
# st_bbox(geom)

library(climateR)
library(raster)
library(ncdf4)
library(ncdf.tools)
library(stars)
library(dplyr)
library(raster)
library(sf)
library(exactextractr)
library(glue)
library(AOI)
library(rgeos)
setwd("C:\\Users\\jhammond\\Desktop\\powell_terraclimate")
AOI = aoi_get(sf::read_sf('aoi_correct.shp'))
years <- 1958:2019
setwd("C:\\Users\\jhammond\\Desktop\\powell_terraclimate\\tifs")

for(i in seq_along(years)){
  # i = 1
  pet = getTerraClim(AOI, param = c('pet'), startDate = paste(years[i],"-01-01", sep = ""), endDate = paste(years[i],"-12-31", sep = "") )
  prcp = getTerraClim(AOI, param = c('prcp'), startDate = paste(years[i],"-01-01", sep = ""), endDate = paste(years[i],"-12-31", sep = "") )
  swe = getTerraClim(AOI, param = c('swe'), startDate = paste(years[i],"-01-01", sep = ""), endDate = paste(years[i],"-12-31", sep = "") )
  tmax = getTerraClim(AOI, param = c('tmax'), startDate = paste(years[i],"-01-01", sep = ""), endDate = paste(years[i],"-12-31", sep = "") )
  tmin = getTerraClim(AOI, param = c('tmin'), startDate = paste(years[i],"-01-01", sep = ""), endDate = paste(years[i],"-12-31", sep = "") )
  
  pet1 <- pet$pet[[1]]
  pet2 <- pet$pet[[2]]
  pet3 <- pet$pet[[3]]
  pet4 <- pet$pet[[4]]
  pet5 <- pet$pet[[5]]
  pet6 <- pet$pet[[6]]
  pet7 <- pet$pet[[7]]
  pet8 <- pet$pet[[8]]
  pet9 <- pet$pet[[9]]
  pet10 <- pet$pet[[10]]
  pet11 <- pet$pet[[11]]
  pet12 <- pet$pet[[12]]
  writeRaster(pet1, paste("pet_mm_",years[i],"01.tif",sep = ""))
  writeRaster(pet2, paste("pet_mm_",years[i],"02.tif",sep = ""))
  writeRaster(pet3, paste("pet_mm_",years[i],"03.tif",sep = ""))
  writeRaster(pet4, paste("pet_mm_",years[i],"04.tif",sep = ""))
  writeRaster(pet5, paste("pet_mm_",years[i],"05.tif",sep = ""))
  writeRaster(pet6, paste("pet_mm_",years[i],"06.tif",sep = ""))
  writeRaster(pet7, paste("pet_mm_",years[i],"07.tif",sep = ""))
  writeRaster(pet8, paste("pet_mm_",years[i],"08.tif",sep = ""))
  writeRaster(pet9, paste("pet_mm_",years[i],"09.tif",sep = ""))
  writeRaster(pet10, paste("pet_mm_",years[i],"10.tif",sep = ""))
  writeRaster(pet11, paste("pet_mm_",years[i],"11.tif",sep = ""))
  writeRaster(pet12, paste("pet_mm_",years[i],"12.tif",sep = ""))
  prcp1 <- prcp$prcp[[1]]
  prcp2 <- prcp$prcp[[2]]
  prcp3 <- prcp$prcp[[3]]
  prcp4 <- prcp$prcp[[4]]
  prcp5 <- prcp$prcp[[5]]
  prcp6 <- prcp$prcp[[6]]
  prcp7 <- prcp$prcp[[7]]
  prcp8 <- prcp$prcp[[8]]
  prcp9 <- prcp$prcp[[9]]
  prcp10 <- prcp$prcp[[10]]
  prcp11 <- prcp$prcp[[11]]
  prcp12 <- prcp$prcp[[12]]
  writeRaster(prcp1, paste("prcp_mm_",years[i],"01.tif",sep = ""))
  writeRaster(prcp2, paste("prcp_mm_",years[i],"02.tif",sep = ""))
  writeRaster(prcp3, paste("prcp_mm_",years[i],"03.tif",sep = ""))
  writeRaster(prcp4, paste("prcp_mm_",years[i],"04.tif",sep = ""))
  writeRaster(prcp5, paste("prcp_mm_",years[i],"05.tif",sep = ""))
  writeRaster(prcp6, paste("prcp_mm_",years[i],"06.tif",sep = ""))
  writeRaster(prcp7, paste("prcp_mm_",years[i],"07.tif",sep = ""))
  writeRaster(prcp8, paste("prcp_mm_",years[i],"08.tif",sep = ""))
  writeRaster(prcp9, paste("prcp_mm_",years[i],"09.tif",sep = ""))
  writeRaster(prcp10, paste("prcp_mm_",years[i],"10.tif",sep = ""))
  writeRaster(prcp11, paste("prcp_mm_",years[i],"11.tif",sep = ""))
  writeRaster(prcp12, paste("prcp_mm_",years[i],"12.tif",sep = ""))
  swe1 <- swe$swe[[1]]
  swe2 <- swe$swe[[2]]
  swe3 <- swe$swe[[3]]
  swe4 <- swe$swe[[4]]
  swe5 <- swe$swe[[5]]
  swe6 <- swe$swe[[6]]
  swe7 <- swe$swe[[7]]
  swe8 <- swe$swe[[8]]
  swe9 <- swe$swe[[9]]
  swe10 <- swe$swe[[10]]
  swe11 <- swe$swe[[11]]
  swe12 <- swe$swe[[12]]
  writeRaster(swe1, paste("swe_mm_",years[i],"01.tif",sep = ""))
  writeRaster(swe2, paste("swe_mm_",years[i],"02.tif",sep = ""))
  writeRaster(swe3, paste("swe_mm_",years[i],"03.tif",sep = ""))
  writeRaster(swe4, paste("swe_mm_",years[i],"04.tif",sep = ""))
  writeRaster(swe5, paste("swe_mm_",years[i],"05.tif",sep = ""))
  writeRaster(swe6, paste("swe_mm_",years[i],"06.tif",sep = ""))
  writeRaster(swe7, paste("swe_mm_",years[i],"07.tif",sep = ""))
  writeRaster(swe8, paste("swe_mm_",years[i],"08.tif",sep = ""))
  writeRaster(swe9, paste("swe_mm_",years[i],"09.tif",sep = ""))
  writeRaster(swe10, paste("swe_mm_",years[i],"10.tif",sep = ""))
  writeRaster(swe11, paste("swe_mm_",years[i],"11.tif",sep = ""))
  writeRaster(swe12, paste("swe_mm_",years[i],"12.tif",sep = ""))
  tmax1 <- tmax$tmax[[1]]
  tmax2 <- tmax$tmax[[2]]
  tmax3 <- tmax$tmax[[3]]
  tmax4 <- tmax$tmax[[4]]
  tmax5 <- tmax$tmax[[5]]
  tmax6 <- tmax$tmax[[6]]
  tmax7 <- tmax$tmax[[7]]
  tmax8 <- tmax$tmax[[8]]
  tmax9 <- tmax$tmax[[9]]
  tmax10 <- tmax$tmax[[10]]
  tmax11 <- tmax$tmax[[11]]
  tmax12 <- tmax$tmax[[12]]
  writeRaster(tmax1, paste("tmax_C_",years[i],"01.tif",sep = ""))
  writeRaster(tmax2, paste("tmax_C_",years[i],"02.tif",sep = ""))
  writeRaster(tmax3, paste("tmax_C_",years[i],"03.tif",sep = ""))
  writeRaster(tmax4, paste("tmax_C_",years[i],"04.tif",sep = ""))
  writeRaster(tmax5, paste("tmax_C_",years[i],"05.tif",sep = ""))
  writeRaster(tmax6, paste("tmax_C_",years[i],"06.tif",sep = ""))
  writeRaster(tmax7, paste("tmax_C_",years[i],"07.tif",sep = ""))
  writeRaster(tmax8, paste("tmax_C_",years[i],"08.tif",sep = ""))
  writeRaster(tmax9, paste("tmax_C_",years[i],"09.tif",sep = ""))
  writeRaster(tmax10, paste("tmax_C_",years[i],"10.tif",sep = ""))
  writeRaster(tmax11, paste("tmax_C_",years[i],"11.tif",sep = ""))
  writeRaster(tmax12, paste("tmax_C_",years[i],"12.tif",sep = ""))
  tmin1 <- tmin$tmin[[1]]
  tmin2 <- tmin$tmin[[2]]
  tmin3 <- tmin$tmin[[3]]
  tmin4 <- tmin$tmin[[4]]
  tmin5 <- tmin$tmin[[5]]
  tmin6 <- tmin$tmin[[6]]
  tmin7 <- tmin$tmin[[7]]
  tmin8 <- tmin$tmin[[8]]
  tmin9 <- tmin$tmin[[9]]
  tmin10 <- tmin$tmin[[10]]
  tmin11 <- tmin$tmin[[11]]
  tmin12 <- tmin$tmin[[12]]
  writeRaster(tmin1, paste("tmin_C_",years[i],"01.tif",sep = ""))
  writeRaster(tmin2, paste("tmin_C_",years[i],"02.tif",sep = ""))
  writeRaster(tmin3, paste("tmin_C_",years[i],"03.tif",sep = ""))
  writeRaster(tmin4, paste("tmin_C_",years[i],"04.tif",sep = ""))
  writeRaster(tmin5, paste("tmin_C_",years[i],"05.tif",sep = ""))
  writeRaster(tmin6, paste("tmin_C_",years[i],"06.tif",sep = ""))
  writeRaster(tmin7, paste("tmin_C_",years[i],"07.tif",sep = ""))
  writeRaster(tmin8, paste("tmin_C_",years[i],"08.tif",sep = ""))
  writeRaster(tmin9, paste("tmin_C_",years[i],"09.tif",sep = ""))
  writeRaster(tmin10, paste("tmin_C_",years[i],"10.tif",sep = ""))
  writeRaster(tmin11, paste("tmin_C_",years[i],"11.tif",sep = ""))
  writeRaster(tmin12, paste("tmin_C_",years[i],"12.tif",sep = ""))
  
  
  closeAllNcfiles()
  closeAllConnections()
  
  # need to close all connections...
  
}


# change line below to where watersheds shapefile is

# i = 1067
setwd("C:\\Users\\jhammond\\Desktop\\powell_terraclimate\\tifs")

geom <- st_read("C:\\Users\\jhammond\\Desktop\\powell_terraclimate\\gage_basins.shp") %>% st_transform("+proj=longlat +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs")

files <- list.files(pattern = ".tif")
files <- files[1067:3660]
for(i in seq_along(files)){
  # i = 1
  current <- raster(files[i])
  extract <- exact_extract(current, geom, weighted.mean, na.rm=TRUE)
  extractdf <- as.data.frame(extract)
  colnames(extractdf) <- files[i]
  #change line below to geom$ whatever watershed ID column name is
  row.names(extractdf) <- geom$GAGE_ID
  write.csv(extractdf, paste(files[i], ".csv", sep = ""))
}



#######################################################################
#######################################################################
#######################################################################
#######################################################################

setwd("C:\\Users\\jhammond\\Desktop\\powell_terraclimate\\csvs")

tmin_files <- list.files(pattern = "tmin_C")
tmax_files <- list.files(pattern = "tmax_C")
pet_files <- list.files(pattern = "pet")
prcp_files <- list.files(pattern = "prcp")
swe_files <- list.files(pattern = "swe")


tmin_data <- do.call(cbind, lapply(tmin_files, read.csv))
tmax_data <- do.call(cbind, lapply(tmax_files, read.csv))
pet_data <- do.call(cbind, lapply(pet_files, read.csv))
prcp_data <- do.call(cbind, lapply(prcp_files, read.csv))
swe_data <- do.call(cbind, lapply(swe_files, read.csv))

# change 1464 to number of columns of combined data
tmin_data <- tmin_data[,c(1,seq(2,1464,2))]
tmax_data <- tmax_data[,c(1,seq(2,1464,2))]
swe_data <- swe_data[,c(1,seq(2,1464,2))]
pet_data <- pet_data[,c(1,seq(2,1464,2))]
prcp_data <- prcp_data[,c(1,seq(2,1464,2))]

setwd("C:\\Users\\jhammond\\Desktop\\powell_terraclimate\\")

write.csv(tmin_data, "powell_baseflow_watersheds_terraclimate_tmin_C_043020.csv")
write.csv(tmax_data, "powell_baseflow_watersheds_terraclimate_tax_C_043020.csv")
write.csv(swe_data, "powell_baseflow_watersheds_terraclimate_swe_mm_043020.csv")
write.csv(pet_data, "powell_baseflow_watersheds_terraclimate_pet_mm_043020.csv")
write.csv(prcp_data, "powell_baseflow_watersheds_terraclimate_prcp_mm_043020.csv")

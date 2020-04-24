## DataPrep_02_CollectStreamflowData.R

source(file.path("code", "paths+packages.R"))

## read in gages, selected in script DataPrep_01_...
sf_gages <- 
  file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "gage_locations.gpkg") %>% 
  sf::st_read(stringsAsFactors = F) %>% 
  dplyr::mutate(HasData = T)

## make empty data frame
# all years/months
df_year_mo <- 
  tibble::tibble(Year = rep(seq(1900, 2019), each = 12),
                 Month = rep(seq(1, 12), times = 120))

## loop through gages
for (i in 1:length(sf_gages$GAGE_ID)){
  g <- sf_gages$GAGE_ID[i]
  
  # path to streamflow data
  g_path <- 
    file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", 
              "FromJessi", "Daily_Discharge_Baseflow_Data", 
              paste0("Daily_SF_BF_USA_", as.numeric(g), ".csv"))
  
  # check if file exists
  if (file.exists(g_path)){
    # read in data frame
    g_df <- 
      readr::read_csv(g_path, col_types = cols()) %>% 
      dplyr::mutate(Year = lubridate::year(Date),
                    Month = lubridate::month(Date))
    
    # summarize to monthly
    g_monthly <-
      g_df %>% 
      dplyr::group_by(Year, Month) %>% 
      dplyr::summarize(Q_cms_mean = mean(Streamflow)*cfs.to.cms,
                       B_cms_1par = mean(One_Par)*cfs.to.cms,
                       B_cms_2par = mean(Eckhardt)*cfs.to.cms) %>% 
      dplyr::ungroup()
    
    if (min(g_monthly$Year) < min(df_year_mo$Year)) stop(paste0("first year too early, ", min(g_monthly$Year)))
    
    
    # group
    if (i == 1){
      df_Q <-
        dplyr::left_join(df_year_mo, g_monthly[,c("Year", "Month", "Q_cms_mean")], by = c("Year", "Month")) %>% 
        dplyr::rename(!!paste0("USGS_", g) := Q_cms_mean)
      df_B_1par <-
        dplyr::left_join(df_year_mo, g_monthly[,c("Year", "Month", "B_cms_1par")], by = c("Year", "Month")) %>% 
        dplyr::rename(!!paste0("USGS_", g) := B_cms_1par)
      df_B_2par <-
        dplyr::left_join(df_year_mo, g_monthly[,c("Year", "Month", "B_cms_2par")], by = c("Year", "Month")) %>% 
        dplyr::rename(!!paste0("USGS_", g) := B_cms_2par)
    } else {
      df_Q <-
        dplyr::left_join(df_Q, g_monthly[,c("Year", "Month", "Q_cms_mean")], by = c("Year", "Month")) %>% 
        dplyr::rename(!!paste0("USGS_", g) := Q_cms_mean)
      df_B_1par <-
        dplyr::left_join(df_B_1par, g_monthly[,c("Year", "Month", "B_cms_1par")], by = c("Year", "Month")) %>% 
        dplyr::rename(!!paste0("USGS_", g) := B_cms_1par)
      df_B_2par <-
        dplyr::left_join(df_B_2par, g_monthly[,c("Year", "Month", "B_cms_2par")], by = c("Year", "Month")) %>% 
        dplyr::rename(!!paste0("USGS_", g) := B_cms_2par)
    }
  } else {
    sf_gages$HasData[i] <- F
  }
  
  print(paste0(i, " of ", length(sf_gages$GAGE_ID), " complete"))
  
}

row1 <- as.numeric(df_Q[1, 3:3863])
sum(is.finite(row1))

## save
readr::write_csv(df_Q, file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "Streamflow_Monthly_AllGages.csv"))
readr::write_csv(df_B_1par, file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "Baseflow-1par_Monthly_AllGages.csv"))
readr::write_csv(df_B_2par, file.path(path_onedrive, "data", "USGS_Gages+Basins+Streamflow", "Baseflow-2par_Monthly_AllGages.csv"))

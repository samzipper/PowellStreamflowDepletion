## Example_KS-ArkansasRiver.R

## prep workspace
source(file.path("code", "paths+packages.R"))

## grab data from Arkansas River
USGS_id <- "07139500" # Arkansas River at Dodge City
df_site <- dataRetrieval::readNWISdv(USGS_id, "00060",
                                     "1950-01-01","2018-12-31") %>% 
  dplyr::select(site_no, Date, X_00060_00003) %>% 
  magrittr::set_colnames(c("gageid", "Date", "discharge_cfs")) %>% 
  dplyr::mutate(discharge_cms = discharge_cfs*(0.3048^3),
                year = lubridate::year(Date),
                month = lubridate::month(Date))

## average to monthly
df_mo <- df_site %>% 
  dplyr::group_by(year, month) %>% 
  dplyr::summarize(Date_mid = mean(Date),
                   discharge_cms_mean = mean(discharge_cms))

## plot
p_monthly_line <- 
  ggplot(df_mo, aes(x = Date_mid, y = discharge_cms_mean)) +
  geom_hline(yintercept = 0, color = col.gray) +
  geom_line() +
  scale_x_date(name = "Date", expand = c(0,0)) +
  scale_y_continuous(name = "Mean Monthly Discharge [cms]")

p_monthly_scatter <- 
  ggplot(df_mo, aes(x = year, y = discharge_cms_mean)) +
  geom_hline(yintercept = 0, color = col.gray) +
  geom_point() +
  facet_wrap(~month, scales = "free",
             labeller = as_labeller(c("1" = "Jan", "2" = "Feb", "3" = "Mar", "4" = "Apr", "5" = "May", "6" = "Jun",
                                      "7" = "Jul", "8" = "Aug", "9" = "Sep", "10" = "Oct", "11" = "Nov", "12" = "Dec"))) +
  scale_x_continuous(name = "Year", expand = c(0,0),
                     breaks = seq(1960, 2000, 20)) +
  scale_y_continuous(name = "Mean Monthly Discharge [cms]")

cowplot::plot_grid(p_monthly_line, p_monthly_scatter,
                   ncol = 1, nrow = 2) %>% 
  cowplot::save_plot(filename = file.path("results", "Example_KS-ArkansasRiver.png"),
                     plot = .,
                     nrow = 2,
                     base_height = 4)

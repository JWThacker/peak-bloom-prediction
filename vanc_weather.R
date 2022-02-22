library(rnoaa)
library(readr)
library(lubridate)
library(dplyr)

setwd('~/peak-bloom-prediction')
vanc <- read_csv('vancouver.csv', col_names=T)
stationid = "CA001108395"
weather.vanc.dat <- meteo_tidy_ghcnd(stationid = stationid, var = c('TMAX', 'TMIN', 'PRCP'), 
                                date_min = "1950-01-01", date_max = "2022-01-31") %>%
  mutate(tmax=tmax/10, tmin=tmin/10)

weather.vanc.dat <- weather.vanc.dat %>% mutate(quarter=quarter(date),
                            year=year(date))

weather.vanc.dat <- weather.vanc.dat %>%
  filter(!(is.na(tmax) | is.na(tmin) | is.na(prcp))) %>%
  group_by(year, quarter) %>%
  summarise(avg_max_temp=mean(tmax), avg_min_temp=mean(tmin),
            avg_prcp=mean(prcp))

vanc.weather <- vanc %>% mutate(quarter=quarter(clean_date),
                year=year(clean_date)) %>%
  left_join(weather.vanc.dat, by=c('quarter' = 'quarter',
                                  'year' = 'year'))
write_csv(vanc.weather, 'vancouver_w_weather.csv', col_names=T)

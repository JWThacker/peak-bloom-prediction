library(rnoaa)

stationid = "USC00186350"
weather.dat <- meteo_tidy_ghcnd(stationid = stationid, var = c('TMAX', 'TMIN'), 
                date_min = "1950-01-01", date_max = "2022-01-31") %>%
                 mutate(tmax=tmax/10, tmin=tmin/10)

ca <- function(tmax, tmin, tc) {
  if (0 <= tc & tc <= tmin & tmin <= tmax) {
    return((tmax + tmin) / 2 - tc)
  }
  else if (0 <= tmin & tmin <= tc & tc < tmax) {
    return((tmax - tc) / 2)
  }
  else if (0 <= tmin & tmin <= tmax & tmax <= tc) {
    return(0)
  }
  else if (tmin < 0 & 0 < tmax & tmax <= tc) {
    return(0)
  }
  else if (tmin < 0 & 0 < tc & tc < tmax) {
    return((tmax - tc) / 2)
  }
  
  }

cd <- function(tmax, tmin, tc) {
  tM <- (tmax + tmin) / 2
  if (0 <= tc & tc <= tmin & tmin <= tmax) {
    return(0)
  }
  else if (0 <= tmin & tmin <= tc & tc < tmax) {
    return(-( (tM - tmin) - (tmax - tc) / 2) )
  }
  else if (0 <= tmin & tmin <= tmax & tmax <= tc) {
    return( -(tM - tmin) )
  }
  else if (tmin < 0 & 0 < tmax & tmax <= tc) {
    return( -( (tmax / (tmax - tmin)) * tmax / 2 ) )
  }
  else if (tmin < 0 & 0 < tc & tc < tmax) {
    return( -( ((tmax / (tmax - tmin)) * tmax / 2) - (tmax - tc) / 2 ) )
  }
}

test.df <- read_csv('liestal.csv')

cd.model <- function(df) {
  
}

weather.dat <- weather.dat %>%  mutate(growdd=gdd(tmax, tmin))

weather.dat <- weather.dat %>% group_by(year(date)) %>% mutate(cumgdd=cumsum(growdd))

for (date in df$bloom_date) {
  print(as.character(date))
}

files <- list(file1='data/kyoto.csv',
              file2='data/liestal.csv',
              file3='data/washingtondc.csv')

test <- read_csv('data/kyoto.csv', col_names=T)

df <- data.frame(location=character(),
                 lat=numeric(),
                 long=numeric(),
                 alt=numeric(),
                 year=numeric(),
                 bloom_date=Date(),
                 bloom_doy=numeric())

for (file in files) {
  print(file)
  df <- df %>% bind_rows(read_csv(file, col_names=T))
}

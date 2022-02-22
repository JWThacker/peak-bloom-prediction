library(rvest)
library(stringr)
library(dplyr)
library(lubridate)
library(readr)
library(xml2)

# Get structure of html and output to file
webpage.1 <- 'https://forums.botanicalgarden.ubc.ca/threads/kerrisdale.36008/page-1'
webpage.1 <- read_html(webpage.1)
xml_structure(webpage.1, file='output.txt')

# define root URL and df that will hold scraped forum postings
url.root <- 'https://forums.botanicalgarden.ubc.ca/threads/kerrisdale.36008/page-'
text.df <- data.frame(page_num=numeric(),
                      text=character(),
                      date=character())

# For each webpage (there are seven) scrape posts, adding the post text, date posted
# and page number
for (i in 1:7) {
  url <- paste(url.root, i, sep='')
  print(url)
  webpage <- read_html(url)
  text <- webpage %>% html_nodes('.messageText.SelectQuoteContainer.ugc.baseHtml') %>%
    html_text() %>%
    str_replace_all(pattern=c('\\t|\\n' = '')) %>% str_to_lower()
  dates <- webpage %>% html_nodes('div.messageMeta.ToggleTriggerAnchor') %>%
    html_nodes('span.DateTime') %>%
    html_text()
  text.df <- text.df %>% bind_rows(data.frame(page_num=i,
                                              text=text,
                                              date=dates))
}

# convert dates from posts to clean dates for future use
text.df$clean_date <- mdy(text.df$date)

# number each post
text.df <- text.df %>% mutate(post_ID = row_number()) %>%
  relocate(post_ID, .before=page_num)

# filter posts that for certain trees
akebono.mentions <- text.df %>% filter(str_detect(text.df$text, 'akebono') | str_detect(text.df$text, 'prunus') |
                                         str_detect(text.df$text, 'yoshino') | str_detect(text.df$text, 'cherry') |
                                         str_detect(text.df$text, 'accolade'))

# find the day of year of blooms
text.df$bloom_doy <- yday(text.df$clean_date)

write_csv(text.df, 'vancouver.csv', col_names=T)



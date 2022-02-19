library(rvest)
library(xml2)

xml_structure(webpage, file='output.txt')
url.root <- 'https://forums.botanicalgarden.ubc.ca/threads/kerrisdale.36008/page-'
text.df <- data.frame(page_num=numeric(),
                      text=character(),
                      date=character())
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

text.df$clean_date <- mdy(text.df$date)

text.df <- text.df %>% mutate(post_ID = row_number()) %>%
  relocate(post_ID, .before=page_num)

akebono.mentions <- text.df %>% filter(str_detect(text.df$text, 'akebono') | str_detect(text.df$text, 'prunus') |
                                         str_detect(text.df$text, 'yoshino') | str_detect(text.df$text, 'cherry') |
                                         str_detect(text.df$text, 'accolade'))

akebono.mentions$bloom_doy <- yday(akebono.mentions$clean_date)

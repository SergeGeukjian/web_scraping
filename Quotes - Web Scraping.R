library(rvest)
library(tibble)
library(dplyr)
library(stringr)



url <- 'https://quotes.toscrape.com/'

# Reading the html file-----------------
page <- read_html(url)
page

# Retrieving the contents of the html-------------
quotes <- page %>%
  html_nodes("div.quote")

## Getting the quotes------------
quote <- quotes %>%
  html_nodes("span.text")%>%
  html_text()

## Getting the authors of the quotes------------
author <- quotes %>%
  html_nodes("small.author")%>%
  html_text()

## Getting the link of author-----------
author_link <- quotes %>%
  html_nodes("span small.author + a") %>% 
  html_attr("href")

author_link <- paste0("https://quotes.toscrape.com/",author_link)


## Getting the tags of each quote so we can put them on different pages on R shiny-----
tags <- quotes %>%
  html_nodes("div.tags")%>%
  html_text()

### Add manipulation here that puts the tags as a list. That way you can later filter with what is in the list as separate pages on Shiny


# Putting the extracted data in a structured table---------
all_quotes <- data.frame(quote, author, author_link, tags)

## Naming of columns--------
names(all_quotes) <- c("quote", "author", "author_link", "tags")

all_quotes$tags <- gsub("\\s+", " ", all_quotes$tags)
all_quotes$tags <- gsub("Tags:", " ", all_quotes$tags)
all_quotes

#write.csv(all_quotes, "C:/Users/s.geukjian/Desktop/all_quotes.csv")

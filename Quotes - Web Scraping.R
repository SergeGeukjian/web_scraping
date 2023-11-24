library(rvest)
library(tibble)
library(dplyr)
library(stringr)


url <- 'https://quotes.toscrape.com/'
base_url <- 'https://quotes.toscrape.com'
page_num <- 1
quotes_list <- list()

while (TRUE) {
  # Reading the html file
  page <- read_html(url)
  
  # Retrieving the contents of the html
  quotes <- page %>% html_nodes("div.quote")
  
  if (length(quotes) == 0) {
    break  # No more pages
  }
  
  # Extracting information from the current page
  quote <- quotes %>% html_nodes("span.text") %>% html_text()
  author <- quotes %>% html_nodes("small.author") %>% html_text()
  author_link <- paste0(base_url, quotes %>% html_nodes("span small.author + a") %>% html_attr("href"))
  tags <- quotes %>% html_nodes("div.tags") %>% html_text()
  
  # Putting the extracted data in a structured table
  current_quotes <- data.frame(quote, author, author_link, tags, stringsAsFactors = FALSE)
  
  # Combine quotes from all pages
  quotes_list <- c(quotes_list, list(current_quotes))
  
  # Check for the next page
  next_page <- page_num + 1
  url <- paste0(base_url, '/page/', next_page, '/')
  page_num <- next_page
}

# Combine all quotes into one data frame
all_quotes <- do.call(rbind, quotes_list)

# Clean up the tags column
all_quotes$tags <- gsub("\\s+", " ", all_quotes$tags)
all_quotes$tags <- gsub("Tags:", "", all_quotes$tags)

# Print the resulting data frame
print(all_quotes)



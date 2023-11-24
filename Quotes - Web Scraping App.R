# Loading Libraries---------------
library(rvest)
library(tibble)
library(dplyr)
library(stringr)
library(shiny)
library(plotly)
library(gridlayout)
library(bslib) 
library(ggplot2)
library(tidyverse)
library(readr)
library(skimr)
library(lubridate)
library(writexl)
library(stringi)
library(stringr)
library(data.table)
library(MMWRweek)
library(kableExtra)
library(ggthemes)
library(rlang)
library(cli)
library(parsnip)
library(fastmap)
library(parsnip)
library(rsample)
library(workflows) 
library(resample)
library(tune)
library(ranger)
library(shinythemes)
library(shinyWidgets)
library(CGPfunctions)
library(devtools)
library(DT)

# Data scraping and manipulation -----------------------
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

# Changing the authors link columns to hyperlinks
all_quotes$author_link <- sprintf('<a href="%s">%s</a>', all_quotes$author_link, all_quotes$author)

# UI ----------------------------------
ui <- grid_page(
  
  layout = c(
    "header  header",
    "sidebar area2 "
  ),
  row_sizes = c(
    "100px",
    "1fr"
  ),
  col_sizes = c(
    "250px",
    "1fr"
  ),
  gap_size = "1rem",
  
  # Header---------------------------------
  
  # Adding the details to the header card
  grid_card_text(
    area = "header",
    icon = "title.png",
    img_height = "100px",
    alignment = "start",
    is_title = TRUE
  ), 
  
  grid_card(
    area = "sidebar",
    card_body_fill(
      textInput("search", "Search in Quote:", ""),
      dateRangeInput("DOS", "Date Range (DOS):"),
      actionButton("submitbudget", "Submit")
    )
  ),
  
  grid_card(
    area = "area2",
    card_body_fill(
      tabsetPanel(
        tabPanel(
          title = "Inspirational Quotes",
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = 12,
          height = 400,
          DTOutput("quotes_table_output")
        )#,
        #tabPanel(
        #  title = "Life Quotes"
        #),
        #tabPanel(
        #  title = "Humor Quotes"
        ))#)
    )
  )



# Server ----------------------------------
server <- function(input, output, session) {
  # Assign temporary IDs to quotes
  all_quotes$id <- seq_len(nrow(all_quotes))
  
  # Randomly select 10 quotes
  random_quotes <- reactive({
    set.seed(123)  # Set seed for reproducibility
    sample_n(all_quotes, 10)
  })
  
  ## # Render the divs
  ## output$quotes_table_output <- renderDT({
  ##   datatable(random_quotes(), options = list(pageLength = 5))
  ## })
  
  # Render the table
  output$quotes_table_output <- renderDataTable({
    # Format the Author_Link column as HTML links
    df$Author_Link <- sprintf('<a href="%s">%s</a>', df$Author_Link, df$Author)
    
    # Return the modified data frame
    df
  }, escape = FALSE)
  
  # Render the modals
  observe({
    for (i in seq_len(nrow(random_quotes()))) {
      observeEvent(input[[paste0("view_quote_", random_quotes()[i, "id"])]], {
        showModal(modalDialog(
          title = random_quotes()[i, "author"],
          div(
            tags$p(random_quotes()[i, "quote"]),
            tags$p("Tags: ", random_quotes()[i, "tags"]),
            tags$a(href = random_quotes()[i, "author_link"], "Author Page", target = "_blank")
          ),
          easyClose = TRUE
        ))
      })
    }
  })
}

shinyApp(ui, server)
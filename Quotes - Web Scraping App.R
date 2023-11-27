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

## # Changing the authors link columns to hyperlinks
## all_quotes$author_link <- sprintf('<a href="%s">%s</a>', all_quotes$author_link, all_quotes$author)

#write_csv(all_quotes, "C:\\Users\\s.geukjian\\Desktop\\all_quotes.csv")

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
  
  # Sidebar -----------------------------
  grid_card(
    area = "sidebar",
    card_body_fill(
      textInput("search", "Search in Quote:", ""),
      dateRangeInput("DOS", "Date Range (DOS):"),
      pickerInput(
        "source",
        "Source: ",
        choices = c("quotes.toscrape.com", "Twitter"), 
        multiple = TRUE,
        selected = "quotes.toscrape.com",
        width = "100%"
      ),
      actionButton("submitbudget", "Submit")
    )
  ),
  # Main body -------------------------------
  grid_card(
    area = "area2",
    card_body_fill(
      tabsetPanel(
        ## First Tab - Inspirational Quotes --------------
        tabPanel(
          title = "Inspirational Quotes",
          grid_container(
            layout = c(
              "quote1",
              "quote2",
              "quote3",
              "quote4",
              "quote5"
            ),
            row_sizes = c(
              "1fr",
              "1fr",
              "1fr",
              "1fr",
              "1fr"
            ),
            col_sizes = c(
              "1fr"
            ),
            gap_size = "5px",
            grid_card(
              area = "quote1",
              HTML("<em style='font-size: 16px;' font-family: sans-serif;>
                   There are only two ways to live your life. One is as though nothing is a miracle. The other is as though everything is a miracle.
                   </em>"),
              HTML("<div class='tags'>
            Tags:
            <meta class='keywords' itemprop='keywords' content='inspirational,life,live,miracle,miracles'> 
            
            <a class='tag'  href='https://quotes.toscrape.com/inspirational/page/1/'>inspirational</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/life/page/1/'>life</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/live/page/1/'>live</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/miracle/page/1/'>miracle</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/miracles/page/1/'>miracles</a>
            
        </div>"),
              HTML("<span style='font-size: 16px;' font-family: sans-serif;>
                          by 
                       <small style='font-size: 16px;' font-family: sans-serif;> Albert Einstein </small>
                       <a href = 'https://quotes.toscrape.com/author/Albert-Einstein'>(about)</a>
                       </span>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: quotes.toscrape.com</span>")
            ),
            grid_card(
              area = "quote2",
              HTML("<em style='font-size: 16px;' font-family: sans-serif;>
              I have not failed. I've just found 10,000 ways that won't work.
                   </em>"),
              HTML("<div class='tags'>
            Tags:
            <meta class='keywords' itemprop='keywords' content='be-yourself,inspirational'> 
            
            <a class='tag'  href='https://quotes.toscrape.com/be-yourself/page/1/'>be-yourself</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/inspirational/page/1/'>inspirational</a>
            
        </div>"),
              HTML("<span style='font-size: 16px;' font-family: sans-serif;>
                          by 
                       <small style='font-size: 16px;' font-family: sans-serif;> Thomas A. Edison </small>
                       <a href = 'https://quotes.toscrape.com/author/Thomas-A-Edison'>(about)</a>
                       </span>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: quotes.toscrape.com</span>")
            ),
            grid_card(
              area = "quote3",
              HTML("<em style='font-size: 16px;' font-family: sans-serif;>
                   Imperfection is beauty, madness is genius and it's better to be absolutely ridiculous than absolutely boring.
                   </em>"),
              HTML("<div class='tags'>
            Tags:
            <meta class='keywords' itemprop='keywords' content='edison,failure,inspirational,paraphrased'> 
            
            <a class='tag'  href='https://quotes.toscrape.com/edison/page/1/'>edison</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/failure/page/1/'>failure</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/inspirational/page/1/'>inspirational</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/paraphrased/page/1/'>paraphrased</a>
            
        </div>"),
              HTML("<span style='font-size: 16px;' font-family: sans-serif;>
                          by 
                       <small style='font-size: 16px;' font-family: sans-serif;> Marilyn Monroe </small>
                       <a href = 'https://quotes.toscrape.com/author/Marilyn-Monroe'>(about)</a>
                       </span>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: quotes.toscrape.com</span>")
            ),
            grid_card(
              area = "quote4",
              HTML("<em style='font-size: 16px;' font-family: sans-serif;>
                   This life is what you make it. No matter what, you're going to mess up sometimes, it's a universal truth. But the good part is you get to decide how you're going to mess it up. Girls will be your friends - they'll act like it anyway. But just remember, some come, some go. The ones that stay with you through everything - they're your true best friends. Don't let go of them. Also remember, sisters make the best friends in the world. As for lovers, well, they'll come and go too. And baby, I hate to say it, most of them - actually pretty much all of them are going to break your heart, but you can't give up because if you give up, you'll never find your soulmate. You'll never find that half who makes you whole and that goes for everything. Just because you fail once, doesn't mean you're gonna fail at everything. Keep trying, hold on, and always, always, always believe in yourself, because if you don't, then who will, sweetie? So keep your head high, keep your chin up, and most importantly, keep smiling, because life's a beautiful thing and there's so much to smile about.
                   </em>"),
              HTML("<div class='tags'>
            Tags:
            <meta class='keywords' itemprop='keywords' content='friends,heartbreak,inspirational,life,love,sisters'> 
            
            <a class='tag'  href='https://quotes.toscrape.com/friends/page/1/'>friends</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/heartbreak/page/1/'>heartbreak</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/inspirational/page/1/'>inspirational</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/life/page/1/'>life</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/love/page/1/'>love</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/sisters/page/1/'>sisters</a>
            
        </div>"),
              HTML("<span style='font-size: 16px;' font-family: sans-serif;>
                          by 
                       <small style='font-size: 16px;' font-family: sans-serif;> Marilyn Monroe </small>
                       <a href = 'https://quotes.toscrape.com/author/Marilyn-Monroe'>(about)</a>
                       </span>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: quotes.toscrape.com</span>")
            ),
            grid_card(
              area = "quote5",
              HTML("<em style='font-size: 16px;' font-family: sans-serif;>
                   The opposite of love is not hate, it's indifference. The opposite of art is not ugliness, it's indifference. The opposite of faith is not heresy, it's indifference. And the opposite of life is not death, it's indifference.
                   </em>"),
              HTML("<div class='tags'>
            Tags:
            <meta class='keywords' itemprop='keywords' content='activism apathy hate indifference inspirational love opposite philosophy'> 
            
            <a class='tag'  href='https://quotes.toscrape.com/activism/page/1/'>activism</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/apathy/page/1/'>apathy</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/hate/page/1/'>hate</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/indifference/page/1/'>indifference</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/inspirational/page/1/'>inspirational</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/love/page/1/'>love</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/opposite/page/1/'>opposite</a>
            
            <a class='tag' href='https://quotes.toscrape.com/tag/philosophy/page/1/'>philosophy</a>
            
        </div>"),
              HTML("<span style='font-size: 16px;' font-family: sans-serif;>
                          by 
                       <small style='font-size: 16px;' font-family: sans-serif;> Elie Wiesel </small>
                       <a href = 'https://quotes.toscrape.com/author/Elie-Wiesel'>(about)</a>
                       </span>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: quotes.toscrape.com</span>")
            )
          )
        ),
        ## Second Tab - Life Quotes --------------
        tabPanel(
          title = "Life Quotes"
        ),
        ## Third Tab - Humor Quotes --------------
        tabPanel(
          title = "Humor Quotes"
        ),
        ## Fourth Tab - Twitter Example --------------
        tabPanel(
          title = "Twitter Demo",
          grid_container(
            layout = c(
              "tweet1",
              "tweet2",
              "tweet3"
            ),
            row_sizes = c(
              "1.8fr",
              "1.3fr",
              "2.3fr"
            ),
            col_sizes = c(
              "1fr"
            ),
            gap_size = "16px",
            grid_card(
              area = "tweet1",
              HTML("<div>
                   <span style='text-overflow: unset;'><strong>Guy In A Cube</strong></span>
                   <span style='text-overflow: unset; font-size: 10px; color: #5f6368;'>@GuyInACube</span>
                   <span style='text-overflow: unset; font-size: 10px; color: #5f6368;'> . Jun 8</span>
                   </div>"),
              
              HTML("<div>
                   <span>We look deeper at</span>
                   <span style='color: rgb(29, 155, 240);'>#DataActivator</span>
                   <span>in</span>
                   <span style='color: rgb(29, 155, 240);'>#MicrosoftFabric</span>
                   <span>with</span>
                   <span style='color: rgb(29, 155, 240);'>@Will_MI77</span>
                   <span>He shows us how to work with real time data and also how you can leverage</span>
                   <span style='color: rgb(29, 155, 240);'>#PowerAutomate</span>
                   <span>from</span>
                   <span style='color: rgb(29, 155, 240);'>#PowerPlatform</span>
                   <span>to take action</span>
                   <br></br>
                   <span>Watch on YouTube - </span>
                   <a style='color: rgb(29, 155, 240);' href='https://t.co/vplH801Shx'>https://t.co/vplH801Shx</a>
                   <br></br>
                   <img src='tweet1.jpg' style='width:225px;height:129px;'>
                   <br></br>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: Twitter</span>
                   </div>")
              ),
            grid_card(
              area = "tweet2",
              HTML("<div>
                   <span style='text-overflow: unset;'><strong>Nellie Gustafsson</strong></span>
                   <span style='text-overflow: unset; font-size: 10px; color: #5f6368;'>@Nelliegson</span>
                   <span style='text-overflow: unset; font-size: 10px; color: #5f6368;'> . Nov 15</span>
                   </div>"),
              
              HTML("<div>
                   <span>Don't miss this video full of</span>
                   <span style='color: rgb(29, 155, 240);'>#MicrosoftFabric</span>
                   <span>demos of data mirroring, Copilot updates and much more!</span>
                   <br></br>
                   <a href = 'https://youtu.be/fz5fBgww0rE'><img src='tweet2.png' style='width:404px;height:97px;'></a>
                   <br></br>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: Twitter</span>
                   </div>")
            ),
            grid_card(
              area = "tweet3",
              HTML("<div>
                   <span style='text-overflow: unset;'><strong>Alex Power|s|</strong></span>
                   <span style='text-overflow: unset; font-size: 10px; color: #5f6368;'>@notaboutthecell</span>
                   <span style='text-overflow: unset; font-size: 10px; color: #5f6368;'> . May 2, 2020</span>
                   </div>"),
              HTML("<div>
                   <span>30 Days. 30</span>
                   <span style='color: rgb(29, 155, 240);'>#PowerQuery</span>
                   <span>Query Folding Challenges. Subscribe to stay up to date, share your own solutions using the hashtag</span>
                   <span style='color: rgb(29, 155, 240);'>#30DQUERY</span>
                   <br></br>
                   <span>YouTube:</span>
                   <a style='color: rgb(29, 155, 240);' href='https://www.youtube.com/playlist?list=PLKW7XPyNDgRCorKNS1bfZoAO3YSIAVz3N'>https://www.youtube.com/playlist?list=PLKW7XPyNDgRCorKNS1bfZoAO3YSIAVz3N</a>
                   <br></br>
                   <span>Note: There's no one right answer, but there is a wrong one, don't break the fold!</span>
                   <br></br>
                   <span style='color: rgb(29, 155, 240);'>#PowerBi #Excel</span>
                   <br></br>
                   <img src='tweet3.png' style='width:340px;height:192px;'>
                   <br></br>
                   <span style='text-overflow: unset; font-size: 10px; color: rgb(29, 155, 240);'>Source: Twitter</span>
                   </div>")
            )
          )
        )))
    )
  )



# Server ----------------------------------
server <- function(input, output, session) {
  
}

shinyApp(ui, server)
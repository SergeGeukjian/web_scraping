# Install and load the rtweet package
#install.packages("rtweet")
#install.packages("twitteR")
library(ROAuth)
library(rtweet)
library(twitteR)
library(tm)

# Set up your Twitter API credentials
api_key <-  "SG5sB2urKKZLK7XtAI9ph3E8l"
api_secret_key <- "LLYPBPYl9zDiz1lvssYW0fdt5C8F6laqTp01Dn9g85iXHmpHIG"
access_token <- "1622856438132383746-XoJjcJ8KmFOWjmOdyIcZKkg7bO02ZX"
access_token_secret <- "4Zz6QpvLZIAfXJD3pEVuk6fDYoBVn2u7fjPcLn5vL0cNb"

# Set up the Twitter API connection
#rtweet
token <- create_token(
  app = "Scraper_SG",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret
)

token

#twitteR
#setup_twitter_oauth(api_key, api_secret_key, access_token, access_token_secret)


# Search for tweets
#rtweet
tweets <- search_tweets(
  'from:dev_avocado',  # Your search query
  n = 3,          # Number of tweets to fetch
  include_rts = FALSE, 
  lang="en", 
  since="2023-11-01", 
  until="2023-11-20"
)

#twitteR
#tweets <- searchTwitter(
#  '@realDonaldTrump',  # Your search query
#  n = 3,          # Number of tweets to fetch
#  include_rts = FALSE, 
#  lang="en", 
#  since="2023-11-01", 
#  until="2023-11-20"
#)

#today_trends <- getTrends(2364559)
#tweets.df <- twListToDF(tweets)

# Print the text of the first few tweets
head(tweets$text)

#bearer token = AAAAAAAAAAAAAAAAAAAAACd7rAEAAAAA%2FOT3dY9BNREkdSr1oZq9GC2R8pY%3D7jXc4YX1U2JU71ECDv4bv8fsiRSp9d2FzFtvueFHdecGbAqFyD
#api_key = SG5sB2urKKZLK7XtAI9ph3E8l
#api_secret_key = LLYPBPYl9zDiz1lvssYW0fdt5C8F6laqTp01Dn9g85iXHmpHIG
#access_token <- 1622856438132383746-yGJyTPLDq70CWoABwBg1IZjhHMqpX8
#access_token_secret <- dl5AZevdLgtpmyGym15g1XwiIS3miBP69YGandWRdl6LB
#ProfFeynman
library(tidyverse)

#install.packages("tidytext")
library(tidytext)

sent <- read.csv('text.csv')

lexicon <- read.table("turkish_lexicon.csv",
                      header = TRUE,
                      sep = ';',
                      stringsAsFactors = FALSE)

lexicon2 <- lexicon %>% 
  select(c("WORD","POLARITY")) %>% 
  rename('word'="WORD",'value'="POLARITY")


sent %>%
  mutate(linenumber = row_number()) %>% #line number for later sentence grouping 
  unnest_tokens(word, tweettext) %>% #tokenization - sentence to words
  inner_join(lexicon2) %>% # inner join with our lexicon to get the polarity score
  group_by(linenumber) %>% #group by for sentence polarity
  summarise(sentiment = sum(value)) %>% # final sentence polarity from words
  left_join(
  sent %>%
  mutate(linenumber = row_number()) #get the actual text next to the sentiment value
) %>% write.csv("sentiment_output.csv",row.names = FALSE)

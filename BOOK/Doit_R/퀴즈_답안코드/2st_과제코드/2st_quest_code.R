library(tidyverse) ; library(rvest) ; library(RSelenium)

## -------------------------------------------------------------------------------------------

remDR <- remoteDriver(remoteServerAddr = "localhost",
                      port = 4445L,
                      browserName = "chrome")

remDR$open()
remDR$navigate("https://movie.naver.com/movie/running/premovie.nhn?order=interestRate")

## ------------------------------------------------------------------------------------------

remove_str = c("12세 관람가", "15세 관람가", "전체 관람가", "청소년 관람불가")

remDR$findElements(using = "class", value = "tit") %>% 
  map(function(x) x$getElementText()) %>% 
  unlist() %>% 
  unique(.) -> title_move

title_move <- gsub("12세 관람가", "", title_move)
title_move <- gsub("15세 관람가", "", title_move)
title_move <- gsub("전체 관람가", "", title_move)
title_move <- gsub("청소년 관람불가", "", title_move)

review_moive_df = data.frame(title_move)
review_moive_df %>% 
  filter(!title_move %in% c(" 터미네이터 2", " 아이언 자이언트", " 매트릭스")) -> review_moive_df


remDR$findElements(using = 'class', value = 'exp_cnt') %>% 
  map(function(x) x$getElementText()) %>% 
  unlist() -> score_move

positive_score = score_move[1:length(score_move) %% 2 == 1]
negative_score = score_move[1:length(score_move) %% 2 == 0]

positive_score = as.numeric(positive_score)
negative_score = as.numeric(negative_score)

review_moive_df %>% 
  cbind(positive_score, negative_score) -> review_moive_df 

# write.csv(review_moive_df, "review_moive_df.csv") 

## ----------------------------------------------------------------------------

review_moive_df %>% 
  mutate(diif_score = positive_score - negative_score) %>% 
  arrange(-diif_score) %>% 
  head(10) %>% 
  ggplot(aes(x =  reorder(title_move, diif_score), y = diif_score)) +
  geom_col(aes(fill = diif_score > 1000), show.legend = F) +
  geom_text(aes(label = diif_score), hjust = -0.1, cex = 4) +
  coord_flip() +
  theme_set(theme_gray(base_family="AppleGothic")) +
  xlab("") +
  ylab("")

   

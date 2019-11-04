library(tidyverse) ; library(rvest) ; library(RSelenium)
setwd("/Users/data_analysis/Desktop/스터디자료/1st_과제코드")
##
remDR <- remoteDriver(remoteServerAddr = "localhost",
                      port = 4445L,
                      browserName = "chrome")



remDR$open()
remDR$navigate("https://www.siksinhot.com/hot/search/places?keywords=%EC%83%81%EB%82%A8%EB%8F%99%EB%A7%9B%EC%A7%91")

### data gathering 

item_code = c("item-256434", "item-365389", "item-365715", "item-454026", "item-367186",
              "item-453927", "item-990506", "item-943447", "item-367184", "item-367185",
              "item-970069", "item-481752", "item-873840", "item-630704", "item-365717",
              "item-315187", "item-434828", "item-873070", "item-367182", "item-367183", 
              "item-327540", "item-999385", "item-431753", "item-256372", "item-256264",
              "item-354798", "item-256354", "item-326990", "item-256245", "item-256322",
              "item-327147", "item-467003", "item-327036", "item-465436", "item-466369",
              "item-391778", "item-256280", "item-256306", "item-327521", "item-391763",
              "item-1089774", "item-465733", "item-879309", "item-873675", "item-872921",
              "item-872822", "item-457969", "item-391694")


place <- data.frame(NULL)

for(page in 1:3){
  for(i in 1:length(item_code)) {
    place_title = remDR$findElements(using = 'xpath', value = paste0('//*[@id="', item_code[i],'"]/div/div/span[1]/a'))
    place_title %>% 
      map(function(x) x$getElementText()) %>% 
      unlist(.) -> place_title_list
    
    place_cont = remDR$findElements(using = 'xpath', value = paste0('//*[@id="', item_code[i], '"]/div/div/span[2]'))
    place_cont %>% 
      map(function(x) x$getElementText()) %>% 
      unlist(.) -> place_cont_list
    place_region = remDR$findElements(using = 'xpath', value = paste0('//*[@id="', item_code[i], '"]/div/div/span[3]'))
    place_region %>% 
      map(function(x) x$getElementText()) %>% 
      unlist(.) -> place_region_list
    
    place_score = remDR$findElements(using = 'xpath', value = paste0('//*[@id="', item_code[i], '"]/div/a/div[1]/div/span[2]'))
    place_score %>% 
      map(function(x) x$getElementText()) %>% 
      unlist(.) -> place_score_list
    
    df = data.frame(title = place_title_list,
                    cont = place_cont_list,
                    region = place_region_list,
                    score = place_score_list)
    
    place = bind_rows(place, df)
  }
  
  bts = remDR$findElement(using = 'xpath', value = paste0('//*[@id="content3"]/div/div/a[', page, ']')) 
  bts$clickElement()
}

View(place)
write.csv(place, "place_nodata.csv")

#### data handling 




place %>% 
  separate(region, into = c("region", "main_food"), sep = "\\|") %>% 
  mutate(dong =  str_sub(region, -4, -1),
         score = as.numeric(score)) %>% 
  select(title, main_food, cont, dong, score) %>% 
  filter(score > 3) %>%
  arrange(- score) -> tidy_place

place1 <- place %>% 
  filter(score >= 3) %>% 
  separate(region,c("region2","main_food"),sep="\\|") %>% 
  mutate(dong=str_sub(region2,-4,-2)) %>% 
  arrange(desc(score)) %>% 
  select(title,main_food,cont,dong,score)

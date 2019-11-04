## --------------------- setting --------------------------- 
library(tidyverse) ; library(httr) ; library(jsonlite)
usethis::edit_r_environ()
Sys.getenv('KAKAO_MAP_API_KEY')
setwd("/Users/data_analysis/Desktop/스터디자료/1st_과제코드")


## -----------------------------------------------------------------
addr = "창원시 성산구 상남동"
res <- GET(url = 'https://dapi.kakao.com/v2/local/search/address.json',
           query = list(query = addr),
           add_headers(Authorization = Sys.getenv('KAKAO_MAP_API_KEY'))) # API로 정보 가져오기 

coord <- res %>% 
  content(as = 'text') %>% 
  fromJSON()

x <- coord$documents$x
y <- coord$documents$y

##
addr = "창원시 합성동"
res <- GET(url = 'https://dapi.kakao.com/v2/local/search/address.json',
           query = list(query = addr),
           add_headers(Authorization = Sys.getenv('KAKAO_MAP_API_KEY'))) # API로 정보 가져오기 

coord <- res %>% 
  content(as = 'text') %>% 
  fromJSON()

x <- coord$documents[1, ]$x
y <- coord$documents[1, ]$y

##
addr = "창원시 월영동"
res <- GET(url = 'https://dapi.kakao.com/v2/local/search/address.json',
           query = list(query = addr),
           add_headers(Authorization = Sys.getenv('KAKAO_MAP_API_KEY'))) # API로 정보 가져오기 

coord <- res %>% 
  content(as = 'text') %>% 
  fromJSON()

x <- coord$documents[1, ]$x
y <- coord$documents[1, ]$y


key_word = c("한식", "중식", "양식", "분식", "카페")
total_df = data.frame(NULL)

for(i in 1:length(key_word)) {
  res <- GET(url = 'https://dapi.kakao.com/v2/local/search/keyword.json',
             query = list(query = key_word[i], 
                          x = x,
                          y = y,
                          radius = 5000,       # 중심점으로부터 반경 (단위:미터)
                          page = 45,            # 이동 가능한 페이지 : 1 ~ 45
                          size = 15,           # 페이지당 검색 결과 : 1 ~ 15
                          sort = 'distance'    # 'accuracy' or 'distance'
             ),
             add_headers(Authorization = Sys.getenv('KAKAO_MAP_API_KEY')))
  
  coord = res %>% 
    content(as = "text") %>% 
    fromJSON() 
  
  place = coord$documents
  total_df = bind_rows(total_df, place)
}




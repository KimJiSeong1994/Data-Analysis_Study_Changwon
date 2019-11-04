#결측치 정제하기

#결측치 찾기
df <- data.frame(sex=c("M","F",NA,"M","F"),
                 score=c(5,4,3,4,NA))

is.na(df)                 #결측치 확인(결측치=TRUE)

table(is.na(df))          #결측치 빈도 출력
table(is.na(df$sex))      #sex 결측치 빈도 출력
table(is.na(df$score))    #score 결측치 빈도 출력

mean(df$sex)
mean(df$score)    #결측치가 포함된 데이터를 함수 적용하면 NA가 출력


#결측치 제거하기
library(dplyr)
df %>% filter(is.na(score))   #score가 NA인 데이터만 출력
df %>% filter(!is.na(score))

df_n <- df %>% filter(!is.na(score))
mean(df_n$score);sum(df_n$score)
#여러 변수 결측치 동시제거
df_n1 <- df %>% filter(!is.na(score)&!is.na(sex))  
df_n2 <- na.omit(df)   #결측치가 하나라도 있으면 모두 제거


#함수의 결측치 제외 기능 
mean(df$score, na.rm=T) #na.rm=T 파라미터 기능 사용
sum(df$score, na.rm=T)

exam <- read.csv("C:/pytest/csv_exam.csv")
exam[c(3,8,15),"math"] <- NA   #3,8,15행의 math에 NA 할당

exam %>% summarise(mean_math=mean(math))
exam %>% summarise(mean_math=mean(math,na.rm=T))
exam %>% summarise(mean_math=mean(math,na.rm=T),
                   sum_math=sum(math,na.rm=T),
                   median_math=median(math,na.rm=T))


#평균값으로 결측치 대체하기
mean(exam$math, na.rm=T)       #결측치 제외하고 math 평균 산출
exam$math <- ifelse(is.na(exam$math),55,exam$math)  #math가 NA면 55로 대체
table(is.na(exam$math))

mean(exam$math)



#문제
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65,124,131,153,212),"hwy"] <- NA

#1. drv 변수와 hwy변수에 결측치가 몇 개 있는지 알아보기
table(is.na(mpg$drv))
table(is.na(mpg$hwy))

#2. filter()이용해 hwy 결측치 제거하고 어떤 drv(구동방식)의 hwy평균이 높은지 알아보기. 
mpg %>% 
  select(drv,hwy) %>% 
  filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy)) %>% 
  arrange(desc(mean_hwy))

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm=T)) %>% 
  arrange(desc(mean_hwy))

mpg %>% 
  filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))



#이상치 정제
outlier <- data.frame(sex=c(1,2,1,3,2,1),
                      score=c(5,4,3,4,2,6))

#이상치 확인하기
table(outlier$sex)
table(outlier$score)

#결측 처리하기
outlier$sex <- ifelse(outlier$sex==3,NA,outlier$sex)
outlier

outlier$score <- ifelse(outlier$score>5,NA,outlier$score)
outlier

outlier %>% 
  filter(!is.na(sex)&!is.na(score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score=mean(score))


#이상치 제거하기 

#상자 그림으로 극단치 기준 정하기
boxplot(mpg$hwy)

#상자 그림 통계치 출력
boxplot(mpg$hwy)$stats


#결측 처리하기
#12~37 벗어나면 NA 할당
mpg$hwy <- ifelse(mpg$hwy<12|mpg$hwy>37,NA,mpg$hwy)
table(mpg$hwy)
table(is.na(mpg$hwy))

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm = T))



#문제
mpg[c(10,14,58,93),"drv"] <- "k"
mpg[c(29,43,129,203),"cty"] <- c(3,4,39,42)

#1. drv에 이상치가 있는지 확인. 이상치 결측 처리 후 확인. 결측 처리 할 때는 %in% 기호 활용하기.
table(mpg$drv)
mpg$drv <- ifelse(mpg$drv=="k",NA,mpg$drv)

table(mpg$drv)
mpg$drv <- ifelse(mpg$drv %in% c("4","f","r"), mpg$drv, NA)
table(mpg$drv)

#Q2. 상자 그림 이용해 cty에 이상치가 있는지 확인하기. 상자 그림의 통계치를 이용해 정상 범위 벗어난 값을 결측 처리하고 다시 상자 그림으로 확인
boxplot(mpg$cty)$stats
mpg$cty <- ifelse(mpg$cty>26|mpg$cty<9,NA,mpg$cty)
boxplot(mpg$cty)

#Q3. 이상치를 제외한 drv별로 cty평균이 어떻게 다른지 알아보기
mpg %>% 
  filter(!is.na(drv)&!is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(cty_mean=mean(cty))
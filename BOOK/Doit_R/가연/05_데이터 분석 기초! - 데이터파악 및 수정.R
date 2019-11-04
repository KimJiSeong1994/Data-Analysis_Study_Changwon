#####05-1 데이터 파악하기#####

exam <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")

#head() : 데이터 앞부분 확인
head(exam)
head(exam,10)    #앞에서부터 10행까지 출력

#tail() : 데이터 뒷부분 확인
tail(exam)
tail(exam,10)    #뒤에서부터 10행까지 출력

#View() : Viewer창에서 데잍터 확인
View(exam)

#dim() : 데이터가 몇 행, 몇 열로 구성되어 있는지 알아보기
dim(exam)        #행, 열 출력

#str() : 속성 파악하기
#관측치(obs)는 행(row)과 동일한 의미로 사용됨
str(exam)

#summary() : 요약 통계량 산출
#1st Qu. : 1사분위수(하위25% 지점에 위치하는 값)
#Median : 중앙값
#Mean : 평균
#3rd Qu. : 3사분위수(하위75% 지점에 위치하는 값)
summary(exam)


#mpg데이터 파악하기
#mpg데이터는 ggplot2에 내장된 데이터
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
head(mpg);tail(mpg);View(mpg)
dim(mpg);str(mpg);summary(mpg)

?mpg          #mpg설명글 출력



#####05-2 변수명 바꾸기#####
library(dplyr)
df_raw <- data.frame(var1=c(1,2,1),
                     var2=c(2,3,2))
df_new <- df_raw                     #복사본 생성
df_new <- rename(df_new, V2=var2)    #var2를 V2로 수정
df_raw;df_new



#####연습문제#####
#Q1.mpg데이터를 불러오고 복사본 생성
mpg_d <- ggplot2::mpg
mpg_d <- as.data.frame(ggplot2::mpg)

#Q2.복사본으로 cty는 city, hwy는 highway로 수정&확인
mpg_d <- rename(mpg_d, city=cty, highway=hwy)
head(mpg_d)



#####05-3 파생변수 만들기#####
#파생변수 : 기존의 변수를 변형해 만든 변수

df <- data.frame(var1=c(4,3,8),
                 var2=c(2,6,1))
df$var_sum <- df$var1+df$var2         #var_sum 파생변수 생성
df

df$var_mean <- (df$var1+df$var2)/2    #var_mean 파생변수 생성
df

###mpg 통합 연비 변수 만들기
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)

mpg$total <- (mpg$cty+mpg$hwy)/2
head(mpg)                #통합 연비 변수 생성
mean(mpg$total)          #통합 연비 변수 평균


###조건문을 활용해 파생변수 만들기
summary(mpg$total)       #요약 통계량 산출
hist(mpg$total)          #히스토그램 생성 : 값의 전반적인 분포 파악 가능

#ifelse(조건, 조건 충족, 조건 비충족)
mpg$test <- ifelse(mpg$total>=20,"pass","fail")
head(mpg)

#table() : 빈도표 작성
table(mpg$test)          #연비 합격 빈도표 생성

#qplot() : 막대 그래프로 빈도 표현
library(ggplot2)
qplot(mpg$test)


###중첩 조건문 활용하기
mpg$grade <- ifelse(mpg$total>=30,"A",
                    ifelse(mpg$total>=20,"B","C"))
head(mpg)
table(mpg$grade)
qplot(mpg$grade)

mpg$grade2 <- ifelse(mpg$total>=30,"A",
                     ifelse(mpg$total>=25,"B",
                            ifelse(mpg$total>=20,"C","D")))
table(mpg$grade2);qplot(mpg$grade2)



#####연습문제2#####
#Q1. ggplot2의 midwest데이터를 데이터 프레임 형태로 불러오고 특징 파악
df_mid <- as.data.frame(ggplot2::midwest)
head(df_mid);dim(df_mid);summary(df_mid);str(df_mid);View(df_mid)

#Q2. poptotal변수를 total로, popasian변수를 asian으로 수정
library(dplyr)
df_mid <- rename(df_mid,total=poptotal,asian=popasian)
head(df_mid)

#Q3. total, asian 변수로 '전체 인구 대비 아시아 인구 백분율' 파생변수를 만들고, 히스토그램을 만들어 도시들 분포 살피기
df_mid$Apercent <- (df_mid$asian/df_mid$total)*100
head(df_mid)
hist(df_mid$Apercent)

#Q4. 아시아 인구 백분율 전체 평균 구하고, 평균 초과하면 "large", 그 외에는 "small"을 부여하는 파생변수 만들기
summary(df_mid$Apercent)
df_mid$Apercent1 <- ifelse(df_mid$Apercent>mean(df_mid$Apercent),"large","small")
head(df_mid)

#Q5. "large"와 "small" 지역 빈도표와 빈도 막대 그래프 작성
table(df_mid$Apercent1)
qplot(df_mid$Apercent1)

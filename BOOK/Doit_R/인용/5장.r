#데이터 파악하기 
head(exam)# 앞에서부터 6행까지 출력 
head(exam,10)# 앞에서부터 10행까지 출력
tail(exam)# 뒤에서부터 6행까지 출력
tail(exam,10)#뒤에서부터 10행까지 출력 
view(exam)#데이터 뷰어창 
dim(exam)#행, 열 출력 
str(exam)# 데이터 속성 확인 
#mpg데이터 파악하기 
mpg <- as.data.frame(ggplot2::mpg)# ggplot2의 mpg 데이터를 데이터프레임 형태로 불러오기 

head(mpg)
tail(mpg)
dim(mpg)
str(mpg)
summary(mpg)# 요약 통계량 출력 


# 변수명 바꾸기
#데이터 프레임생성 
df_raw <- data.frame(var1=c(1,2,1),
                     var2=c(2,3,2))
#데이터 가공패키지 
library(dplyr)
# 복사본 생성
df_new <- df_raw
#변수명 바꾸기 
df_new <- rename(df_new, V2=var2)    


#문제 
#1.  ggplot2()의 데이터를 사용할 수있도록 불러온후 복사본만들기 

mpg1 <- ggplot2::mpg
mpg1 <- as.data.frame(ggplot2::mpg)

#2.복사본 데이터를 이용해 cty는 city로,hwy는 highway로 수정 

mpg1 <- rename(mpg1, city=cty, highway=hwy)
head(mpg1)
# 파생변수 만들기 
df <- data.frame(var1=c(4,3,8),
                 var2=c(2,6,1))

#var_sum 파생변수 생성
df$var_sum <- df$var1+df$var2 
#var_mean 파생변수 생성
df$var_mean <- (df$var1+df$var2)/2

#통합 연비 변수 생성

mpg$total <- (mpg$cty+mpg$hwy)/2
head(mpg)               
#통합 연비 변수 평균
mean(mpg$total)

#요약 통계량 산출
summary(mpg$total)       
#히스토그램 생성 
hist(mpg$total)         

# 합격 판정 변수 만들기 

mpg$test <- ifelse(mpg$total>=20,"pass","fail")
# 데이터 확인
head(mpg, 20)
# 빈도표로 합격 판정 자동차 수 살펴보기 
table(mpg$test)
#막대그래프로 빈도 표현하기 
library(ggplot2)
qplot(mpg$test)

###중첩 조건문 활용하기
mpg$grade <- ifelse(mpg$total>= 30,"A",
                    ifelse(mpg$total>=20, "B", "C"))
head(mpg)

#빈도표 막대 그래프로 연비 등급 살펴보기 
table(mpg$grade)# 등급 빈도표 생성 
qplot(mpg$grade)# 등급 빈도 막대 그래프 생성 

# 원하는 만큼 범주 만들기 
# A B C D 등급 부여 
mpg$grade2 <- ifelse(mpg$total>=30,"A",
                     ifelse(mpg$total>=25,"B",
                            ifelse(mpg$total>=20,"C","D")))

# 문제 
#1. ggplot2의 midwest데이터를 데이터 프레임 형태로 불러 특징 파악
df_mid <- as.data.frame(ggplot2::midwest)
head(df_mid);dim(df_mid);summary(df_mid);str(df_mid);View(df_mid)

#2. poptotal변수를 total로, popasian변수를 asian으로 수정
df_mid <- rename(df_mid,total=poptotal,asian=popasian)
head(df_mid)

#3. total, asian 변수로 '전체 인구 대비 아시아 인구 백분율' 파생변수를 만들고, 히스토그램을 만들어 도시들 분포 살피기
df_mid$Apercent <- (df_mid$asian/df_mid$total)*100
head(df_mid)
hist(df_mid$Apercent)

#4. 아시아 인구 백분율 전체 평균 구하고, 평균 초과하면 "large", 그 외에는 "small"을 부여하는 파생변수 만들기
summary(df_mid$Apercent)
df_mid$Apercent1 <- ifelse(df_mid$Apercent>mean(df_mid$Apercent),"large","small")
head(df_mid)

#5. "large"와 "small" 지역 빈도표와 빈도 막대 그래프 생성 
table(df_mid$Apercent1)
qplot(df_mid$Apercent1)


















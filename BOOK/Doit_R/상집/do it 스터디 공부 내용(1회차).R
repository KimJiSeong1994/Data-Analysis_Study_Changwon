#04-2 데이터 프레임 만들기
#1.변수 만들기
english <- c(90,80,60,70) #영어 점수 변수 생성
math <- c(50,60,100,20) #수학 점수 변수 생성

#2.데이터 프레임 만들기
df_midterm <- data.frame(english,math) #md_midterm 변수에 데이터 할당
#3.반에 대한 정보 변수 추가

class <- c(1,1,2,2) 

df_midterm <- data.frame(english,math,class)
df_midterm

#4.분석하기
mean(df_midterm$english) #영어점수 평균 구하기
mean(df_midterm$math) #수학점수 평균 구하기

5.데이터 프레임 한번에 만들기
df_midterm <- data.frame(englisg=c(09,80,60,70),
                         math=c(50,60,100,20),
                         class=c(1,1,2,2))
df_midterm

#04-3 외부 데이터 이용하기
#디렉토리 설정
getwd()
setwd("c:\\Users\\tkdwl\\OneDrive\\바탕 화면\\do it 깃허브 파일")
#패키지 설치
install.packages("readxl")
library(readxl)
#엑셀파일 불러오기
df_exam <- read_excel("excel_exam.xlsx")  #엑셀 파일 출력
df_exam #출력
#파일 경로가 다른 곳에 지정되어 있는 경우
df_exam <- read_excel("C:\\Users\\tkdwl\\OneDrive\\바탕 화면\\do it 깃허브 파일\\excel_exam.xlsx")

#5.분석하기
mean(df_exam$english) #영어점수 평균

mean(df_exam$science) #과학점수 평균

#첫행이 변수명이 아닐 경우
df_exam_novar <- read_excel("excel_exam_novar.xlsx",col_names = F)
df_exam_novar

#엑셀 파일에 sheet가 여러개 일 떄
df_exam_sheet <- read_excel("excel_exam_sheet.xlsx",sheet=3)
df_exam_sheet

#csv 파일 불러오기

df_csv_exam <- read.csv("csv_exam.csv")
df_csv_exam

#문자가 들어있는 파일 불러올 떄
df_csv_exam <- read.csv("csv_exam.csv",stringAsFactors=F)


#csv파일로 저장하기
write.csv(df_midterm,file = "df_midterm.csv")

#RData 활용
save(df_midterm,file="df_midterm.rda")

#RData 불러오기 
rm(df_midterm) #데이터 삭제
df_midterm #삭제 됬는지 확인

load("df_midterm.rda")
df_midterm

###################################

#05-1 데이터 파악하기
#데이터 불러오기
exam <- read.csv("csv_exam.csv")

#head():데이터 앞부분 확인
head(exam) #앞에서 6행까지 출력
head(exam,10) #앞에서 10행까지 출력

#tail():데이터 뒷부분 확인
tail(exam)
tail(exam,10) #뒤에서부터 10행까지 출력

#view():뷰어창으로 데이터 확인
View(exam) #주의 사항 :"V"는 대문자로 입력!

#dim():데이터 행렬 구성 알려줌
dim(exam)#출력 결과 앞은 행 ,뒤는 열  총 20명의 5가지 변수(특성)을 가짐

#str():속성 파악
str(exam)

#summary():요약통계량 산출
summary(exam) #최솟값,1사분위,중앙값,평균,3사분위,최대값 알려줌

#mpg 데이터 파악
#ggplot2의 내장 데이터 설치
install.packages("ggplot2")

#데이터 프레임화
mpg <- as.data.frame(ggplot2::mpg)  #"::"는 ~에 들어있는 데이터를 지칭

#데이터 확인
head(mpg)

tail(mpg)

View(mpg)

dim(mpg)

str(mpg)

summary(mpg)

#데이터에 대한 설명
?mpg

#05-2 변수명 바꾸기
##dplyr rename 이용
df_raw <- data.frame(var1=c(1,2,1),
                     var2=c(2,3,2))
df_raw

install.packages("dplyr")
library(dplyr)

###복사본 만들기
df_new <- df_raw

df_new <- rename(df_new,v2=var2)

#05-3 파생변수 만들기
#데이터 생성
df <- data.frame(var1=c(4,3,8),
                 var2=c(2,6,1))
df

df$var_sum <- df$var1 + df$var2 #var_sum 파생변수 생성
df

df$var_mean <- (df$var1 + df$var2) / 2 #var_mean 변수 생성
df

##mpg 통합 연비 파생변수 만들기(cty-도시연비,hwy-고속도로연비)

mpg$total <- (mpg$cty + mpg$hwy)/2 #통합연비 변수 생성
head(mpg)

###변수 분석
mean(mpg$total)

##조건문 활용 파생변수 만들기
#1.기준값 정하기
summary(mpg$total) #요약통계산출
hist(mpg$total)#히스토그램 생성

#2.합격 판정 변수 만들기 (20기준-합격/불합격)
mpg$test <- ifelse(mpg$total>=20,"pass","fail")

head(mpg,20) #데이터 확인

#3.빈도표로 합격 판정인 자동차수 파악
table(mpg$test) 

#4.막대그래프로 빈표 표현
library(ggplot2)
qplot(mpg$test) #연비 합격 빈도 막대 그래프 생성

#중첩조건문 활용하기
#total 기준 A,B,C 등급 부여
mpg$grade <- ifelse(mpg$total>=30,"A",ifelse(mpg$total>=20,"B","C"))

head(mpg,20) #데이터 확인

##빈도,막대그래포 표현
table(mpg$grade) #빈도

qplot(mpg$grade)

#06-1 데이터 전처리
##dplyr함수:추출,정렬,변수추가,통계,집단별 나누기,데이터 합치기

#06-2 조건에 맞는 데이터 추출
library(dplyr)
exam <- read.csv("csv_exam.csv")

##1반 학생만 추출

exam %>% filter(class==1) #1반 학생 추출

exam %>% filter(class==2) #2반 학생 추출

##"!=" 특정 값이 아닌경우
exam %>% filter(class!=1) #1반이 아닌 경우

exam %>% filter(class!=3) #3반이 아닌 경우

#초과,미만,이상,이하 조건 걸기
exam %>% filter(math>50) #수학 50점 초과
exam %>% filter(math<50) #수학 50점 미만
exam %>% filter(english>=80) #영어 80점 이상
exam %>% filter(english<=80) #영어 80점 이하

##여러조건 충족 연산자:&=and, |=or
exam %>% filter(class==1 & math>=50) #1반이면서 수학점수 50점 이상
exam %>% filter(math>=90 | english>=90) #수학이 90점 이상 이거나 영어가 90점 이상인 경우

##지정된 목록에 해당되는 경우
exam %>% filter(class==1 | class==3 | class==5) #1,3,5반만 추출

##"%in%" 조건 목록 입력
exam %>% filter(class %in% c(1,3,5)) #1,3,5반만 추출

##추출한 행으로 새 데이터 만들기
class1 <- exam %>% filter(class==1) #1반 데이터 추출 ->새로 생성
class2 <- exam %>% filter(class==2)  #2반 데이터 추출 ->새로 생성

mean(class1$math) #1반 평균

mean(class2$math) #2반 평균

#06-3 필요한 변수만 추출
exam %>% select(math) #math 추출

##변수제외
exam %>% select(-math)

##dplyr() 조합
###filter와 select 조합
exam %>% 
    filter(class==1) %>%  
    select(english) #1반인 학생 영어 성적

###일부만 출력
exam %>% 
  select(id,math) %>% 
  head


#06-4 순서대로 정렬 arrange() :기본 오름차순
exam %>% arrange(math)
exam %>% arrange(desc(math)) #내림차순 정렬

#06-5 파생변수 추가 mutate()
exam %>% 
  mutate(total=math+english+science,
         mean=(math+english+science)/3) %>% 
  head #총합 변수 추가

##ifelse 적용
exam %>% 
  mutate(test = ifelse(science >= 60,"pass","fail")) %>% 
  head

##arrrage() 결합
exam %>% 
  mutate(total=math+english+science) %>%  #총합변수 추가 
  arrange(total) %>%  #총합변수 기준 정렬
  head  #일부 머릿말 부분 출력

#06-6 집단별 요약 group_by(),summarise()

exam %>% summarize(mean_math=mean(math)) #math 평균 산출

exam %>% 
  group_by(class) %>%  #class 별로 분리
  summarise(meand_math=mean(math)) #math 평균 산출

##여러 요약 통계
exam %>% 
  group_by(class) %>% 
  summarise(mean_math=mean(math),
            sum_math=sum(math),
            median_math=median(math), 
            n=n())  #빈도

##집단별 또 집단 나누기
mpg %>% 
  group_by(manufacturer,drv) %>%  #회사별,구동 방식 별
  summarise(mean_city=mean(cty)) %>%  #cty평균 산출
  head(10)  #일부 출력

##dplyr 조합
###회사별 분리->suv 추출 ->통합연비 변수 생성->통합연비 평균 산출->내림차순 정렬->1~5위까지 출력

mpg %>% 
  group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  mutate(tot=(cty+hwy)/2) %>% 
  summarise(mean_tot=mean(tot)) %>% 
  arrange(desc(mean_tot)) %>% 
  head(5)

#06-7 데이터 합치기
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm=c(60,80,70,90,85))
test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(70,83,65,95,80))
##가로 합치기 dplyr 패키지 left_join()
total <- left_join(test1,test2,by="id")
total

###다른 데이터 변수 활용
name <- data.frame(class=c(1,2,3,4,5),
                   teacher=c("kim","lee","park","choi","jung"))
exam_new <- left_join(exam,name,by="class")
exam_new


###세로 합치기  bind_row()
group_a <- data.frame(id=c(1,2,3,4,5),
                      test=c(60,80,70,90,85))

group_b <- data.frame(id=c(6,7,8,9,10),
                      test=c(70,83,65,95,80))

group_all <- bind_rows(group_a,group_b)
group_all

#07.데이터 정제(결측치,이상치 처리)
df <- data.frame(sex=c("M","F",NA,"M","F"),
                 score=c(5,4,3,4,NA))
df
##결측치 확인
is.na(df)
table(is.na(df)) #결측치 빈도 출력
table(is.na(df$sex))
table(is.na(df$score))


##결측치 제거
df %>% filter(!is.na(df$score)& !is.na(df$sex)) #sex,score 결측치 제거
na.omit(df)#결측치 있는 행 한번에 제거

##함수의 결측치 제외 기능 사용
mean(df$score,na.rm=T) #결측치 제외하고 평균 산출

exam <- read.csv("csv_exam.csv")
exam[c(3,8,15),"math"] <- NA #NA 값 할당
exam

exam %>% 
  summarise(mean_math=mean(math,na.rm=T)) #평균 외에 합계 중앙값 등 사용 가능

##결측치 대체

#1.평균값으로 결측치 대체
mean(exam$math,na.rm=T)   #결측치 제외한 math 값
exam
exam$math <- ifelse(is.na(exam$math),55,exam$math)   #math가 na 값이면 55로 대체
table(is.na(exam$math))    #결측치 빈도 확인
mean(exam$math)

#07-2 이상치 정제
##이상치 제거-존재할수 없는 값 ex) sex=3 ,score=6 이상치라 가정
outlier <- data.frame(sex=c(1,2,1,3,2,1),
                      score=c(5,4,3,4,2,6))

table(outlier$sex)#이상치 확인
table(outlier$score)#이상치 확인

##이상치->결측치 변환
outlier$sex <- ifelse(outlier$sex==3,NA,outlier$sex)
outlier$score <- ifelse(outlier$score>5,NA,outlier$score)
outlier

#계산
outlier %>% 
  filter(!is.na(sex)&!is.na(score))%>% 
  group_by(sex) %>% 
  summarise(mean_score=mean(score))

#이상치-극단적인 값 제거
##극단치의 기준 정하기
boxplot(mpg$hwy)$stats #상자 그림 통계치 출력

##결측처리
mpg$hwy <- ifelse(mpg$hwy<12|mpg$hwy>37,NA,mpg$hwy)
table(is.na(mpg$hwy))

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm=T))

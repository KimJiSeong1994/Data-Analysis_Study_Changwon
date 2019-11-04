#do it 스터디 2회차

#08.그래프 만들기

##08-1 R로 만들수 있는 그래프 살펴보기
#2차원,3차원,지도,네트워크,모션 차트,인터랙티브 그래프 등
#ggplot2 를 이용 :산점도,막대그래프,선그래프,상자 그림 만들기

##08-2 산점도- 변수간 관계 표현
#정의 :x축과 y축을 점으로 표현
#ggplot 레이어 구조 : 1단계: 배경설정(축)->
#2단계:그래프 추가(점,막대,선)->
#3단계:설정추가(축범위,색 표식)
library(ggplot2)
###배경설정
ggplot(data=mpg , aes(x = displ, y = hwy)) #mpg 데이터,x축은 배기량(displ),y축은 고속도로 연비(hwy)

###그래프 추가
ggplot(data=mpg , aes(x = displ, y = hwy))+geom_point() #배경에 산점도 추가

###축범위를 조정하는 설정 추가
ggplot(data=mpg , aes(x = displ, y = hwy)) + geom_point() + xlim(3,6) #x축 범위 3~6으로 지정

ggplot(data=mpg , aes(x = displ, y = hwy)) + 
  geom_point() + 
  xlim(3,6) + 
  ylim(10,30) #x축 범위3~6,y축 범위 10~30으로 지정

###이미지 파일로 저장

##08-3 막대그래프 -집단 간 차이 표현
 #정의:데이터의 크기를 막대로 표현

###(1)집단별 평균표 만들기
library(dplyr)

df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))

df_mpg

###(2)그래프 생성
ggplot(data=df_mpg,aes(x = drv,y=mean_hwy))+geom_col()

###(3)크기순 정렬
ggplot(data=df_mpg,aes(x = reorder(drv,-mean_hwy) , y = mean_hwy)) + geom_col()

###빈도 막대 그래프 그리기
ggplot(data=mpg,aes(x=drv))+geom_bar()

ggplot(data=mpg,aes(x = hwy)) + geom_bar() #연속 변수 지정


##08-4 선 그래프 -시간에 따라 달라지는 데이터 표현

###시계열 그래프 그릭
ggplot(data = economics, aes(x = date, y = unemploy)) + geom_line()

##08-4 상자 그림 -집단간 분포 차이 표현

###상자 그림 만들기
ggplot(data = mpg , aes(x = drv , y = hwy)) + geom_boxplot()

#9 데이터 분석 프로젝트

##09-1 '한국 복지 패널 데이터' 준비
setwd("C:\\Users\\tkdwl\\Downloads\\Doit_R-master\\Data")
getwd()

###패키지 설치 및 로드
 install.packages("foreign") #spss,sas,stata,등 통계분석 소프트웨어 파일 불러올수 있게함
 
library("dplyr")   #전처리
library("readxl")  #엑셀파일 불러오기
library("ggplot2")  #시각화
library("foreign")#spss 파일 불러오기

###데이터 불러오기
raw_welfare <- read.spss(file = "Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T) #spss파일을 데이터 프레임 형태로 변환

###복사본 만들기
welfare <- raw_welfare

###데이터 검토 :데이터 구조와 특징 파악
head(welfare)
tail(welfare)
view(welfare)
dim(welfare)
str(welfare)
summary(welfare)

###변수명 바꾸기
welfare <- rename(welfare,
                  sex = h10_g3, #성별
                  birth = h10_g4, #태어난 연도
                  marriage = h10_g10, #혼인 상태
                  religion = h10_g11, #종교
                  income = p1002_8aq1, #월급
                  code_job = h10_eco9, #직업 코드
                  code_region = h10_reg7) #지역 코드


##데이터 분석 절차
###1단계 : 변수 검토 및 전처리

###2단계 : 변수 간 관계 분석

##09-2 성별에 따른 월급 차이 -"성별에 따라 월급이 다를까?"

###성별 변수 검토 및 전처리

####(1)변수 검토
class(welfare$sex)

####(2)전처리 :성별
table(welfare$sex) #이상치 확인

welfare$sex <- ifelse(welfare$sex ==1,"male","female")
table(welfare$sex)

qplot(welfare$sex)

####이상치가 발견 되었을 경우
welfare$sex <- ifelse(welfare$sex ==9,NA,welfare$sex) #이상치 결측 처리

table(is.na(welfare$sex)) #결측치 확인

###(2)전처리 :월급 , 만원 단위로 기록 됨
class(welfare$income)  #변수 속성 확인

summary(welfare$income) #요약 통계량을 통해 특징 파악

qplot(welfare$income) +xlim(0,1000)  #간단한 그래프를 제한된 범위로 출력

summary(welfare$income) #이상치 확인 

welfare$income <- ifelse(welfare$income %in% c(0,9999),NA,welfare$income) #이상치(0,9999) 결측 처리

table(is.na(welfare$income))

###성별에 따른 월급 차이 분석

####성별 월급 평균표 만들기

sex_income <- welfare %>% 
                filter(!is.na(income)) %>% 
                group_by(sex) %>% 
                summarise(mean_income = mean(income))

head(sex_income) #분석 남자312만원,여자163만원

###그래프 만들기
ggplot(data = sex_income,aes(x = sex,y = mean_income)) + geom_col()


##09-3 나이와 월급의 관계 -"몇살 때 월급을 가장 많이 받을까?"

###(1)전처리 :나이 변수 검토 
class(welfare$birth) #변수 속성 확인

summary(welfare$birth) #요약 통계량 확인

qplot(welfare$birth) #간단한 그래프 표현

table(is.na(welfare$birth))

###나이변수 이상치가 발견 되었을 시
welfare$birth <- ifelse(welfare$birth ==9999,NA,welfare$birth)
table(is.na(welfare$birth))


###(2)파생변수 만들기
welfare$age <- 2015 - welfare$birth +1
summary(welfare$age)

qplot(welfare$age)

##(3)나이와 월급의 관계 분석
age_income <- welfare %>% 
                filter(!is.na(income)) %>% 
                group_by(age) %>% 
                summarise(mean_income=mean(income))

head(age_income)

###그래프 만들기
ggplot(data = age_income,aes(x = age ,y = mean_income))+geom_line()

##09-4 연령대에 따른 월급 차이

###파생변수 만들기-연령대
welfare <- welfare %>% 
  mutate(ageg = ifelse(age <30,"young",
                       ifelse(age<=59,"middle","old")))

table(welfare$ageg)

qplot(welfare$ageg)

##연령대에 따른 월급 차이 분석
ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income=mean(income))

ageg_income

###그래프 만들기
ggplot(data=ageg_income,aes(x = ageg,y = mean_income)) +
  geom_col() + 
  scale_x_discrete(limits =c("young","middle","old")) #나이순으로 막대그래프 정렬


##09-5 연령대 및 성별 월급 차이

###연령대 및 성별 월급 평균표 만들기
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg,sex) %>% 
  summarise(mean_income = mean(income))

sex_income

###그래프 만들기
ggplot(data = sex_income,aes(x = ageg, y= mean_income,fill = sex)) + 
  geom_col(position = "dodge")+ #막대 그래프 분리
  scale_x_discrete(limits=c("young","middle","old"))


##나이 및 성별 월급 차이 분석
sex_age <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age,sex) %>% 
  summarise(mean_income = mean(income))

head(sex_age)

ggplot(data = sex_age , aes(x = age , y = mean_income,col = sex)) +geom_line()

##09-6 직업별 월급 차이
class(welfare$code_job)

table(welfare$code_job)

###전처리 :직업 분류 코드 목록 불러오기

library(readxl)
list_job <- read_excel("Koweps_Codebook.xlsx",col_names = T,sheet=2)

head(list_job)

dim(list_job)

###left join() : job 변수를 데이터 결합
welfare <- left_join(welfare,list_job,id="code_job")

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job,job) %>% 
  head()

###직업별 월급 차이 분석
####직업별 월급 차이 평균표 만들기

job_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))

head(job_income)

###월급을 내림차순으로 정렬, 상위 10개만 추출
top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)

top10

###그래프 만들기
ggplot(data =top10 ,aes(x = reorder(job,mean_income),y = mean_income))+
  geom_col()+
  coord_flip() #막대 그래프를 90도 회전


###하위 10위 직업 추출
bottom10 <- job_income %>% 
  arrange(mean_income) %>% 
  head(10)
bottom10

###하위 10위 그래프 만들기
ggplot(data = bottom10,aes(x=reorder(job,-mean_income),y =mean_income))+
  geom_col()+
  coord_flip()+
  ylim(0,850)


##09-7 성별 직업 빈도

###남성 직업 빈도 상위 10 추출
job_male <- welfare %>% 
  filter(!is.na(job)& sex== "male") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_male

###여성 직업 빈도 상위 10 추출

job_female <- welfare %>% 
  filter(!is.na(job)& sex== "female") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_female

###그래프 만들기
ggplot(data = job_male,aes(x = reorder(job,n),y = n))+
  geom_col()+
  coord_flip()

ggplot(data = job_female,aes(x = reorder(job,n),y = n))+
  geom_col()+
  coord_flip()

##09-8 종교 유무에 따른 이혼율

###변수 검토 :종교 유무
class(welfare$religion)

table(welfare$religion)

###종교 유무 이름 부여
welfare$religion <- ifelse(welfare$religion==1,"yes","no")
table(welfare$religion)
qplot(welfare$religion)

###변수 검토 :혼인상태
class(welfare$marriage)
table(welfare$marriage)

###파생 변수 만들기 혼인상태->이혼 여부 1:배우자 3:이혼
welfare$group_marriage <- ifelse(welfare$marriage==1,"marriage",
                                ifelse(welfare$marriage==3,"divorce",NA))
table(welfare$group_marriage)

table(is.na(welfare$group_marriage))

qplot(welfare$group_marriage)

###종교 유무에 따른 이혼율 분석
religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion,group_marriage) %>% 
  summarise(n =n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100,1))

religion_marriage

####집단별 빈도 count()
religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  count(religion,group_marriage) %>% 
  group_by(religion) %>% 
  mutate(pct = round(n/sum(n)*100,1))

####이혼 추출
divorce <- religion_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(religion,pct)

divorce

###그래프 만들기
ggplot(data = divorce,aes(x=religion, y= pct))+ geom_col()


###연령대 및 종교 유무에 따른 이혼율 분석
####연령대별 이혼율 표
ageg_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg,group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group =sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))

ageg_marriage

###다른 방법
ageg_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  count(ageg,group_marriage) %>% 
  group_by(ageg) %>% 
  mutate(pct = round(n/sum(n)*100,1))

###연령대별 이혼율 그래프
####초년 제외,이혼 추출
ageg_divorce <- ageg_marriage %>% 
  filter(ageg !="young" & group_marriage=="divorce") %>% 
  select(ageg,pct)

ageg_divorce

####그래프 만들기
ggplot(data = ageg_divorce,aes(x= ageg,y = pct)) + geom_col()


###연령대 및 종교 우무에 따른 이혼율 표 만들기
####연령대,종교 우무,결혼 상태별 비율표 만들기
ageg_religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage) & ageg != "young") %>% 
  group_by(ageg,religion,group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group=sum(n)) %>% 
  mutate(pct = round(n/tot_group*100,1))

ageg_religion_marriage

####다른 방식
ageg_religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage) & ageg != "young") %>%
  count(ageg,religion,group_marriage) %>% 
  group_by(ageg,religion) %>% 
  mutate(pct = round(n/sum(n)*100,1))


####연령대 및 종요 유무별 이혼율 표 만들기
df_divorce <- ageg_religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(ageg,religion,pct)

df_divorce

#####그래프 만들기
ggplot(data = df_divorce,aes(x = ageg , y = pct, fill = religion))+
  geom_col(position = "dodge")


##09-9 지역별 연령대 비율
###변수 검토 :지역

class(welfare$code_region)

table(welfare$code_region)

####전처리 :지역 코드 목록 불러오기
list_region <- data.frame(code_region = c(1:7),
                          region =  c("서울",
                                      "수도권(인천/경기)",
                                      "부산/경남/울산",
                                      "대구/경북",
                                      "대전/충남",
                                      "강원/충북",
                                      "광주/전남/전북/제주도"))

list_region

###지역별 변수 추가
welfare <- left_join(welfare,list_region,id = "code_region")

welfare %>% 
  select(code_region,region) %>% 
  head

####지역별 연령대 비율표 만들기
region_ageg <- welfare %>% 
  group_by(region,ageg) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100,2))

head(region_ageg)

####다른 방식
region_ageg <- welfare %>% 
  count(region,ageg) %>% 
  group_by(region) %>% 
  mutate(pct = round(n/sum(n)*100,2))

####그래프 만들기
ggplot(data = region_ageg,aes(x = region, y = pct, fill =ageg))+
  geom_col()+
  coord_flip()

####노년충 높은 순으로 막대 정렬
list_order_old <- region_ageg %>% 
  filter(ageg == "old") %>% 
  arrange(pct)

list_order_old

####지역명 순서 변수 만들기
order <- list_order_old$region
order

ggplot(data = region_ageg,aes(x = region,y =pct,fill = ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits =order)
####연령대 순으로 막대 샐깔 나열
class(region_ageg$ageg)

levels(region_ageg$ageg)

region_ageg$ageg <- factor(region_ageg$ageg,
                           level = c("old","middle","young"))

class(region_ageg$ageg)

levels(region_ageg$ageg)

ggplot(data =region_ageg,aes(x = region , y = pct, fill = ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits = order)












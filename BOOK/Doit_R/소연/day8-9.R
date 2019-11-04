#8.그래프 만들기
#8-1 R로 만들 수 있는 그래프 살펴보기
#8-2 산점도-변수 간 관계 표현하기
library(ggplot2)
ggplot(data=mpg, aes(x=displ,y=hwy)) #배경생성
ggplot(data=mpg, aes(x=displ,y=hwy))+geom_point() #배경에 산점도 추가
ggplot(data=mpg, aes(x=displ,y=hwy))+geom_point() +xlim(3,6) #x축 범위 지정
ggplot(data=mpg, aes(x=displ,y=hwy))+
  geom_point() +
  xlim(3,6) +
  ylim(10,30)   #x축 y축 범위 지정

##혼자서 해보기
#1
ggplot(data=mpg, aes(x=cty, y=hwy))+geom_point()
#2
ggplot(data=midwest,aes(x=poptotal, y=popasian)) +
  geom_point() +
  xlim(0,500000) +
  ylim(0,10000)

#8-3 막대 그래프-집단 간 차이 표현하기
library(dplyr)
mpg

df_mpg<-mpg %>% 
  group_by(drv) %>%
  summarise(mean_hwy=mean(hwy))

df_mpg

ggplot(data=df_mpg, aes(x=drv ,y=mean_hwy)) + geom_col() # 그래프 생성
ggplot(data=df_mpg, aes(x=reorder(drv,-mean_hwy) ,y=mean_hwy)) + geom_col() #오름차순정렬
ggplot(data=mpg, aes(x=drv)) + geom_bar() # 빈도 막대 그래프
ggplot(data=mpg, aes(x=hwy)) + geom_bar()

##혼자서 해보기
#1
a_mpg<-mpg %>% 
  filter(class=="suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)
ggplot(data=a_mpg, aes(x=reorder(manufacturer,-mean_cty),y=mean_cty)) + geom_col()
ggplot(data=mpg, aes(x=class))+geom_bar()

#8-4 선 그래프 - 시간에 따라 달라지는 데이터 표현하기
ggplot(data=economics, aes(x=date, y=unemploy)) + geom_line() #시계열 그래프 만들기

##혼자서 해보기
ggplot(data=economics, aes(x=date, y=psavert)) + geom_line()

#8-5 상자 그림 - 집단 간 분포 차이 표현하기
ggplot(data=mpg, aes(x=drv, y=hwy)) + geom_boxplot()

##혼자서 해보기
b_mpg<-mpg %>% 
  filter(class %in% c("compact", "subcompact", "suv"))
ggplot(data=b_mpg, aes(x=class, y=cty)) + geom_boxplot()


#9. 데이터 분석 프로젝트 - '한국인의 삶을 파악하라'
#9-1 '한국복지패널데이터' 분석 준비하기
#install.packages("foreign")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)
raw_welfare <- read.spss(file="C:/doit_r/Koweps_etc/데이터/Koweps_hpc10_2015_beta1.sav",
                        to.data.frame=T)
welfare<-raw_welfare
head(welfare)
tail(welfare)
View(welfare)
dim(welfare)
str(welfare)
summary(welfare)
welfare <- rename(welfare,
                  sex=h10_g3,
                  birth=h10_g4,
                  marriage=h10_g10,
                  religion=h10_g11,
                  income=p1002_8aq1,
                  code_job=h10_eco9,
                  code_region=h10_reg7)

#9-2 성별에 따른 월급 차이-'성별에 따라 월급이 다를까?'
class(welfare$sex)
table(welfare$sex)

welfare$sex <- ifelse(welfare$sex==9, NA, welfare$sex) #이상치 결측 처리
table(is.na(welfare$sex)) #결측치 확인

welfare$sex <- ifelse(welfare$sex == 1, "male", "female") #성별 항목 이름 부여
table(welfare$sex)
qplot(welfare$sex)
#변수 검토하기
class(welfare$income)
summary(welfare$income)
qplot(welfare$income)
qplot(welfare$income) +xlim(0,1000)

#전처리
summary(welfare$income)
welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)
table(is.na(welfare$income))
#성별 월급 평균표 만들기
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income=mean(income))
sex_income

#그래프 만들기
ggplot(data=sex_income, aes(x=sex, y=mean_income))+geom_col()

#9-3 나이와 월급의 관계-'몇 살 때 월급을 가장 많이 받을까?'
#변수 검토하기
class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)
#전처리
summary(welfare$birth) #이상치 확인
table(is.na(welfare$birth))

welfare$birth<- ifelse(welfare$birth==9999,NA,welfare$birth)  #이상치 결측 처리
table(is.na(welfare$birth))  

#파생변수 만들기-나이
welfare$age <- 2015-welfare$birth +1
summary(welfare$age)
qplot(welfare$age)

#나이에 따른 월급 평균표 만들기

age_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age) %>% 
  summarise(mean_income = mean(income))

head(age_income)

#그래프 만들기
ggplot(data=age_income, aes(x=age, y=mean_income))+geom_line()

#9-4 연령대에 따른 월급 차이-'어떤 연령대의 월급이 가장 많을까?'
welfare<-welfare %>% 
  mutate(ageg=ifelse(age<30,"young",
                     ifelse(age<=59, "middle","old")))
table(welfare$ageg)
qplot(welfare$ageg)

ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income))

ageg_income

ggplot(data=ageg_income , aes(x=ageg, y=mean_income)) + geom_col()

ggplot(data=ageg_income, aes(x=ageg, y=mean_income)) + 
  geom_col() +
  scale_x_discrete(limits=c("young","middle","old"))

#9-5 연령대 및 성별 월급 차이
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income = mean(income))
sex_income

ggplot(data= sex_income, aes(x=ageg, y=mean_income, fill=sex)) +
  geom_col() +
  scale_x_discrete(limits= c("young","middle","old"))

ggplot(data= sex_income, aes(x=ageg, y=mean_income, fill=sex)) +
  geom_col(position="dodge") +
  scale_x_discrete(limits= c("young","middle","old"))

#나이 및 성별 월급 차이 분석하기
sex_age <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age,sex) %>% 
  summarise(mean_income = mean(income))
head(sex_age)
ggplot(data=sex_age, aes(x=age, y=mean_income, col=sex)) +geom_line()

#9-6 직업별 월급 차이
class(welfare$code_job)
table(welfare$code_job)

library(readxl)
list_job <- read_excel("Koweps_Codebook.xlsx", col_names = T, sheet=2)
head(list_job)
dim(list_job)

welfare <- left_join(welfare, list_job , id="code_job")
welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)

job_income <- welfare %>% 
  filter(!is.na(job)& ! is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))
head(job_income)

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)
top10

ggplot(data=top10, aes(x=reorder(job, mean_income), y=mean_income))+
  geom_col()+
  coord_flip()   #막대를 오른쪽으로 90도 회전

bottom10 <- job_income %>%   #하위 10위 추출
  arrange(mean_income) %>% 
  head(10)
bottom10

ggplot(data=bottom10, aes(x=reorder(job, -mean_income), y=mean_income))+
  geom_col()+
  coord_flip()+
  ylim(0,850)
#9-7 성별 직업 빈도
job_male <- welfare %>%            #남성 직업 빈도 상의 10개 추출
  filter(!is.na(job) & sex == "male") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_male

job_female <- welfare %>%            #여성 직업 빈도 상의 10개 추출
  filter(!is.na(job) & sex == "female") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_female

ggplot(data=job_male , aes(x=reorder(job, n),y=n)) +
  geom_col()+
  coord_flip()

ggplot(data=job_female , aes(x=reorder(job, n),y=n)) +
  geom_col()+
  coord_flip()

#9-8 종교 유뮤에 따른 이혼율
class(welfare$religion)
table(welfare$religion)

welfare$religion <- ifelse(welfare$religion==1, "yes","no")
table(welfare$religion)

qplot(welfare$religion)

class(welfare$marriage)
table(welfare$marriage)

welfare$group_marriage <- ifelse(welfare$marriage==1,"marriage",        #이혼 여부 변수 만들기
                                 ifelse(welfare$marriage==3, "divorce",NA))
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))

qplot(welfare$group_marriage)

#종교 유무에 따른 이혼율 표 만들기
religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct= round(n/tot_group*100,1))

religion_marriage

religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  count(religion, group_marriage) %>% 
  group_by(religion) %>% 
  mutate(pct=round(n/sum(n)*100,1))

divorce <- religion_marriage %>%   #이혼 추출 
  filter(group_marriage =="divorce") %>% 
  select(religion, pct)

divorce

ggplot(data=divorce , aes(x=religion, y=pct)) + geom_col()

#연령대별 이혼율 표 만들기
ageg_marriage <- welfare
ageg_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg, group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))

ageg_marriage

#초년 제외, 이혼 추출
ageg_divorce <- ageg_marriage %>% 
  filter(ageg !="young" & group_marriage=="divorce") %>% 
  select(ageg, pct)
ageg_divorce
ggplot(data=ageg_divorce, aes(x=ageg, y=pct))+geom_col()

#연령대, 종교유무, 결혼 상태별 비율표 만들기
ageg_religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)&ageg !="young") %>% 
  group_by(ageg, religion, group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,1))
ageg_religion_marriage

#연령대 및 종교 유무별 이혼율 표 만들기
df_divorce <- ageg_religion_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(ageg, religion, pct)
df_divorce

ggplot(data=df_divorce, aes(x=ageg, y=pct, fill=religion))+
  geom_col(position="dodge")

#9-9 지역별 연령대 비율
class(welfare$code_region)
table(welfare$code_region)

#지역 코드 목록 만들기
list_region <- data.frame(code_region=c(1:7),
                         region=c("서울",
                                  "수도권(인천/경기)",
                                  "부산/경남/울산",
                                  "대구/경북",
                                  "대전/충남",
                                  "강원/충북",
                                  "광주/전남/전북/제주도"))
list_region

#지역명 변수 추가

welfare <- left_join(welfare, list_region, id="code_region")

welfare %>% 
  select(code_region,region) %>% 
  head

#지역별 연령대 비율표 만들기
region_ageg <-welfare %>% 
  group_by(region, ageg) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group=sum(n)) %>% 
  mutate(pct=round(n/tot_group*100,2))
head(region_ageg)

ggplot(data=region_ageg, aes(x=region, y=pct, fill=ageg))+
  geom_col()+
  coord_flip()

#노년층 비율 높은 순으로 막대 정렬하기
list_order_old <- region_ageg %>% 
  filter(ageg=="old") %>% 
  arrange(pct)
list_order_old

order <- list_order_old$region
order

ggplot(data=region_ageg, aes(x=region, y=pct, fill=ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits=order)

#연령대 순으로 막대 색깔 나열하기
class(region_ageg$ageg)
levels(region_ageg$ageg)

region_ageg$ageg <- factor(region_ageg$ageg,                #factor타입 변환
                           level= c("old","middle","young"))
class(region_ageg$ageg)
levels(region_ageg$ageg)

ggplot(data=region_ageg, aes(x=region, y=pct, fill=ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits=order)



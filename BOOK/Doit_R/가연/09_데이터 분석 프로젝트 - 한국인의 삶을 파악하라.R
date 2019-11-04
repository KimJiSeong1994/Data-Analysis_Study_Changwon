#####09-1 '한국복지패널데이터' 분석 준비하기#####
install.packages("foreign")

library(foreign)   #SPSS파일 불러오기
library(dplyr)     #전처리
library(ggplot2)   #시각화
library(readxl)    #엑셀 파일 불러오기


#데이터 불러오기
welfare <- read.spss(file = "C:/rtest/Doit_R/Koweps_etc/data/Koweps_hpc10_2015_beta1.sav", to.data.frame = T)  #to.data.frame = T는 SPSS파일을 df형태로 바꿈

welfare1 <- welfare

head(welfare1);tail(welfare1)
View(welfare1)
dim(welfare1)
str(welfare1)
summary(welfare1)


#변수명 바꾸기
welfare1 <- rename(welfare1,                    
                   sex = h10_g3,                #성별
                   birth = h10_g4,              #태어난 연도
                   marriage = h10_g10,          #혼인 상태
                   religion = h10_g11,          #종교
                   income = p1002_8aq1,         #월급
                   code_job = h10_eco9,         #직업코드
                   code_region = h10_reg7)      #지역코드


#데이터 분석 절차 : 변수 검토 및 전처리 -> 변수 간 관계 분석



#####09-2 성별에 따른 월급 차이 - "성별에 따라 월급이 다를까?"#####
##성별 변수 검토 및 전처리
#1.변수 검토하기
class(welfare1$sex)    #변수 타입 확인
table(welfare1$sex)    #각 범주에 몇명 있는지 확인

#2.전처리 : 코드북 정보를 참고하여 이상치 검토
table(welfare1$sex)

#이상치가 있을 경우 결측 처리
welfare1$sex <- ifelse(welfare1$sex==9,NA,welfare1$sex)
table(is.na(welfare1$sex))

#성별 항목 이름 부여
welfare1$sex <- ifelse(welfare1$sex=="1","male","female")
table(welfare1$sex)
qplot(welfare1$sex)


##월급 변수 검토 및 전처리
#1.변수 검토하기 : income변수는 연속 변수이므로 table()을 이용하면 너무 많은 항목이 출력되므로 summary()로 요약통계량을 확인해 특징 파악
class(welfare1$income)
summary(welfare1$income)
qplot(welfare1$income)
qplot(welfare1$income)+xlim(0,1000)  #xlim()으로 0~1000까지만 표현되게 설정

#2.전처리
summary(welfare1$income)             #이상치 확인, 결측치가 12030개 존재

#이상치 결측 처리(0과 9999일 때)
welfare1$income <- ifelse(welfare1$income %in% c(0,9999),NA,welfare1$income)
table(is.na(welfare1$income))


##성별에 따른 월급 차이 분석하기
sex_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income=mean(income))

ggplot(data = sex_income, aes(x=sex,y=mean_income))+geom_col()



#####09-3 나이와 월급의 관계 - "몇 살 때 월급을 가장 많이 받을까?"#####
##나이변수 검토 및 전처리
class(welfare1$birth)
summary(welfare1$birth)
qplot(welfare1$birth)

summary(welfare1$birth)         #이상치 확인 : 없음
table(is.na(welfare1$birth))    #결측치 확인 : 없음

#결측치가 있으면 이렇게 처리
#welfare1$birth <- ifelse(welfare1$birth==9999,NA,welfare1$birth)
#table(is.na(welfare1$birth))

#파생변수 만들기 - 나이
welfare1$age <- 2015-welfare1$birth+1     #태어난 연도 이용해 나이 구하기
summary(welfare1$age)
qplot(welfare1$age)


##나이와 월급의 관계 분석하기
#1.나이에 따른 월급 평균표 만들기
age_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income=mean(income))

ggplot(data=age_income,aes(x=age,y=mean_income))+geom_line()
#x축과 y축을 지정할 때 ""이거 넣으면 안 됨 ㅜㅜㅜ 



#####09-4 연령대에 따른 월급 차이 - "어떤 연령대의 월급이 가장 많을까?"#####
##연령대 변수 검토 및 처리하기
welfare1 <- welfare1 %>% 
  mutate(ageg = ifelse(age<30,"young",
                       ifelse(age<=59, "middle", "old")))
table(welfare1$ageg)
qplot(welfare1$ageg)


##연령대에 따른 월급 차이 분석하기
ageg_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income=mean(income))

ggplot(data=ageg_income,aes(x=ageg,y=mean_income))+geom_col()
ggplot(data=ageg_income,aes(x=ageg,y=mean_income))+
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))  #범주 순서 지정



#####09-5 연령대 및 성별 월급차이 - "성별 월급 차이는 연령대별로 다를까?"#####
##연령대 및 성별 월급 차이 분석하기
sex_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg,sex) %>% 
  summarise(mean_income=mean(income))

#fill=sex : 막대가 성별에 따라 다른 색으로 표현 되도록 지정
ggplot(data=sex_income,aes(x=ageg,y=mean_income,fill=sex))+ 
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))

#position="dodge" : 색깔 막대를 각각 분리
ggplot(data=sex_income,aes(x=ageg,y=mean_income,fill=sex))+ 
  geom_col(position = "dodge")+
  scale_x_discrete(limits=c("young","middle","old"))


##나이 및 성별 월급 차이 분석하기
sex_age <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income=mean(income))

ggplot(data = sex_age,aes(x=age,y=mean_income,col=sex))+geom_line()
?aes



#####09-6 직업별 월급 차이 - "어떤 직업이 월급을 가장 많이 받을까?"#####
##직업 변수 검토 및 전처리하기
class(welfare1$code_job)
table(welfare1$code_job)

#전처리 : 직업의 명칭으로 된 변수 만들고 결합
library(readxl)
list_job <- read_excel("C:/rtest/Doit_R/Data/Koweps_Codebook.xlsx",
                       col_names = T, sheet = 2)
head(list_job)
dim(list_job)

welfare1 <- left_join(welfare1,list_job,id="code_job")
welfare1 %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job,job) %>% 
  head(10)


##직업별 월급 차이 분석하기
job_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income=mean(income))

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)

ggplot(data = top10, aes(x=reorder(job, mean_income), y=mean_income,))+
  geom_col()+
  coord_flip()     #막대를 오른쪽으로 90도 회전(x축 이름이 겹치지 않게)
                   #reorder() : 값의 크기 순서대로 정렬

bottom10 <- job_income %>% 
  arrange(mean_income) %>% 
  head(10)

ggplot(data = bottom10, aes(x=reorder(job, -mean_income), y=mean_income,))+
  geom_col()+
  coord_flip()+
  ylim(0,850)      #top10그래프와 비교할 수 있도록 y축 범위를 0~850로 설정



#####09-7 성별 직업 빈도 - "성별로 어떤 직업이 가장 많을까?"#####
##성별 직업 빈도 분석하기

#남성 직업 빈도 상위 10개
job_male <- welfare1 %>% 
  filter(!is.na(job) & sex=="male") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

ggplot(data = job_male, aes(x=reorder(job,n),y=n))+
  geom_col()+
  coord_flip()

#여성 직업 빈도 상위 10개
job_female <- welfare1 %>% 
  filter(!is.na(job) & sex=="female") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

ggplot(data = job_female, aes(x=reorder(job,n),y=n))+
  geom_col()+
  coord_flip()



#####09-8 종교 유무에 따른 이혼율 - "종교가 있는 사람들이 이혼을 덜 할까?"#####
##종교 변수 검토 및 전처리하기
class(welfare1$religion)
table(welfare1$religion)

welfare1$religion <- ifelse(welfare1$religion==1,"yes","no")
table(welfare1$religion)
qplot(welfare1$religion)


##혼인 상태 변수 검토 및 전처리하기
class(welfare1$marriage)
table(welfare1$marriage)

welfare1$group_marriage <- ifelse(welfare1$marriage==1,"marriage",
                            ifelse(welfare1$marriage==3,"divorce",NA))

table(welfare1$group_marriage)
table(is.na(welfare1$group_marriage))
qplot(welfare1$group_marriage)


##종교 유무에 따른 이혼율 분석하기
religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(total=sum(n)) %>% 
  mutate(per=round(n/total*100,1))

#count()를 써서 구할수도 있음(집단별 빈도를 구하는 함수)
religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  count(religion, group_marriage) %>% 
  group_by(religion) %>% 
  mutate(per=round(n/sum(n)*100,1))

#이혼 값만 추출
divorce <- religion_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(religion,per)

ggplot(data=divorce, aes(x=religion,y=per))+geom_col()


##연령대 및 종교 유무에 따른 이혼율 분석하기
#연령대별 이혼율
ageg_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg,group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(total=sum(n)) %>% 
  mutate(per=round(n/total*100,1))

#count()를 써서 구할수도 있음
ageg_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  count(ageg,group_marriage) %>% 
  group_by(ageg) %>% 
  mutate(per=round(n/sum(n)*100,1))

#그래프
divorce1 <- ageg_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(ageg,per)

ggplot(data=divorce1,aes(x=ageg,y=per))+
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))

#연령대 및 종교 유무에 따른 이혼율 표 만들기
ageg_religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg,religion,group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(total=sum(n)) %>% 
  mutate(per=round(n/total*100,1))

#count()를 써서 구할수도 있음
ageg_religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  count(ageg,religion,group_marriage) %>% 
  group_by(ageg,religion) %>% 
  mutate(per=round(n/sum(n)*100,1))

#연령대 및 종교 유무별 이혼율 표 만들기
divorce2 <- ageg_religion_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(ageg,religion,per)

#그래프
ggplot(data = divorce2,aes(x=ageg,y=per,fill=religion))+
  geom_col(position = "dodge")



#####09-9 지역별 연령대 비율 - "노년층이 많은 지역은 어디일까?"#####
##지역 변수 검토 및 전처리하기
class(welfare1$code_region)
table(welfare1$code_region)

#지역코드 목록 만들기
list_region <- data.frame(code_region=c(1:7), 
                          region=c("서울",
                                   "수도권(인천/경기)",
                                   "부산/경남/울산",
                                   "대구/경북",
                                   "대전/충남",
                                   "강원/충북",
                                   "광주/전남/전북/제주도"))

#지역명 변수 추가
welfare1 <- left_join(welfare1,list_region,id="code_region")

welfare1 %>% 
  select(code_region,region) %>% 
  head


##지역별 연령대 비율 분석하기
region_ageg <- welfare1 %>% 
  group_by(region,ageg) %>% 
  summarise(n=n()) %>% 
  mutate(per=round(n/sum(n)*100,2))

#count()를 써서 구할수도 있음
region_ageg <- welfare1 %>% 
  count(region,ageg) %>% 
  group_by(region) %>% 
  mutate(per=round(n/sum(n)*100,2))

#그래프
ggplot(data = region_ageg,aes(x=region,y=per,fill=ageg))+
  geom_col()+
  coord_flip()

#scale_x_discrete()를 통해 정렬할 것이므로 순서 변수를 만들어야 함!!!
#노년층 비율 내림차순 정렬
list_order_old <- region_ageg %>% 
  filter(ageg=="old") %>% 
  arrange(per)

#지역명 순서 변수 만들기
order <- list_order_old$region

#그래프
ggplot(data=region_ageg,aes(x=region,y=per,fill=ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits=order)

#연령대 순으로 막대 색깔 나열 : fill파라미터에 범주(levels) 순서 지정
#현재 ageg 변수는 character타입이라 levels가 없음
class(region_ageg$ageg)
levels(region_ageg$ageg)

#factor()이용해 변환, level파라미터를 이용해 순서 지정
region_ageg$ageg <- factor(region_ageg$ageg,
                           level=c("old","middle","young"))
class(region_ageg$ageg)
levels(region_ageg$ageg)

#그래프 생성 코드 다시 실행
ggplot(data=region_ageg,aes(x=region,y=per,fill=ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits=order)

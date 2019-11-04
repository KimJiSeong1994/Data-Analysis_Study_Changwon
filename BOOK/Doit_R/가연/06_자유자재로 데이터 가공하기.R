#####06-1 데이터 전처리 - 원하는 형태로 데이터 가공#####
#dplyr : 데이터 전처리 작업에 가장 많이 사용되는 패키지
library(dplyr)



#####06-2 조건에 맞는 데이터만 추출하기#####
exam <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")

#' %>% ' : 함수들을 연결하는 기능('Ctrl'+'Shift'+'M')
exam %>% filter(class==1)     #exam에서 class가 1인 경우만 추출해 출력
exam %>% filter(class==2)

exam %>% filter(class!=1)     #1반이 아닌 경우
exam %>% filter(class!=3)


#초과,미만,이상,이하 조건 걸기
exam %>% filter(math>50)      #math가 50점을 초과한 경우
exam %>% filter(math<50)
exam %>% filter(english>=80)  #english가 80점 이상인 경우
exam %>% filter(english<=80)


#여러 조건을 충족하는 행 추출하기
exam %>% filter(class==1 & math>=50)  #1반이면서 math가 50 이상인 경우
exam %>% filter(class==2 & english>=80)


#여러 조건 중 하나 이상 충족하는 행 추출하기
exam %>% filter(math>=90 | english>=90)
exam %>% filter(english<90 | science<50)


#목록에 해당하는 행 추출하기
exam %>% filter(class==1|class==3|class==5)
exam %>% filter(class %in% c(1,3,5))  #1,3,5반에 해당하면 추출


#추출한 행으로 데이터 만들기
class1 <- exam %>% filter(class==1)
class2 <- exam %>% filter(class==2)

mean(class1$math)        #1반 수학점수 평균 구하기
mean(class2$math)        #2반 수학점수 평균 구하기



#####연습문제#####
#Q1. displ(배기량)이 4이하인 자동차와 5이상인 자동차 중 어떤 자동차의 hwy(고속도로 연비)가 평균적으로 높은지 알아보기
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
displ1 <- mpg %>% filter(displ<=4)
displ2 <- mpg %>% filter(displ>=5)
mean(displ1$hwy);mean(displ2$hwy)

#Q2. "audi"와 "toyota"중 어느 manufacturer의 cty(도시연비)가 평균적으로 높은지 알아보기
mf1 <- mpg %>% filter(manufacturer=="audi")
mf2 <- mpg %>% filter(manufacturer=="toyota")
mean(mf1$cty);mean(mf2$cty)

#Q3. "chevrolet","ford","honda"의 hwy(고속도로 연비) 평균을 구하기
mf3 <- mpg %>% filter(manufacturer %in% c("chevrolet","ford","honda"))
mean(mf3$hwy)



#####06-3 필요한 변수만 추출하기#####
exam %>% select(math)                 #math 추출
exam %>% select(english)              #english추출

exam %>% select(class,math,english)   #class,math,english 변수 추출

exam %>% select(-math)                #math 제외
exam %>% select(-math,-english)       #math, english 제외


#dplyr함수 조합하기
#class가 1인 행만 추출한 다음 english 추출
exam %>% filter(class==1) %>% select(english)

exam %>%                    #가독성 있게 줄 바꾸기
  filter(class==1) %>%      #class가 1인 행 추출
  select(english)           #english 추출

exam %>% 
  select(id, math) %>% 
  head                      #앞부분 6행까지 추출

exam %>% 
  select(id, math) %>% 
  head(10)                  #앞부분 10행까지 추출



#####연습문제2#####
#Q1. mpg데이터에서 class, cty 변수를 추출해 새로운 데이터 만들고 확인
mpg1 <- mpg %>% select(class,cty)
head(mpg1)

#Q2. 앞에서 추출한 데이터를 이용해 class가 "suv"인 자동차와 "compact"인 자동차 중에서 어떤 자동차의 cty가 높은지 구하기
mpg1_s <- mpg1 %>% filter(class=="suv")
mean(mpg1_s$cty)

mpg1_c <- mpg1 %>% filter(class=="compact")
mean(mpg1_c$cty)



#####06-4 순서대로 정렬하기#####
#오름차순으로 정렬(낮은수->높은수)
exam %>% arrange(math)         #math 오름차순 정렬

#내림차순으로 정렬(높은수->낮은수)
exam %>% arrange(desc(math))

exam %>% arrange(class,math)   #class 및 math 오름차순 정렬



#####연습문제3#####
#Q1. "audi" 자동차 중 hwy가 1~5위에 해당하는 자동차의 데이터 출력
head(mpg)
mpg %>% 
  filter(manufacturer=="audi") %>% 
  arrange(desc(hwy)) %>% 
  head(5)



#####06-5 파생변수 추가하기#####
exam %>% 
  mutate(total=math+english+science) %>% 
  head

#이렇게 기본 문법을 이용해도 되긴 된다...
#이렇게 하지 않는 이유는? : dplyr 함수는 데이터 프레임명을 반복 입력하지 않기 때문에 코드가 간결해진다는 장점이 있기 때문!
exam$total <- exam$math+exam$english+exam$science
exam

#여러 파생변수 한 번에 추가하기
exam %>% 
  mutate(total=math+english+science,
         mean=(math+english+science)/3) %>% 
  head

#mutate()에 ifelse()적용하기
exam %>% 
  mutate(test=ifelse(science>=60,"pass","fail")) %>% 
  head

#추가한 변수를 바로 dplyr코드에 활용하기
exam %>% 
  mutate(total=math+english+science) %>% 
  arrange(total) %>% 
  head



#####연습문제4#####
#Q1. mpg데이터 복사본을 만들고 cty와 hwy를 더한 '합산 연비 변수' 추가
mpg_new <- mpg
mpg_new %>% 
  mutate(sum1=cty+hwy) %>% 
  head

#Q2. '합산 연비 변수'를 2로 나눠 '평균 연비 변수' 추가
mpg_new %>% 
  mutate(mean1=(cty+hwy)/2) %>% 
  head

#Q3. '평균 연비 변수'가 가장 높은 자동차 3종 데이터 출력
mpg_new %>% 
  mutate(mean1=(cty+hwy)/2) %>% 
  arrange(desc(mean1)) %>% 
  head

#Q4. 앞 문제들을 하나로 연결된 dplyr 구문을 만들어 실행해보기
mpg_new %>% 
  mutate(sum1=cty+hwy,
         mean1=sum1/2) %>% 
  arrange(desc(mean1)) %>% 
  head

#정답: 과정 자체는 맞는데 변수를 넣어주지 않으면 저장이 안됨 ㅜㅜㅜ
#Q1. mpg데이터 복사본을 만들고 cty와 hwy를 더한 '합산 연비 변수' 추가
mpg_new <- mpg
mpg_new <- mpg_new %>% 
  mutate(sum1=cty+hwy) %>% 
  head

#Q2. '합산 연비 변수'를 2로 나눠 '평균 연비 변수' 추가
mpg_new <- mpg_new %>% 
  mutate(mean1=sum1/2) %>% 
  head

#Q3. '평균 연비 변수'가 가장 높은 자동차 3종 데이터 출력
mpg_new %>% 
  arrange(desc(mean1)) %>% 
  head(3)

#Q4. 앞 문제들을 하나로 연결된 dplyr 구문을 만들어 실행해보기
mpg_new %>% 
  mutate(sum1=cty+hwy,            #합산 변수 만들기
         mean1=sum1/2) %>%        #평균 변수 만들기
  arrange(desc(mean1)) %>%        #내림차순 정렬
  head(3)                         #상위 3행 출력



#####06-6 집단별로 요약하기#####
exam %>% summarise(mean_math=mean(math))    #집단별 math 평균 산출

exam %>% 
  group_by(class) %>%                       #class별로 분리
  summarise(mean_math=mean(math))           #집단별 math 평균 산출

exam %>% 
  group_by(class) %>%                       #class별로 분리
  summarise(mean_math=mean(math),           #math 평균
            sum_math=sum(math),             #math 합계
            median_math=median(math),       #math 중앙값
            n=n())                          #학생수

#각 집단별로 다시 집단 나누기
#회사별로 집단 나누고, 다시 구동 방식별로 나눠 도시 연비 평균 구할거~
mpg %>% 
  group_by(manufacturer, drv) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  head(10)


#dplyr조합하기
#회사별로 "suv"자동차의 cty(도시) 및 hwy(고속도로 통합 연비) 평균을 구해 내림차순으로 정리하고, 1~5위까지 출력
mpg %>% 
  group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  mutate(suv1=(cty+hwy)/2) %>% 
  summarise(suv_mean=mean(suv1)) %>% 
  arrange(desc(suv_mean)) %>% 
  head



#####연습문제5#####
#Q1.mpg데이터의 class별 cty평균 구하기
mpg %>% 
  group_by(class) %>% 
  summarise(cty_mean=mean(cty)) %>% 
  head

#Q2.cty평균이 높은 순으로 정렬해 출력
mpg %>% 
  group_by(class) %>% 
  summarise(cty_mean=mean(cty)) %>% 
  arrange(desc(cty_mean)) %>% 
  head

#Q3.hwy평균이 가장 높은 회사 세 곳을 출력
head(mpg)
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(hwy_mean=mean(hwy)) %>% 
  arrange(desc(hwy_mean)) %>% 
  head(3)

#Q4.각 회사별 "compact"(경차) 차종 수를 내림차순으로 정렬해 출력
mpg %>% 
  group_by(manufacturer) %>%
  filter(class=="compact") %>% 
  summarise(n=n()) %>% 
  arrange(desc(n))

#Q4.정답은 이거
mpg %>% 
  filter(class=="compact") %>%      #compact 추출
  group_by(manufacturer) %>%        #manufacturer별 분리
  summarise(n=n()) %>%              #빈도 구하기
  arrange(desc(n))                  #내림차순 정렬



#####06-7 데이터 합치기#####
#가로로 합치기 : dplyr패키지의 left_join() 함수 사용
test1 <- data.frame(id=c(1,2,3,4,5),
                    mid=c(60,80,70,90,85))

test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(70,83,65,95,80))

total <- left_join(test1,test2,by="id")  #기준으로 삼을 변수명을 by에 지정

#다른 데이터를 활용해 변수 추가하기
name <- data.frame(class=c(1,2,3,4,5),
                   teacher=c("kim","lee","park","choi","jung"))
exam <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")

exam_n <- left_join(exam,name,by="class")


#세로로 합치기 : bind_rows() 함수 사용
#변수명이 같아야 사용 가능. 만약 다르면 rename()써서 똑같이 맞추고 사용
group1 <- data.frame(id=c(1,2,3,4,5),
                     test=c(60,80,70,90,85))
group2 <- data.frame(id=c(6,7,8,9,10),
                     test=c(70,83,65,95,80))

group_all <- bind_rows(group1, group2)



#####연습문제6#####
mpg <- as.data.frame(ggplot2::mpg)

fuel <- data.frame(fl=c("c","d","e","p","r"),
                   price=c(2.35,2.38,2.11,2.76,2.22),
                   stringsAsFactors = F) #문자를 factor타입으로 변환 놉
                                         #f1을 mpg와 같이 문자타입으로 둠


#Q1. mpg데이터에 price(연료가격) 변수를 추가하기
head(mpg)
mpg_new <- left_join(mpg,fuel,by="fl")

#Q2. model, fl, price 변수를 추출해 앞부분 5행만 출력
select(mpg_new,"model","fl","price") %>% head(5)

#Q2. 정답은 이거
mpg_new %>% 
  select(model, fl, price) %>% 
  head(5)



#####연습문제7#####
library(ggplot2)
mid <- as.data.frame(ggplot2::midwest)
head(mid);summary(mid)

#Q1. midwest데이터에 '전체 인구 대비 미성년 인구 백분율'변수 추가
library(dplyr)
mid <- mid %>% mutate(popminor=(poptotal-popadults)/poptotal*100)

#Q2. 미성년 인구 백분율이 가장 높은 상위 5개 county(지역)의 popminor 출력
mid %>% 
  arrange(desc(popminor)) %>% 
  select(county,popminor) %>% 
  head(5)

#Q3. 뷴류표 기준에 따라 미성년 비율 등급 변수 추가, 각 등급에 몇 개 지역 있는지 알아보기
mid <- mid %>% 
  mutate(level=ifelse(popminor>=40,"large",
                      ifelse(popminor>=30,"middle","small"))) %>% 
  group_by(level) %>% 
  summarise(n=n())

#Q3. 정답은 이거. group_by를 쓰고 mid에 다시 저장하면 data가 그룹으로 묶여서 3obs. of 2 variables로 바뀌기 때문ㅜㅡㅜ
mid <- mid %>% 
  mutate(level=ifelse(popminor>=40,"large",
                        ifelse(popminor>=30,"middle","small")))

table(mid$level)

#Q4. '전체 인구 대비 아시아인 인구 백분율' 변수 추가하고 하위 10개 지역의 state와 county, 아시아인 백분율을 출력
mid %>% 
  mutate(alevel=(popasian/poptotal)*100) %>% 
  arrange(alevel) %>% 
  select(state,county,alevel) %>% 
  head(10)
#####08-1 R로 만들 수 있는 그래프 살펴보기#####
#ggplot2 패키지로 쉽게 그래프를 만들 수 있음
install.packages("ggplot2")
library(ggplot2)



#####08-2 산점도 - 변수 간 관계 표현하기#####
#ggplot2의 레이어 구조 : 배경 설정(축) - 그래프 추가(점, 막대, 선) - 설정 추가(축 범위, 색, 표식)

#배경 설정하기
#x축은 displ, y축은 hwy로 지정해 배경 설정
ggplot(data = mpg, aes(x=displ,y=hwy))


#그래프 추가하기
#ggplot2패키지 함수들은 "+"기호로 연결(dplyr은 "%>%" 으로 연결)
#산점도를 그리는 함수 : geom_point()
ggplot(data = mpg, aes(x=displ,y=hwy))+geom_point()


#축 범위를 조정하는 설정 추가하기
#xlim()과 ylim()을 이용해 지정

#x축 범위 3-6으로 지정
ggplot(data = mpg, aes(x=displ,y=hwy))+geom_point()+xlim(3,6)

#x축 범위 3-6, y축 범위 10-30으로 지정
ggplot(data = mpg,aes(x=displ,y=hwy))+
  geom_point()+
  xlim(3,6)+
  ylim(10,30)


#qplot() : 전처리 단계에 간단하게 확인(문법이 간단해서)
#ggplot() : 최종 결과 보고 위해 그래프 만들 때 사용



#####연습문제#####
#Q1. mpg데이터에서 x축 cty, y축 hwy로 된 산점도 만들기
ggplot(data = mpg, aes(x=cty,y=hwy))+geom_point()

#Q2.midwest 데이터에서 x축은 poptotal, y축은 popasian으로 된 산점도를 만들기. 전체인구는 50만 명 이하, 아시아인 인구는 1만명 이하인 지역만 표시하기.
#축을 정수로 표현하려면 options(scipen=99) 실행 후 그래프 만들면 됨. options(scipen=0) 실행하면 다시 지수로 표현됨
ggplot(data=midwest, aes(x=poptotal,y=popasian))+
  geom_point()+
  xlim(0,500000)+
  ylim(0,10000)



#####08-3 막대 그래프 - 집단 간 차이 표현하기#####
#평균 막대 그래프 만들기 : geom_col()로 막대 그래프 만듦
install.packages("dplyr")
library(dplyr)

df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))

ggplot(data = df_mpg, aes(x=drv,y=mean_hwy))+geom_col()

#크기 순으로 정렬하기 : reorder() 사용(x축 변수, 정렬 기준으로 삼을 변수)
ggplot(data = df_mpg, aes(x=reorder(drv,-mean_hwy),y=mean_hwy))+geom_col()


#빈도 막대그래프 만들기 : geom_bar() 사용, x축만 지정
ggplot(data = mpg, aes(x=drv))+geom_bar()
ggplot(data = mpg, aes(x=hwy))+geom_bar()

#geom_col() : 요약표를 사용해 그래프 만듦
#geom_bar() : 원자료를 사용해 그래프 만듦



#####연습문제2#####
#Q1. "suv"차종 대상으로 평균 cty가 가장 높은 회사 다섯 곳을 막대 그래프로 표현. 막대는 연비가 높은 순으로 정렬
df_mpg1 <- mpg %>% 
  filter(class=="suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)

ggplot(data = df_mpg1, aes(x=reorder(manufacturer,-mean_cty),y=mean_cty))+geom_col()

#Q2. class(자동차 종류별) 빈도를 표현한 막대 그래프 만들기
ggplot(data = mpg, aes(x=class))+geom_bar()



#####08-4 선 그래프 - 시간에 따라 달라지는 데이터 표현하기#####
#시계열 그래프 만들기 : geom_line() 사용
ggplot(data = economics, aes(x=date,y=unemploy))+geom_line()  #x는 시간, y는 실업자 수



#####연습문제3#####
#Q1. date(시간)에 따른 psavert(개인 저축률) 변화를 나타낸 시계열 그래프 만들기
ggplot(data = economics, aes(x=date,y=psavert))+geom_line()



#####08-5 상자 그림 - 집단 간 분포 차이 표현하기#####
#상자 그림 만들기 : geom_boxplot() 사용
ggplot(data = mpg, aes(x=drv,y=hwy))+geom_boxplot()

#ggplot 패키지 사용법 : help -> Cheatsheets -> Data Visualization with ggplot2
#사용자들이 만든 그래프와 코드 참고 : THE R GRAPH GALLERY(bit.ly/2s5cmdc)
#확장 패키지들 : ggplot2 extensions(bit.ly/2pqzga)



#####연습문제4#####
#Q1. class(자동차 종류)가 "compact","subcompact","suv"인 자동차의 cty를 나타낸 상자 그림 만들기
df_mpg2 <- mpg %>% 
  filter(class=="compact"|class=="subcompact"|class=="suv")

ggplot(data = df_mpg2, aes(x=class,y=cty))+geom_boxplot()  

#Q1. 정답은 이거
df_mpg2 <- mpg %>% 
  filter(class %in% c("compact","subcompact","suv"))

ggplot(data = df_mpg2, aes(x=class,y=cty))+geom_boxplot() 
#####03-1 변하는 수, '변수' 이해하기#####

#변수(Variable) : 데이터 분석의 대상, 다양한 값을 지니고 있는 하나의 속성
#상수(Constant) : 하나의 값으로만 되어 있는 속성


a <- 1
b <- 2
c <- 3
d <- 3.5
a+b
a+b+c
4/b
5*b

#여러 값으로 구성된 변수 만들기
var1 <- c(1,2,5,7,8)
var2 <- c(1:5)           #1~5까지 연속 값으로 var2 생성
var3 <- seq(1,5)         #1~5까지 연속 값으로 var3 생성
var4 <- seq(1,10,by=2)   #1~10까지 2간격 연속 값으로 var4 생성
var5 <- seq(1,10,by=3)
var1+2
var1+var2
var4+var5
var1+var2+var3

str1 <- "a"              #따옴표 없으면 1으로 입력 및 출력됨...
str2 <- "text"
str3 <- "Hello World!"
str4 <- c("a","b","c")
str5 <- c("Hello!","World","is","good!")
str1+2                   #문자 변수는 연산 불가



#####03-2 마술 상자 같은 '함수' 이해하기#####

#함수 -> 함수이름 + 괄호 

#mean() : 평균을 구하는 함수
x <- c(1,2,3)
mean(x)

#max() / min() : 최댓값/최솟값을 구하는 함수
max(x)
min(x)

#paste() : 여러 문자를 합쳐 하나로 만드는 함수
str5
paste(str5, collapse = ",")    #쉼표를 구분자로 단어들 하나로 합치기
paste(str5, collapse = " ")    #collapse같은 명령어 = 파라미터/매개변수

x_mean <- mean(x)
str5_paste <- paste(str5, collapse = " ")



#####03-3 함수 꾸러미, '패키지' 이해하기#####

library(ggplot2)
x <- c("a","a","b","c")
qplot(x)                       #빈도 막대 그래프 출력

#ggplot2의 mpg 데이터로 그래프 만들기
qplot(data=mpg,x=hwy)
qplot(data=mpg,x=cty)
qplot(data=mpg,x=drv,y=hwy)

#x축 drv, y축 hwy, 선 그래프 형태
qplot(data=mpg,x=drv,y=hwy,geom="line")

#x축 drv, y축 hwy, 상자 그림 형태
qplot(data=mpg,x=drv,y=hwy,geom="boxplot")

#x축 drv, y축 hwy, 상자 그림 형태, drv별 색 표현
qplot(data=mpg,x=drv,y=hwy,geom="boxplot",colour=drv)

#qplot 함수 매뉴얼 출력
?qplot



#####연습문제#####
#Q1 시험 점수 변수 만들고 출력하기 : 다섯 명의 학생이 시험을 봤습니다. 학생들의 시험 점수를 담고 있는 변수를 만들어 출력하시오. 시험 점수는 다음과 같다. -> 80,60,70,50,90
score <- c(80,60,70,50,90)

#Q2 전체 평균 구하기 : 앞의 변수를 이용해 전체 평균 점수 구하기
mean(score)

#Q3 전체 평균 변수 만들고 출력하기 : 전체 평균을 새 변수로 만들어 출력
avr_score <- mean(score)
x <- c(1,3,2,5)
x
x= c(1,6,2)

x
y= c(1,4,3)
length(x)
length(y)
x+y
ls()
rm(x,y)
ls()
str1 <- "a"              
str2 <- "text"
str3 <- "Hello World!"
str4 <- c("a","b","c")
str5 <- c("Hello!","World","is","good!")

# 마술상자같은 '함수' 이해하기 
#########################################
# 변수 만들기 
x <- c(1,2,3)
x
#함수 적용하기 
mean(x)

max(x)
min(x)
#문자를 다루는 함수 이용하기 
str5
paste(str5, collapse = ",")# 쉼표를 구분자로 str5의 단어들 하나로 합치기 

#함수의 옵션 설정하기 -파라미터 
paste(str5, collapse = " ")
#함수의 결과물로 새변수 만들기 
x_mean <- mean(x)
x_mean
str_paste <- paste(str5, collapse = " ")
str_paste
######################################
#함수 꾸러미, '패키지 이해하기 
#ggplot2 설치하기
#install.packages("ggplot2)
library(ggplot2)
#함수 사용하기 
x <- c('a','a','b','c')
x
#빈도 막대 그래프 출력 
qplot(x)

#ggplot2의 mpg데이터로 그래프 만들기 

# data에 mpg,x축에 hwy 변수 지정해 그래프 생성 
qplot(data = mpg,x =hwy)
#x축 cty
qplot(data = mpg,x= cty)
#x축 dry, y축 hwy
qplot(data = mpg ,x = drv ,y= hwy)
#x축 dry, y축 hwy ,선그래프 형태
qplot(data = mpg ,x = drv ,y= hwy, geom = 'line')
#x축 dry, y축 hwy ,상자그림형태 
qplot(data = mpg ,x = drv ,y= hwy, geom = 'boxplot')
#x축 dry, y축 hwy ,상자그림형태,drv별 색 표현 
qplot(data = mpg ,x = drv ,y= hwy, geom = 'boxplot',colour = drv)

#문제 

#시험 점수 변수 만들고 출력 하기
test <- c(80,60,70,50,90)
# 전체 평균 구하기
mean(test)

#전체 평균 변수 만들고 출력하기
t <- mean(test)
t
########################################
#######################################
#
# 데이터 프레임 만들기 
#1.변수 만들기 
english <- c(90,80,60,70)#영어 점수 변수 생성 
english
math <- c(50,60,100,20)
math
########
df_midterm <- data.frame(english, math)
df_midterm
# 정보추가 
class <- c(1,1,2,2)
class
df_midterm <- data.frame(english, math,class)
df_midterm
#분석하기 
mean(df_midterm$english)
mean(df_midterm$math)
#데이터프레임 한 번에 만들기
df_midterm <- data.frame(english = c(90,80,60,70),
                         math = c(50,60,100,20),
                         class = c(1,1,2,2))
df_midterm
#문제 
df_f <- data.frame(제품 = c("사과","딸기","수박"),
                     가격 = c(1800,1500,3000),
                     판매량 = c(24,38,13))
mean(df_f$가격)
mean(df_f$판매량)

#####################
#외부데이터 이용하기
install.packages('readxl')
library(readxl)
#엑셀파일 불러오기 
cpwd
df_exam <- read_excel("C:/pytest/excel_exam.xlsx")
df_exam

mean(df_exam$english)
mean(df_exam$science)
#엑셀 첫번째 행이 변수명이아닐때 
df_exam_novar <- read_excel("C:/pytest/excel_exam_novar.xlsx")
df_exam_novar <- read_excel("C:/pytest/excel_exam_novar.xlsx",col_names = F)
#엑셀파일에 시트가 여러개 있을경우 
df_exam_sheet <- read_excel("C:/pytest/excel_exam_sheet.xlsx",sheet = 3)
#csv파일 불러오기 
df_csv_exam <- read.csv("C:/pytest/csv_exam.csv")
#문자가 들어있는 파일 
df_csv_exam <- read.csv("C:/pytest/csv_exam.csv",stringsAsFactors=F)
#데이터 프레임 만들기 
df_midterm
#csv파일로 저장 
write.csv(df_midterm, file = "df_midterm.csv")
#rdata 파일로저장 
save(df_midterm,file = "df_midterm.rda")
#rdata 파일 불러오기 
rm(df_midterm)
df_midterm
load("df_midterm.rda")









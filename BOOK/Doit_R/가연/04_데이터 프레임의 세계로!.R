#####04-1 데이터는 어떻게 생겼나? - 데이터 프레임 이해하기#####

#데이터 프레임 : 행과 열로 구성된 사각형 모양의 표처럼 생김
#열(Column/variable) : 세로로 나열, 속성을 나타냄
#행(row/case) : 가로로 나열, 각 사람에 대한 정보를 보여줌



#####04-2 데이터 프레임 만들기 - 시험성적 데이터 만들기#####

#변수 만들기
eng <- c(90, 80, 60, 70 )       #영어 점수 변수 생성
math <- c(50,60,100,20)     #수학 점수 변수 생성

#데이터 프레임 만들기 : 'data.frame()' 이용
df_midterm <- data.frame(eng,math)

#학생의 반 정보 추가
class <- c(1,1,2,2)
df_midterm <- data.frame(eng,math,class)

#분석
#'$'는 데이터 프레임 안의 변수를 지정할 때 사용
mean(df_midterm$eng)        #df_midterm의 eng로 평균 산출
mean(df_midterm$math)       #df_midterm의 math로 평균 산출

#데이터 프레임 한 번에 만들기
df_midterm <- data.frame(eng=c(90,80,60,70),
                         math=c(50,60,100,20),
                         class=c(1,1,2,2))


#####연습문제#####
#Q1.다음 표의 내용을 데이터 프레임으로 만들어 출력하시오.
df_ff <- data.frame(제품 = c("사과","딸기","수박"),
                      가격 = c(1800,1500,3000), 
                      판매량 = c(24,38,13))

df_ft <- data.frame(name=c("사과","딸기","수박"),
                     price=c(1800,1500,3000),
                     volume=c(24,38,13))

#Q2. 가격평균, 판매량 평균을 구해보시오.
mean(df_f$가격)
mean(df_f$판매량)
mean(df_ff$price)
mean(df_ff$volume)



#####04-3 외부 데이터 이용하기 - 축적된 시험 성적 데이터를 불러오기#####

#엑셀파일 불러오기
library(readxl)
df_exam <- read_excel("C:\\rtest\\Doit_R\\Data\\excel_exam.xlsx")

getwd()
setwd(/Users/data_analysis/Desktop/project_1)

#분석
mean(df_exam$english)
mean(df_exam$science)

#엑셀파일 첫 번째 행이 변수명이 아닐 경우 : 'col_names=F' 파라미터 설정
df_n <- read_excel("C:/rtest/Doit_R/Data/excel_exam_novar.xlsx")
df_n <- read_excel("C:/rtest/Doit_R/Data/excel_exam_novar.xlsx",col_names = F)

#엑셀파일에 시트가 여러 개 있을 경우 : 'sheet=' 파라미터 이용
df_s <- read_excel("C:/rtest/Doit_R/Data/excel_exam_sheet.xlsx",sheet=3)


#CSV파일 불러오기
#첫 번째 행에 변수명이 없는 경우 : 'header=F' 사용
#문자가 들어있는 파일 불러올 때 : 'stringsAsFactors=F' 사용
df_csv <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")


#데이터 프레임을 CSV파일로 저장 : write.csv()
write.csv(df_midterm, file="df_midterm.csv")

#데이터 프레임을 RData파일로 저장 : save()
save(df_midterm,file = "df_midterm.rda")

#RData파일 불러오기 : load()
rm(df_midterm)
load("df_midterm.rda")     #새 변수에 할당 하지 않아도 자동 저장 됨
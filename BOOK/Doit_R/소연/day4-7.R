##데이터 프레임 data.frame()
english <- c(90,80,60,70)
math <- c(50,60,100,20)
df_midterm <- data.frame(english,math)
class <-c(1,1,2,2)
df_midterm <- data.frame(english,math,class)
df_midterm
mean(df_midterm$english) #df_midterm의 english로 평균 산출
mean(df_midterm$math)

##혼자서 해보기
product <- c("사과","딸기","수박")
price <- c(1800,1500,3000)
sell <- c(24,38,13)
sales <- data.frame(product,price,sell)
sales
#외부 데이터 이용하기
library(readxl) #엑셀 파일 불러오기
df_exam <- read_excel("excel_exam.xlsx")
df_exam
mean(df_exam$english)
mean(df_exam$science)
df_exam_novar <- read_excel("excel_exam_novar.xlsx")
df_exam_novar
df_exam_novar <- read_excel("excel_exam_novar.xlsx",col_names=F) #col_names=F : 첫 번째 행을 변수명이 아닌 데이터로 인식
df_exam_novar
#엑셀 파일에 여러개의 시트가 있을때
df_exam_sheet <- read_excel("excel_exam_sheet.xlsx",sheet=3)
df_exam_sheet
#csv파일 불러오기
df_csv_exam <- read.csv("csv_exam.csv")
#데이터 프레임을 csv파일로 저장하기
df_midterm<- data.frame(engish=c(90,80,60,70),
                        math=c(50,60,100,20),
                        class=c(1,1,2,2))
df_midterm
write.csv(df_midterm,file="df_midterm.csv")
#데이터 프레임을 RData 파일로 저장하기
save(df_midterm, file="df_midterm.rda") #save()를 이용해 데이터프레임을.rda파일로 저장장
#RData 파일 불러오기 <-load()이용
rm(df_midterm) #앞에서 만든 df_midterm 삭제
df_midterm
load("df_midterm.rda")
df_midterm

##데이터 분석 기초
exam<-read.csv("csv_exam.csv")
exam
head(exam) #앞에서부터 6행까지 출력
head(exam,10) # 앞에ㅓ부터 10행까지 출력
tail(exam) #뒤에서부터 6행까지 출력
tail(exam,10)
View(exam) #데이터 뷰어 창에서 확인
dim(exam)
str(exam)
summary(exam)
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg) #ggplot2의 mpg데이터를 데이터 프레임 형태로 불러오기
head(mpg)
dim(mpg)
str(mpg)
summary(mpg)
df_raw <- data.frame(var1=c(1,2,1),
                     var2=c(2,3,2))
df_raw
library(dplyr)  #rename()을 이용할때 사용하는 패키지
df_new<-df_raw
df_new
df_new <-rename(df_new, v2=var2)  # var2를 v2로 수정
df_new
##혼자서해보기
mpg<-as.data.frame(ggplot2::mpg)
mpg_new <- mpg
mpg_new<-rename(mpg_new, city=cty, highway=hwy)
mpg_new
#파생변수 만들기
df <- data.frame(var1=c(4,3,8),
                 var2=c(2,6,1))
df
df$var_sum <- df$var1 + df$var2 # var_sum 파생변수 생성
df
df$var_mean <- (df$var1 + df$var2)/2  # var_mean 파생변수 생성
df
mpg$total <- (mpg$cty + mpg$hwy)/2
mpg
head(mpg)
mean(mpg$total)
summary(mpg$total)
hist(mpg$total)
ifelse(mpg$total >=20, "pass","fail")
mpg$test <- ifelse(mpg$total >=20,"pass","fail")
mpg
head(mpg)
table(mpg$test)
qplot(mpg$test)
mpg$grade <- ifelse(mpg$total>=30,"A",
                    ifelse(mpg$total>=20,"B","C"))
mpg
table(mpg$grade)
qplot(mpg$grade)
mpg$grade2 <-ifelse(mpg$total>=30,"A",
                    ifelse(mpg$total>=25,"B",
                           ifelse(mpg$total>=20,"C","D")))
mpg
##123분석도전
midwest<-as.data.frame(ggplot2::midwest)
head(midwest)
midwest_new<-midwest
midwest_new<-rename(midwest_new,total=poptotal,asian=popasian)
midwest_new
midwest_new$ratio<-midwest_new$asian/midwest_new$total*100
head(midwest_new)
hist(midwest_new$ratio)
mean(midwest_new$ratio)
midwest_new$test<-ifelse(midwest_new$ratio>0.4872462,"large","small")
table(midwest_new$test)
qplot(midwest_new$test)

###데이터 가공하기

exam<-read.csv("csv_exam.csv")
head(exam)
exam
exam %>% filter(class==1)  #class가 1인 경우만 추출해 출력
exam %>% filter(class==2)
exam %>% filter(class!=1)  #class가 1이 아닌경우
exam %>% filter(math>50)
exam %>% filter(math<=50)
exam %>% filter(class==1 & math>=50)
exam %>% filter(class==2 & english>=80)
exam %>% filter(math>=90 | english>=90)
exam %>% filter(english<90 | science<50)
exam %>% filter(class==1 | class==3 | class==5)
exam %>% filter(class %in% c(1,3,5)) # %in% : 변수의 값이 지정한 조건 목록에 해당하는지 확인하는 기능
class1<-exam %>% filter(class==1)
class1
class2<-exam %>% filter(class==2)
mean(class1$math)
mean(class2$math)

##혼자서 해보기
displ1<-mpg %>% filter(displ<=4)
displ2<-mpg %>% filter(displ>5)
mean(displ1$hwy)
mean(displ2$hwy)
manu_a <- mpg %>% filter(manufacturer=="audi")
manu_t <- mpg %>% filter(manufacturer=="toyota")
mean(manu_a$cty)
mean(manu_t$cty)
manu <- mpg %>% filter(manufacturer %in% c("chevrolet","ford","honda"))
mean(manu$hwy)
exam %>% select(math)
exam
exam %>% select(class,math,english)
exam %>% select(-math) #math 제외
exam %>%
  filter(class==1) %>%
  select(english)
exam %>%
  select(id,math) %>% 
  head
exam %>%
  select(id,math) %>% 
  head(10)
mpg_a<-mpg %>%
  select(class,cty)
class_suv<-mpg_a %>% 
  filter(class=="suv")
class_compact<-mpg_a %>% 
  filter(class=="compact")
mean(class_suv$cty)
mean(class_compact$cty)

#arrange() 순서대로 정렬하기
exam %>% arrange(math)
exam %>% arrange(desc(math))  #내림차순으로 정렬
exam %>% arrange(class,math)
mpg %>% filter(manufacturer=="audi") %>% 
  arrange(desc(hwy)) %>%
  head(5)
#mutate() 파생변수 추가하기
exam %>% 
  mutate(total=math+english+science) %>%
  head
exam %>% 
  mutate(total=math+english+science,
         mean=total/3)%>%
  head  
#mutate()에 ifelse() 적용하기
exam %>% 
  mutate(test=ifelse(science>=60,"pass","fail")) %>% 
  head
exam %>%
  mutate(total=math+english+science) %>% 
  arrange(total)
##혼자서 해보기
mpg<-as.data.frame(ggplot2::mpg)
mpg_new<-mpg
mpg_new %>% 
  mutate(total=cty+hwy) %>% 
  mutate(mean=total/2) %>% 
  arrange(desc(mean)) %>% 
  head(3)
#group_by() ,summarise() 집단별로 요약하기
exam %>% 
  summarise(mean_math=mean(math)) #math 평균 산출
exam
exam %>% 
  group_by(class) %>% 
  summarise(math_mean=mean(math))
exam %>% 
  group_by(class) %>%
  summarise(math_mean=mean(math), 
            sum_math=sum(math),
            median_math=median(math),
            n=n()) #학생수
##혼자서 해보기 p150
mpg
mpg %>% 
  group_by(manufacturer,drv) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  head(10)
mpg %>%
  group_by(manufacturer) %>%
  filter(class=="suv") %>% 
  mutate(tot=(cty+hwy)/2) %>% 
  summarize(mean_ch=mean(tot)) %>% 
  arrange(desc(mean_ch)) %>% 
  head(5)
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty))
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty))

mpg %>% 
  group_by(manufacturer) %>%
  summarise(mean_hwy=mean(hwy)) %>% 
  arrange(desc(mean_hwy)) %>% 
  head(3)
mpg %>% 
  filter(class=="compact") %>% 
  group_by(manufacturer) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n))

#데이터 합치기
test1<-data.frame(id=c(1,2,3,4,5),
                  midterm=c(60,80,70,90,85))
test2<-data.frame(id=c(1,2,3,4,5),
                  final=c(70,83,65,95,80))
test1
test2
total<-left_join(test1,test2,by="id") #데이터 가로로 합치기
name<-data.frame(class=c(1,2,3,4,5),
                 teacher=c("kim","lee","park","choi","jung"))
name
exam
exam_new<-left_join(exam,name,by="class")
exam_new
group_a<-data.frame(id=c(1,2,3,4,5),
                    test=c(60,70,80,90,85))
group_b<-data.frame(id=c(6,7,8,9,10),
                    test=c(70,83,65,95,80))
group_total<-bind_rows(group_a,group_b)
group_total
fuel<-data.frame(fl=c("c","d","e","p","r"),
                 price_fl=c(2.35, 2.38, 2.11, 2.76, 2.22),
                 stringsAsFactors = F)
fuel
mpg
mpg_new<-left_join(mpg,fuel,by="fl")
mpg_new
mpg_new %>% 
  select(model,fl,price_fl)
##데이터 정제
#빠진 데이터,이상한 데이터 제거하기
df<-data.frame(sex=c("M","F",NA,"M","F"),
               score=c(5,4,3,4,NA))
df
is.na(df)
table(is.na(df))
table(is.na(df$sex))
table(is.na(df$score))
mean(df$score)
mean(df$sex)
df %>% filter(is.na(score)) #score가 NA인 데이터만 출력
df %>% filter(!is.na(score)) #결측치 제거
df_nomiss<-df %>% filter(!is.na(score))
mean(df_nomiss$score)
sum(df_nomiss$score)
df_nomiss<-df %>% filter(!is.na(score)& !is.na(sex))
df_nomiss

#na.omit() 결측치가 있는 행을 한번에 제거
df_nomiss2<- na.omit(df) #모든 변수에 결측치 없는 데이터 추출
df_nomiss2
mean
mean(df$score,na.rm=T)
sum(df$score,na.rm=T)
exam<-read.csv("csv_exam.csv")
exam[c(3,8,15),"math"] <- NA #3,8,15행의 math에 NA할당
exam
exam %>% summarise(mean_math=mean(math))
exam %>% summarise(mean_math=mean(math,na.rm = T))
exam %>% summarise(mean_math=mean(math,na.rm = T),
                   sum_math=sum(math,na.rm = T),
                   median_math=median(math,na.rm = T))
mean(exam$math,na.rm=T)
exam$math <-ifelse(is.na(exam$math),55,exam$math) #math가 NA면 55로 대체
table(is.na(exam$math))
exam
mean(exam$math)
##혼자서 해보기
mpg<-as.data.frame(mpg)
mpg[c(65,124,131,153,212),"hwy"]<-NA
head(mpg)
table(is.na(mpg$drv))
table(is.na(mpg$hwy))
mpg %>% filter(!is.na(mpg$hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))
##이상치 정제하기
outlier <-data.frame(sex=c(1,2,1,3,2,1),
                     score=c(5,4,3,4,2,6))
outlier
table(outlier$sex)
table(outlier$score)
outlier$sex<-ifelse(outlier$sex==3,NA,outlier$sex) #sex가 3이면 NA할당
outlier
outlier$score<-ifelse(outlier$score>5,NA,outlier$score) #score가 5이상이면 NA할당
outlier
outlier %>% 
  filter(!is.na(outlier$sex) & !is.na(outlier$score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score=mean(score))
boxplot(mpg$hwy)
boxplot(mpg$hwy)$stats #상자 그림 통계치 출력
mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy >37 , NA, mpg$hwy )
table(is.na(mpg$hwy))
mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm=T))
##혼자서 해보기
mpg<-as.data.frame(ggplot2::mpg)
mpg[c(10,14,58,93),"drv"]<-"k"
mpg[c(29,43,129,203),"cty"]<-c(3,4,39,42)
table(mpg$drv)
mpg$drv <- ifelse(mpg$drv=="k",NA, mpg$drv)
table(mpg$drv)
mpg$drv<-ifelse(mpg$drv %in% c("4","f","r"), mpg$drv, NA)
table(mpg$drv)
boxplot(mpg$cty)
boxplot(mpg$cty)$stats
mpg$cty <- ifelse(mpg$cty <9 | mpg$cty>26, NA, mpg$cty)
boxplot(mpg$cty)
mpg_new %>%
  filter(!is.na(mpg$drv) & !is.na(mpg$cty)) %>% 
  group_by(drv) %>% 
  summarise(mean_cty=mean(cty))
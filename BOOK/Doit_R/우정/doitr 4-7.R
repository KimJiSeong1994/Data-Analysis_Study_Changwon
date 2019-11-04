english<-c(90,80,60,70)
math<-c(50,60,100,20)
df_midterm<-data.frame(english,math)
df_midterm
class<-c(1,1,2,2)
df_midterm<-data.frame(english,math,class)
df_midterm
mean(df_midterm$english)
mean(df_midterm$math)
df_midterm<-data.frame(english=c(90,80,60,70),
                       math=c(50,60,100,20),
                       class=c(1,1,2,2))
df_midterm
df_fruit<-data.frame(fruit=c("사과","딸기","수박"),
                     price=c(1800,1500,3000),
                     sales=c(24,38,13))
mean(df_fruit$price)
mean(df_fruit$sales)
df_fruit
library("readxl")
setwd("C:/easy_r")
df_exam<-read_excel("excel_exam.xlsx")
df_exam
mean(df_exam$english)
mean(df_exam$science)
df_exam_novar<-read_excel("excel_exam_novar.xlsx",col_names=F)
df_exam_novar
df_exam_sheet<-read_excel("excel_exam_sheet.xlsx",sheet=3)
df_exam_sheet
df_csv_exam<-read.csv("csv_exam.csv",stringsAsFactors = F)
df_csv_exam
df_midterm<-data.frame(english=c(90,80,60,70),
                       math=c(50,60,100,20),
                       class=c(1,1,2,2))
df_midterm
write.csv(df_midterm,file="df_midterm.csv")
save(df_midterm,file="df_midterm.rda")
rm(df_midterm)
df_midterm
load("df_midterm.rda")
df_midterm
exam<-read.csv("csv_exam.csv")
head(exam)
head(exam,10)
tail(exam)
View(exam)
dim(exam)
str(exam)
summary(exam)
library("ggplot2")
mpg<-as.data.frame(ggplot2::mpg)
head(mpg)
tail(mpg)
dim(mpg)
str(mpg)
summary(mpg)
df_raw<-data.frame(var=c(1,2,1),
                   var2=c(2,3,2))
df_raw
#install.packages("dplyr")
library(dplyr)
df_new<-df_raw
df_new
df_new<-rename(df_new,v2=var2)
df_new
df_raw
mpg1<-mpg
mpg1
mpg1<-rename(mpg1,city=cty,highway=hwy) 
mpg1
df<-data.frame(var1=c(4,3,8),
               var2=c(2,6,1))
df
df$var_sum<-df$var1+df$var2
df
df$var_mean<-(df$var1+df$var2)/2
df
mpg$total<-(mpg$cty+mpg$hwy)/2
head(mpg)
mean(mpg$total)
summary(mpg$total)
hist(mpg$total)
mpg$test<-ifelse(mpg$total>=20,"pass","fail")
head(mpg)
tail(mpg)
table(mpg$test)
library(ggplot2)
qplot(mpg$test)
mpg$grade<-ifelse(mpg$total>=30,"A",
                  ifelse(mpg$total>=20,"B","C"))
head(mpg,20)
table(mpg$grade)
qplot(mpg$grade)
mpg$grade2<-ifelse(mpg$total>=30,"A",
                   ifelse(mpg$total>=25,'B',
                          ifelse(mpg$total>=20,"C","D")))

midwest<-as.data.frame(ggplot2::midwest)
head(midwest,10)
midwest<-rename(midwest,total=poptotal,asian=popasian)
head(midwest,10)
midwest$percent<-(midwest$asian/midwest$total)*100
hist(midwest$percent)
midwest$average<-ifelse(midwest$percent>mean(midwest$percent),"large","small")
table(midwest$average)
qplot(midwest$average)
library(dplyr)
exam<-read.csv("csv_exam.csv")
exam %>% filter(class==1)
exam %>% filter(class==2)
exam %>% filter(class!=1)
exam %>% filter(class!=3)
exam %>% filter(math>50)
exam %>% filter(math<50)
exam %>% filter(english>=80)
exam %>% filter(english<=80)
exam %>% filter(class==1 & math>=50)
exam %>% filter(class==2 & english>=80)
exam %>% filter( math>=90 | english>=90 )
exam %>% filter( english<90 | science<50 )
exam %>% filter(class==1| class==3 | class==5)
exam %>% filter(class %in% c(1,3,5))
class1 <- exam %>% filter(class==1)
class2 <- exam %>% filter(class==2)
mean(class1$math)
mean(class2$math)
head(mpg)
mpg1<- mpg %>% filter(displ<=4)
mpg2<- mpg %>% filter(displ>=5)
mean(mpg1$hwy)
mean(mpg2$hwy)
mpg3<- mpg %>% filter(manufacturer=="audi")
mpg4<- mpg %>% filter(manufacturer=="toyota")
mean(mpg3$cty)
mean(mpg4$cty)
mpg5<-mpg %>% filter(manufacturer %in% c("chevrolet","ford","honda"))
mean(mpg5$hwy)
exam %>% select(math)               
exam %>% select(english)
exam %>% select(class,math,english)
exam %>% select(-math)
exam %>% select(-math,-english)
exam %>% filter(class==1) %>% select(english)
exam %>% 
  filter(class==1) %>% 
  select(english)
exam %>% 
  select(id,math) %>% 
  head
exam %>% 
  select(id,math) %>% 
  head(10)
exam %>% arrange(math)
exam %>% arrange(desc(math))
exam %>% arrange(class,math)
mpg %>% 
  filter(manufacturer=="audi")%>% 
  arrange(desc(hwy))%>% 
  head(5)
exam %>% 
  mutate(total= math+english+science) %>% 
  head
exam %>% 
  mutate(total= math+english+science,
         mean=(math+english+science)/3) %>% 
  head
exam %>% 
  mutate(test= ifelse(science>=60,"pass","fail")) %>% 
  head
exam %>% 
  mutate(total=math+english+science) %>% 
  arrange(total) %>% 
  head
mpg_1<-mpg
mpg_1 %>%
  mutate(total=cty+hwy) %>% 
  head
mpg_1 %>%
  mutate(total=cty+hwy,
         mean=(cty+hwy)/2) %>% 
  arrange(desc(mean)) %>% 
  head(3)
exam %>% summarise(mean_math = mean(math))
exam %>% 
  group_by(class) %>% 
  summarise(mean_math =mean(math))
exam %>% 
  group_by(class) %>% 
  summarise(mean_math =mean(math),
            sum_math=sum(math),
            median_math=median(math),
            n=n())
head(mpg)
mpg %>% 
  group_by(manufacturer,drv) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  head(10)
mpg %>% 
  group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  mutate(total=(cty+hwy)/2) %>% 
  summarise(mean=mean(total)) %>% 
  arrange(desc(mean)) %>% 
  head(5)
mpg %>%
  group_by(class) %>%
  summarise(mean=mean(cty)) %>% 
  arrange(desc(mean))
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
test1<-data.frame(id=c(1,2,3,4,5),
                  midterm=c(60,80,70,90,85))
test2<-data.frame(id=c(1,2,3,4,5),
                  final=c(70,83,65,95,80))
test1
test2
total<-left_join(test1,test2,by="id")
total
name<-data.frame(class=c(1,2,3,4,5),
                 teacher=c("kim","lee","park","choi","jung"))
name
exam_new<-left_join(exam,name,by="class")
exam_new
group_a<-data.frame(id=c(1,2,3,4,5),
                    test=c(60,80,70,90,85))
group_b<-data.frame(id=c(6,7,8,9,10),
                    test=c(70,83,65,95,80))
group_a
group_b
group_all<-bind_rows(group_a,group_b)
group_all
fuel<-data.frame(fl=c("c","d","e","p","r"),
                 price_fl = c(2.35,2.38,2.11,2.76,2.22),
                 stringsAsFactors = F)
fuel
mpg_all<-left_join(mpg,fuel, by = "fl" )
mpg_all %>% 
  select(model,fl,price_fl) %>% 
  head(5)
head(midwest)
midwest<-as.data.frame(ggplot2::midwest)
midwest<-midwest %>% 
  mutate(popinfancy=(poptotal-popadults)/poptotal*100)
midwest %>% 
  group_by(county) %>% 
  select(county,popinfancy) %>% 
  arrange(desc(popinfancy)) %>% 
  head(5)
midwest <- midwest %>% 
  mutate(grade = ifelse(popinfancy>=40,"large",
                        ifelse(popinfancy>=30,"middle","small")))
midwest
table(midwest$grade)
midwest %>% 
  mutate(popasianp= (popasian/poptotal) * 100) %>% 
  arrange(popasianp) %>% 
  select(state,county,popasianp) %>% 
  head(10)

df <- data.frame(sex=c("M","F",NA,"M","F"),
                 score=c(5,4,3,4,NA))
df
is.na(df)
table(is.na(df))
table(is.na(df$sex))
table(is.na(df$score))
mean(df$score)
sum(df$score)
library(dplyr)
df %>% filter(is.na(score))
df %>% filter(!is.na(score))
df_nomiss<- df %>% filter(!is.na(score)) 
mean(df_nomiss$score)
sum(df_nomiss$score)
df_nomiss <-df %>% filter(!is.na(score) & !is.na(sex))
df_nomiss
df_nomiss2<- na.omit(df)
df_nomiss2
mean(df$score,na.rm=T)
sum(df$score,na.rm=T)
setwd("C:/easy_r")
exam<-read.csv("csv_exam.csv")
exam
exam[c(3,8,15),"math"]<-NA
exam %>% summarise(mean_math= mean(math))
exam %>% summarise(mean_math=mean(math,na.rm=T))
exam %>% summarise(mean_math=mean(math,na.rm=T),
                   sum_math=sum(math,na.rm=T),
                   median_math=median(math,na.rm=T))
mean(exam$math,na.rm=T)
exam$math <- ifelse(is.na(exam$math),55,exam$math)
table(is.na(exam$math))
exam      
mean(exam$math)
mpg<-as.data.frame(ggplot2::mpg)
mpg[c(65,124,131,153,212),"hwy"]<-NA
table(is.na(mpg$drv))
table(is.na(mpg$hwy))
mpg %>% 
  filter(!is.na(hwy)) %>%
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))
outlier <- data.frame(sex=c(1,2,1,3,2,1),
                      score=c(5,4,3,4,2,6))  
outlier
table(outlier$sex)
table(outlier$score)
outlier$sex <- ifelse(outlier$sex==3,NA,outlier$sex)
outlier$score <- ifelse(outlier$score>5,NA,outlier$score)
outlier
outlier %>% 
  filter(!is.na(sex) & !is.na(score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score=mean(score))
boxplot(mpg$hwy)
boxplot(mpg$hwy)$stats
mpg$hwy <- ifelse(mpg$hwy<12 | mpg$hwy>37,NA,mpg$hwy)
table(is.na(mpg$hwy))
mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy,na.rm=T))
mpg<-as.data.frame(ggplor::mpg)
mpg[c(10,14,58,93),"drv"]<-"k"
mpg[c(29,43,129,203),"cty"]<-c(3,4,39,42)
table(mpg$drv)
mpg$drv <- ifelse(mpg$drv %in% c("4","f","r"),mpg$drv,NA)
table(mpg$drv)
boxplot(mpg$cty)
boxplot(mpg$cty)$stats
mpg$cty <- ifelse(mpg$cty<9 | mpg$cty>26,NA,mpg$cty)
boxplot(mpg$cty)
mpg %>% 
  filter(!is.na(drv)&!is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(mean_cty=mean(cty))
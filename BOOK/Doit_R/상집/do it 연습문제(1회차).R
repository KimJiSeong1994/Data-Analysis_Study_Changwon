##do it R 데이터 분석 숙제 ##

#p88
price <- c(1800,1500,3000) #가격
sale <- c(24,38,13) #판매량

df_fruit <- data.frame(price,sale) #가격과 판매량 데이터 프레임화

mean(df_fruit$price) #가격 평균
mean(df_fruit$sale)#판매량 평균

###################################

#p112
library(ggplot2);library(dplyr)

mpg <- as.data.frame(ggplot2::mpg)

mpg_new <- mpg
head(mpg)
mpg_new <- rename(mpg_new,city=cty,highway=hwy)
head(mpg_new)

##############################################
#p123
#문제 1-데이터 프레임화, 데이터 특징 파악
library(ggplot2)
midwest <- as.data.frame(midwest)
head(midwest)
tail(midwest)
str(midwest)
View(midwest)
dim(midwest)
summary(midwest)

#문제2-변수 이름 수정
library(dplyr)
midwest_new <- midwest
midwest_new<- rename(midwest_new,total=poptotal,asian=popasian)
head(midwest_new)

#문제3.파생변수 ,히스토그램
midwest_new$asian_total <- (midwest_new$asian/midwest_new$total)*100
head(midwest_new$asian_total,20)

hist(midwest_new$asian_total)

#문제4. 평균,조건문-large/small:파생변수
asian_mean <- mean(midwest_new$asian_total) #대략 0.487
head(asian_mean)
midwest_new$size <- ifelse(midwest_new$asian_total>asian_mean,"large","small")
midwest_new$size

#문제5.빈도표,막대그래프
table(midwest_new$size)
qplot(midwest_new$size)

################################################
#p123
#Q1
displ4 <- mpg %>% filter(displ<=4)
displ5 <- mpg %>% filter(displ>=5)
mean(displ4$hwy)
mean(displ5$hwy)
#Q2
type_audi <- mpg %>% filter(manufacturer== "audi")
type_toyota <- mpg %>% filter(manufacturer== "toyota")
mean(type_audi$cty)
mean(type_toyota$cty)

#Q3
mpg %>% filter(manufacturer %in% c("Chevolet","ford","honda"))
mean(mpg$hwy)

####################################

#p138
#Q1
mpg %>% select(class,cty)

#Q2
suv <- mpg %>% filter(class=="suv")
compact <- mpg %>% filter(class=="compact")

mean(suv$cty)
mean(compact$cty)


##############################

#p141
#Q1
mpg %>%
  filter(manufacturer=="audi") %>%  
  arrange(desc(hwy)) %>% 
  head(5)

###################################

#p144
#Q1
mpg <- as.data.frame(ggplot2::mpg)
mpg_copy <- mpg #복사본
mpg_copy <- mpg_copy %>% 
  mutate(total=cty+hwy) #합산 연비변수 추가

#Q2
mpg_copy<- mpg_copy %>% 
            mutate(mean=total/2)

#Q3
mpg_copy %>% 
  arrange(desc(mean)) %>% 
  head(3)

#Q4
mpg %>% 
  mutate(total = cty+hwy,  
          mean = total/2) %>%  
  arrange(desc(mean)) %>% 
  head(3)

#################################################
#p150
#Q1,Q2
mpg %>%
  group_by(class) %>% 
  summarise(cty_mean=mean(cty)) %>% 
  arrange(desc(cty_mean))

#Q3
mpg %>% 
  arrange(desc(hwy)) %>% 
  head(3)

#Q4
mpg %>% 
  filter(class=="compact") %>% 
  group_by(manufacturer) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n))
#################################
#p157
fuel <- data.frame(f1=c("c","d","e","p","r"),
                   price_f1=c(2.35,2.38,2.11,2.76,2.22),
                   stringsAsFactors = F)
#Q1
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)
mpg<- left_join(mpg,fuel,by="f1") ##이구간 에러뜸..
#Q2
mpg %>%
  select(model,f1,price_f1) %>% 
  head(5)

############################################3
#p160
midwest <- as.data.frame(ggplot2::midwest)
head(midwest)
#Q1,Q2
midwest %>% 
         mutate(minority=poptotal-popadults,
         pop_minority=(minority/poptotal)*100) %>% 
         arrange(desc(pop_minority)) %>% 
         head(5) %>% 
         select(county,pop_minority)

#Q3
midwest %>% 
                  mutate(minority=poptotal-popadults,
                          pop_minority=(minority/poptotal)*100) %>% 
                  mutate(var=ifelse(midwest_new$pop_minority<30,"small",
                                ifelse(midwest_new$pop_minority<40,"middle","large"))) %>% 
                  group_by(var) %>% 
                  summarise(n=n())

#Q4
midwest_11 <- midwest %>% 
        mutate(asian=(popasian/poptotal)*100) %>% 
        arrange(asian) %>% 
        select(state,county) %>% 
        head(10) 
        
#########################################################

#p170
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65,124,131,153,212),"hwy"]<-NA

#Q1
table(is.na(mpg$drv))
table(is.na(mpg$hwy))

#Q2
mpg_nomiss<- mpg %>% filter(!is.na(hwy))  
table(is.na(mpg_nomiss$hwy)) 
mpg_nomiss %>% 
  group_by(drv) %>%    
  summarise(mean(mpg_nomiss$hwy))

####################################################
#p178
library(ggplot2);library(dplyr)
mpg <- as.data.frame(ggplot2::mpg) 
mpg[c(10,14,58,93),"drv"] <- "K"
mpg[c(29,43,129,203),"cty"] <- c(3,4,39,42)

#Q1
table(mpg$drv)
mpg$drv <- ifelse(mpg$drv=="K",NA,mpg$drv)
mpg<- mpg %>% filter(!is.na(drv))
table(is.na(mpg$drv))

#Q2
boxplot(mpg$cty)$stats #9~26사이 정상범위
mpg$cty<- ifelse(mpg$cty<9|mpg$cty>26,NA,mpg$cty)
mpg <- mpg %>% 
      filter(!is.na(cty))
boxplot(mpg$cty)

#Q3
mpg %>% 
  group_by(drv) %>% 
  summarise(cty_mean=mean(cty))



  
        
midwest_
var_minority <- 
  



  
#####07-1 ���� �����͸� ã�ƶ�! - ����ġ �����ϱ�#####

#����ġ ã��
df <- data.frame(sex=c("M","F",NA,"M","F"),
                 score=c(5,4,3,4,NA))

is.na(df)                 #����ġ Ȯ��(����ġ=TRUE)

table(is.na(df))          #����ġ �� ���
table(is.na(df$sex))      #sex ����ġ �� ���
table(is.na(df$score))    #score ����ġ �� ���

mean(df$sex)
mean(df$score)            #����ġ�� ���Ե� �����͸� �Լ� �����ϸ� NA�� ���


#����ġ �����ϱ�
library(dplyr)
df %>% filter(is.na(score))   #score�� NA�� �����͸� ���
df %>% filter(!is.na(score))

df_n <- df %>% filter(!is.na(score))
mean(df_n$score);sum(df_n$score)

df_n1 <- df %>% filter(!is.na(score)&!is.na(sex))  #���� ���� ����ġ ��������
df_n2 <- na.omit(df)           #����ġ�� �ϳ��� ������ ��� ����


#�Լ��� ����ġ ���� ��� 
mean(df$score, na.rm=T)        #na.rm=T �Ķ���� ��� ���
sum(df$score, na.rm=T)

exam <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")
exam[c(3,8,15),"math"] <- NA   #3,8,15���� math�� NA �Ҵ�

exam %>% summarise(mean_math=mean(math))
exam %>% summarise(mean_math=mean(math,na.rm=T))
exam %>% summarise(mean_math=mean(math,na.rm=T),
                   sum_math=sum(math,na.rm=T),
                   median_math=median(math,na.rm=T))


#��հ����� ����ġ ��ü�ϱ�
mean(exam$math, na.rm=T)       #����ġ �����ϰ� math ��� ����
exam$math <- ifelse(is.na(exam$math),55,exam$math)  #math�� NA�� 55�� ��ü
table(is.na(exam$math))

mean(exam$math)



#####��������#####
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65,124,131,153,212),"hwy"] <- NA

#Q1. drv ������ hwy������ ����ġ�� �� �� �ִ��� �˾ƺ���
table(is.na(mpg$drv))
table(is.na(mpg$hwy))

#Q2. filter()�̿��� hwy ����ġ �����ϰ� � drv(�������)�� hwy����� ������ �˾ƺ���. �ϳ��� dplyr �������� ��������.
mpg %>% 
  select(drv,hwy) %>% 
  filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy)) %>% 
  arrange(desc(mean_hwy))

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm=T)) %>% 
  arrange(desc(mean_hwy))

#Q2. ������ �̰�(select ��� ��)
mpg %>% 
  filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))



#####07-2 �̻��� �����͸� ã�ƶ�! - �̻�ġ �����ϱ�#####
outlier <- data.frame(sex=c(1,2,1,3,2,1),
                      score=c(5,4,3,4,2,6))

#�̻�ġ Ȯ���ϱ�
table(outlier$sex)
table(outlier$score)

#���� ó���ϱ�
outlier$sex <- ifelse(outlier$sex==3,NA,outlier$sex)
outlier

outlier$score <- ifelse(outlier$score>5,NA,outlier$score)
outlier

outlier %>% 
  filter(!is.na(sex)&!is.na(score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score=mean(score))


#�̻�ġ �����ϱ� - �ش����� ��
#�ش�ġ�� ������ �м� ����� �ְ�� �� �ֱ� ������ �м� �� �����ؾ���

#���� �׸����� �ش�ġ ���� ���ϱ�
boxplot(mpg$hwy)

#���� �׸� ���ġ ���
#��� ����� ���ʴ�� �Ʒ��� �ش�ġ ���/1�������/�߾Ӱ�/3�������/���� �ش�ġ ���
boxplot(mpg$hwy)$stats


#���� ó���ϱ�
#12~37 ����� NA �Ҵ�
mpg$hwy <- ifelse(mpg$hwy<12|mpg$hwy>37,NA,mpg$hwy)
table(mpg$hwy)
table(is.na(mpg$hwy))

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm = T))



#####��������2#####
mpg[c(10,14,58,93),"drv"] <- "k"
mpg[c(29,43,129,203),"cty"] <- c(3,4,39,42)

#Q1. drv�� �̻�ġ�� �ִ��� Ȯ��. �̻�ġ ���� ó�� �� Ȯ��. ���� ó�� �� ���� %in% ��ȣ Ȱ���ϱ�.
table(mpg$drv)
mpg$drv <- ifelse(mpg$drv=="k",NA,mpg$drv)

#Q1. ������ �̰�
table(mpg$drv)
mpg$drv <- ifelse(mpg$drv %in% c("4","f","r"), mpg$drv, NA)
table(mpg$drv)

#Q2. ���� �׸� �̿��� cty�� �̻�ġ�� �ִ��� Ȯ���ϱ�. ���� �׸��� ���ġ�� �̿��� ���� ���� ��� ���� ���� ó���ϰ� �ٽ� ���� �׸����� Ȯ��
boxplot(mpg$cty)$stats
mpg$cty <- ifelse(mpg$cty>26|mpg$cty<9,NA,mpg$cty)
boxplot(mpg$cty)

#Q3. �̻�ġ�� ������ drv���� cty����� ��� �ٸ��� �˾ƺ���. �ϳ��� dplyr�������� ��������
mpg %>% 
  filter(!is.na(drv)&!is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(cty_mean=mean(cty))
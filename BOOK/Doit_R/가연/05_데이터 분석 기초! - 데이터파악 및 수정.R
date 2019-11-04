#####05-1 ������ �ľ��ϱ�#####

exam <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")

#head() : ������ �պκ� Ȯ��
head(exam)
head(exam,10)    #�տ������� 10����� ���

#tail() : ������ �޺κ� Ȯ��
tail(exam)
tail(exam,10)    #�ڿ������� 10����� ���

#View() : Viewerâ���� ������ Ȯ��
View(exam)

#dim() : �����Ͱ� �� ��, �� ���� �����Ǿ� �ִ��� �˾ƺ���
dim(exam)        #��, �� ���

#str() : �Ӽ� �ľ��ϱ�
#����ġ(obs)�� ��(row)�� ������ �ǹ̷� ����
str(exam)

#summary() : ��� ��跮 ����
#1st Qu. : 1�������(����25% ������ ��ġ�ϴ� ��)
#Median : �߾Ӱ�
#Mean : ���
#3rd Qu. : 3�������(����75% ������ ��ġ�ϴ� ��)
summary(exam)


#mpg������ �ľ��ϱ�
#mpg�����ʹ� ggplot2�� ����� ������
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
head(mpg);tail(mpg);View(mpg)
dim(mpg);str(mpg);summary(mpg)

?mpg          #mpg����� ���



#####05-2 ������ �ٲٱ�#####
library(dplyr)
df_raw <- data.frame(var1=c(1,2,1),
                     var2=c(2,3,2))
df_new <- df_raw                     #���纻 ����
df_new <- rename(df_new, V2=var2)    #var2�� V2�� ����
df_raw;df_new



#####��������#####
#Q1.mpg�����͸� �ҷ����� ���纻 ����
mpg_d <- ggplot2::mpg
mpg_d <- as.data.frame(ggplot2::mpg)

#Q2.���纻���� cty�� city, hwy�� highway�� ����&Ȯ��
mpg_d <- rename(mpg_d, city=cty, highway=hwy)
head(mpg_d)



#####05-3 �Ļ����� �����#####
#�Ļ����� : ������ ������ ������ ���� ����

df <- data.frame(var1=c(4,3,8),
                 var2=c(2,6,1))
df$var_sum <- df$var1+df$var2         #var_sum �Ļ����� ����
df

df$var_mean <- (df$var1+df$var2)/2    #var_mean �Ļ����� ����
df

###mpg ���� ���� ���� �����
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)

mpg$total <- (mpg$cty+mpg$hwy)/2
head(mpg)                #���� ���� ���� ����
mean(mpg$total)          #���� ���� ���� ���


###���ǹ��� Ȱ���� �Ļ����� �����
summary(mpg$total)       #��� ��跮 ����
hist(mpg$total)          #������׷� ���� : ���� �������� ���� �ľ� ����

#ifelse(����, ���� ����, ���� ������)
mpg$test <- ifelse(mpg$total>=20,"pass","fail")
head(mpg)

#table() : ��ǥ �ۼ�
table(mpg$test)          #���� �հ� ��ǥ ����

#qplot() : ���� �׷����� �� ǥ��
library(ggplot2)
qplot(mpg$test)


###��ø ���ǹ� Ȱ���ϱ�
mpg$grade <- ifelse(mpg$total>=30,"A",
                    ifelse(mpg$total>=20,"B","C"))
head(mpg)
table(mpg$grade)
qplot(mpg$grade)

mpg$grade2 <- ifelse(mpg$total>=30,"A",
                     ifelse(mpg$total>=25,"B",
                            ifelse(mpg$total>=20,"C","D")))
table(mpg$grade2);qplot(mpg$grade2)



#####��������2#####
#Q1. ggplot2�� midwest�����͸� ������ ������ ���·� �ҷ����� Ư¡ �ľ�
df_mid <- as.data.frame(ggplot2::midwest)
head(df_mid);dim(df_mid);summary(df_mid);str(df_mid);View(df_mid)

#Q2. poptotal������ total��, popasian������ asian���� ����
library(dplyr)
df_mid <- rename(df_mid,total=poptotal,asian=popasian)
head(df_mid)

#Q3. total, asian ������ '��ü �α� ��� �ƽþ� �α� �����' �Ļ������� �����, ������׷��� ����� ���õ� ���� ���Ǳ�
df_mid$Apercent <- (df_mid$asian/df_mid$total)*100
head(df_mid)
hist(df_mid$Apercent)

#Q4. �ƽþ� �α� ����� ��ü ��� ���ϰ�, ��� �ʰ��ϸ� "large", �� �ܿ��� "small"�� �ο��ϴ� �Ļ����� �����
summary(df_mid$Apercent)
df_mid$Apercent1 <- ifelse(df_mid$Apercent>mean(df_mid$Apercent),"large","small")
head(df_mid)

#Q5. "large"�� "small" ���� ��ǥ�� �� ���� �׷��� �ۼ�
table(df_mid$Apercent1)
qplot(df_mid$Apercent1)

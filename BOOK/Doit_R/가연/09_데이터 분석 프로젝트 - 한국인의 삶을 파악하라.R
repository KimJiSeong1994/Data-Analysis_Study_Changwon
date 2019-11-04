#####09-1 '�ѱ������гε�����' �м� �غ��ϱ�#####
install.packages("foreign")

library(foreign)   #SPSS���� �ҷ�����
library(dplyr)     #��ó��
library(ggplot2)   #�ð�ȭ
library(readxl)    #���� ���� �ҷ�����


#������ �ҷ�����
welfare <- read.spss(file = "C:/rtest/Doit_R/Koweps_etc/data/Koweps_hpc10_2015_beta1.sav", to.data.frame = T)  #to.data.frame = T�� SPSS������ df���·� �ٲ�

welfare1 <- welfare

head(welfare1);tail(welfare1)
View(welfare1)
dim(welfare1)
str(welfare1)
summary(welfare1)


#������ �ٲٱ�
welfare1 <- rename(welfare1,                    
                   sex = h10_g3,                #����
                   birth = h10_g4,              #�¾ ����
                   marriage = h10_g10,          #ȥ�� ����
                   religion = h10_g11,          #����
                   income = p1002_8aq1,         #����
                   code_job = h10_eco9,         #�����ڵ�
                   code_region = h10_reg7)      #�����ڵ�


#������ �м� ���� : ���� ���� �� ��ó�� -> ���� �� ���� �м�



#####09-2 ������ ���� ���� ���� - "������ ���� ������ �ٸ���?"#####
##���� ���� ���� �� ��ó��
#1.���� �����ϱ�
class(welfare1$sex)    #���� Ÿ�� Ȯ��
table(welfare1$sex)    #�� ���ֿ� ��� �ִ��� Ȯ��

#2.��ó�� : �ڵ�� ������ �����Ͽ� �̻�ġ ����
table(welfare1$sex)

#�̻�ġ�� ���� ��� ���� ó��
welfare1$sex <- ifelse(welfare1$sex==9,NA,welfare1$sex)
table(is.na(welfare1$sex))

#���� �׸� �̸� �ο�
welfare1$sex <- ifelse(welfare1$sex=="1","male","female")
table(welfare1$sex)
qplot(welfare1$sex)


##���� ���� ���� �� ��ó��
#1.���� �����ϱ� : income������ ���� �����̹Ƿ� table()�� �̿��ϸ� �ʹ� ���� �׸��� ��µǹǷ� summary()�� �����跮�� Ȯ���� Ư¡ �ľ�
class(welfare1$income)
summary(welfare1$income)
qplot(welfare1$income)
qplot(welfare1$income)+xlim(0,1000)  #xlim()���� 0~1000������ ǥ���ǰ� ����

#2.��ó��
summary(welfare1$income)             #�̻�ġ Ȯ��, ����ġ�� 12030�� ����

#�̻�ġ ���� ó��(0�� 9999�� ��)
welfare1$income <- ifelse(welfare1$income %in% c(0,9999),NA,welfare1$income)
table(is.na(welfare1$income))


##������ ���� ���� ���� �м��ϱ�
sex_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income=mean(income))

ggplot(data = sex_income, aes(x=sex,y=mean_income))+geom_col()



#####09-3 ���̿� ������ ���� - "�� �� �� ������ ���� ���� ������?"#####
##���̺��� ���� �� ��ó��
class(welfare1$birth)
summary(welfare1$birth)
qplot(welfare1$birth)

summary(welfare1$birth)         #�̻�ġ Ȯ�� : ����
table(is.na(welfare1$birth))    #����ġ Ȯ�� : ����

#����ġ�� ������ �̷��� ó��
#welfare1$birth <- ifelse(welfare1$birth==9999,NA,welfare1$birth)
#table(is.na(welfare1$birth))

#�Ļ����� ����� - ����
welfare1$age <- 2015-welfare1$birth+1     #�¾ ���� �̿��� ���� ���ϱ�
summary(welfare1$age)
qplot(welfare1$age)


##���̿� ������ ���� �м��ϱ�
#1.���̿� ���� ���� ���ǥ �����
age_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income=mean(income))

ggplot(data=age_income,aes(x=age,y=mean_income))+geom_line()
#x��� y���� ������ �� ""�̰� ������ �� �� �̤̤� 



#####09-4 ���ɴ뿡 ���� ���� ���� - "� ���ɴ��� ������ ���� ������?"#####
##���ɴ� ���� ���� �� ó���ϱ�
welfare1 <- welfare1 %>% 
  mutate(ageg = ifelse(age<30,"young",
                       ifelse(age<=59, "middle", "old")))
table(welfare1$ageg)
qplot(welfare1$ageg)


##���ɴ뿡 ���� ���� ���� �м��ϱ�
ageg_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income=mean(income))

ggplot(data=ageg_income,aes(x=ageg,y=mean_income))+geom_col()
ggplot(data=ageg_income,aes(x=ageg,y=mean_income))+
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))  #���� ���� ����



#####09-5 ���ɴ� �� ���� �������� - "���� ���� ���̴� ���ɴ뺰�� �ٸ���?"#####
##���ɴ� �� ���� ���� ���� �м��ϱ�
sex_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg,sex) %>% 
  summarise(mean_income=mean(income))

#fill=sex : ���밡 ������ ���� �ٸ� ������ ǥ�� �ǵ��� ����
ggplot(data=sex_income,aes(x=ageg,y=mean_income,fill=sex))+ 
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))

#position="dodge" : ���� ���븦 ���� �и�
ggplot(data=sex_income,aes(x=ageg,y=mean_income,fill=sex))+ 
  geom_col(position = "dodge")+
  scale_x_discrete(limits=c("young","middle","old"))


##���� �� ���� ���� ���� �м��ϱ�
sex_age <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income=mean(income))

ggplot(data = sex_age,aes(x=age,y=mean_income,col=sex))+geom_line()
?aes



#####09-6 ������ ���� ���� - "� ������ ������ ���� ���� ������?"#####
##���� ���� ���� �� ��ó���ϱ�
class(welfare1$code_job)
table(welfare1$code_job)

#��ó�� : ������ ��Ī���� �� ���� ����� ����
library(readxl)
list_job <- read_excel("C:/rtest/Doit_R/Data/Koweps_Codebook.xlsx",
                       col_names = T, sheet = 2)
head(list_job)
dim(list_job)

welfare1 <- left_join(welfare1,list_job,id="code_job")
welfare1 %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job,job) %>% 
  head(10)


##������ ���� ���� �м��ϱ�
job_income <- welfare1 %>% 
  filter(!is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income=mean(income))

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)

ggplot(data = top10, aes(x=reorder(job, mean_income), y=mean_income,))+
  geom_col()+
  coord_flip()     #���븦 ���������� 90�� ȸ��(x�� �̸��� ��ġ�� �ʰ�)
                   #reorder() : ���� ũ�� ������� ����

bottom10 <- job_income %>% 
  arrange(mean_income) %>% 
  head(10)

ggplot(data = bottom10, aes(x=reorder(job, -mean_income), y=mean_income,))+
  geom_col()+
  coord_flip()+
  ylim(0,850)      #top10�׷����� ���� �� �ֵ��� y�� ������ 0~850�� ����



#####09-7 ���� ���� �� - "������ � ������ ���� ������?"#####
##���� ���� �� �м��ϱ�

#���� ���� �� ���� 10��
job_male <- welfare1 %>% 
  filter(!is.na(job) & sex=="male") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

ggplot(data = job_male, aes(x=reorder(job,n),y=n))+
  geom_col()+
  coord_flip()

#���� ���� �� ���� 10��
job_female <- welfare1 %>% 
  filter(!is.na(job) & sex=="female") %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

ggplot(data = job_female, aes(x=reorder(job,n),y=n))+
  geom_col()+
  coord_flip()



#####09-8 ���� ������ ���� ��ȥ�� - "������ �ִ� ������� ��ȥ�� �� �ұ�?"#####
##���� ���� ���� �� ��ó���ϱ�
class(welfare1$religion)
table(welfare1$religion)

welfare1$religion <- ifelse(welfare1$religion==1,"yes","no")
table(welfare1$religion)
qplot(welfare1$religion)


##ȥ�� ���� ���� ���� �� ��ó���ϱ�
class(welfare1$marriage)
table(welfare1$marriage)

welfare1$group_marriage <- ifelse(welfare1$marriage==1,"marriage",
                            ifelse(welfare1$marriage==3,"divorce",NA))

table(welfare1$group_marriage)
table(is.na(welfare1$group_marriage))
qplot(welfare1$group_marriage)


##���� ������ ���� ��ȥ�� �м��ϱ�
religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(total=sum(n)) %>% 
  mutate(per=round(n/total*100,1))

#count()�� �Ἥ ���Ҽ��� ����(���ܺ� �󵵸� ���ϴ� �Լ�)
religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  count(religion, group_marriage) %>% 
  group_by(religion) %>% 
  mutate(per=round(n/sum(n)*100,1))

#��ȥ ���� ����
divorce <- religion_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(religion,per)

ggplot(data=divorce, aes(x=religion,y=per))+geom_col()


##���ɴ� �� ���� ������ ���� ��ȥ�� �м��ϱ�
#���ɴ뺰 ��ȥ��
ageg_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg,group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(total=sum(n)) %>% 
  mutate(per=round(n/total*100,1))

#count()�� �Ἥ ���Ҽ��� ����
ageg_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  count(ageg,group_marriage) %>% 
  group_by(ageg) %>% 
  mutate(per=round(n/sum(n)*100,1))

#�׷���
divorce1 <- ageg_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(ageg,per)

ggplot(data=divorce1,aes(x=ageg,y=per))+
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))

#���ɴ� �� ���� ������ ���� ��ȥ�� ǥ �����
ageg_religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg,religion,group_marriage) %>% 
  summarise(n=n()) %>% 
  mutate(total=sum(n)) %>% 
  mutate(per=round(n/total*100,1))

#count()�� �Ἥ ���Ҽ��� ����
ageg_religion_marriage <- welfare1 %>% 
  filter(!is.na(group_marriage)) %>% 
  count(ageg,religion,group_marriage) %>% 
  group_by(ageg,religion) %>% 
  mutate(per=round(n/sum(n)*100,1))

#���ɴ� �� ���� ������ ��ȥ�� ǥ �����
divorce2 <- ageg_religion_marriage %>% 
  filter(group_marriage=="divorce") %>% 
  select(ageg,religion,per)

#�׷���
ggplot(data = divorce2,aes(x=ageg,y=per,fill=religion))+
  geom_col(position = "dodge")



#####09-9 ������ ���ɴ� ���� - "������� ���� ������ ����ϱ�?"#####
##���� ���� ���� �� ��ó���ϱ�
class(welfare1$code_region)
table(welfare1$code_region)

#�����ڵ� ��� �����
list_region <- data.frame(code_region=c(1:7), 
                          region=c("����",
                                   "������(��õ/���)",
                                   "�λ�/�泲/���",
                                   "�뱸/���",
                                   "����/�泲",
                                   "����/���",
                                   "����/����/����/���ֵ�"))

#������ ���� �߰�
welfare1 <- left_join(welfare1,list_region,id="code_region")

welfare1 %>% 
  select(code_region,region) %>% 
  head


##������ ���ɴ� ���� �м��ϱ�
region_ageg <- welfare1 %>% 
  group_by(region,ageg) %>% 
  summarise(n=n()) %>% 
  mutate(per=round(n/sum(n)*100,2))

#count()�� �Ἥ ���Ҽ��� ����
region_ageg <- welfare1 %>% 
  count(region,ageg) %>% 
  group_by(region) %>% 
  mutate(per=round(n/sum(n)*100,2))

#�׷���
ggplot(data = region_ageg,aes(x=region,y=per,fill=ageg))+
  geom_col()+
  coord_flip()

#scale_x_discrete()�� ���� ������ ���̹Ƿ� ���� ������ ������ ��!!!
#����� ���� �������� ����
list_order_old <- region_ageg %>% 
  filter(ageg=="old") %>% 
  arrange(per)

#������ ���� ���� �����
order <- list_order_old$region

#�׷���
ggplot(data=region_ageg,aes(x=region,y=per,fill=ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits=order)

#���ɴ� ������ ���� ���� ���� : fill�Ķ���Ϳ� ����(levels) ���� ����
#���� ageg ������ characterŸ���̶� levels�� ����
class(region_ageg$ageg)
levels(region_ageg$ageg)

#factor()�̿��� ��ȯ, level�Ķ���͸� �̿��� ���� ����
region_ageg$ageg <- factor(region_ageg$ageg,
                           level=c("old","middle","young"))
class(region_ageg$ageg)
levels(region_ageg$ageg)

#�׷��� ���� �ڵ� �ٽ� ����
ggplot(data=region_ageg,aes(x=region,y=per,fill=ageg))+
  geom_col()+
  coord_flip()+
  scale_x_discrete(limits=order)

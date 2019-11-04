#####06-1 ������ ��ó�� - ���ϴ� ���·� ������ ����#####
#dplyr : ������ ��ó�� �۾��� ���� ���� ���Ǵ� ��Ű��
library(dplyr)



#####06-2 ���ǿ� �´� �����͸� �����ϱ�#####
exam <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")

#' %>% ' : �Լ����� �����ϴ� ���('Ctrl'+'Shift'+'M')
exam %>% filter(class==1)     #exam���� class�� 1�� ��츸 ������ ���
exam %>% filter(class==2)

exam %>% filter(class!=1)     #1���� �ƴ� ���
exam %>% filter(class!=3)


#�ʰ�,�̸�,�̻�,���� ���� �ɱ�
exam %>% filter(math>50)      #math�� 50���� �ʰ��� ���
exam %>% filter(math<50)
exam %>% filter(english>=80)  #english�� 80�� �̻��� ���
exam %>% filter(english<=80)


#���� ������ �����ϴ� �� �����ϱ�
exam %>% filter(class==1 & math>=50)  #1���̸鼭 math�� 50 �̻��� ���
exam %>% filter(class==2 & english>=80)


#���� ���� �� �ϳ� �̻� �����ϴ� �� �����ϱ�
exam %>% filter(math>=90 | english>=90)
exam %>% filter(english<90 | science<50)


#��Ͽ� �ش��ϴ� �� �����ϱ�
exam %>% filter(class==1|class==3|class==5)
exam %>% filter(class %in% c(1,3,5))  #1,3,5�ݿ� �ش��ϸ� ����


#������ ������ ������ �����
class1 <- exam %>% filter(class==1)
class2 <- exam %>% filter(class==2)

mean(class1$math)        #1�� �������� ��� ���ϱ�
mean(class2$math)        #2�� �������� ��� ���ϱ�



#####��������#####
#Q1. displ(��ⷮ)�� 4������ �ڵ����� 5�̻��� �ڵ��� �� � �ڵ����� hwy(��ӵ��� ����)�� ��������� ������ �˾ƺ���
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
displ1 <- mpg %>% filter(displ<=4)
displ2 <- mpg %>% filter(displ>=5)
mean(displ1$hwy);mean(displ2$hwy)

#Q2. "audi"�� "toyota"�� ��� manufacturer�� cty(���ÿ���)�� ��������� ������ �˾ƺ���
mf1 <- mpg %>% filter(manufacturer=="audi")
mf2 <- mpg %>% filter(manufacturer=="toyota")
mean(mf1$cty);mean(mf2$cty)

#Q3. "chevrolet","ford","honda"�� hwy(��ӵ��� ����) ����� ���ϱ�
mf3 <- mpg %>% filter(manufacturer %in% c("chevrolet","ford","honda"))
mean(mf3$hwy)



#####06-3 �ʿ��� ������ �����ϱ�#####
exam %>% select(math)                 #math ����
exam %>% select(english)              #english����

exam %>% select(class,math,english)   #class,math,english ���� ����

exam %>% select(-math)                #math ����
exam %>% select(-math,-english)       #math, english ����


#dplyr�Լ� �����ϱ�
#class�� 1�� �ุ ������ ���� english ����
exam %>% filter(class==1) %>% select(english)

exam %>%                    #������ �ְ� �� �ٲٱ�
  filter(class==1) %>%      #class�� 1�� �� ����
  select(english)           #english ����

exam %>% 
  select(id, math) %>% 
  head                      #�պκ� 6����� ����

exam %>% 
  select(id, math) %>% 
  head(10)                  #�պκ� 10����� ����



#####��������2#####
#Q1. mpg�����Ϳ��� class, cty ������ ������ ���ο� ������ ����� Ȯ��
mpg1 <- mpg %>% select(class,cty)
head(mpg1)

#Q2. �տ��� ������ �����͸� �̿��� class�� "suv"�� �ڵ����� "compact"�� �ڵ��� �߿��� � �ڵ����� cty�� ������ ���ϱ�
mpg1_s <- mpg1 %>% filter(class=="suv")
mean(mpg1_s$cty)

mpg1_c <- mpg1 %>% filter(class=="compact")
mean(mpg1_c$cty)



#####06-4 ������� �����ϱ�#####
#������������ ����(������->������)
exam %>% arrange(math)         #math �������� ����

#������������ ����(������->������)
exam %>% arrange(desc(math))

exam %>% arrange(class,math)   #class �� math �������� ����



#####��������3#####
#Q1. "audi" �ڵ��� �� hwy�� 1~5���� �ش��ϴ� �ڵ����� ������ ���
head(mpg)
mpg %>% 
  filter(manufacturer=="audi") %>% 
  arrange(desc(hwy)) %>% 
  head(5)



#####06-5 �Ļ����� �߰��ϱ�#####
exam %>% 
  mutate(total=math+english+science) %>% 
  head

#�̷��� �⺻ ������ �̿��ص� �Ǳ� �ȴ�...
#�̷��� ���� �ʴ� ������? : dplyr �Լ��� ������ �����Ӹ��� �ݺ� �Է����� �ʱ� ������ �ڵ尡 ���������ٴ� ������ �ֱ� ����!
exam$total <- exam$math+exam$english+exam$science
exam

#���� �Ļ����� �� ���� �߰��ϱ�
exam %>% 
  mutate(total=math+english+science,
         mean=(math+english+science)/3) %>% 
  head

#mutate()�� ifelse()�����ϱ�
exam %>% 
  mutate(test=ifelse(science>=60,"pass","fail")) %>% 
  head

#�߰��� ������ �ٷ� dplyr�ڵ忡 Ȱ���ϱ�
exam %>% 
  mutate(total=math+english+science) %>% 
  arrange(total) %>% 
  head



#####��������4#####
#Q1. mpg������ ���纻�� ����� cty�� hwy�� ���� '�ջ� ���� ����' �߰�
mpg_new <- mpg
mpg_new %>% 
  mutate(sum1=cty+hwy) %>% 
  head

#Q2. '�ջ� ���� ����'�� 2�� ���� '��� ���� ����' �߰�
mpg_new %>% 
  mutate(mean1=(cty+hwy)/2) %>% 
  head

#Q3. '��� ���� ����'�� ���� ���� �ڵ��� 3�� ������ ���
mpg_new %>% 
  mutate(mean1=(cty+hwy)/2) %>% 
  arrange(desc(mean1)) %>% 
  head

#Q4. �� �������� �ϳ��� ����� dplyr ������ ����� �����غ���
mpg_new %>% 
  mutate(sum1=cty+hwy,
         mean1=sum1/2) %>% 
  arrange(desc(mean1)) %>% 
  head

#����: ���� ��ü�� �´µ� ������ �־����� ������ ������ �ȵ� �̤̤�
#Q1. mpg������ ���纻�� ����� cty�� hwy�� ���� '�ջ� ���� ����' �߰�
mpg_new <- mpg
mpg_new <- mpg_new %>% 
  mutate(sum1=cty+hwy) %>% 
  head

#Q2. '�ջ� ���� ����'�� 2�� ���� '��� ���� ����' �߰�
mpg_new <- mpg_new %>% 
  mutate(mean1=sum1/2) %>% 
  head

#Q3. '��� ���� ����'�� ���� ���� �ڵ��� 3�� ������ ���
mpg_new %>% 
  arrange(desc(mean1)) %>% 
  head(3)

#Q4. �� �������� �ϳ��� ����� dplyr ������ ����� �����غ���
mpg_new %>% 
  mutate(sum1=cty+hwy,            #�ջ� ���� �����
         mean1=sum1/2) %>%        #��� ���� �����
  arrange(desc(mean1)) %>%        #�������� ����
  head(3)                         #���� 3�� ���



#####06-6 ���ܺ��� ����ϱ�#####
exam %>% summarise(mean_math=mean(math))    #���ܺ� math ��� ����

exam %>% 
  group_by(class) %>%                       #class���� �и�
  summarise(mean_math=mean(math))           #���ܺ� math ��� ����

exam %>% 
  group_by(class) %>%                       #class���� �и�
  summarise(mean_math=mean(math),           #math ���
            sum_math=sum(math),             #math �հ�
            median_math=median(math),       #math �߾Ӱ�
            n=n())                          #�л���

#�� ���ܺ��� �ٽ� ���� ������
#ȸ�纰�� ���� ������, �ٽ� ���� ��ĺ��� ���� ���� ���� ��� ���Ұ�~
mpg %>% 
  group_by(manufacturer, drv) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  head(10)


#dplyr�����ϱ�
#ȸ�纰�� "suv"�ڵ����� cty(����) �� hwy(��ӵ��� ���� ����) ����� ���� ������������ �����ϰ�, 1~5������ ���
mpg %>% 
  group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  mutate(suv1=(cty+hwy)/2) %>% 
  summarise(suv_mean=mean(suv1)) %>% 
  arrange(desc(suv_mean)) %>% 
  head



#####��������5#####
#Q1.mpg�������� class�� cty��� ���ϱ�
mpg %>% 
  group_by(class) %>% 
  summarise(cty_mean=mean(cty)) %>% 
  head

#Q2.cty����� ���� ������ ������ ���
mpg %>% 
  group_by(class) %>% 
  summarise(cty_mean=mean(cty)) %>% 
  arrange(desc(cty_mean)) %>% 
  head

#Q3.hwy����� ���� ���� ȸ�� �� ���� ���
head(mpg)
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(hwy_mean=mean(hwy)) %>% 
  arrange(desc(hwy_mean)) %>% 
  head(3)

#Q4.�� ȸ�纰 "compact"(����) ���� ���� ������������ ������ ���
mpg %>% 
  group_by(manufacturer) %>%
  filter(class=="compact") %>% 
  summarise(n=n()) %>% 
  arrange(desc(n))

#Q4.������ �̰�
mpg %>% 
  filter(class=="compact") %>%      #compact ����
  group_by(manufacturer) %>%        #manufacturer�� �и�
  summarise(n=n()) %>%              #�� ���ϱ�
  arrange(desc(n))                  #�������� ����



#####06-7 ������ ��ġ��#####
#���η� ��ġ�� : dplyr��Ű���� left_join() �Լ� ���
test1 <- data.frame(id=c(1,2,3,4,5),
                    mid=c(60,80,70,90,85))

test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(70,83,65,95,80))

total <- left_join(test1,test2,by="id")  #�������� ���� �������� by�� ����

#�ٸ� �����͸� Ȱ���� ���� �߰��ϱ�
name <- data.frame(class=c(1,2,3,4,5),
                   teacher=c("kim","lee","park","choi","jung"))
exam <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")

exam_n <- left_join(exam,name,by="class")


#���η� ��ġ�� : bind_rows() �Լ� ���
#�������� ���ƾ� ��� ����. ���� �ٸ��� rename()�Ἥ �Ȱ��� ���߰� ���
group1 <- data.frame(id=c(1,2,3,4,5),
                     test=c(60,80,70,90,85))
group2 <- data.frame(id=c(6,7,8,9,10),
                     test=c(70,83,65,95,80))

group_all <- bind_rows(group1, group2)



#####��������6#####
mpg <- as.data.frame(ggplot2::mpg)

fuel <- data.frame(fl=c("c","d","e","p","r"),
                   price=c(2.35,2.38,2.11,2.76,2.22),
                   stringsAsFactors = F) #���ڸ� factorŸ������ ��ȯ ��
                                         #f1�� mpg�� ���� ����Ÿ������ ��


#Q1. mpg�����Ϳ� price(���ᰡ��) ������ �߰��ϱ�
head(mpg)
mpg_new <- left_join(mpg,fuel,by="fl")

#Q2. model, fl, price ������ ������ �պκ� 5�ุ ���
select(mpg_new,"model","fl","price") %>% head(5)

#Q2. ������ �̰�
mpg_new %>% 
  select(model, fl, price) %>% 
  head(5)



#####��������7#####
library(ggplot2)
mid <- as.data.frame(ggplot2::midwest)
head(mid);summary(mid)

#Q1. midwest�����Ϳ� '��ü �α� ��� �̼��� �α� �����'���� �߰�
library(dplyr)
mid <- mid %>% mutate(popminor=(poptotal-popadults)/poptotal*100)

#Q2. �̼��� �α� ������� ���� ���� ���� 5�� county(����)�� popminor ���
mid %>% 
  arrange(desc(popminor)) %>% 
  select(county,popminor) %>% 
  head(5)

#Q3. ���ǥ ���ؿ� ���� �̼��� ���� ��� ���� �߰�, �� ��޿� �� �� ���� �ִ��� �˾ƺ���
mid <- mid %>% 
  mutate(level=ifelse(popminor>=40,"large",
                      ifelse(popminor>=30,"middle","small"))) %>% 
  group_by(level) %>% 
  summarise(n=n())

#Q3. ������ �̰�. group_by�� ���� mid�� �ٽ� �����ϸ� data�� �׷����� ������ 3obs. of 2 variables�� �ٲ�� �����̤Ѥ�
mid <- mid %>% 
  mutate(level=ifelse(popminor>=40,"large",
                        ifelse(popminor>=30,"middle","small")))

table(mid$level)

#Q4. '��ü �α� ��� �ƽþ��� �α� �����' ���� �߰��ϰ� ���� 10�� ������ state�� county, �ƽþ��� ������� ���
mid %>% 
  mutate(alevel=(popasian/poptotal)*100) %>% 
  arrange(alevel) %>% 
  select(state,county,alevel) %>% 
  head(10)
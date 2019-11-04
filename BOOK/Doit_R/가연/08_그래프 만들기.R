#####08-1 R�� ���� �� �ִ� �׷��� ���캸��#####
#ggplot2 ��Ű���� ���� �׷����� ���� �� ����
install.packages("ggplot2")
library(ggplot2)



#####08-2 ������ - ���� �� ���� ǥ���ϱ�#####
#ggplot2�� ���̾� ���� : ��� ����(��) - �׷��� �߰�(��, ����, ��) - ���� �߰�(�� ����, ��, ǥ��)

#��� �����ϱ�
#x���� displ, y���� hwy�� ������ ��� ����
ggplot(data = mpg, aes(x=displ,y=hwy))


#�׷��� �߰��ϱ�
#ggplot2��Ű�� �Լ����� "+"��ȣ�� ����(dplyr�� "%>%" ���� ����)
#�������� �׸��� �Լ� : geom_point()
ggplot(data = mpg, aes(x=displ,y=hwy))+geom_point()


#�� ������ �����ϴ� ���� �߰��ϱ�
#xlim()�� ylim()�� �̿��� ����

#x�� ���� 3-6���� ����
ggplot(data = mpg, aes(x=displ,y=hwy))+geom_point()+xlim(3,6)

#x�� ���� 3-6, y�� ���� 10-30���� ����
ggplot(data = mpg,aes(x=displ,y=hwy))+
  geom_point()+
  xlim(3,6)+
  ylim(10,30)


#qplot() : ��ó�� �ܰ迡 �����ϰ� Ȯ��(������ �����ؼ�)
#ggplot() : ���� ��� ���� ���� �׷��� ���� �� ���



#####��������#####
#Q1. mpg�����Ϳ��� x�� cty, y�� hwy�� �� ������ �����
ggplot(data = mpg, aes(x=cty,y=hwy))+geom_point()

#Q2.midwest �����Ϳ��� x���� poptotal, y���� popasian���� �� �������� �����. ��ü�α��� 50�� �� ����, �ƽþ��� �α��� 1���� ������ ������ ǥ���ϱ�.
#���� ������ ǥ���Ϸ��� options(scipen=99) ���� �� �׷��� ����� ��. options(scipen=0) �����ϸ� �ٽ� ������ ǥ����
ggplot(data=midwest, aes(x=poptotal,y=popasian))+
  geom_point()+
  xlim(0,500000)+
  ylim(0,10000)



#####08-3 ���� �׷��� - ���� �� ���� ǥ���ϱ�#####
#��� ���� �׷��� ����� : geom_col()�� ���� �׷��� ����
install.packages("dplyr")
library(dplyr)

df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))

ggplot(data = df_mpg, aes(x=drv,y=mean_hwy))+geom_col()

#ũ�� ������ �����ϱ� : reorder() ���(x�� ����, ���� �������� ���� ����)
ggplot(data = df_mpg, aes(x=reorder(drv,-mean_hwy),y=mean_hwy))+geom_col()


#�� ����׷��� ����� : geom_bar() ���, x�ุ ����
ggplot(data = mpg, aes(x=drv))+geom_bar()
ggplot(data = mpg, aes(x=hwy))+geom_bar()

#geom_col() : ���ǥ�� ����� �׷��� ����
#geom_bar() : ���ڷḦ ����� �׷��� ����



#####��������2#####
#Q1. "suv"���� ������� ��� cty�� ���� ���� ȸ�� �ټ� ���� ���� �׷����� ǥ��. ����� ���� ���� ������ ����
df_mpg1 <- mpg %>% 
  filter(class=="suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)

ggplot(data = df_mpg1, aes(x=reorder(manufacturer,-mean_cty),y=mean_cty))+geom_col()

#Q2. class(�ڵ��� ������) �󵵸� ǥ���� ���� �׷��� �����
ggplot(data = mpg, aes(x=class))+geom_bar()



#####08-4 �� �׷��� - �ð��� ���� �޶����� ������ ǥ���ϱ�#####
#�ð迭 �׷��� ����� : geom_line() ���
ggplot(data = economics, aes(x=date,y=unemploy))+geom_line()  #x�� �ð�, y�� �Ǿ��� ��



#####��������3#####
#Q1. date(�ð�)�� ���� psavert(���� �����) ��ȭ�� ��Ÿ�� �ð迭 �׷��� �����
ggplot(data = economics, aes(x=date,y=psavert))+geom_line()



#####08-5 ���� �׸� - ���� �� ���� ���� ǥ���ϱ�#####
#���� �׸� ����� : geom_boxplot() ���
ggplot(data = mpg, aes(x=drv,y=hwy))+geom_boxplot()

#ggplot ��Ű�� ���� : help -> Cheatsheets -> Data Visualization with ggplot2
#����ڵ��� ���� �׷����� �ڵ� ���� : THE R GRAPH GALLERY(bit.ly/2s5cmdc)
#Ȯ�� ��Ű���� : ggplot2 extensions(bit.ly/2pqzga)



#####��������4#####
#Q1. class(�ڵ��� ����)�� "compact","subcompact","suv"�� �ڵ����� cty�� ��Ÿ�� ���� �׸� �����
df_mpg2 <- mpg %>% 
  filter(class=="compact"|class=="subcompact"|class=="suv")

ggplot(data = df_mpg2, aes(x=class,y=cty))+geom_boxplot()  

#Q1. ������ �̰�
df_mpg2 <- mpg %>% 
  filter(class %in% c("compact","subcompact","suv"))

ggplot(data = df_mpg2, aes(x=class,y=cty))+geom_boxplot() 
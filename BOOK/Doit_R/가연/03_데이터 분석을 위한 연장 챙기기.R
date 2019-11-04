#####03-1 ���ϴ� ��, '����' �����ϱ�#####

#����(Variable) : ������ �м��� ���, �پ��� ���� ���ϰ� �ִ� �ϳ��� �Ӽ�
#���(Constant) : �ϳ��� �����θ� �Ǿ� �ִ� �Ӽ�


a <- 1
b <- 2
c <- 3
d <- 3.5
a+b
a+b+c
4/b
5*b

#���� ������ ������ ���� �����
var1 <- c(1,2,5,7,8)
var2 <- c(1:5)           #1~5���� ���� ������ var2 ����
var3 <- seq(1,5)         #1~5���� ���� ������ var3 ����
var4 <- seq(1,10,by=2)   #1~10���� 2���� ���� ������ var4 ����
var5 <- seq(1,10,by=3)
var1+2
var1+var2
var4+var5
var1+var2+var3

str1 <- "a"              #����ǥ ������ 1���� �Է� �� ��µ�...
str2 <- "text"
str3 <- "Hello World!"
str4 <- c("a","b","c")
str5 <- c("Hello!","World","is","good!")
str1+2                   #���� ������ ���� �Ұ�



#####03-2 ���� ���� ���� '�Լ�' �����ϱ�#####

#�Լ� -> �Լ��̸� + ��ȣ 

#mean() : ����� ���ϴ� �Լ�
x <- c(1,2,3)
mean(x)

#max() / min() : �ִ�/�ּڰ��� ���ϴ� �Լ�
max(x)
min(x)

#paste() : ���� ���ڸ� ���� �ϳ��� ����� �Լ�
str5
paste(str5, collapse = ",")    #��ǥ�� �����ڷ� �ܾ�� �ϳ��� ��ġ��
paste(str5, collapse = " ")    #collapse���� ��ɾ� = �Ķ����/�Ű�����

x_mean <- mean(x)
str5_paste <- paste(str5, collapse = " ")



#####03-3 �Լ� �ٷ���, '��Ű��' �����ϱ�#####

library(ggplot2)
x <- c("a","a","b","c")
qplot(x)                       #�� ���� �׷��� ���

#ggplot2�� mpg �����ͷ� �׷��� �����
qplot(data=mpg,x=hwy)
qplot(data=mpg,x=cty)
qplot(data=mpg,x=drv,y=hwy)

#x�� drv, y�� hwy, �� �׷��� ����
qplot(data=mpg,x=drv,y=hwy,geom="line")

#x�� drv, y�� hwy, ���� �׸� ����
qplot(data=mpg,x=drv,y=hwy,geom="boxplot")

#x�� drv, y�� hwy, ���� �׸� ����, drv�� �� ǥ��
qplot(data=mpg,x=drv,y=hwy,geom="boxplot",colour=drv)

#qplot �Լ� �Ŵ��� ���
?qplot



#####��������#####
#Q1 ���� ���� ���� ����� ����ϱ� : �ټ� ���� �л��� ������ �ý��ϴ�. �л����� ���� ������ ��� �ִ� ������ ����� ����Ͻÿ�. ���� ������ ������ ����. -> 80,60,70,50,90
score <- c(80,60,70,50,90)

#Q2 ��ü ��� ���ϱ� : ���� ������ �̿��� ��ü ��� ���� ���ϱ�
mean(score)

#Q3 ��ü ��� ���� ����� ����ϱ� : ��ü ����� �� ������ ����� ���
avr_score <- mean(score)
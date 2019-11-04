#####04-1 �����ʹ� ��� ���峪? - ������ ������ �����ϱ�#####

#������ ������ : ��� ���� ������ �簢�� ����� ǥó�� ����
#��(Column/variable) : ���η� ����, �Ӽ��� ��Ÿ��
#��(row/case) : ���η� ����, �� ����� ���� ������ ������



#####04-2 ������ ������ ����� - ���輺�� ������ �����#####

#���� �����
eng <- c(90, 80, 60, 70 )       #���� ���� ���� ����
math <- c(50,60,100,20)     #���� ���� ���� ����

#������ ������ ����� : 'data.frame()' �̿�
df_midterm <- data.frame(eng,math)

#�л��� �� ���� �߰�
class <- c(1,1,2,2)
df_midterm <- data.frame(eng,math,class)

#�м�
#'$'�� ������ ������ ���� ������ ������ �� ���
mean(df_midterm$eng)        #df_midterm�� eng�� ��� ����
mean(df_midterm$math)       #df_midterm�� math�� ��� ����

#������ ������ �� ���� �����
df_midterm <- data.frame(eng=c(90,80,60,70),
                         math=c(50,60,100,20),
                         class=c(1,1,2,2))


#####��������#####
#Q1.���� ǥ�� ������ ������ ���������� ����� ����Ͻÿ�.
df_ff <- data.frame(��ǰ = c("���","����","����"),
                      ���� = c(1800,1500,3000), 
                      �Ǹŷ� = c(24,38,13))

df_ft <- data.frame(name=c("���","����","����"),
                     price=c(1800,1500,3000),
                     volume=c(24,38,13))

#Q2. �������, �Ǹŷ� ����� ���غ��ÿ�.
mean(df_f$����)
mean(df_f$�Ǹŷ�)
mean(df_ff$price)
mean(df_ff$volume)



#####04-3 �ܺ� ������ �̿��ϱ� - ������ ���� ���� �����͸� �ҷ�����#####

#�������� �ҷ�����
library(readxl)
df_exam <- read_excel("C:\\rtest\\Doit_R\\Data\\excel_exam.xlsx")

getwd()
setwd(/Users/data_analysis/Desktop/project_1)

#�м�
mean(df_exam$english)
mean(df_exam$science)

#�������� ù ��° ���� �������� �ƴ� ��� : 'col_names=F' �Ķ���� ����
df_n <- read_excel("C:/rtest/Doit_R/Data/excel_exam_novar.xlsx")
df_n <- read_excel("C:/rtest/Doit_R/Data/excel_exam_novar.xlsx",col_names = F)

#�������Ͽ� ��Ʈ�� ���� �� ���� ��� : 'sheet=' �Ķ���� �̿�
df_s <- read_excel("C:/rtest/Doit_R/Data/excel_exam_sheet.xlsx",sheet=3)


#CSV���� �ҷ�����
#ù ��° �࿡ �������� ���� ��� : 'header=F' ���
#���ڰ� ����ִ� ���� �ҷ��� �� : 'stringsAsFactors=F' ���
df_csv <- read.csv("C:/rtest/Doit_R/Data/csv_exam.csv")


#������ �������� CSV���Ϸ� ���� : write.csv()
write.csv(df_midterm, file="df_midterm.csv")

#������ �������� RData���Ϸ� ���� : save()
save(df_midterm,file = "df_midterm.rda")

#RData���� �ҷ����� : load()
rm(df_midterm)
load("df_midterm.rda")     #�� ������ �Ҵ� ���� �ʾƵ� �ڵ� ���� ��
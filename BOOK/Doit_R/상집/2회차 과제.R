#2일차 과제


#p188 혼자서 해보기
##Q1
library(ggplot2)
ggplot(data=mpg,aes(x = cty , y = hwy))+geom_point()

##Q2
ggplot(data = midwest,aes(x = poptotal,y = popasian)) + 
  geom_point()+
  xlim(0,500000)+
  ylim(0,10000)
#---------------------------------------------------------------------------
#p193
##Q1
library(dplyr);library(tidyverse);library(ggplot2)

Q1_mpg <- mpg %>% 
  filter(class == "suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)

ggplot(data=Q1_mpg,aes(x = reorder(manufacturer,-mean_cty),y = mean_cty)) + geom_col()

##Q2
ggplot(data=mpg ,aes(x = class)) + geom_bar()
#-----------------------------------------------------------------
#p195
##Q1
ggplot(data = economics ,aes(x = date,y = psavert)) + geom_line()

#-------------------------------------
#p198
##Q1
box_mpg <- mpg %>% 
  filter(class %in% c("compact","subcompact","suv"))

ggplot(data = box_mpg,aes(x = class , y = cty)) + geom_boxplot()
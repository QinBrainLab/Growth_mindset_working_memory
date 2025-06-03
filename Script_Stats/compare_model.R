#Comparisons among 7 models (Fig. S3)
library(readxl)
library(ggplot2)
library(ggthemes)
rm(list = ls()) 
compmodel<-read_excel(".../Data/dic_model_compare.xlsx")


p<-ggplot(compmodel,aes( x=reorder(Models,-DIC_diff),DIC_diff,group=1))+geom_line(size=1)+geom_point(color="red",size=3)
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
p<-p+labs(x="Models",y="DIC value difference")
p

ggsave(file=".../figures/model_compare.pdf",width=4,height=4)

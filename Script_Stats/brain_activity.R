#------------------------------
# Project: CBD
# Title: Growth mindset & working memory capacity
# Author: Yuyao Zhao
# Date: 2022/09/22
#------------------------------
rm(list = ls()) 
library(readxl)
library(ppcor)
library(ggplot2)
library(ggthemes)

primary <-read.csv(".../Data/ROI_cluster_17_20.csv",header=TRUE,sep=",")
attach(primary)

#Age distribution of the final imaging sample (n = 306) (Fig. S1B)
a<-cbind(length(which(floor(Age_test/365)==8)),length(which(floor(Age_test/365)==9)),length(which(floor(Age_test/365)==10)),length(which(floor(Age_test/365)==11)),length(which(floor(Age_test/365)==12)))
colnames(a)=c('8','9','10','11','12')
b<-barplot(a, names.arg =colnames(a),width = 0.3,space= 0.8,col = c("firebrick3"),border = FALSE ,ylab="Count",xlab="Age (Years)",xlim = c(0,2.5),ylim=c(0,140))
b
#ROI analysis

#Activations of all ROIs (Fig. S4D)
#box_plot
ALLmelt<-data.matrix(primary_RT[c("aInsula","dACC","DLPFC","FEF","IPS","vmPFC","PCC","AG","PH")])
ALLdata<-melt(ALLmelt,measure.vars = c("aInsula","dACC","DLPFC","FEF","IPS","vmPFC","PCC","AG","PH"),variable.name = "variable")
ALLplot<-ggplot(data=ALLdata) + geom_boxplot(aes(x = Var2, y = value), width = 0.6,fill=c("darkorange2","darkorange2","brown3","brown3","brown3","dodgerblue3","dodgerblue3","dodgerblue3","dodgerblue3"))+ scale_x_discrete(labels=c("Caudate","aInsula","dACC","DLPFC","FEF","IPS","vmPFC","PCC","AG","PH"))
ALLplot<-ALLplot+labs(x= element_blank(),y="Activation of 2- > 0-back")+theme_classic()
ALLplot<-ALLplot+scale_colour_manual("",values = c("FPN"="brown3","DMN" = "dodgerblue3","SN"="darkorange2"))
ALLplot

#partial correlation pairwise (Table S15)
#MS & ROIs
a<-pcor.test(MS,Caudate,primary[,c("Age_test","gender")],method='pearson')
b<-pcor.test(MS,aInsula,primary[,c("Age_test","gender")],method='pearson')
c<-pcor.test(MS,dACC,primary[,c("Age_test","gender")],method='pearson')
d<-pcor.test(MS,DLPFC,primary[,c("Age_test","gender")],method='pearson')
e<-pcor.test(MS,FEF,primary[,c("Age_test","gender")],method='pearson')
f<-pcor.test(MS,IPS,primary[,c("Age_test","gender")],method='pearson')
g<-pcor.test(MS,vmPFC,primary[,c("Age_test","gender")],method='pearson')
h<-pcor.test(MS,PCC,primary[,c("Age_test","gender")],method='pearson')
i<-pcor.test(MS,AG,primary[,c("Age_test","gender")],method='pearson')
j<-pcor.test(MS,PH,primary[,c("Age_test","gender")],method='pearson')

format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(p.adjust(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value),method="fdr"), digits=3, scientific=FALSE)

#ACC & ROIs
a<-pcor.test(ACC_2,Caudate,primary[,c("Age_test","gender")],method='pearson')
b<-pcor.test(ACC_2,aInsula,primary[,c("Age_test","gender")],method='pearson')
c<-pcor.test(ACC_2,dACC,primary[,c("Age_test","gender")],method='pearson')
d<-pcor.test(ACC_2,DLPFC,primary[,c("Age_test","gender")],method='pearson')
e<-pcor.test(ACC_2,FEF,primary[,c("Age_test","gender")],method='pearson')
f<-pcor.test(ACC_2,IPS,primary[,c("Age_test","gender")],method='pearson')
g<-pcor.test(ACC_2,vmPFC,primary[,c("Age_test","gender")],method='pearson')
h<-pcor.test(ACC_2,PCC,primary[,c("Age_test","gender")],method='pearson')
i<-pcor.test(ACC_2,AG,primary[,c("Age_test","gender")],method='pearson')
j<-pcor.test(ACC_2,PH,primary[,c("Age_test","gender")],method='pearson')

format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(p.adjust(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value),method="fdr"), digits=3, scientific=FALSE)

#RT & ROIs
primary_RT<-primary[which(primary$hit_rate_RT_2>0),]
attach(primary_RT)
a<-pcor.test(hit_rate_RT_2,Caudate,primary_RT[,c("Age_test","gender")],method='pearson')
b<-pcor.test(hit_rate_RT_2,aInsula,primary_RT[,c("Age_test","gender")],method='pearson')
c<-pcor.test(hit_rate_RT_2,dACC,primary_RT[,c("Age_test","gender")],method='pearson')
d<-pcor.test(hit_rate_RT_2,DLPFC,primary_RT[,c("Age_test","gender")],method='pearson')
e<-pcor.test(hit_rate_RT_2,FEF,primary_RT[,c("Age_test","gender")],method='pearson')
f<-pcor.test(hit_rate_RT_2,IPS,primary_RT[,c("Age_test","gender")],method='pearson')
g<-pcor.test(hit_rate_RT_2,vmPFC,primary_RT[,c("Age_test","gender")],method='pearson')
h<-pcor.test(hit_rate_RT_2,PCC,primary_RT[,c("Age_test","gender")],method='pearson')
i<-pcor.test(hit_rate_RT_2,AG,primary_RT[,c("Age_test","gender")],method='pearson')
j<-pcor.test(hit_rate_RT_2,PH,primary_RT[,c("Age_test","gender")],method='pearson')

format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(p.adjust(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value),method="fdr"), digits=3, scientific=FALSE)

#avt & ROIs (change for a v t separately) (Table S16)
attach(primary)
a<-pcor.test(v_2,Caudate,primary[,c("Age_test","gender")],method='pearson')
b<-pcor.test(v_2,aInsula,primary[,c("Age_test","gender")],method='pearson')
c<-pcor.test(v_2,dACC,primary[,c("Age_test","gender")],method='pearson')
d<-pcor.test(v_2,DLPFC,primary[,c("Age_test","gender")],method='pearson')
e<-pcor.test(v_2,FEF,primary[,c("Age_test","gender")],method='pearson')
f<-pcor.test(v_2,IPS,primary[,c("Age_test","gender")],method='pearson')
g<-pcor.test(v_2,vmPFC,primary[,c("Age_test","gender")],method='pearson')
h<-pcor.test(v_2,PCC,primary[,c("Age_test","gender")],method='pearson')
i<-pcor.test(v_2,AG,primary[,c("Age_test","gender")],method='pearson')
j<-pcor.test(v_2,PH,primary[,c("Age_test","gender")],method='pearson')

format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(p.adjust(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value),method="fdr"), digits=3, scientific=FALSE)




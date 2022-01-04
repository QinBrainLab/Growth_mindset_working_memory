##new yuyao zhao 2020.09.23
setwd("/Users/zhaoyuyao/Desktop/MS_WM_project/behavior/TP1_analysis")
data <- read.csv('TP1.csv') 


#library
library(lme4)
library(lmerTest)
library(irr)
library(ggplot2)
library(psych)
library(car)
library(MASS)
library(reshape2)
library(gvlma)
library(ggthemes)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(ppcor)

attach(data)

##descriptive analysis
#gender
summary(as.factor(gender))
#others
desvars <- c("Age_scale","Age_test","test_scale","MS","ACC_0","ACC_1","ACC_2","hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2")
describe(data[desvars])
Age_inyear <- Age_test/365
describe(Age_inyear)

#bar_plot age
a<-cbind(length(which(floor(Age_test/365)==8)),length(which(floor(Age_scale/365)==9)),length(which(floor(Age_scale/365)==10)),length(which(floor(Age_scale/365)==11)),length(which(floor(Age_scale/365)==12)))
colnames(a)=c('8','9','10','11','12')
b<-barplot(a, names.arg =colnames(a),width = 0.3,space= 0.8,col = c("firebrick3"),border = FALSE ,ylab="Count",xlab="Age (Years)",xlim = c(0,2.5),ylim=c(0,140))



###ANOVA WM
##ACC
ACCmelt<-data.matrix(data[c("ACC_0","ACC_1","ACC_2")])
ACCdata<-melt(ACCmelt,measure.vars = c("ACC_0","ACC_1","ACC_2"))
#normality assumption
shapiro.test(ACC_2)
shapiro.test(ACC_1)
shapiro.test(ACC_0)
ggqqplot(ACCdata,"value",facet.by = "Var2")
#computation
res.aov <- anova_test(data = ACCdata, dv = value, wid = Var1, within = Var2)
get_anova_table(res.aov)
# pairwise comparisons
pwc <- ACCdata %>%
  pairwise_t_test(
    value ~ Var2, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
pwc

#box_plot ACC
ACCplot<-ggplot(data = ACCdata) + geom_boxplot(aes(x = Var2, y = value), width = 0.6,fill = c("rosybrown1","brown3","firebrick4"))+ scale_x_discrete(labels=c("0-back","1-back","2-back"))
ACCplot<-ACCplot+labs(x= element_blank(),y="Normalized modularity")+theme_base()+ expand_limits (y = c(-1.5, 7))
ACCplot

##RT
RTmelt<-data.matrix(data[c("hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2")])
RTdata<-melt(RTmelt,measure.vars = c("hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2"))
#normality assumption
shapiro.test(hit_rate_RT_2)
shapiro.test(hit_rate_RT_1)
shapiro.test(hit_rate_RT_0)
ggqqplot(RTdata,"value",facet.by = "Var2")
#computation
res.aov <- anova_test(data = RTdata, dv = value, wid = Var1, within = Var2)
get_anova_table(res.aov)
# pairwise comparisons
pwc <- RTdata %>%
  pairwise_t_test(
    value ~ Var2, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
pwc

#box_plot RT
RTplot<-ggplot(data = RTdata) + geom_boxplot(aes(x = Var2, y = value), width = 0.6,fill = c("lightskyblue1","dodgerblue", "dodgerblue4"))+ scale_x_discrete(labels=c("0-back","1-back","2-back"))
RTplot<-RTplot+labs(x= element_blank(),y="Milliseconds")+theme_base()+ expand_limits (y = c(200,1500))
RTplot
# this will remove 8 rows with miss data




#correlation
testvar<-as.matrix(cbind(MS,Age_test,ACC_0,ACC_1,ACC_2,hit_rate_RT_0,hit_rate_RT_1,hit_rate_RT_2))
print(corr.test(testvar,method='pearson'),digits=3)
#partial correlation pairwise
pcor.test(MS,ACC_2,Age_test,method='pearson')
pcor.test(MS,ACC_1,Age_test,method='pearson')
pcor.test(MS,ACC_0,Age_test,method='pearson')
data0.prep<-data.frame(data$MS,data$hit_rate_RT_0,data$Age_test)
data0<-data[complete.cases(data0.prep),]
pcor.test(data0$MS,data0$hit_rate_RT_0,data0$Age_test,method='pearson')
data1.prep<-data.frame(data$MS,data$hit_rate_RT_1,data$Age_test)
data1<-data[complete.cases(data1.prep),]
pcor.test(data1$MS,data1$hit_rate_RT_1,data1$Age_test,method='pearson')
data2.prep<-data.frame(data$MS,data$hit_rate_RT_2,data$Age_test)
data2<-data[complete.cases(data2.prep),]
pcor.test(data2$MS,data2$hit_rate_RT_2,data2$Age_test,method='pearson')


pre0<-lm(MS~Age_test,data=data)
summary(pre0)
pre1<-lm(ACC_0~Age_test,data=data)
summary(pre1)
pre2<-lm(ACC_1~Age_test,data=data)
summary(pre2)
pre3<-lm(ACC_2~Age_test,data=data)
summary(pre3)
pre4<-lm(hit_rate_RT_0~Age_test,data=data)
summary(pre4)
pre5<-lm(hit_rate_RT_1~Age_test,data=data)
summary(pre5)
pre6<-lm(hit_rate_RT_2~Age_test,data=data)
summary(pre6)


#trajectory plot
#GM
p<-ggplot(data.frame(Age_test,MS),aes(Age_test,MS))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5),text=element_text(family = "Times New Roman"))
p<-p+annotate("text",x=4500,y=15,label="italic(r) == 0.018",parse=T,size=5)+labs(x="Age",y="Score")+theme_base()
p
#2back
p<-ggplot(data.frame(Age_test,ACC_2),aes(Age_test,ACC_2))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
p<-p+annotate("text",x=4500,y=-0.5,label="italic(r) == 0.258^'***'",parse=T,size=5)+labs(x="Age",y="Normalized modularity")+theme_base()
p
#1back
p<-ggplot(data.frame(Age_test,ACC_1),aes(Age_test,ACC_1))+geom_point(color="rosybrown1")+stat_smooth(method="lm",color="firebrick3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
p<-p+annotate("text",x=4500,y=-0.5,label="italic(r) == 0.159^'**'",parse=T,size=5)+labs(x="Age",y="Normalized modularity")+theme_base()
p
#0back
p<-ggplot(data.frame(Age_test,ACC_0),aes(Age_test,ACC_0))+geom_point(color="rosybrown1")+stat_smooth(method="lm",color="firebrick3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
p<-p+annotate("text",x=4500,y=-0.5,label="italic(r) == 0.078",parse=T,size=5)+labs(x="Age",y="Normalized modularity")+theme_base()
p
#2back
p<-ggplot(data.frame(Age_test,hit_rate_RT_2),aes(Age_test,hit_rate_RT_2))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",color="dodgerblue3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
p<-p+annotate("text",x=4500,y=250,label="italic(r) == -0.203^'***'",parse=T,size=5)+labs(x="Age",y="Milliseconds")+theme_base()
p
#1back
p<-ggplot(data.frame(Age_test,hit_rate_RT_1),aes(Age_test,hit_rate_RT_1))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",color="dodgerblue3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
p<-p+annotate("text",x=4500,y=250,label="italic(r) == -0.281^'***'",parse=T,size=5)+labs(x="Age",y="Milliseconds")+theme_base()
p
#0back
p<-ggplot(data.frame(Age_test,hit_rate_RT_0),aes(Age_test,hit_rate_RT_0))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",color="dodgerblue3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
p<-p+annotate("text",x=4500,y=250,label="italic(r) == -0.289^'***'",parse=T,size=5)+labs(x="Age",y="Milliseconds")+theme_base()
p

##linear regression
#regression

fit1<-lm(ACC_2~Age_test+MS,data=data)
summary(fit1)
fit2<-lm(ACC_1~Age_test+MS,data=data)
summary(fit2)
fit3<-lm(ACC_0~Age_test+MS,data=data)
summary(fit3)
fit4<-lm(hit_rate_RT_2~Age_test+MS,data=data)
summary(fit4)
fit5<-lm(hit_rate_RT_1~Age_test+MS,data=data)
summary(fit5)
fit6<-lm(hit_rate_RT_0~Age_test+MS,data=data)
summary(fit6)


gvmodel<-gvlma(fit2)
summary(gvmodel)


#plot

#integrated plot
predata<-data[c("MS","Age_test","ACC_0","ACC_1","ACC_2")]
premelt<-melt(predata,ad = c("MS","Age_test"),measure.vars=c("ACC_0","ACC_1","ACC_2"))
p<-ggplot(data=premelt,aes(x=MS,y=value,color=variable))+geom_smooth(method="lm")
p<-p+theme_base()
p<-p+labs(x="Mindset Score",y="Normalized modularity")
p<-p + 
  scale_color_manual(values = c("rosybrown1","brown3","firebrick4"),breaks=c("ACC_0","ACC_1","ACC_2"),labels=c("0-back","1-back","2-back"))+
  annotate("text",x=40,y=4.1,label="italic(r) == 0.197^'***'",parse=T,size=5)+
  annotate("text",x=40,y=3.1,label="italic(r) == 0.136^'**'",parse=T,size=5)+
  annotate("text",x=40,y=1.9,label="italic(r) == 0.214^'***'",parse=T,size=5)+
  theme(
    legend.position = c(.15,.85),
    legend.title = element_blank()
  )
p

#single plot with scatter
#ACC
p<-ggplot(data.frame(MS,ACC_0),aes(MS,ACC_0))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_base()
p<-p+annotate("text",x=50,y=-1,label="italic(r) == 0.197^'***'",parse=T,size=5)+labs(x="Mindset Score",y="Normalized modularity")
p

p<-ggplot(data.frame(MS,ACC_1),aes(MS,ACC_1))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_base()
p<-p+annotate("text",x=55,y=-1,label="italic(r) == 0.136^'**'",parse=T,size=5)+labs(x="Mindset Score",y="Normalized modularity")
p

p<-ggplot(data.frame(MS,ACC_1),aes(MS,ACC_2))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_base()
p<-p+annotate("text",x=50,y=-1,label="italic(r) == 0.214^'***'",parse=T,size=5)+labs(x="Mindset Score",y="Normalized modularity")
p

#RT

p<-ggplot(data.frame(MS,hit_rate_RT_0),aes(MS,hit_rate_RT_0))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",color="dodgerblue3")
p<-p+annotate("text",x=50,y=350,label="italic(r) == -0.008",parse=T,size=5)+labs(x="Mindset Score",y="Milliseconds")+theme_base()
p

p<-ggplot(data.frame(MS,hit_rate_RT_1),aes(MS,hit_rate_RT_1))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",color="dodgerblue3")
p<-p+annotate("text",x=50,y=250,label="italic(r) == -0.046",parse=T,size=5)+labs(x="Mindset Score",y="Milliseconds")+theme_base()
p

p<-ggplot(data.frame(MS,hit_rate_RT_2),aes(MS,hit_rate_RT_2))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",color="dodgerblue3")
p<-p+annotate("text",x=55,y=250,label="italic(r) == -0.011",parse=T,size=5)+labs(x="Mindset Score",y="Milliseconds")+theme_base()
p




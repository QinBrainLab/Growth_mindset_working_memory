
#------------------------------
# Project: CBD
# Title: Growth mindset & working memory capacity
# Author: Yuyao Zhao (yuyao.zhao98@gmail.com)
# Date: 2022/09/22
#------------------------------

#library
library(psych)
library(lme4)
library(lmerTest)
library(irr)
library(ggplot2)
library(reshape2)
library(ggthemes)

# basic information setup
rm(list = ls())  
setwd('...')
getwd()
# Loading files
library(readxl)
Long_nb <- read_excel('.../data/NB_3Y_HDDM.xlsx', col_types = c("text", 
                                                                                                                         "numeric", "numeric", "numeric", "numeric", 
                                                                                                                         "numeric", "numeric", "numeric", "numeric", 
                                                                                                                         "numeric", "numeric", "numeric", "numeric", 
                                                                                                                         "numeric", "numeric", "numeric", "numeric", 
                                                                                                                         "numeric", "numeric", "numeric", "numeric", 
                                                                                                                         "numeric", "numeric", "numeric", "numeric", 
                                                                                                                         "numeric","numeric", "numeric", "numeric", "numeric", "numeric", 
                                                                                                                         "numeric","numeric", "numeric"))
head(Long_nb)
attach(Long_nb)


##test the effect of manipulation in each year
TP1<-Long_nb[which(Year==1),]
TP2<-Long_nb[which(Year==2),]
TP3<-Long_nb[which(Year==3),]
des<-describe(TP3$Age_inyear)
summary(as.factor(TP3$gender))

#Descriptive
summary(TP1)
sd(MS)
sd(ACC_0)
sd(ACC_1)
sd(ACC_2)
sd(c(TP1[complete.cases(TP1),hit_rate_RT_0]))
sd(hit_rate_RT_1)
sd(hit_rate_RT_2)

###Effect of workloads for WM performance (Table S3-S4)
## Change the dataframe for each year

##d'
ACCmelt<-data.matrix(TP1[c("ACC_0","ACC_1","ACC_2")])
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

#RT
RTmelt<-data.matrix(TP1[c("hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2")])
RTdata<-melt(RTmelt,measure.vars = c("hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2"))
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

#a
amelt<-data.matrix(TP1[c("a_0","a_1","a_2")])
adata<-melt(amelt,measure.vars = c("a_0","a_1","a_2"))
#computation
res.aov <- anova_test(data = adata, dv = value, wid = Var1, within = Var2)
get_anova_table(res.aov)

#v
vmelt<-data.matrix(TP1[c("v_0","v_1","v_2")])
vdata<-melt(vmelt,measure.vars = c("v_0","v_1","v_2"))
#computation
res.aov <- anova_test(data = vdata, dv = value, wid = Var1, within = Var2)
get_anova_table(res.aov)

#t
tmelt<-data.matrix(TP1[c("t_0","t_1","t_2")])
tdata<-melt(tmelt,measure.vars = c("t_0","t_1","t_2"))
#computation
res.aov <- anova_test(data = tdata, dv = value, wid = Var1, within = Var2)
get_anova_table(res.aov)



#correlation
library(psych)
print(corr.test(cbind(TP1[6],TP1[11],TP1[14]),cbind(TP1[17:18],TP1[21:22],TP1[25:26]),method='pearson'),digits=3)
print(corr.test(cbind(TP2[6],TP2[11],TP2[14]),cbind(TP2[17:18],TP2[21:22],TP2[25:26]),method='pearson'),digits=3)
print(corr.test(cbind(TP3[6],TP3[11],TP3[14]),cbind(TP3[17:18],TP3[21:22],TP3[25:26]),method='pearson'),digits=3)

par.1<-partial.r(TP1, c(13,14:22,25:26,29:30,33:34), c(5,10),use="pairwise",method="pearson")
lowerMat(par.1,digits=3)
cp<-corr.p(par.1,adjust="fdr",n=dim(TP1)[1])
print(cp,short=FALSE,digits=3) 

par.2<-partial.r(TP2, c(13,14:22,25:26,29:30,33:34), c(5,10),use="pairwise",method="pearson")
lowerMat(par.2,digits=3)
cp<-corr.p(par.2,adjust="fdr",n=dim(TP2)[1])
print(cp,short=FALSE,digits=3) 

par.3<-partial.r(TP3,  c(13,14:22,25:26,29:30,33:34), c(5,10),use="pairwise",method="pearson")
lowerMat(par.3,digits=3)
cp<-corr.p(par.3,adjust="bonferroni",n=dim(TP3)[1])
print(cp,short=FALSE,digits=3) 






#seperate into different years and match datasets
MS_TP1<-Long_nb[which(Year==1),c("ID","MS")]
MS_TP2<-Long_nb[which(Year==2),c("ID","MS")]
MS_TP3<-Long_nb[which(Year==3),c("ID","MS")]
MS_match<-merge(merge(MS_TP1,MS_TP2,by="ID",suffixes = c("_1","_2")),MS_TP3,by="ID")

WM_TP1<-Long_nb[which(Year==1),c("ID","ACC_0","ACC_1","ACC_2","hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2")]
WM_TP2<-Long_nb[which(Year==2),c("ID","ACC_0","ACC_1","ACC_2","hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2")]
WM_TP3<-Long_nb[which(Year==3),c("ID","ACC_0","ACC_1","ACC_2","hit_rate_RT_0","hit_rate_RT_1","hit_rate_RT_2")]
WM_match<-merge(merge(WM_TP1,WM_TP2,by="ID",suffixes = c("_1","_2")),WM_TP3,by="ID")

HDDM_TP1<-Long_nb[which(Year==1),c("ID","a_0","a_1","a_2","v_0","v_1","v_2","t_0","t_1","t_2")]
HDDM_TP2<-Long_nb[which(Year==2),c("ID","a_0","a_1","a_2","v_0","v_1","v_2","t_0","t_1","t_2")]
HDDM_TP3<-Long_nb[which(Year==3),c("ID","a_0","a_1","a_2","v_0","v_1","v_2","t_0","t_1","t_2")]
HDDM_match<-merge(merge(HDDM_TP1,HDDM_TP2,by="ID",suffixes = c("_1","_2")),HDDM_TP3,by="ID")


##ICC (Table S5 & S6)
data=na.omit(WM_match)
#MS
icc(MS_match[,2:4],"twoway","consistency","average", r0 = 0, conf.level = 0.95)

#WM_0back
icc(data[,c(2,8,14)],"twoway","consistency","average", r0 = 0, conf.level = 0.95)
icc(data[,c(5,11,17)],"twoway","consistency","average", r0 = 0, conf.level = 0.95)
#WM_1back
icc(data[,c(3,9,15)],"twoway","consistency","average", r0 = 0, conf.level = 0.95)
icc(data[,c(6,12,18)],"twoway","consistency","average", r0 = 0, conf.level = 0.95)
#WM_2back
icc(data[,c(4,10,16)],"twoway","consistency","average", r0 = 0, conf.level = 0.95)
icc(data[,c(7,13,19)],"twoway","consistency","average", r0 = 0, conf.level = 0.95)
#HDDM_a
icc(HDDM_match[,c(2,11,20)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #0
icc(HDDM_match[,c(3,12,21)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #1
icc(HDDM_match[,c(4,13,22)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #2
#HDDM_v
icc(HDDM_match[,c(5,14,23)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #0
icc(HDDM_match[,c(6,15,24)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #1
icc(HDDM_match[,c(7,16,25)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #2
#HDDM_t
icc(HDDM_match[,c(8,17,26)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #0
icc(HDDM_match[,c(9,18,27)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #1
icc(HDDM_match[,c(10,19,28)],"twoway","consistency","average", r0 = 0, conf.level = 0.95) #2
Long_nb$Age_C<-scale(Long_nb$Age_test)
Long_nb$MS_C<-scale(Long_nb$MS)
Long_nb$gender_factor<-factor(Long_nb$gender-1)

#LMM output & comparison
#Comparison of linear mixed models for Mindset (Table S7)
lmG.null<-lmer(MS~(1|ID), data = Long_nb, REML = F)
summary(lmG.null)
lmG.adj1<-lmer(MS~gender_factor+(1|ID),data=Long_nb, REML = F)
summary(lmG.adj1)
lmG.adj2<-lmer(MS~gender_factor+Age_C+(1|ID),data=Long_nb, REML = F)
summary(lmG.adj2)
lmG.adj3<-lmer(MS~gender_factor+Age_C+I(Age_C^2)+(1|ID),data=Long_nb, REML = F)
summary(lmG.adj3)
anova(lmG.null,lmG.adj1,lmG.adj2,lmG.adj3)

# (not displayed in results or supplementary but interesting)
#here is an interesting interaction between age and gender for MS, but did not observe any gender effect for d' or v
ggplot(Long_nb, aes( x = Age_inyear, y = MS,color = gender_factor)) + geom_point( aes( color = gender_factor), size=2) + geom_smooth(method = 'lm', formula = y ~ x, se = T)
Long_female<-Long_nb[which(Long_nb$gender==2),]
Long_male<-Long_nb[which(Long_nb$gender==1),]
lmG.male<-lmer(MS~Age_test+(1|ID),data=Long_male, REML = F)
summary(lmG.male)
lmG.female<-lmer(MS~Age_test+(1|ID),data=Long_female, REML = F)
summary(lmG.female)
lm.fe<-lmer(v_2~MS_C*Age_C+(1|ID),data=Long_female, REML = F)
summary(lm.fe)
lm.ma<-lmer(v_2~MS_C*Age_C+(1|ID),data=Long_male, REML = F)
summary(lm.ma)
#only male shows innately growth of mindset


#Comparison of linear mixed models for d' (Table S7)
lm.null<-lmer(ACC_2~(1|ID), data = Long_nb, REML = F)
summary(lm.null)
lm.adj1<-lmer(ACC_2~gender_factor+(1|ID), data = Long_nb, REML = F)
summary(lm.adj1)
lm.adj2<-lmer(ACC_2~gender_factor+Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj2)
lm.adj3<-lmer(ACC_2~gender_factor+Age_C+I(Age_C^2)+(1|ID),data=Long_nb, REML = F)
summary(lm.adj3)
anova(lm.null,lm.adj1,lm.adj2,lm.adj3)

lm.null<-lmer(ACC_1~(1|ID), data = Long_nb, REML = F)
summary(lm.null)
lm.adj1<-lmer(ACC_1~gender_factor+(1|ID), data = Long_nb, REML = F)
summary(lm.adj1)
lm.adj2<-lmer(ACC_1~gender_factor+Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj2)
lm.adj3<-lmer(ACC_1~gender_factor+Age_C+I(Age_C^2)+(1|ID),data=Long_nb, REML = F)
summary(lm.adj3)
anova(lm.null,lm.adj1,lm.adj2,lm.adj3)

lm.null<-lmer(ACC_0~(1|ID), data = Long_nb, REML = F)
summary(lm.null)
lm.adj1<-lmer(ACC_0~gender_factor+(1|ID), data = Long_nb, REML = F)
summary(lm.adj1)
lm.adj2<-lmer(ACC_0~gender_factor+Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj2)
lm.adj3<-lmer(ACC_0~gender_factor+Age_C+I(Age_C^2)+(1|ID),data=Long_nb, REML = F)
summary(lm.adj3)
anova(lm.null,lm.adj1,lm.adj2,lm.adj3)

#Linear mixed model of mindset and d' over age and gender (Table S9)
lm.adj40<-lmer(ACC_0~gender+MS_C*Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj40)
lm.adj41<-lmer(ACC_1~gender+MS_C*Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj41)
lm.adj42<-lmer(ACC_2~gender+MS_C*Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj42)
#control for multiple comparison
format(p.adjust(c(0.002,0.00256,0.000366),method="fdr"), digits=2, scientific=FALSE)




#Comparison of linear mixed models for drift rate (v) (Table S8)
lm.null<-lmer(v_2~(1|ID), data = Long_nb, REML = F)
summary(lm.null)
lm.adj1<-lmer(v_2~gender_factor+(1|ID), data = Long_nb, REML = F)
summary(lm.adj1)
lm.adj2<-lmer(v_2~gender_factor+Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj2)
lm.adj3<-lmer(v_2~gender_factor+Age_C+I(Age_C^2)+(1|ID),data=Long_nb, REML = F)
summary(lm.adj3)
anova(lm.null,lm.adj1,lm.adj2,lm.adj3)


lm.null<-lmer(v_1~(1|ID), data = Long_nb, REML = F)
summary(lm.null)
lm.adj1<-lmer(v_1~gender_factor+(1|ID), data = Long_nb, REML = F)
summary(lm.adj1)
lm.adj2<-lmer(v_1~gender_factor+Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj2)
lm.adj3<-lmer(v_1~gender_factor+Age_C+I(Age_C^2)+(1|ID),data=Long_nb, REML = F)
summary(lm.adj3)
anova(lm.null,lm.adj1,lm.adj2,lm.adj3)


lm.null<-lmer(v_0~(1|ID), data = Long_nb, REML = F)
summary(lm.null)
lm.adj1<-lmer(v_0~gender_factor+(1|ID), data = Long_nb, REML = F)
summary(lm.adj1)
lm.adj2<-lmer(v_0~gender_factor+Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj2)
lm.adj3<-lmer(v_0~gender_factor+Age_C+I(Age_C^2)+(1|ID),data=Long_nb, REML = F)
summary(lm.adj3)
anova(lm.null,lm.adj1,lm.adj2,lm.adj3)

#Linear mixed model of mindset and drift rate over age and gender (Table S10)
lm.adj40<-lmer(v_0~gender+MS_C*Age_C+(1|ID),data=Long_nb, REML = F)
lm.adj41<-lmer(v_1~gender+MS_C*Age_C+(1|ID),data=Long_nb, REML = F)
lm.adj42<-lmer(v_2~gender+MS_C*Age_C+(1|ID),data=Long_nb, REML = F)
summary(lm.adj40)
#control for multiple comparison
format(p.adjust(c(0.0186,0.0000735,0.000127),method="fdr"), digits=2, scientific=FALSE)

#Growth mindset positively associated with WM d’ across three years (Fig. 1G)
predata<-Long_nb[c("MS","Age_test","ACC_0","ACC_1","ACC_2")]
premelt<-melt(predata,ad = c("MS","Age_test"),measure.vars=c("ACC_0","ACC_1","ACC_2"))
p<-ggplot(data=premelt,aes(x=MS,y=value,color=variable))+geom_smooth(method="lm")
p<-p+theme_base()
p<-p+labs(x="Mindset",y="d'")
p<-p + 
  scale_color_manual(values = c("rosybrown1","brown3","firebrick4"),breaks=c("ACC_0","ACC_1","ACC_2"),labels=c("0-back","1-back","2-back"))
p

#Growth mindset positively correlated with drift rate across three years (Fig. 1H)
predata<-Long_nb[c("MS","Age_test","v_0","v_1","v_2")]
premelt<-melt(predata,ad = c("MS","Age_test"),measure.vars=c("v_0","v_1","v_2"))
p<-ggplot(data=premelt,aes(x=MS,y=value,color=variable))+geom_smooth(method="lm")
p<-p+theme_base()
p<-p+labs(x="Mindset",y="Drift rate (v)")
p<-p + 
  scale_color_manual(values = c("rosybrown1","brown3","firebrick4"),breaks=c("v_0","v_1","v_2"),labels=c("0-back","1-back","2-back"))
p

#trajectory plots
library(ggthemes)
#GM
p<-ggplot(data.frame(Age_inyear,MS),aes(Age_inyear,MS))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x+I(x^2),color="firebrick3")
p<-p+theme(panel.grid.major=element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5),text=element_text(family = "Times New Roman"))
p<-p+labs(x="Age",y="Score",title="Predicted trajectory for Mindset",family = "Times New Roman")
p
# Developmental trajectories of WM performance measured by d’ (Fig.1.F)
#2back
p<-ggplot(data.frame(Age_inyear,ACC_2),aes(Age_inyear,ACC_2))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x+I(x^2),color="firebrick3")
p<-p+theme_base()
p<-p+labs(x="Age",y="d'")
p
#1back
p<-ggplot(data.frame(Age_inyear,ACC_1),aes(Age_inyear,ACC_1))+geom_point(color="rosybrown1")+stat_smooth(method="lm",color="firebrick3")
p<-p+theme_base()
p<-p+labs(x="Age",y="d'")
p
#0back
p<-ggplot(data.frame(Age_inyear,ACC_0),aes(Age_inyear,ACC_0))+geom_point(color="rosybrown1")+stat_smooth(method="lm",color="firebrick3")
p<-p+theme_base()
p<-p+labs(x="Age",y="d'")
p



library(mediation)
library(readxl)
library(ppcor)
library(ggplot2)
library(ggthemes)
library(psych)
library(reshape2)
library(rstatix)

ROI_cluster_new<-read_excel("C:/Users/lenovo/Desktop/MS_project/behavior/TP1_analysis/ROI_cluster_new_2.xlsx")

attach(ROI_cluster_new)
#bar_plot age
a<-cbind(length(which(floor(Age_test/365)==8)),length(which(floor(Age_scale/365)==9)),length(which(floor(Age_scale/365)==10)),length(which(floor(Age_scale/365)==11)),length(which(floor(Age_scale/365)==12)))
colnames(a)=c('8','9','10','11','12')
b<-barplot(a, names.arg =colnames(a),width = 0.3,space= 0.8,col = c("firebrick3"),border = FALSE ,ylab="Count",xlab="Age (Years)",xlim = c(0,2.5),ylim=c(0,140))

#ROI analysis

#overall boxplot
#box_plot FPN
ALLmelt<-data.matrix(ROI_cluster_new[c("DLPFC","IPS","Caudate","vmPFC","PCC","AG","PH")])
ALLdata<-melt(ALLmelt,measure.vars = c("DLPFC","IPS","Caudate","vmPFC","PCC","AG","PH"))
ALLplot<-ggplot(data=ALLdata) + geom_boxplot(aes(x = Var2, y = value), width = 0.6,fill=c("brown3","brown3","brown3","dodgerblue3","dodgerblue3","dodgerblue3","dodgerblue3"))+ scale_x_discrete(labels=c("dlPFC","IPS","Caudate","vmPFC","PCC","AG","PH"))
ALLplot<-ALLplot+labs(x= element_blank(),y="Activation of 1- > 0-back")+theme_classic()
ALLplot<-ALLplot+scale_colour_manual("",values = c("FPN"="brown3","DMN" = "dodgerblue3"))
ALLplot
#t test
t.test(DLPFC,mu=0)
t.test(IPS,mu=0)
t.test(Caudate,mu=0)
t.test(vmPFC,mu=0)
t.test(PCC,mu=0)
t.test(AG,mu=0)
t.test(PH,mu=0)
# pairwise comparisons
commelt<-data.matrix(ROI_cluster_new[c("DLPFC","IPS","Caudate","vmPFC","PCC","AG","PH","FPN","DMN")])
comdata<-melt(commelt,measure.vars = c("DLPFC","IPS","Caudate","vmPFC","PCC","AG","PH","FPN","DMN"))
pwc <- comdata %>%
  pairwise_t_test(
    value ~ Var2, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
pwc



#correlation
testvar<-as.matrix(cbind(MS,Age_test,ACC_0,ACC_1,ACC_2,hit_rate_RT_0,hit_rate_RT_1,hit_rate_RT_2,Caudate,Caudate_L,Caudate_R,IPS,IPS_L,IPS_R,DLPFC,dlPFC_L,dlPFC_R,vmPFC,PCC,PH,PH_L,PH_R,AG,AG_L,AG_R))
print(corr.test(testvar,method='pearson'),digits=3)
#partial correlation pairwise
#MS & ROIs
pcor.test(MS,Caudate,Age_test,method='pearson')
pcor.test(MS,Caudate_L,Age_test,method='pearson')
pcor.test(MS,Caudate_R,Age_test,method='pearson')
pcor.test(MS,IPS,Age_test,method='pearson')
pcor.test(MS,IPS_L,Age_test,method='pearson')
pcor.test(MS,IPS_R,Age_test,method='pearson')
pcor.test(MS,DLPFC,Age_test,method='pearson')
pcor.test(MS,dlPFC_L,Age_test,method='pearson')
pcor.test(MS,dlPFC_R,Age_test,method='pearson')
pcor.test(MS,vmPFC,Age_test,method='pearson')
pcor.test(MS,PCC,Age_test,method='pearson')
pcor.test(MS,PH,Age_test,method='pearson')
pcor.test(MS,PH_L,Age_test,method='pearson')
pcor.test(MS,PH_R,Age_test,method='pearson')
pcor.test(MS,AG,Age_test,method='pearson')
pcor.test(MS,AG_L,Age_test,method='pearson')
pcor.test(MS,AG_R,Age_test,method='pearson')
#ACC & ROIs
pcor.test(ACC_2,Caudate,Age_test,method='pearson')
pcor.test(ACC_2,Caudate_L,Age_test,method='pearson')
pcor.test(ACC_2,Caudate_R,Age_test,method='pearson')
pcor.test(ACC_2,IPS,Age_test,method='pearson')
pcor.test(ACC_2,IPS_L,Age_test,method='pearson')
pcor.test(ACC_2,IPS_R,Age_test,method='pearson')
pcor.test(ACC_2,DLPFC,Age_test,method='pearson')
pcor.test(ACC_2,dlPFC_L,Age_test,method='pearson')
pcor.test(ACC_2,dlPFC_R,Age_test,method='pearson')
pcor.test(ACC_2,vmPFC,Age_test,method='pearson')
pcor.test(ACC_2,PCC,Age_test,method='pearson')
pcor.test(ACC_2,PH,Age_test,method='pearson')
pcor.test(ACC_2,PH_L,Age_test,method='pearson')
pcor.test(ACC_2,PH_R,Age_test,method='pearson')
pcor.test(ACC_2,AG,Age_test,method='pearson')
pcor.test(ACC_2,AG_L,Age_test,method='pearson')
pcor.test(ACC_2,AG_R,Age_test,method='pearson')
#ROIs & Age



#plots
#MS & ROIs
p<-ggplot(data.frame(MS,Caudate),aes(MS,Caudate))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_classic()
p<-p+annotate("text",x=55,y=-0.5,label="italic(r) == 0.154^'**'",parse=T,size=5)+labs(x="Mindset Score",y="Caudate Activation")
p
p<-ggplot(data.frame(MS,IPS),aes(MS,IPS))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_classic()
p<-p+annotate("text",x=50,y=-0.6,label="italic(r) == 0.253^'***'",parse=T,size=5)+labs(x="Mindset Score",y="IPS Activation")
p
p<-ggplot(data.frame(MS,DLPFC),aes(MS,DLPFC))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_classic()
p<-p+annotate("text",x=50,y=-0.6,label="italic(r) == 0.233^'***'",parse=T,size=5)+labs(x="Mindset Score",y="dlPFC Activation")
p
p<-ggplot(data.frame(MS,PCC),aes(MS,PCC))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",formula=y~x,color="dodgerblue3")
p<-p+theme_classic()
p<-p+annotate("text",x=50,y=-0.6,label="italic(r) == -0.113^'*'",parse=T,size=5)+labs(x="Mindset Score",y="PCC Activation")
p
p<-ggplot(data.frame(MS,PH_R),aes(MS,PH_R))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",formula=y~x,color="dodgerblue3")
p<-p+theme_classic()
p<-p+annotate("text",x=50,y=-0.6,label="italic(r) == -0.130^'*'",parse=T,size=5)+labs(x="Mindset Score",y="Right PH Activation")
p
#ACC & ROIs
p<-ggplot(data.frame(Caudate,ACC_2),aes(Caudate,ACC_2))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_classic()
p<-p+annotate("text",x=0.6,y=-1,label="italic(r) == 0.157^'**'",parse=T,size=5)+labs(y="2-back Accuracy",x="Caudate Activation")
p 
p<-ggplot(data.frame(IPS,ACC_2),aes(IPS,ACC_2))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_classic()
p<-p+annotate("text",x=3,y=-1,label="italic(r) == 0.211^'***'",parse=T,size=5)+labs(y="2-back Accuracy",x="IPS Activation")
p
p<-ggplot(data.frame(DLPFC,ACC_2),aes(DLPFC,ACC_2))+geom_point(color="rosybrown1")+stat_smooth(method="lm",formula=y~x,color="firebrick3")
p<-p+theme_classic()
p<-p+annotate("text",x=1.5,y=-0.6,label="italic(r) == 0.165^'**'",parse=T,size=5)+labs(y="2-back Accuracy",x="dlPFC Activation")
p
p<-ggplot(data.frame(PCC,ACC_2),aes(PCC,ACC_2))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",formula=y~x,color="dodgerblue3")
p<-p+theme_classic()
p<-p+annotate("text",x=0.7,y=-1,label="italic(r) == -0.147^'*'",parse=T,size=5)+labs(y="2-back Accuracy",x="PCC Activation")
p
p<-ggplot(data.frame(PH_R,ACC_2),aes(PH_R,ACC_2))+geom_point(color="lightskyblue1")+stat_smooth(method="lm",formula=y~x,color="dodgerblue3")
p<-p+theme_classic()
p<-p+annotate("text",x=0.7,y=-1,label="italic(r) == -0.227^'***'",parse=T,size=5)+labs(y="2-back Accuracy",x="Right PH Activation")
p

p<-ggplot()+geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,Caudate,color="Caudate"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,IPS,color="IPS"), method = "lm")+
  geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,DLPFC,color="dlPFC"), method = "lm")
p<-p+theme_classic()
p<-p+scale_colour_manual("",values = c("Caudate" = "rosybrown1","dlPFC" = "brown3","IPS"="firebrick4"))
p<-p+annotate("text",x=4,y=1.5,label="italic(r) == 0.211^'***'",parse=T,size=4)+annotate("text",x=4,y=0.1,label="italic(r) == 0.157^'**'",parse=T,size=4)+annotate("text",x=4,y=0.6,label="italic(r) == 0.165^'**'",parse=T,size=4)+labs(x="2-back Accuracy",y="Activation",color="FPN Regions")
p

p<-ggplot()+geom_smooth(data = ROI_cluster_new, mapping = aes(MS,Caudate,color="Caudate"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(MS,IPS,color="IPS"), method = "lm")+
  geom_smooth(data = ROI_cluster_new, mapping = aes(MS,DLPFC,color="dlPFC"), method = "lm")
p<-p+theme_classic()
p<-p+scale_colour_manual("",values = c("IPS"="firebrick4","dlPFC" = "brown3","Caudate" = "rosybrown1"))
p<-p+annotate("text",x=55,y=1.5,label="italic(r) == 0.253^'***'",parse=T,size=4)+annotate("text",x=55,y=0.1,label="italic(r) == 0.154^'**'",parse=T,size=4)+annotate("text",x=55,y=0.7,label="italic(r) == 0.233^'***'",parse=T,size=4)+labs(x="Mindset Score",y="Activation",color="FPN Regions")
p

p<-ggplot()+geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,PH_R,color="Right PH"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,PCC,color="PCC"), method = "lm")
p<-p+theme_classic()
p<-p+scale_colour_manual("",values = c("Right PH"="dodgerblue4","PCC" = "lightskyblue1"))
p<-p+annotate("text",x=4,y=-0.2,label="italic(r) == -0.227^'***'",parse=T,size=4)+annotate("text",x=4,y=-0.5,label="italic(r) == -0.147^'*'",parse=T,size=4)+labs(x="2-back Accuracy",y="Activation",color="DMN Regions")
p

p<-ggplot()+geom_smooth(data = ROI_cluster_new, mapping = aes(MS,PH_R,color="Right PH"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(MS,PCC,color="PCC"), method = "lm")
p<-p+theme_classic()
p<-p+scale_colour_manual("",values = c("Right PH"="dodgerblue4","PCC" = "lightskyblue1"))
p<-p+annotate("text",x=55,y=-0.2,label="italic(r) == -0.130^'*'",parse=T,size=4)+annotate("text",x=55,y=-0.5,label="italic(r) == -0.113^'*'",parse=T,size=4)+labs(x="Mindset Score",y="Activation",color="DMN Regions")
p

#supplementary
p<-ggplot()+geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,PH_L,color="Left Hippocampus"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,vmPFC,color="vmPFC"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(ACC_2,AG,color="AG"), method = "lm")
p<-p+theme_classic()
p<-p+scale_colour_manual("",values = c("vmPFC" = "dodgerblue4","Left Hippocampus"="dodgerblue","AG"="lightskyblue2"))
p<-p+labs(x="Accuracy (d')",y="Activation",color="DMN Regions")
p

p<-ggplot()+geom_smooth(data = ROI_cluster_new, mapping = aes(MS,PH_L,color="Left Hippocampus"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(MS,vmPFC,color="vmPFC"), method = "lm")+geom_smooth(data = ROI_cluster_new, mapping = aes(MS,AG,color="AG"), method = "lm")
p<-p+theme_classic()
p<-p+scale_colour_manual("",values = c("vmPFC" = "dodgerblue4","Left Hippocampus"="dodgerblue","AG"="lightskyblue2"))
p<-p+labs(x="Mindset Score",y="Activation",color="DMN Regions")
p

#box_plot FPN
FPNmelt<-data.matrix(ROI_cluster_new[c("IPS","DLPFC","Caudate")])
FPNdata<-melt(FPNmelt,measure.vars = c("IPS","DLPFC","Caudate"))
FPNplot<-ggplot(data=FPNdata) + geom_boxplot(aes(x = Var2, y = value), width = 0.6,fill = c("firebrick4","brown3","rosybrown1"))+ scale_x_discrete(labels=c("IPS","DLPFC","Caudate"))
FPNplot<-FPNplot+labs(x= element_blank(),y="Activation")+theme_classic()
FPNplot

#computation
res.aov <- anova_test(data = FPNdata, dv = value, wid = Var1, within = Var2)
get_anova_table(res.aov)
# pairwise comparisons
pwc <- FPNdata %>%
  pairwise_t_test(
    value ~ Var2, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
pwc

#box_plot DMN
DMNmelt<-data.matrix(ROI_cluster_new[c("PH_R","PCC")])
DMNdata<-melt(DMNmelt,measure.vars = c("PH_R","PCC"))
DMNplot<-ggplot(data=DMNdata) + geom_boxplot(aes(x = Var2, y = value), width = 0.6,fill = c("dodgerblue4","lightskyblue1"))+ scale_x_discrete(labels=c("PH_R","PCC"))
DMNplot<-DMNplot+labs(x= element_blank(),y="Activation")+theme_classic()
DMNplot

#computation
res.aov <- anova_test(data = DMNdata, dv = value, wid = Var1, within = Var2)
get_anova_table(res.aov)
# pairwise comparisons
pwc <- DMNdata %>%
  pairwise_t_test(
    value ~ Var2, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
pwc


#mediation
b <- lm(AG ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + AG + Age_test, data=ROI_cluster_new)
set.seed(12345)
med1 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="AG", conf.level = 0.95)
plot(med1)
summary(b)
summary(c)
summary(med1)
med1$d.avg.ci

b <- lm(Caudate_L ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + Caudate_L + Age_test, data=ROI_cluster_new)
set.seed(12345)
med2 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="Caudate_L", conf.level = 0.95)
plot(med2)
summary(b)
summary(c)
summary(med2)
med2$d.avg.ci

b <- lm(Caudate_R ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + Caudate_R + Age_test, data=ROI_cluster_new)
set.seed(12345)
med3 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="Caudate_R", conf.level = 0.95)
summary(b)
summary(c)
summary(med3)
med3$d.avg.ci
plot(med3)

b <- lm(IPL_L ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + IPL_L + Age_test, data=ROI_cluster_new)
set.seed(12345)
med4 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="IPL_L", conf.level = 0.95)
summary(b)
summary(c)
summary(med4)
med4$d.avg.ci
plot(med4)

b <- lm(IPL_R ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + IPL_R + Age_test, data=ROI_cluster_new)
set.seed(12345)
med5 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="IPL_R", conf.level = 0.95)
summary(b)
summary(c)
summary(med5)
med5$d.avg.ci
plot(med5)

b <- lm(PCC ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + PCC + Age_test, data=ROI_cluster_new)
set.seed(12345)
med6 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="PCC", conf.level = 0.95)
summary(b)
summary(c)
summary(med6)
med6$d.avg.ci
plot(med6)

b <- lm(ParaHipp ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + ParaHipp + Age_test, data=ROI_cluster_new)
set.seed(1245)
med7 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="ParaHipp", conf.level = 0.95)
summary(b)
summary(c)
summary(med7)
med7$d.avg.ci
plot(med7)

b <- lm(dlPFC_L ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + dlPFC_L + Age_test, data=ROI_cluster_new)
set.seed(12345)
med8 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="dlPFC_L", conf.level = 0.95)
summary(b)
summary(c)
summary(med8)
med8$d.avg.ci
plot(med8)

b <- lm(dlPFC_R ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + dlPFC_R + Age_test, data=ROI_cluster_new)
set.seed(12345)
med9 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="dlPFC_R", conf.level = 0.95)
summary(b)
summary(c)
summary(med9)
med9$d.avg.ci
plot(med9)

b <- lm(vmPFC ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + vmPFC + Age_test, data=ROI_cluster_new)
set.seed(12345)
med10 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="vmPFC", conf.level = 0.95)
summary(b)
summary(c)
summary(med10)
med10$d.avg.ci
plot(med10)

#new add
b <- lm(AG_L ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + AG_L + Age_test, data=ROI_cluster_new)
set.seed(12345)
med11 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="AG_L", conf.level = 0.95)
plot(med11)
summary(b)
summary(c)
summary(med11)
med11$d.avg.ci

b <- lm(AG_R ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + AG_R + Age_test, data=ROI_cluster_new)
set.seed(12345)
med12 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="AG_R", conf.level = 0.95)
plot(med12)
summary(b)
summary(c)
summary(med12)
med12$d.avg.ci

b <- lm(PH_L ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + PH_L + Age_test, data=ROI_cluster_new)
set.seed(12345)
med13 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="PH_L", conf.level = 0.95)
plot(med13)
summary(b)
summary(c)
summary(med13)
med13$d.avg.ci

b <- lm(PH_R ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + PH_R + Age_test, data=ROI_cluster_new)
set.seed(12345)
med14 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="PH_R", conf.level = 0.95)
plot(med14)
summary(b)
summary(c)
summary(med14)
med14$d.avg.ci

b <- lm(Caudate ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + Caudate + Age_test, data=ROI_cluster_new)
set.seed(12345)
med15 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="Caudate", conf.level = 0.95)
plot(med15)
summary(b)
summary(c)
summary(med15)
med15$d.avg.ci

b <- lm(DLPFC ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + DLPFC + Age_test, data=ROI_cluster_new)
set.seed(12345)
med16 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="DLPFC", conf.level = 0.95)
plot(med16)
summary(b)
summary(c)
summary(med16)
med16$d.avg.ci

b <- lm(IPS ~ MS + Age_test, data=ROI_cluster_new)
c <- lm(ACC_2 ~ MS + IPS + Age_test, data=ROI_cluster_new)
set.seed(12345)
med17 <- mediate(b, c, sims = 5000, boot =TRUE,boot.ci.type = "bca", treat="MS", mediator="IPS", conf.level = 0.95)
plot(med17)
summary(b)
summary(c)
summary(med17)
med17$d.avg.ci

data<-c(0.004,0.028,0.02,0.048,0.1848,0.120)
p.adjust(data,method="fdr",n=length(data))

#ROIs regression to age






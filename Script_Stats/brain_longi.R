
#------------------------------
# Project: CBD
# Title: Growth mindset & working memory capacity
# Author: Yuyao Zhao
# Date: 2022/09/22
#------------------------------
rm(list = ls()) 
#set path
setwd('.../Data')
getwd()

# Loading files
library(readxl)
ROI_cluster_new<-read_excel(".../Data/ROI_cluster_17_20.xlsx")
Long_data <- read_excel('.../Data/NB_3Y_HDDM.xlsx', col_types = c("text", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric", "numeric", "numeric", "numeric", 
                                                                                                  "numeric"))
#match imaging data and longitudinal behavior
ROI_cluster_new_sub<-subset(ROI_cluster_new,select=c("ID","aInsula","dACC","DLPFC","FEF","IPS","vmPFC","PCC","AG","PH","cau_Insula_R_20","cau_PCC_20","aInsula_R","Caudate","FPN","SN","DMN","moti_salien"))
Long_brain<-merge(ROI_cluster_new_sub,Long_data,by="ID")


head(Long_brain)
attach(Long_brain)

TP1<-Long_brain[which(Year==1),]
TP2TP3<-Long_brain[which(Year>1),]

TP1_sub<-subset(TP1,select=c("ID","MS","gender","Age_test","a_2","v_2","t_2","ACC_2","ACC_1","ACC_0","hit_rate_RT_2","hit_rate_RT_1","hit_rate_RT_0"))


#match for future performance
match_future<-as.data.frame(matrix(nrow=0,ncol=29))
freq.ID<-as.data.frame(table(Long_brain$ID))
nlength<-length(freq.ID$Var1)
for (i in 1:nlength) {
  if(freq.ID$Freq[i]>1){
    if(freq.ID$Freq[i]==3){
      match_future<-rbind(match_future,Long_brain[which(Long_brain$ID==freq.ID$Var1[i]&Long_brain$Year==3),])
    }else{
      match_future<-rbind(match_future,Long_brain[which(Long_brain$ID==freq.ID$Var1[i]&Long_brain$Year!=1),])
    }
    
  } 
}


match_future2<-merge(TP1_sub,match_future,by="ID",suffixes = c(".x",".y"))
##RT calculation (Two participants were excluded from RT analysis because of no correct response)
match_future2_RT<-match_future2[which(match_future2$hit_rate_RT_2.x>0&match_future2$hit_rate_RT_2.y>0),]
summary(as.factor(match_future2_RT$Year))

timelag<-match_future2_RT$Age_test.y-match_future2_RT$Age_test.x
summary(timelag)

#partial correlation (partial age, gender, primary performance)
#direct effect
pcor.test(match_future2_RT$MS.x,match_future2_RT$ACC_2.y,match_future2_RT[,c("Age_test.x","gender.x", "ACC_2.x")],method='pearson')
pcor.test(match_future2_RT$MS.x,match_future2_RT$hit_rate_RT_2.y,match_future2_RT[,c("Age_test.x","gender.x", "hit_rate_RT_2.x")],method='pearson')


# Partial correlation with mindset and Year-2/3 WM performance of ROIs  (Table S19)
#performance 
a<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$PH,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
b<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$aInsula,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
c<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$dACC,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
d<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$DLPFC,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
e<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$FEF,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
f<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$IPS,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
g<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$vmPFC,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
h<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$PCC,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
i<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$AG,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
j<-pcor.test(match_future2_RT$ACC_2.y,match_future2_RT$PH,match_future2_RT[,c("Age_test.x","gender.x","ACC_2.x")],method='pearson')
format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value), digits=2, scientific=FALSE)

#RT 
a<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$Caudate,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
b<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$aInsula,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
c<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$dACC,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
d<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$DLPFC,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
e<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$FEF,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
f<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$IPS,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
g<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$vmPFC,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
h<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$PCC,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
i<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$AG,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
j<-pcor.test(match_future2_RT$hit_rate_RT_2.y,match_future2_RT$PH,match_future2_RT[,c("Age_test.x","gender.x","hit_rate_RT_2.x")],method='pearson')
format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value), digits=2, scientific=FALSE)

#MS
a<-pcor.test(match_future2_RT$MS.x,match_future2_RT$Caudate,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
b<-pcor.test(match_future2_RT$MS.x,match_future2_RT$aInsula,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
c<-pcor.test(match_future2_RT$MS.x,match_future2_RT$dACC,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
d<-pcor.test(match_future2_RT$MS.x,match_future2_RT$DLPFC,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
e<-pcor.test(match_future2_RT$MS.x,match_future2_RT$FEF,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
f<-pcor.test(match_future2_RT$MS.x,match_future2_RT$IPS,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
g<-pcor.test(match_future2_RT$MS.x,match_future2_RT$vmPFC,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
h<-pcor.test(match_future2_RT$MS.x,match_future2_RT$PCC,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
i<-pcor.test(match_future2_RT$MS.x,match_future2_RT$AG,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
j<-pcor.test(match_future2_RT$MS.x,match_future2_RT$PH,match_future2_RT[,c("Age_test.x","gender.x")],method='pearson')
format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value), digits=2, scientific=FALSE)




##HDDM calculation
# Partial correlation with mindset and Year-2/3 HDDM parameters of ROIs (Table S20)
#partial correlation (partial age, gender, primary performance)
#direct effect
pcor.test(match_future2$MS.x,match_future2$v_2.y,match_future2[,c("Age_test.x","gender.x")],method='pearson')
pcor.test(match_future2$MS.x,match_future2$t_2.y,match_future2[,c("Age_test.x","gender.x")],method='pearson')

#v
a<-pcor.test(match_future2$v_2.y,match_future2$Caudate,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
b<-pcor.test(match_future2$v_2.y,match_future2$aInsula,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
c<-pcor.test(match_future2$v_2.y,match_future2$dACC,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
d<-pcor.test(match_future2$v_2.y,match_future2$DLPFC,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
e<-pcor.test(match_future2$v_2.y,match_future2$FEF,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
f<-pcor.test(match_future2$v_2.y,match_future2$IPS,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
g<-pcor.test(match_future2$v_2.y,match_future2$vmPFC,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
h<-pcor.test(match_future2$v_2.y,match_future2$PCC,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
i<-pcor.test(match_future2$v_2.y,match_future2$AG,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
j<-pcor.test(match_future2$v_2.y,match_future2$PH,match_future2[,c("Age_test.x","gender.x","v_2.x")],method='pearson')
format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value), digits=2, scientific=FALSE)


#T
a<-pcor.test(match_future2$t_2.y,match_future2$Caudate,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
b<-pcor.test(match_future2$t_2.y,match_future2$aInsula,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
c<-pcor.test(match_future2$t_2.y,match_future2$dACC,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
d<-pcor.test(match_future2$t_2.y,match_future2$DLPFC,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
e<-pcor.test(match_future2$t_2.y,match_future2$FEF,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
f<-pcor.test(match_future2$t_2.y,match_future2$IPS,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
g<-pcor.test(match_future2$t_2.y,match_future2$vmPFC,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
h<-pcor.test(match_future2$t_2.y,match_future2$PCC,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
i<-pcor.test(match_future2$t_2.y,match_future2$AG,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
j<-pcor.test(match_future2$t_2.y,match_future2$PH,match_future2[,c("Age_test.x","gender.x","t_2.x")],method='pearson')
format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value), digits=2, scientific=FALSE)


#a
a<-pcor.test(match_future2$a_2.y,match_future2$Caudate,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
b<-pcor.test(match_future2$a_2.y,match_future2$aInsula,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
c<-pcor.test(match_future2$a_2.y,match_future2$dACC,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
d<-pcor.test(match_future2$a_2.y,match_future2$DLPFC,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
e<-pcor.test(match_future2$a_2.y,match_future2$FEF,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
f<-pcor.test(match_future2$a_2.y,match_future2$IPS,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
g<-pcor.test(match_future2$a_2.y,match_future2$vmPFC,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
h<-pcor.test(match_future2$a_2.y,match_future2$PCC,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
i<-pcor.test(match_future2$a_2.y,match_future2$AG,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
j<-pcor.test(match_future2$a_2.y,match_future2$PH,match_future2[,c("Age_test.x","gender.x","a_2.x")],method='pearson')
format(c(a$estimate,b$estimate,c$estimate,d$estimate,e$estimate,f$estimate,g$estimate,h$estimate,i$estimate,j$estimate), digits=2, scientific=FALSE)
format(c(a$p.value,b$p.value,c$p.value,d$p.value,e$p.value,f$p.value,g$p.value,h$p.value,i$p.value,j$p.value), digits=3, scientific=FALSE)



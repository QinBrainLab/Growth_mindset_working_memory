##new yuyao zhao 2020.09.23
#change dataframe name
attach(TP1)

#normalize
for(i in 1:length(hit_rate_0)){
if (hit_rate_0[i]==1) hit_rate_0[i]=0.99
else if (hit_rate_0[i]==0) hit_rate_0[i]=0.01
else hit_rate_0[i]=hit_rate_0[i]
if (hit_rate_1[i]==1) hit_rate_1[i]=0.99
else if (hit_rate_1[i]==0) hit_rate_1[i]=0.01
else hit_rate_1[i]=hit_rate_1[i]
if (hit_rate_2[i]==1) hit_rate_2[i]=0.99
else if (hit_rate_2[i]==0) hit_rate_2[i]=0.01
else hit_rate_2[i]=hit_rate_2[i]
if (false_alarm_rate_0[i]==1) false_alarm_rate_0[i]=0.99
else if (false_alarm_rate_0[i]==0) false_alarm_rate_0[i]=0.01
else false_alarm_rate_0[i]=false_alarm_rate_0[i]
if (false_alarm_rate_1[i]==1) false_alarm_rate_1[i]=0.99
else if (false_alarm_rate_1[i]==0) false_alarm_rate_1[i]=0.01
else false_alarm_rate_1[i]=false_alarm_rate_1[i]
if (false_alarm_rate_2[i]==1) false_alarm_rate_2[i]=0.99
else if (false_alarm_rate_2[i]==0) false_alarm_rate_2[i]=0.01
else false_alarm_rate_2[i]=false_alarm_rate_2[i]
}

ACC_0<-qnorm(hit_rate_0)-qnorm(false_alarm_rate_0)
ACC_1<-qnorm(hit_rate_1)-qnorm(false_alarm_rate_1)
ACC_2<-qnorm(hit_rate_2)-qnorm(false_alarm_rate_2)
#should change the root
write.csv(data.frame(ACC_0,ACC_1,ACC_2), file = "/Users/zhaoyuyao/Desktop/MS_WM_project/behavior/ACC_Z.csv")

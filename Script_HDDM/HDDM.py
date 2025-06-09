
#!/usr/bin/env python
# coding: utf-8

import hddm
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

data = hddm.load_csv(r'I:\swu_longitudinal_project\script\HDDM\hddm_yuyao\HDDM_all_final.csv')
data=data[data['rt']>0.2]

#avt model
models = []
dic = []
for i in range(3):
    m = hddm.HDDM(data,p_outlier=0.05,depends_on={'a':['stim','group'],
                                                    'v':['stim','group'],
                                                    't':['stim','group']},
                  is_group_model=True) #include={'z'},
    m.find_starting_values()    
    m.sample(20000, burn=2000)
    models.append(m)
      
    model_stat= m.gen_stats()
    # print(model_stat)
    model_stat.to_csv(r'I:\swu_longitudinal_project\script\HDDM\hddm_yuyao\Run'
                      +str(i+1)+'_avt.csv') #or avtz; save model parameters
    dic.append(m.dic)
    models.append(m)

r = hddm.analyze.gelman_rubin(models)  # R hat is a dic
models_R = pd.DataFrame([r])
models_R.to_csv(r'I:\swu_longitudinal_project\script\HDDM\hddm_yuyao\rhat_avt.csv')

models_DIC = pd.DataFrame(dic)
models_DIC.columns = {"DIC"}
models_DIC.to_csv(r'I:\swu_longitudinal_project\script\HDDM\hddm_yuyao\DIC_avt.csv')



# ##avtz model
# models = []
# dic = []
# for i in range(3):
#     m = hddm.HDDM(data,p_outlier=0.05,depends_on={'a':['stim','group'],
                                                    'v':['stim','group'],
                                                    't':['stim','group']},
#                   include={'z'},is_group_model=True) 
#     m.find_starting_values()    
#     m.sample(20000, burn=2000)
#     models.append(m)
     
#     model_stat= m.gen_stats()
#     # print(model_stat) 
#     model_stat.to_csv(r'I:\swu_longitudinal_project\script\HDDM\hddm_yuyao\Run'
#                       +str(i+1)+'_avtz.csv') #save model parameters
#     dic.append(m.dic)
#     models.append(m)

# r = hddm.analyze.gelman_rubin(models)  # R hat is a dic
# models_R = pd.DataFrame([r])
# models_R.to_csv(r'I:\swu_longitudinal_project\script\HDDM\hddm_yuyao\rhat_avtz.csv')

# models_DIC = pd.DataFrame(dic)
# models_DIC.columns = {"DIC"}
# models_DIC.to_csv(r'I:\swu_longitudinal_project\script\HDDM\hddm_yuyao\DIC_avtz.csv')

#compare a smaller DIC to decide a better fit model


#the next code is for comparing dic of all models
# ### model avtz:
# modelavtz = hddm.HDDM(data,p_outlier=0.05,depends_on={'a':['stim','group'],
#                                                    'v':['stim','group'],
#                                                    't':['stim','group']}
#                       ,include={'z'},is_group_model=True)
# modelavtz.find_starting_values()
# # Create model and start MCMC sampling
# modelavtz.sample(20000, burn=2000,dbname='NB_20000_2000Burnin_avtz.db',db='pickle')
# # modelavt.plot_posteriors(['a','a_var'])
# # modelavt.plot_posteriors(['v','v_var'])
# # modelavt.plot_posteriors(['t','t_var'])
# modelavtz.save(r'NB_20000_2000Burnin_avtz')
# modelavtz_stat= modelavtz.gen_stats()
# modelavtz_stat.to_csv(r'NB_20000_2000Burnin_avtz.csv')
# # model.plot_posterior_predictive()
# # model.print_stats()
# print(modelavtz.dic)

# ### model avt:
# modelavt = hddm.HDDM(data,p_outlier=0.05,depends_on={'a':['stim','group'],
#                                                    'v':['stim','group'],
#                                                    't':['stim','group']},
#                   is_group_model=True) #False,is_group_model=True
# modelavt.find_starting_values()
# # Create model and start MCMC sampling
# modelavt.sample(20000, burn=2000,dbname='NB_20000_2000Burnin_avt.db',db='pickle')
# # modelavt.plot_posteriors(['a','a_var'])
# # modelavt.plot_posteriors(['v','v_var'])
# # modelavt.plot_posteriors(['t','t_var'])
# modelavt.save(r'NB_20000_2000Burnin_avt')
# modelavt_stat= modelavt.gen_stats()
# modelavt_stat.to_csv(r'NB_20000_2000Burnin_avt.csv')
# # model.plot_posterior_predictive()
# # model.print_stats()
# print(modelavt.dic)

# ## model a:
# modela = hddm.HDDM(data,p_outlier=0.05,depends_on={'a':['stim','group']}
#                                                     ,is_group_model=True) 
# modela.find_starting_values()
# modela.sample(20000, burn=2000)# Create model and start MCMC sampling
# #modela.save(r'NB_20000_2000Burnin_a')
# modela_stat= modela.gen_stats()
# modela_stat.to_csv(r'E:\yuyao\NB_20000_2000Burnin_a.csv')
# dic_a=modela.dic

# # model v
# modelv = hddm.HDDM(data,p_outlier=0.05,depends_on={'v':['stim','group']},
#                   is_group_model=True) #False,is_group_model=True
# modelv.find_starting_values()
# # Create model and start MCMC sampling
# modelv.sample(20000, burn=2000)#10000,5000
# #modelv.save(r'NB_all_20000_2000Burnin_v')
# modelv_stat= modelv.gen_stats()
# modelv_stat.to_csv(r'E:\yuyao\NB_20000_2000Burnin_v.csv')
# # model.plot_posterior_predictive()
# dic_v=modelv.dic#model DIC

# # model t
# modelt = hddm.HDDM(data,p_outlier=0.05,depends_on={'t':['stim','group']},
#                   is_group_model=True) #False,is_group_model=True
# modelt.find_starting_values()
# # Create model and start MCMC sampling
# modelt.sample(20000, burn=2000)
# #modelt.save(r'NB_20000_2000Burnin_t')
# modelt_stat= modelt.gen_stats()
# modelt_stat.to_csv(r'E:\yuyao\NB_20000_2000Burnin_t.csv')
# # model.plot_posterior_predictive()
# print(modelt.dic)#model DIC

# dic_compare=[modela.dic,modelv.dic,modelt.dic]
# dic_compare=pd.DataFrame(dic_compare)
# dic_compare.to_csv(r'E:\yuyao\dic_model_compare.csv')

# # model av
# modelav = hddm.HDDM(data,p_outlier=0.05,depends_on={'a':['stim','group'],
#                                                     'v':['stim','group']},
#                   is_group_model=True) #False,is_group_model=True
# modelav.find_starting_values()
# # Create model and start MCMC sampling
# modelav.sample(20000, burn=2000)#
# #modelav.save(r'NB_20000_2000Burnin_av')
# modelav_stat= modelav.gen_stats()
# modelav_stat.to_csv(r'NB_20000_2000Burnin_av.csv')
# # model.plot_posterior_predictive()
# print(modelav.dic)#model DIC

# # model at
# modelat = hddm.HDDM(data,p_outlier=0.05,depends_on={'a':['stim','group'],
#                                                     't':['stim','group']},
#                   is_group_model=True) #False,is_group_model=True
# modelat.find_starting_values()
# # Create model and start MCMC sampling
# modelat.sample(20000, burn=2000)#10000,5000
# #modelat.save(r'NB_20000_2000Burnin_at')
# modelat_stat= modelat.gen_stats()
# modelat_stat.to_csv(r'NB_20000_2000Burnin_at.csv')
# # model.plot_posterior_predictive()
# print(modelat.dic)#model DIC

# # model vt
# modelvt = hddm.HDDM(data,p_outlier=0.05,depends_on={'v':['stim','group'],
#                                                     't':['stim','group']},
#                   is_group_model=True) #False,is_group_model=True
# modelvt.find_starting_values()
# # Create model and start MCMC sampling
# modelvt.sample(20000, burn=2000)#10000,5000
# #modelvt.save(r'NB_20000_2000Burnin_vt')
# modelvt_stat= modelvt.gen_stats()
# modelvt_stat.to_csv(r'NB_20000_2000Burnin_vt.csv')
# # model.plot_posterior_predictive()
# print(modelvt.dic)#model DIC

# dic_compare=[modelav.dic,modelat.dic,modelvt.dic]
# dic_compare=pd.DataFrame(dic_compare)
# dic_compare.to_csv(r'dic_model_compare.csv')

# dic_compare=[modelavtz.dic,modelavt.dic]
# dic_compare=pd.DataFrame(dic_compare)
# dic_compare.to_csv(r'dic_model_compare.csv')




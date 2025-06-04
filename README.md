# Growth_mindset_working_memory
Codes for the growth mindset and working memory manuscript
## Checklist for Data Analysis Conducted in the manuscript
Lead authors: Yuyao Zhao & Junjie Cui
<br /> Created by Yuyao Zhao on January 4th, 2022; Updated on 4th Jun, 2025
## Summary and Requirements:
This repository contains MATLAB and R scripts needed to produce key results in the manuscript, including figures, behavioral, and fMRI analysis.
## Test Environment(s):
MATLAB version: R2020a, Operating System: Windows 10
## Statistical tests behavioral and imaging data(Fig. 1 & 2-5 mediation models)
- Script_Stats: main behavioral analysis & figures
<br /> Behavioral analysis of longitudinal data: behav_longi.R
<br /> Cross-sectional and longitudinal statistical tests of imaging data: brain_activity.R & brain_longi.R
<br /> Compare HDDM models: compare_model.R
## fMRI Analysis (Fig. 2-5)
- Script_QC: imaging data quality control
<br /> script: aroma_outliers
<br /> outlier number drawn from confound file in fMRIPrep: outliers_aroma1.txt
- Script_Multiple_Reg: first & second level (multiple regression) analysis & Preparation for Neurotransmitter Analysis (Fig. 2)
<br /> 1st-level script: scr_1lv_spm_aroma_parallel_nb.m
<br /> 2nd-level script: scr_2lv_multireg.m
<br /> ROI analysis: scr_extrmean_nroi.m
<br /> ROI definition and Meta-analysis were based on Neurosynth (https://github.com/neurosynth/neurosynth)
<br /> Preparation for Neurotransmitter Analysis: scr_2lv_multireg_Bootstrap.m & scr_2lv_multireg_for_hormone.m
<br /> Neurotransmitter Analysis was based on Canlabtools (https://github.com/KeBo2018/KeBo2023_EmotionReg_BayesFactor/tree/main)
- Script_HMM: HMM analysis (Fig. 4&5)
<br /> main script used for HMM analysis
<br /> HMM Analysis was based on HMM-MAR toolbox (https://github.com/OHBA-analysis/HMM-MAR/wiki/User-Guide#struct)


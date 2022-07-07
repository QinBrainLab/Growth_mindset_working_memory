# Growth_mindset_working_memory
Codes for growth mindset and working memory manuscript
## Checklist for Data Analysis Conducted in the manuscript
Lead author(s): Yuyao Zhao
<br /> Created by Yuyao Zhao on January 4th, 2022
## Summary and Requirements:
This repository contains Matlab, R scriptes needed to produce key results in the manuscript including figures, behavioral and fMRI analysis.
## Test Environment(s):
MATLAB version: R2020a, Operating System: windows 10
## Behavioral Analysis
- normalize accuracy 
<br /> script: normalize accuracy
- main behavioral analysis & figures (Figure 1 & Supplementary material figure2,3)
<br /> script: TP1_analysis_new
<br /> Figure. 1A plotted by Adobe Illustrator
## fMRI Analysis
- imaging data quality control
<br /> script: aroma_outliers
<br /> outlier number draw from confound file in fMRIPrep: outliers_aroma1.txt
- first level
<br /> script: scr_1lv_spm_aroma_parallel_nb
- second level (multiple regression)
<br /> script: scr_2lv_multireg
Figure2. A plotter by Surf Ice and MRIcroGL
- gPPI analysis (Figure 3)
<br /> script: folder gPPI
- ROI extraction
<br /> script: scr_extrmean_nroi
- mediation analysis (Figure 4)
<br /> script: mediation


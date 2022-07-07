% configuration file for gPPI.m
% shaozheng qin adapted for his poject on January 1, 2014
% lei hao adapted for his poject on September 12, 2017

%% gzip swcar.nii
gzip_swcar = 1;
sess_name  = 'nb';
spm_ver    = 'spm12';

%% set path
spm_dir    = '/home/zhaoyuyao/toolbox/spm12';
script_dir = '/home/zhaoyuyao/code_bk/MS_project/MS_TP1/brain/gPPI/gPPI_zyy';

%% specify the preprocessing path
% paralist.preproc_dir = '/Users/haol/Downloads/scr_test/Preproc';

%% specify the first level path
paralist.firstlv_dir = '/home/zhaoyuyao/deriv/firstlevel_withbeta';

%% specify the parent folder of the static data
% for YEAR data structure, use the first one
% for NONE YEAR data structure, use the second one
% paralist.parent_folder = '';

%% specify the subject list file (.txt) or a cell array
% subjlist = '/home/haol/list_test.txt';

%% get ROIs list
paralist.rois_dir = '/home/zhaoyuyao/code_bk/MS_project/MS_TP1/brain/gPPI/gPPI_ROI/cluster_15/rerun_524';

%% specify the task to include
% set = { '1', 'task1', 'task2'} -> must exist in all sessions
% set = { '0', 'task1', 'task2'} -> does not need to exist in all sessions
paralist.tasks_include = {'1', 'nb00','nb11','nb22'};

%% mask file, restricting the analysis on voxels within the mask
paralist.mask_file = '/home/zhaoyuyao/code_bk/MS_project/MS_TP1/brain/gPPI/gPPI_zyy/greymask.nii';

%% specify the confound names
paralist.confound_names = {'R1', 'R2'}; %CSF & WM

%% make T contrast
Pcon.Contrasts(1).left     = {'nb00'};
Pcon.Contrasts(1).right    = {'none'};
Pcon.Contrasts(1).STAT     = 'T';
Pcon.Contrasts(1).Weighted = 0;
Pcon.Contrasts(1).name     = 'NB_00';

Pcon.Contrasts(2).left     = {'nb11'};
Pcon.Contrasts(2).right    = {'none'};
Pcon.Contrasts(2).STAT     = 'T';
Pcon.Contrasts(2).Weighted = 0;
Pcon.Contrasts(2).name     = 'NB_11';

Pcon.Contrasts(3).left     = {'nb22'};
Pcon.Contrasts(3).right    = {'none'};
Pcon.Contrasts(3).STAT     = 'T';
Pcon.Contrasts(3).Weighted = 0;
Pcon.Contrasts(3).name     = 'NB_22';

Pcon.Contrasts(4).left     = {'nb11'};
Pcon.Contrasts(4).right    = {'nb00'};
Pcon.Contrasts(4).STAT     = 'T';
Pcon.Contrasts(4).Weighted = 0;
Pcon.Contrasts(4).name     = 'NB_10';

Pcon.Contrasts(5).left     = {'nb22'};
Pcon.Contrasts(5).right    = {'nb00'};
Pcon.Contrasts(5).STAT     = 'T';
Pcon.Contrasts(5).Weighted = 0;
Pcon.Contrasts(5).name     = 'NB_20';

Pcon.Contrasts(6).left     = {'nb22'};
Pcon.Contrasts(6).right    = {'nb11'};
Pcon.Contrasts(6).STAT     = 'T';
Pcon.Contrasts(6).Weighted = 0;
Pcon.Contrasts(6).name     = 'NB_21';

%% ===================================================================== %%
% acquire ROIs list
roi_list = dir(fullfile(paralist.rois_dir, '*.nii'));
roi_list = struct2cell(roi_list);
roi_list = roi_list(1, :)';

paralist.roi_file_list = {};
for roi_i = 1:length(roi_list)
    paralist.roi_file_list{roi_i,1} = fullfile(paralist.rois_dir, roi_list{roi_i, 1});
end
paralist.roi_name_list = strtok(roi_list, '.');

% add path
addpath(genpath(spm_dir));
addpath(genpath(script_dir));

% specify the stats folder name
paralist.spm_ver   = spm_ver;
paralist.stats_ver = ['Stats_', spm_ver];
paralist.stats_dir = [sess_name, '/Stats_', spm_ver];
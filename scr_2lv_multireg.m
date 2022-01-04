% written by l.hao (ver_18.09.07)
% hao1ei@foxmail.com
% qinlab.BNU
clear;
clc;


%% set up
spm_dir    = 'C:\Program Files\MATLAB\R2020a\toolbox\spm12';
firlv_dir  = 'C:\Users\lenovo\Desktop\MS_project\deriv\firstlevel';
seclv_dir  =  'D:\deriv\2nd_level';
script_dir ='C:\Users\lenovo\Desktop\MS_project\codes_origin';
var_list   = 'C:\Users\lenovo\Desktop\MS_project\codes_origin\list_multireg_covar_match_child_t1_nb_MS.txt';

task_name  = 'nb';
tconweig   = [0 1 0];
res_folder = 'MS_child_t1_nb_aroma_outliers_306';
cond_name  = {'c1nb00'; 'c2nb11'; 'c3nb22';'c4nb01'; 'c5nb02'; 'c6nb12'};
% {'c1alert'; 'c2orient'; 'c3executive'};
% {'c1pump'; 'c2cashout'; 'c3explode'};
% {'c1emotion'; 'c2control'; 'c3emocon'};
% {'c1nb00'; 'c2nb11'; 'c3nb22'};

%% run second level
addpath(genpath(spm_dir));
addpath(genpath(script_dir));
load(fullfile(script_dir, 'Depend', ['batch_2lv_multireg', num2str(length(tconweig)), '.mat']));

fid = fopen(var_list); varlist = {}; cntlist = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    varlist(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
end
fclose(fid);

[~, ncol] = size(varlist);
sublist = varlist(:,1);

for icol = 2:ncol
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(icol-1).c = ...
        str2num(cell2mat(varlist(:,icol))); %#ok<*ST2NM>
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(icol-1).cname = ...
        ['Var_',num2str(icol)];
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(icol-1).iCC = 1;
end

for icond = 1:length(cond_name)
    con_name = cond_name{icond};
    imgdir = {};
    for isub = 1:length(sublist)
        imgdir{isub,1} = fullfile(firlv_dir, task_name, ...
            ['sub-', sublist{isub,1}], ...
            ['con_000', cond_name{icond}(2), '.nii']); %#ok<*SAGROW>
    end
    res_save_dir = fullfile(seclv_dir, res_folder, cond_name{icond});
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = cond_name{icond};
    
    run(fullfile(script_dir, 'Depend', 'job_2lv_multireg.m'));
end

%% done
cd(script_dir)
disp('=== second level analysis done ===');
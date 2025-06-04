% written by l.hao (ver_18.09.07)
% edited by Y.Zhao for Neurotransmitter Analysis
% qinlab.BNU
clear;
clc;

%% set up
%spm_dir    = '...';
firlv_dir  = '.../deriv/firstlevel';
seclv_dir  = '.../deriv/2nd_level';
script_dir = '.../brain/multiple_reg';
var_list   = '.../brain/multiple_reg/list_multireg_covar_match_child_t1_nb_ms_hddm_ex_age_gender_306.txt';

task_name  = 'nb';
tconweig   = [0 1 -1 0 0];
res_folder = 'MS_child_t1_nb_meanFD_aroma_outliers_306_ex_age_gender_hddm_neg_Bootstrap100';
cond_name  = {'c5nb02'};
n_bootstrap = 100; % Number of bootstraps


addpath(genpath(script_dir));
load(fullfile(script_dir, 'Depend', ['batch_2lv_multireg', num2str(length(tconweig)), '.mat']));
%% Load subject list and covariates
fid = fopen(var_list); varlist = {}; cntlist = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    varlist(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
end
fclose(fid);

[~, ncol] = size(varlist);
sublist = varlist(:,1);

for b = 1:n_bootstrap
    fprintf('Bootstrap iteration %d/%d\n', b, n_bootstrap);
    
    % Resample subjects with replacement
    bootstrap_sublist_idx = randsample(length(sublist), length(sublist), true);
    bootstrap_sublist = sublist(bootstrap_sublist_idx);
    
    for icol = 2:ncol
    % Extract the column data
    column_data = varlist(:,icol);

    % Initialize a numeric array to store valid entries
    numeric_data = nan(size(column_data));  % Fill with NaNs by default
    
    for irow = 1:length(column_data)
        % Attempt to convert each entry to a number
        numeric_val = str2double(column_data{irow});
        
        if ~isnan(numeric_val)  % If conversion is successful (numeric)
            numeric_data(irow) = numeric_val;
        else
            warning('Non-numeric value detected in row %d, column %d', irow, icol);
        end
    end

    % Now use the cleaned numeric_data
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(icol-1).c = numeric_data;
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(icol-1).cname = ['Var_', num2str(icol)];
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(icol-1).iCC = 1;
    end
    
    %% For each condition, set the images for the bootstrapped subjects
    for icond = 1:length(cond_name)
        con_name = cond_name{icond};
        imgdir = {};
        for isub = 1:length(bootstrap_sublist)
            imgdir{isub,1} = fullfile(firlv_dir, task_name, ...
                ['sub-', bootstrap_sublist{isub,1}], ...
                ['con_000', cond_name{icond}(2), '.nii']); %#ok<*SAGROW>
        end
        
        % Set the result save directory for each condition
        res_save_dir = fullfile(seclv_dir, res_folder, cond_name{icond}, ['bootstrap_', num2str(b)]);
        if ~exist(res_save_dir, 'dir')
            mkdir(res_save_dir);
        end
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = [cond_name{icond}, '_bootstrap_', num2str(b)];
        
        % Run the multiple regression analysis
        run(fullfile(script_dir, 'Depend', 'job_2lv_multireg.m'));
    end
    
end

%% done
cd(script_dir)
disp('=== Bootstrap analysis done ===');

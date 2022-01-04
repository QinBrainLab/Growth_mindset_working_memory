% This script performs individual fMRI analysis
% It first loads configuration file containing individual stats parameters
% A changeable configuration file can be found at
% /home/fmri/fmrihome/SPM/spm8_scripts/IndividualStats/individualstats_conf
% ig.m.template
%
% This scripts are compatible with both Analyze and NIFTI formats
% To use either format, change the data type in individualstats_config.m
%
% -------------------------------------------------------------------------

function fun_1lv_indiv_stats_aroma_parallel(config_file)
global currentdir;
warning ('off', 'MATLAB:FINITE:obsoleteFunction')
c = fix(clock);
disp('========================================================================');
fprintf('fMRI individualstats start at %d/%02d/%02d %02d:%02d:%02d \n', c);
disp('========================================================================');
disp(['Current Directory is: ', pwd]);
disp('------------------------------------------------------------------------');

%% Check existence of the configuration file
config_file = strtrim(config_file);
if ~exist(config_file, 'file')
    fprintf('Cannot find the configuration file ... \n');
    diary off;
    return;
end

% Read individual stats parameters
currentdir = pwd;
config_file = config_file(1: end-2);
eval(config_file);

% Ignore white space if there is any
isub          = strtrim(paralist.isub);
sesslist      = strtrim(paralist.sesslist);
dele_beta     = strtrim(paralist.dele_beta); 
gzip_file     = strtrim(paralist.gzip_file); 
deriv_dir     = strtrim(paralist.deriv_dir);
output_dir    = strtrim(paralist.output_dir);
inclu_covar   = strtrim(paralist.inclu_covar);
sublist_yes   = strtrim(paralist.sublist_yes);
contrastmat   = strtrim(paralist.contrastmat);
template_path = strtrim(paralist.template_path);

tim_tr  = paralist.tr;
tim_slc = paralist.timslc;
ref_slc = paralist.refslc;

% fname = sprintf('individualstats-%d_%02d_%02d-%02d_%02d_%02.0f.log',c);
% fname = sprintf(['indivstats_', suffix ,'-%d_%02d_%02d-%02d_%02d_%02.0f.log'],c);
% diary(fname);

disp('----------------- Contents of the Parameter List -----------------------');
disp(paralist);
disp('------------------------------------------------------------------------');
clear paralist;

% Check the location of analysis results
% plumtoken = regexpi(currentdir, '^\/\w+\/plum(\d+)_share\d+', 'tokens');
% if ~isempty(plumtoken)
%   if(strcmpi(plumtoken{1}, '2'))
%     fprintf('Analysis results should not be saved in Plum2_Share<x>. \n');
%     diary off;
%     return;
%   end
% end

if ~exist(template_path,'dir')
    disp('Template folder does not exist!');
end

% Read in subjects and sessions
% Get the subjects, sesses in cell array format
% subjects = subjectlist;
% numsub   = length(subjects);

numsess = length(sesslist);
if isempty(contrastmat) && (numsess > 1)
    disp('Contrastmat file is not specified for more than two sessions.');
    diary off; return;
end

%% Start individual stats processing
fprintf('Processing Subject: %s \n', isub);
disp('------------------------------------------------------------------------');
sub_stats_dir = fullfile(output_dir, isub);

% Create stats folder.
fprintf('Creating the directory: %s \n', sub_stats_dir);
if ~ exist(sub_stats_dir, 'dir'); mkdir(sub_stats_dir); end

% Change to stats folder
fprintf('Changing to directory: %s \n', sub_stats_dir);
cd(sub_stats_dir);

% If stats folder contains SPM.mat file and others, they will be deleted
if exist('SPM.mat', 'file')
    disp('The stats directory contains SPM.mat. It will be deleted.');
    system('/bin/rm -rf *');
end

for sesscnt = 1:numsess
    % session_raw_dir: directory of subject/session in raw server
    session_raw_dir = fullfile(deriv_dir, 'fmriprep', isub);
    
    % Load TaskDesign file in raw server
    task_dsgn = fullfile(deriv_dir, 'taskdesign', isub, 'ses-s02', 'func', ...
        ['sub_', isub(5:end), '_ses_s02_task_', sesslist{sesscnt}, '_events']);
    % addpath(session_raw_dir);
    % str = which(task_dsgn);
    if isempty(task_dsgn)
        disp('Cannot find task design file in TaskDesign folder.');
        cd(currentdir);
        diary off; return;
    end
    fprintf('Running the task design file: %s \n', task_dsgn);
    run(task_dsgn);
    movefile(fullfile(deriv_dir, 'taskdesign', isub, 'ses-s02', 'func', 'task_design.mat'), sub_stats_dir);
    % rmpath(session_raw_dir);
    
    % Check the existence of preprocessed folder
    if ~exist(session_raw_dir, 'dir')
        fprintf('Cannot find %s \n', session_raw_dir);
        cd(currentdir);
        diary off; return;
    end
    
    % Unzip files if needed
    system(sprintf('gunzip -fq %s', fullfile(session_raw_dir, ...
        [isub, '_ses-s02_task-', sesslist{sesscnt}, ...
        '_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii.gz'])));
    
    % Update the design with the movement covariates
    if strcmp(inclu_covar, 'yes')
        cofounds_file =  fullfile(session_raw_dir, [isub, '_ses-s02_task-', ...
            sesslist{sesscnt}, '_desc-confounds_regressors.tsv']);
        % cofounds_load = readtable(cofounds_file,'FileType','text','Delimiter','\t','TreatAsEmpty',{'N/A','n/a'});
        cofounds_load = tdfread(cofounds_file, '\t');
        % headmotion = table(cofounds_load.trans_x, cofounds_load.trans_y, cofounds_load.trans_z, ...
        %     cofounds_load.rot_x, cofounds_load.rot_y, cofounds_load.rot_z);
        covar_read = [cofounds_load.csf, cofounds_load.white_matter];
        reg_file = fullfile(session_raw_dir, [isub, '_ses-s02_task-', sesslist{sesscnt}, '_rp.txt']);
        if exist(reg_file, 'file'); delete(reg_file); end
        % writetable(headmotion, reg_file, 'Delimiter', ' ', 'WriteVariableNames', false);
        dlmwrite(reg_file, covar_read, 'delimiter',' ')
        
        % regressor names, ordered according regressor file structure
        % reg_names = {'movement_x','movement_y','movement_z','movement_xr','movement_yr','movement_zr'};
        
        % 0 if regressor of no interest, 1 if regressor of interest
        % reg_vec   = [1 1 1 1 1 1];
        disp('Updating the task design with movement covariates');
        % save task_design.mat sess_name names onsets durations rest_exists reg_file reg_names reg_vec %#ok<*USENS>
        save task_design.mat names onsets durations reg_file %#ok<*USENS>
    end
    
    if (numsess > 1)
        % Rename the task design file
        newtaskdesign = ['task_design_sess' num2str(sesscnt) '.mat'];
        movefile('task_design.mat', newtaskdesign);
    end
    
    % Clear the variables used in input task_design.m file
    clear sess_name names onsets durations rest_exists reg_file reg_names reg_vec
end

% Get the contrast file
[pathstr, contrast_fname] = fileparts(contrastmat);

if(isempty(pathstr) && ~isempty(contrast_fname))
    contrastmat = [currentdir '/' contrastmat]; %#ok<*AGROW>
end

cd(sub_stats_dir);
foname    = cell(1,2);
foname{1} = template_path;
foname{2} = session_raw_dir;

% Call the N session batch script
individualfmri(isub, sesslist, numsess, contrastmat, foname, tim_tr, tim_slc, ref_slc);
if strcmp(dele_beta, 'yes')
    system(['rm -rf ', fullfile(output_dir, isub, 'beta*')]);
end

% Gzip scan data
if strcmp(gzip_file, 'yes')
    for sess = 1:numsess
        system (sprintf ('gzip -fq %s', fullfile(foname{2}, ...
            [isub, '_ses-s02_task-', sesslist{sess}, ...
        '_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii'])));
    end
end
disp('========================================================================')

system(['echo ', isub(5:end), ' >> ', sublist_yes])

% Change back to the directory from where you started.
fprintf('Changing back to the directory: %s \n', currentdir);
c = fix(clock);
disp('========================================================================');
fprintf('fMRI Individual Stats finished at %d/%02d/%02d %02d:%02d:%02d \n',c);
disp('========================================================================');
cd(currentdir);
% diary off;
delete(get(0, 'Children'));
clear all; %#ok<*CLALL>
close all;

end


%% Run batch script
% individualfmri is called by invidualstats.m to creates individual fMRI model.
% it updates batch file with model specification, estimation and contrasts

function individualfmri(isub, sesslist, numsess, contrastmat, foname, tim_tr, tim_slc, tim_refslc)
% Initialization
spm('defaults', 'fmri');

% Subject statistics folder
statsdir      = pwd;
template_path = foname{1};

% fMRI design specification
load(fullfile(template_path, 'batch_1lv_indiv_stats.mat'));

% Get TR value: initialized to 2 but will be update by calling GetTR.m
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = tim_tr;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = tim_slc;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = tim_refslc;

% Initializing scans
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {};

for sess = 1:numsess
    % Set preprocessed folder
    datadir = foname{2};
    
    nifti_file = spm_select('ExtFPList', datadir, [isub, '_ses-s02_task-', sesslist{sess}, ...
        '_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii']);
    V          = spm_vol(deblank(nifti_file));
    nframes    = V(1).private.dat.dim(4);
    files      = spm_select('ExtFPList', datadir, [isub, '_ses-s02_task-', sesslist{sess}, ...
        '_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii'], 1:nframes);
    nscans     = size(files,1);
    clear nifti_file V nframes;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess) = ...
        matlabbatch{1}.spm.stats.fmri_spec.sess(1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess).scans = {};
    
    % Input preprocessed images
    for nthfile = 1:nscans
        matlabbatch{1}.spm.stats.fmri_spec.sess(sess).scans{nthfile,1} = deblank(files(nthfile,:));
    end
    
    if(numsess == 1)
        taskdesign_file = fullfile(statsdir, 'task_design.mat');
    else
        taskdesign_file = sprintf('%s/task_design_sess%d.mat', statsdir, sess);
    end
    
    reg_file = '';
    load(taskdesign_file);
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess).multi{1}  = taskdesign_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess).multi_reg = {reg_file};
    
end
matlabbatch{1}.spm.stats.fmri_spec.dir{1} = statsdir;

% Estimation setup
matlabbatch{2}.spm.stats.fmri_est.spmmat{1} = strcat(statsdir, '/SPM.mat');

% Contrast setup
matlabbatch{3}.spm.stats.con.spmmat{1} = strcat(statsdir,'/SPM.mat');

% Built the standard contrats only if the number of sessions is one
% else use the user provided contrast file
if isempty(contrastmat)
    if (numsess >1 )
        disp(['The number of session is more than 1, No automatic contrast' ...
            ' generation option allowed, please spcify the contrast file']);
        diary off; return;
    else
        build_contrasts (matlabbatch{1}.spm.stats.fmri_spec.sess);
    end
else
    copyfile (contrastmat, './contrasts.mat');
end

load contrasts.mat;

for i = 1:length(cont_names)
    if (i <= cont_num)
        matlabbatch{3}.spm.stats.con.consess{i}.tcon.name   = cont_names{i};
        matlabbatch{3}.spm.stats.con.consess{i}.tcon.convec = cont_vecs{i};
    elseif (i > cont_num)
        matlabbatch{3}.spm.stats.con.consess{i}.fcon.name = cont_names{i};
        for j=1:length(cont_vecs{i}(:,1))
            matlabbatch{3}.spm.stats.con.consess{i}.fcon.convec{j} = cont_vecs{i}(j,:);
        end
    end
end
save batch_stats matlabbatch;

% Initialize the batch system
spm_jobman ('initcfg');
delete (get (0,'Children'));

% Run analysis
spm_jobman ('run', './batch_stats.mat');

end
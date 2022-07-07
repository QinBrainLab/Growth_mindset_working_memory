% gPPI analysis for task-related fMRI data and analysis pipeline
% shaozheng qin adapted for his memory poject on January 1, 2014
% lei hao readapted for his development poject on Septmber 21, 2017
function fun_gPPImask_1by1(config_file)
warning('off', 'MATLAB:FINITE:obsoleteFunction')
c = fix(clock);
disp('========================================================================');
fprintf('gPPI analysis started at %d/%02d/%02d %02d:%02d:%02d \n',c);
disp('========================================================================');
% fname = sprintf('gPPImask-%d_%02d_%02d-%02d_%02d_%02.0f.log',c);
% diary(fname);
disp(['Current directory is: ',pwd]);
disp('------------------------------------------------------------------------');

% Check existence of the configuration file
config_file = strtrim(config_file);

if ~exist(config_file, 'file')
    fprintf('Cannot find the configuration file ... \n');
    diary off;
    return;
end
config_file = config_file(1:end-2);

% Read individual stats parameters
eval(config_file);

% Load parameters
% preproc_dir    = strtrim(paralist.preproc_dir);
firstlv_dir    = strtrim(paralist.firstlv_dir);
spm_ver        = strtrim(paralist.spm_ver);
stats_ver      = strtrim(paralist.stats_ver);
stats_dir      = strtrim(paralist.stats_dir);
subjects       = strtrim(paralist.sublist);
num_subj       = length(subjects);
roi_file       = paralist.roi_file_list;
roi_name       = paralist.roi_name_list;
num_roi_name   = length(roi_name);
num_roi_file   = length(roi_file);
tasks_include  = paralist.tasks_include;
mask_file      = paralist.mask_file;
confound_names = paralist.confound_names;
scriptdir      = strtrim(script_dir);
gzipswcar      = gzip_swcar;

if num_roi_name ~= num_roi_file
    error('Number of ROI files not equal to number of ROI names');
end

for i_roi = 1:num_roi_file
    fprintf('===> gPPI for ROI: %s\n', roi_name{i_roi});
    load(fullfile(scriptdir, 'Depend', 'ppi_master_template.mat'));
    
    P.VOI      = roi_file{i_roi};
    P.Region   = roi_name{i_roi};
    P.Tasks    = tasks_include;
    P.FLmask   = 1;
    P.equalroi = 0;
    
    for isub = 1:num_subj
        fprintf('------> Processing subject: %s\n', subjects{isub});
        year_id = ['20', subjects{isub}(1:2)];
        
        % Directory of SPM.mat file
        subject_stats_dir = fullfile(firstlv_dir, year_id, subjects{isub}, ...
            'fMRI', stats_ver, stats_dir);
        
        subject_gPPI_stats_dir = fullfile(firstlv_dir, year_id, subjects{isub}, ...
            'fMRI', stats_ver, [stats_dir, '_gPPI_mask']);
        
        if ~exist(subject_gPPI_stats_dir, 'dir')
            mkdir(subject_gPPI_stats_dir);
        end
        
        cd(subject_gPPI_stats_dir);
        unix(sprintf('/bin/cp -af %s %s', fullfile(subject_stats_dir, 'SPM.mat'), ...
            subject_gPPI_stats_dir));
        
        if strcmp(spm_ver, 'spm8')
        unix(sprintf('/bin/cp -af %s %s', fullfile(subject_stats_dir, '*.img'), ...
            subject_gPPI_stats_dir));
        unix(sprintf('/bin/cp -af %s %s', fullfile(subject_stats_dir, '*.hdr'), ...
            subject_gPPI_stats_dir));
        elseif strcmp(spm_ver, 'spm12')
        unix(sprintf('/bin/cp -af %s %s', fullfile(subject_stats_dir, '*.nii'), ...
            subject_gPPI_stats_dir));
        end
        
        P.subject = subjects{isub};
        P.directory = subject_gPPI_stats_dir;
        
        % Update the SPM path for gPPI analysis
        load('SPM.mat');
        SPM.swd = pwd;
        
        num_sess = numel(SPM.Sess);
        
        img_name = cell(num_sess, 1);
        img_path = cell(num_sess, 1);
        num_scan = [1, SPM.nscan];
        
        for i_sess = 1:num_sess
            first_scan_sess = sum(num_scan(1:i_sess));
            img_name{i_sess} = SPM.xY.VY(first_scan_sess).fname;
            img_path{i_sess} = fileparts(img_name{i_sess});
            unix(sprintf('gunzip -fq %s', [img_name{i_sess}, '.gz']));
        end
        
        iG = [];
        col_name = SPM.xX.name;
        
        num_confound = length(confound_names);
        
        for i_c = 1:num_confound
            iG_exp = ['^Sn\(.*\).', confound_names{i_c}, '$'];
            iG_match = regexpi(col_name, iG_exp);
            iG_match = ~cellfun(@isempty, iG_match);
            if sum(iG_match) == 0
                error('Confound columns are not well defined or found');
            else
                iG = [iG find(iG_match == 1)]; %#ok<*AGROW>
            end
        end
        
        if length(iG) ~= num_confound*num_sess
            error('Number of confound columns does not match SPM design');
        end
        
        num_col = size(SPM.xX.X, 2);
        FCon = ones(num_col, 1);
        FCon(iG) = 0;
        FCon(SPM.xX.iB) = 0;
        FCon = diag(FCon);
        
        num_con = length(SPM.xCon);
        
        % Make F contrast and run it
        SPM.xCon(end+1)= spm_FcUtil('Set', 'effects_of_interest', 'F', ...
            'c', FCon', SPM.xX.xKXs);
        spm_contrasts(SPM, num_con+1);
        
        % Make T contrast
        P.contrast = num_con + 1;
        
        SPM.xX.iG = sort(iG);
        for g = 1:length(iG)
            SPM.xX.iC(SPM.xX.iC==iG(g)) = [];
        end
        
        save SPM.mat SPM;
        clear SPM;
        
        % Make T contrast
        P.Contrasts = Pcon.Contrasts;
        
        % User input required (change analysis to be more specific)
        save(['gPPI_', subjects{isub}, '_', roi_name{i_roi}, '.mat'], 'P');
        mkdir(fullfile(subject_gPPI_stats_dir, ['PPI_', roi_name{i_roi}]));
        PPPI_mask(['gPPI_', subjects{isub}, '_', roi_name{i_roi}, '.mat'], ...
            ['gPPI_', subjects{isub}, '_', roi_name{i_roi}, '.mat'], mask_file);
        
        for i_sess = 1:num_sess
            if gzipswcar==1
                unix(sprintf('gzip -fq %s', img_name{i_sess}));
            end
        end
        
        cd(subject_gPPI_stats_dir);
        unix(sprintf('/bin/rm -rf %s', 'SPM.mat'));
        unix(sprintf('/bin/rm -rf %s', '*.nii'));
        unix(sprintf('/bin/rm -rf %s', '*.img'));
        unix(sprintf('/bin/rm -rf %s', '*.hdr'));
        unix(sprintf('/bin/mv -f %s %s', '*.txt', ['PPI_', roi_name{i_roi}]));
        unix(sprintf('/bin/mv -f %s %s', '*.mat', ['PPI_', roi_name{i_roi}]));
        unix(sprintf('/bin/mv -f %s %s', '*.log', ['PPI_', roi_name{i_roi}]));
    end
end

cd(scriptdir);
disp('------------------------------------------------------------------------');
fprintf('Changing back to the directory: %s \n', scriptdir);
c = fix(clock);
disp('========================================================================');
fprintf('gPPI analysis finished at %d/%02d/%02d %02d:%02d:%02d \n',c);
disp('========================================================================');

% diary off;
clear all;
close all;
end

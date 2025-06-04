% written by l.hao (ver_19.09.11)
% edited by Y.Zhao for Growth Mindset project
% qinlab.BNU
restoredefaultpath
clear;
clc;

%% Set up
% Set parallel pattern
ppl_max_queued = 50;
ppl_mode       = 'session';
ppl_mode_manag = 'session';

% Set path
spm_dir    = '...\MATLAB\R2020a\toolbox\spm12';
psom_dir   = '...\MATLAB\R2020a\toolbox\psom';
deriv_dir  = '...';
script_dir = '...';

% Basic ponfigure
tim_tr      = 2;
tim_slc     = 33;
ref_slc     = 17;
data_type   = 'nii';
dele_beta   = 'yes';
gzip_file   = 'yes';
inclu_covar = 'yes';

suffix    = 'zyy';
task_name = 'nb';
list_runs = '{''nb''}';
cont_name = 'cont_nb_chen_aroma.mat';

%% The following do not need to be modified
logs_dir = fullfile(script_dir, ['logs_', task_name, '_', suffix]);
switch exist(logs_dir, 'dir')
    case 7
       system(['rm -rf ', fullfile(logs_dir, '*', '*')]);
    case 0
        mkdir(fullfile(logs_dir, 'config'));
        mkdir(fullfile(logs_dir, 'parallel'));
        mkdir(fullfile(logs_dir, 'subject'));
end

addpath(genpath(spm_dir));
addpath(genpath(psom_dir));
addpath(genpath(script_dir));

sublist_all = fullfile(logs_dir, 'subject', 'sublist_firstlv_all.txt');
sublist_yes = fullfile(logs_dir, 'subject', 'sublist_firstlv_yes.txt');
list_all = struct2cell(dir(fullfile(deriv_dir, 'fmriprep', 'sub-*')))';
for isub = 1:size(list_all, 1)
    rnum = eval(list_runs);
    
    file_ext = 1;
    for irun = 1:size(rnum, 2)
        img_file1 = fullfile(deriv_dir, 'fmriprep', list_all{isub, 1}, ...
            [list_all{isub, 1}, '_ses-s02_task-', ...
            rnum{1, irun}, '_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii']);
        img_file2 = fullfile(deriv_dir, 'fmriprep', list_all{isub, 1}, ...
            [list_all{isub, 1}, '_ses-s02_task-', ...
            rnum{1, irun}, '_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii.gz']);
        dsg_file = fullfile(deriv_dir, 'taskdesign', list_all{isub, 1}, ...
            'ses-s02', 'func', ['sub_', list_all{isub, 1}(5:end), ...
            '_ses_s02_task_', rnum{1, irun}, '_events.m']);
        
        file_ext = file_ext & exist(dsg_file, 'file') & ...
            (exist(img_file1, 'file') | exist(img_file2, 'file'));
    end
    
 % if file_ext == 1; system(['echo ', list_all{isub, 1}(5:end), ' >> ', sublist_all]); end
end

sublist_run = importdata(sublist_all);
for isub = 1:size(sublist_run, 1)
    iconfigname = ['config_firstlv_', task_name, '_', ...
        sublist_run{isub, 1}, '_', suffix, '.m'];
    iconfigfile = fopen(iconfigname, 'a');
    
    fprintf(iconfigfile,'%s\n',['paralist.isub = ''', ['sub-', sublist_run{isub, 1}], ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.tr = ', num2str(tim_tr), ';']);
    fprintf(iconfigfile,'%s\n',['paralist.timslc = ', num2str(tim_slc), ';']);
    fprintf(iconfigfile,'%s\n',['paralist.refslc = ', num2str(ref_slc), ';']);
    fprintf(iconfigfile,'%s\n',['paralist.suffix = ''', suffix, ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.sesslist = ', list_runs, ';']);
    fprintf(iconfigfile,'%s\n',['paralist.dele_beta = ''', dele_beta, ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.gzip_file = ''', gzip_file, ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.data_type = ''', data_type, ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.deriv_dir = ''', deriv_dir, ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.output_dir = ''', fullfile(deriv_dir, 'firstlevel_new', task_name), ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.contrastmat = ''', fullfile(script_dir, 'contrast', cont_name), ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.inclu_covar = ''', inclu_covar, ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.sublist_yes = ''', sublist_yes, ''';']);
    fprintf(iconfigfile,'%s\n',['paralist.template_path = ''', fullfile(script_dir, 'depend'), ''';']);
    fclose(iconfigfile);
    movefile (iconfigname, fullfile(script_dir, 'depend'))
    
    ppl_opt.max_queued = ppl_max_queued;
    ppl_opt.mode = ppl_mode;
    ppl_opt.mode_pipeline_manager = ppl_mode_manag;
    ppl_opt.path_logs = fullfile(logs_dir, 'parallel');
    
    sub_firlv =['sub_', task_name, '_', sublist_run{isub,1}];
    pipeline.(sub_firlv).command = 'fun_1lv_indiv_stats_aroma_parallel(opt.iconf)';
    pipeline.(sub_firlv).opt.iconf = iconfigname;
end
psom_run_pipeline(pipeline, ppl_opt);
movefile (fullfile(script_dir, 'depend', ['config_firstlv_', task_name, '*']), fullfile(logs_dir, 'config'))

%% Completed
disp(['Completed at: ', datestr(now)]);

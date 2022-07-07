% written by l.hao (ver_18 .09.08)
% rock3.hao@gmail.com 
% qinlab.BNU  
clear

%% set up
% set path
ppl_max_queued = 10;
ppl_mode       = 'session';
ppl_mode_manag = 'session';

sess_name  = 'nb';
psom_dir   = '/home/zhaoyuyao/toolbox/psom';
script_dir = '/home/zhaoyuyao/code_bk/MS_project/MS_TP1/brain/gPPI/gPPI_zyy';
subjlist   = fullfile(script_dir, 'list_sub_zyy.txt');

%% the following do not need to be modified
addpath(genpath(psom_dir));
addpath(genpath(script_dir));

fid = fopen(subjlist); sublist = {}; cnt = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid),'%s','Delimiter','\t');
    sublist(cnt,:) = linedata{1}; cnt = cnt+1; %#ok<*SAGROW>
end
fclose(fid);

for isub = 1:length(sublist)
    ppl_opt.max_queued = ppl_max_queued;
    ppl_opt.mode = ppl_mode;
    ppl_opt.mode_pipeline_manager = ppl_mode_manag;
    ppl_opt.path_logs = fullfile(pwd, 'Logs', 'Parallel');
    if ~exist(fullfile(pwd, 'Logs', 'Parallel'), 'dir')
        mkdir(ppl_opt.path_logs);
    end
    
    sub_gppi = [ 'Sub_', sess_name, '_', num2str(isub)];
    pipeline.(sub_gppi).command = 'fun_gPPImask_parallel(opt.conf, opt.isub)';
    pipeline.(sub_gppi).opt.conf = 'conf_gPPImask_parallel.m';
    pipeline.(sub_gppi).opt.isub = sublist{isub,1};
end
psom_run_pipeline(pipeline, ppl_opt);

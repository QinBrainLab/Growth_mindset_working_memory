% written by hao (2017/08/06)
% rock3.hao@gmail.com
% qinlab.BNU
clear

%% Set up
subj_list   = 'C:\Users\lenovo\Desktop\MS_project\codes\codes_image-analysis_matlab-master\ROIs-analy\sublist_all.txt';

roi_form  = 'nii';
roi_dir   = 'D:\deriv\ROI\cluster_new_2';
spm8_dir  = 'C:\Program Files\MATLAB\R2020a\toolbox\spm12'; 
firlv_dir = 'D:\deriv\firstlevel\nb';

task_name = 'nb';
%con_name  = {'0back';'1back';'2back';'1-0';'2-0';};
%con_num   = {'1'    ; '2'   ; '3'   ;'4'  ; '5' ;};
con_name  = {'01back';'02back';'12back';};
con_num   = { '4';'5';'6';  };


%% ===================================================================== %%


% Acquire Subject list
fid  = fopen (subj_list); subj = {}; Cnt  = 1;
while ~feof (fid)
    linedata = textscan (fgetl (fid), '%s', 'Delimiter', '\t');
    subj (Cnt,:) = linedata{1}; Cnt = Cnt + 1; %#ok<*SAGROW>
end
fclose (fid);

% Acquire ROI file & list
ROI_list = dir (fullfile (roi_dir, ['*.', roi_form]));
ROI_list = struct2cell (ROI_list);
ROI_list = ROI_list (1, :);
ROI_list = ROI_list';

%% Extract Mean Value
for con_i = 1:length(con_name)
    mean = {'Scan_ID'};
    for roi_i = 1:length(ROI_list)
        mean{1,roi_i+1} = ROI_list{roi_i,1}(1:end-4);
        roifile = fullfile(roi_dir, ROI_list{roi_i,1});
        for sub_i = 1:length(subj)

            subjfile = fullfile (firlv_dir, ['sub-', subj{sub_i,1}], ...
                ['con_000',con_num{con_i,1},'.nii']);
            mean{sub_i+1,1} = subj{sub_i,1};
            if strcmp(roi_form, 'nii')
                mean{sub_i+1,roi_i+1} = rex(subjfile,roifile);
            end
            if strcmp(roi_form, 'mat')
                roi_obj = maroi(roifile);
                roi_data = get_marsy(roi_obj, subjfile, 'mean');
                mean{sub_i+1,roi_i+1} = summary_data(roi_data);
            end
        end
    end
    
    %% Save Results
    save_name = ['res_beta_nroi_', con_name{con_i}, '.csv'];
    
    fid = fopen(save_name, 'w');
    [nrows,ncols] = size(mean);
    col_num = '%s';
    for col_i = 1:(ncols-1); col_num = [col_num,',','%s']; end %#ok<*AGROW>
    col_num = [col_num, '\n'];
    for row_i = 1:nrows; fprintf(fid, col_num, mean{row_i,:}); end;
    fclose(fid);
    
end

%% Done
clear all
disp('=== Extract Done ===');

clear;clc;
img_dir='D:\deriv\fmriprep';
subj_list='C:\Users\lenovo\Desktop\MS_project\fMRI_data_indics\sublist.txt';

fid = fopen(subj_list); sub2list = {}; cntlist = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sub2list(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
end
fclose(fid);

fp = fopen('outliers_aroma1.txt', 'a');
for i=1:length(sub2list)
    sub2list{i,1}
    cwd= fullfile(img_dir,sub2list{i,1});
    cd(cwd);
    mvment_file = fullfile(cwd,[sub2list{i,1},'_ses-s02_task-nb_desc-confounds_regressors.tsv']);
    fid = fopen(mvment_file); mvment_all = {}; cntlist = 1;
    while ~feof(fid)
        linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
        mvment_all(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
    end
    fclose(fid);
   

   num=0;
    dim=size(mvment_all);
    for j=1:dim(2)
        if length(mvment_all{1,j})>14
        if strcmp(mvment_all{1,j}(1:14),'motion_outlier')
                num=num+1;
        end
        end
    end
    fprintf(fp,'%f\n',num);
    
end


fclose(fp);
fprintf('End\n');
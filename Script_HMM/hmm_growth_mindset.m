% written by Junjie Cui 



clear;clc
load("roi_11_mean.mat"); % BOLD signal
load("brain_data.mat"); % participants' information

K = 8; % number of states
roi_num = 11; 
TR = 2;
use_stochastic = 1; % set to 1 if you have loads of data

N = 305; % no. subjects
f = cell(N,1); T = cell(N,1);
% each .mat file contains the data (ICA components) for a given subject, 
% in a matrix X of dimension (4800time points by 50 ICA components). 
% T{j} contains the lengths of each session (in time points)
for j=1:N
T{j} = 228; 
end

f = roi_file_new; % BOLD signal

options = struct();
options.K = K; % number of states 
options.order = 0; %order = 0, HMM Gaussian distribution
options.zeromean = 0; % model the mean
options.covtype = 'full'; % full covariance matrix
options.Fs = 1/TR; 
options.verbose = 1;
options.standardise = 1; % whether or not to standardize to each subject, default = 1, standardize
options.inittype = 'hmmmar'; % "hmmmar" for HMM-MAR initialisation, "sequential" ...
% for an initialisation where trials or segments start on state 1 and progress in sequence towards state K, or "random" for random initialisation. (default to "hmmmar").
options.cyc = 1000;
options.initcyc = 25;
options.initrep = 5;
options.useParallel = 0;

[hmm, Gamma, ~, vpath] = hmmmar(f,T,options);

%% calculate subjects' state stability＆variability

%% state stability indicates the consistence of states' probability sequence during high demand blocks
%% hl_temp_stability

subject_stability = zeros(305,8);
subject_stability_all = zeros(4,4,8,305);
for i = 1:305

    for k = 1:8

    subj_s_gamma = zeros(14,4);

    for j = 1:4  

    subj_s_gamma(:,j) = Gamma(228*(i-1) + (onsets_file{1,3}(1,j):1:(onsets_file{1,3}(1,j)+13)),k); % subject's state probability sequence during high demand

    end

    subject_stability_all(:,:,k,i) = corr(subj_s_gamma);
    subject_stability(i,k) = sum(subject_stability_all(:,:,k,i),"all")-4;

    end

end

%% state variability indicates the variability of states' probability sequence during high demand blocks
%% hl_temp_variability

subj_cons_variability = zeros(305,4,8);
for i = 1:305
    for j = 1:4

            temp_gamma = Gamma(228*(i-1) + (onsets_file{1,3}(i,j):onsets_file{1,3}(i,j)+13),:);
            temp_gamma_std = std(temp_gamma,0,1);
            subj_cons_variability(i,j,:) = temp_gamma_std;

    end
end
subj_cons_variability = reshape(mean(subj_cons_variability,2),305,8);

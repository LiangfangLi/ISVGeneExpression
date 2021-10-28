
%% To do: calculate intersubject variability in functional connectivity (ROI-level).
%
%   Note: FC matrix should be prepared as a .mat format file; detailed
%   parameter you can get from isv_parameters_ROI.mat
%

clear,clc

Step_1st_Folder = 'D:\wd\Replication_CodeShare\Step_1st_ISV_Calculation';
FunctionFolder = [Step_1st_Folder '\functions'];
ReplicationFolder = 'D:\wd\Replication_CodeShare\Replicate';
addpath(FunctionFolder)
%% ROI level
load('isv_parameters_ROI.mat')
isv_parameters_ROI.job_list
isv_parameters_ROI.output_path =  [ReplicationFolder '\ROI_results_replicate.csv'];%you can customize the path where the output file is stored and customize the filename (here set ROI_results_replicate.csv as example)

ROI_results = isv_job_man(isv_parameters_ROI.job_list,...
    isv_parameters_ROI.data_sess_01,...
    isv_parameters_ROI.data_sess_02,...
    isv_parameters_ROI.opt)
csvwrite(isv_parameters_ROI.output_path,ROI_results.data_sess_0102_r_s_intra_inter_isv)%ROI_results.data_sess_0102_r_s_intra_inter_isv is the ROI-level ISV matrix

size(ROI_results.data_sess_0102_r_s_intra_inter_isv)%size of the ROI-level ISV matrix (number of participants * number of ROIs)

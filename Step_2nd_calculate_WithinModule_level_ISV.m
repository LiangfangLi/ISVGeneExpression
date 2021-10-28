
%% To do: calculate intersubject variability in functional connectivity (within-module level).
%
%   Note: FC matrix should be prepared as a .mat format file; detailed
%   parameter you can get from isv_parameters_Network.mat
%

clear,clc

Step_1st_Folder = 'D:\wd\Replication_CodeShare\Step_1st_ISV_Calculation';
FunctionFolder = [Step_1st_Folder '\functions'];
ReplicationFolder = 'D:\wd\Replication_CodeShare\Replicate';
addpath(FunctionFolder)
%% within-module level
% loading information about the correspondence between ROI and the network label of Yeo 7 atlas
ROI2Network = importdata('ROI2Network.csv');%the first column is the ROI ID, and the second column is the corresponding network label
ROI2Network = ROI2Network.data;
% check the number of ROIs and netoworks that would be used in subsequent analysis
number_of_ROI = size(find(ROI2Network(:,2)~=0),1)%some ROIs were not assigned to certain networks, their network labels were set as 0
number_of_Network = size(find(unique(ROI2Network(:,2))~=0),1)

load('isv_parameters_Network.mat')
isv_parameters_Network.opt.group = ROI2Network(ROI2Network(:,2)~=0,:);%send the ROI-to-Network correspondence information to parameters group
isv_parameters_Network.output_path =[ReplicationFolder '\Network_results_replicate.csv'];
isv_parameters_Network = adjust_fc_matrix(isv_parameters_Network)%adjust FC matrix according to the group information, deleting the FC vector of the ROI labeled as network 0
% the FC matrix after adjustment/reorganization would be stored in the folder called tmp.
% note. the matrix size of the adjusted FC matrix can be varied, depending on the ROI-to-Network matching situation. 
% If all of ROIs can be matched to a specific module in your study, you can also use adjust_fc_matrix.m, which will not make unnecessary adjustments to the original FC matrix.

intra_network_results = isv_job_man(isv_parameters_Network.job_list,...
    isv_parameters_Network.data_sess_01,...
    isv_parameters_Network.data_sess_02,...
    isv_parameters_Network.opt)
csvwrite(isv_parameters_Network.output_path,intra_network_results.network_intra_isv)

size(intra_network_results.network_intra_isv)%size of the Within-module-level ISV matrix (number of participants * number of modules)
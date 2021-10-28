%% To do: prepare predictor variable and response variable for PLS regression.

clear
%prepare path
cd 'D:\wd\Replication_CodeShare\Step_3rd_PLS_regression'
Step_3rd_Folder = 'D:\wd\Replication_CodeShare\Step_3rd_PLS_regression';
FunctionFolder = [Step_3rd_Folder '\functions'];
ReplicationFolder = 'D:\wd\Replication_CodeShare\Replicate';
addpath(FunctionFolder,ReplicationFolder);
%% prepare response variable £¨ROI-level ISV£© and predcitor variabiles (302 ROI x 415 HAR-BRAIN genes)
ROI_level_ISV = csvread([ReplicationFolder,'\ROI_results_replicate.csv']);
average_roi_isv = mean(ROI_level_ISV)';
load('union_roi_list_in6donors.mat')%302 union roi, corrsponding row number
response_var_file = average_roi_isv(union_roi_list_in6donors,:);%302*1 isv vector
save(fullfile(ReplicationFolder,'response_var_file.mat'),'response_var_file');

%% predictor-415 HAR-BRAIN gene
load('HAR_BRAIN_expression.mat')%415 har brain gene
predictor_var_file = table2array(HAR_BRAIN_expression(:,2:end))';%302*415 gene expression matrix
save(fullfile(ReplicationFolder,'predictor_var_file.mat'),'predictor_var_file');
% 415 HAR-BRAIN gene name
HAR_BRAIN_symbol =  HAR_BRAIN_expression.Allen_Gene_Symbol;
save(fullfile(ReplicationFolder,'HAR_BRAIN_symbol.mat'),'HAR_BRAIN_symbol');

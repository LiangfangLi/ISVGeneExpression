%% To do: combine PLS score, CBF and ISV score to conduct mediation analysis.

clear

cd D:\wd\Replication_CodeShare\Step_6th_CerebralBloodFlow
Step_6th_Folder = 'D:\wd\Replication_CodeShare\Step_6th_CerebralBloodFlow';
ReplicationFolder = 'D:\wd\Replication_CodeShare\Replicate';
addpath(ReplicationFolder)

load('PLS1_score.mat')
load('PLS2_score.mat')
load('response_var_file.mat')
load('union_roi_list_in6donors.mat')
% combine PLS scores isv and union ROI id
tbl_pls_isv_union_roi = array2table([union_roi_list_in6donors,PLS1_score,PLS2_score,response_var_file],'VariableNames',{'ROI_id','PLS1_scores','PLS2_scores','ISV'});

% merge CBF
load('available_roi_cbf.mat')
tbl_cbf_intersectROI = available_roi_cbf(ismember(available_roi_cbf.ROI_id,tbl_pls_isv_union_roi.ROI_id),:);
tbl_pls_isv_intersectROI = tbl_pls_isv_union_roi(ismember(tbl_pls_isv_union_roi.ROI_id,available_roi_cbf.ROI_id),:);
isequal(tbl_cbf_intersectROI.ROI_id,tbl_pls_isv_intersectROI.ROI_id)
isequal(tbl_cbf_intersectROI.ISV,tbl_pls_isv_intersectROI.ISV)%both contain ISV, and are equal

% combine
pls_cbf_isv_forMediation = join(tbl_cbf_intersectROI(:,1:3),tbl_pls_isv_intersectROI,'Keys','ROI_id');%only merge the first three columns
pls_cbf_isv_forMediation.Properties.VariableNames{3} = 'CBF';
save(fullfile(ReplicationFolder,'\pls_cbf_isv_forMediation.mat'),'pls_cbf_isv_forMediation')
writetable(pls_cbf_isv_forMediation,fullfile(ReplicationFolder,'CBF','\pls_cbf_isv_forMediation.csv'))

%% To do: extract CBF value from the CBF map shared by Satterthwaite et al. (2014) to obtain an ROI-level CBF map based on AAL-625 atlas.

clear

cd D:\wd\Replication_CodeShare\Step_6th_CerebralBloodFlow
Step_6th_Folder = 'D:\wd\Replication_CodeShare\Step_6th_CerebralBloodFlow';
FunctionFolder = [Step_6th_Folder '\functions'];
SPMFolder = 'D:\wd\combine_toolbox\spm12';
ReplicationFolder = 'D:\wd\Replication_CodeShare\Replicate';
addpath(FunctionFolder,SPMFolder,ReplicationFolder)

% load CBF map
[CBF, CBF_VoxelSize, CBF_FileList, CBF_Header]  = y_ReadAll(fullfile(Step_6th_Folder,'CBFmap_BrainAtlas','n1172_AslMean_gamBeta_Intercept_MNI.nii.gz'));
% load AAL625 atlas
[atlas, atlas_VoxelSize, atlas_FileList, atlas_Header]  = y_ReadAll(fullfile(Step_6th_Folder,'CBFmap_BrainAtlas','AAL625_1mm.nii'));
% extract cbf
roi_label_in_atals = unique(atlas(atlas~=0));
for i=1:(length(roi_label_in_atals))
    disp(i)
    single_roi_label = roi_label_in_atals(i);
    loc = find(atlas == single_roi_label);%extract roi i location index
    % corrsponding cbf
    cbf_roi_i = CBF(loc);
    roi_index_cbf{i,:} = cbf_roi_i;%detail
    count(i,1) = single_roi_label;     
    temp_cbf_roi_i = cbf_roi_i.*(cbf_roi_i>0);%set negative cbf as 0
    count(i,2) =numel(find(temp_cbf_roi_i==0))/size(loc,1)*100;% cbf value=0 and <0
    % mean cbf of roi i
    mean_cbf_roi(i,1) = single_roi_label;
    mean_cbf_roi(i,2) =mean(temp_cbf_roi_i(temp_cbf_roi_i > 0));% only postive = set negative value as zero and exclude zero when average
end

tbl_count = array2table(count,'VariableNames',{'ROI_id','perc_NegativeAndZero'})
tbl_mean_cbf = array2table(mean_cbf_roi,'VariableNames',{'ROI_id','only_postive_voxel_meancbf'})
% combine
tbl_mean_postive_cbf_perc = join(tbl_count,tbl_mean_cbf,'Keys','ROI_id')

%% remove the ROI whose more than 90% of voxels are zero or negative
available_roi_cbf = tbl_mean_postive_cbf_perc(tbl_mean_postive_cbf_perc.perc_NegativeAndZero<90,:);
size(available_roi_cbf,1)
% isv martix for AAL 625 rois
ROI_level_ISV = csvread([ReplicationFolder,'\ROI_results_replicate.csv']);
average_roi_isv = mean(ROI_level_ISV)';
corrponding_isv =  average_roi_isv(available_roi_cbf.ROI_id,:);
[r1,p1] = corr(available_roi_cbf.only_postive_voxel_meancbf,corrponding_isv,'type','Spearman','rows','pairwise') 
scatter(available_roi_cbf.only_postive_voxel_meancbf,corrponding_isv)

available_roi_cbf.ISV = corrponding_isv;
save(fullfile(ReplicationFolder,'\available_roi_cbf.mat'),'available_roi_cbf')
writetable(available_roi_cbf,fullfile(ReplicationFolder,'CBF','\available_roi_cbf_isv.csv'))

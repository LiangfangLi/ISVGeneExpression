%% To do: calculate the minimal Euclidean distance between the reported MNI coordinates of samples and that of all gray matter voxels, find the closest voxel for each sample.

clear
% prep path 
cd D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
MaskFolder = [Step_2nd_Folder '\brain_mask'];
DataFolder = [Step_2nd_Folder '\wd_data'];
addpath(genpath(FunctionFolder),MaskFolder,DataFolder);

% load AAL625 mask,calculate the MNI coordinate of each voxel in AAL625 mask
atlas_625= load_nii('AAL625_1mm.nii');%load_nii is a function located in '\functions\NIfTI_20140122'
atlas_625.hdr.hist
atlas_625_zero_point = atlas_625.hdr.hist.originator(:,1:3)
atlas_625_mat = atlas_625.img;

load('left_ROI_list_AAL625.mat')
[left_ROI_voxel_MNIcorr_label,left_ROI_voxel_index_label] = voxel_MNI(atlas_625_mat,atlas_625_zero_point,left_ROI_list);
save(fullfile(Step_2nd_Folder,'wd_data','left_ROI_voxel_MNIcorr_label.mat'),'left_ROI_voxel_MNIcorr_label')%mni x,y,z and ROI label
save(fullfile(Step_2nd_Folder,'wd_data','left_ROI_voxel_index_label.mat'),'left_ROI_voxel_index_label')%voxel index x,y,z and ROI label

%% calculate Euclidean distance between sample and voxel
left_ROI_voxel_MNIcorr = table2array(left_ROI_voxel_MNIcorr_label(:,1:3));
load('SampleAnnot_only_left.mat')
for i = 1:size(SampleAnnot_only_left,1)
    count = 0;
    donori_file = SampleAnnot_only_left{i};%single donor i
    sample_counts = size(donori_file,1);
    
    for j = 1:sample_counts
        single_sample_MNI = table2array(donori_file(j,1:3));
        %calculate distance
        dists = sqrt(sum(bsxfun(@minus,single_sample_MNI,left_ROI_voxel_MNIcorr).^2,2));
        nearst_dist = min(dists);
        nearst_voxel_mni_label = left_ROI_voxel_MNIcorr_label(find(dists==nearst_dist),:);
        
        if nearst_dist < 2 %the smallest distance under 2 mm theshold
            if size(nearst_voxel_mni_label,1)==1
                donori_file.matched_ROI_ID(j,:) =nearst_voxel_mni_label.region_lable;
                donori_file.clear_or_not(j,:) = 1;
                donori_file.dist(j,:) = nearst_dist;
            else
                
                specfic_roi_label = unique(nearst_voxel_mni_label.region_lable);
                if size(specfic_roi_label,1) == 1
                    donori_file.matched_ROI_ID(j,:) = specfic_roi_label;
                    donori_file.clear_or_not(j,:) = 1;
                    donori_file.dist(j,:) = nearst_dist;
                    
                else%multiple ROI 
                    
                    %prepare information
                    dist_under_2mm = dists(find(dists<2),:);
                    under_2mm_mni = left_ROI_voxel_MNIcorr(find(dists<2),1:3);
                    %check
                    check_dists = sqrt(sum(bsxfun(@minus,single_sample_MNI,under_2mm_mni).^2,2));
                    isequal(dist_under_2mm,check_dists)
                   
                    under_2mm_mni_label = left_ROI_voxel_MNIcorr_label(find(dists<2),:);
                    temp = [dist_under_2mm,under_2mm_mni_label.region_lable]; 
                    temp = array2table(temp,'VariableNames',{'distance','region_lable'});
                    summary = grpstats(temp,'region_lable');
                    summary.Properties.VariableNames{:,2} = 'voxel_counts';
                    
                    for k = 1:size(specfic_roi_label,1)
                        roi_label = specfic_roi_label(k,:);
                        all_vol_of_roi_k = size(find(atlas_625_mat == roi_label),1);
                        %check
                        isequal(all_vol_of_roi_k,size(find(left_ROI_voxel_MNIcorr_label.region_lable == roi_label),1))

                        summary.all_voxel_counts((summary.region_lable == roi_label),:) = all_vol_of_roi_k;
                        summary.perc((summary.region_lable == roi_label),:) = summary.voxel_counts(summary.region_lable == roi_label)./all_vol_of_roi_k;
                        summary = sortrows(summary,'perc','descend');
                    end
                    %pick the ROI label with the unqiue maximum proportion
                    max_perc_roi_list = summary.region_lable(summary.perc==max(summary.perc))
                    if size(max_perc_roi_list,1)~=1  %some samples not only have the same Euclidean distance with multiple ROIs, but also have the same proportion, that is, when the maximum proportional ROI is not unique
                        donori_file.matched_ROI_ID(j,:)= -1; %label these sample as -1, excluded them in following analysis
                        donori_file.clear_or_not(j,:) = 0;
                        donori_file.dist(j,:) = nearst_dist;
                        else
                        donori_file.matched_ROI_ID(j,:)= summary.region_lable(summary.perc==max(summary.perc));%pick the ROI label with the unqiue maximum proportion
                        donori_file.clear_or_not(j,:) = 0;
                        donori_file.dist(j,:) = nearst_dist;
                    end
                end
            end
        else%did not find the voxel with smallest distance under 2 mm theshold
            donori_file.matched_ROI_ID(j,:) = 0;%label as 0
            donori_file.clear_or_not(j,:) = 1;
            donori_file.dist(j,:) = nearst_dist;
            
        end
    end
    assign_sample_to_ROI{i,:} = donori_file;
end

save(fullfile(Step_2nd_Folder,'wd_data','assign_sample_to_ROI.mat'),'assign_sample_to_ROI')


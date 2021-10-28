function [MNI_coordinate_label,voxel_index_lable] = voxel_MNI(img_mat_of_atlas,zero_point,left_ROI_list_in_mask)
%img_mat_of_atlas: 3D matrix of atlas
%zero_point
%left_ROI_list_in_mask: ROI located in left hemisphere of AAL625 atlas

%define the ROI located in left hemisphere of AAL625 atlas
label_list = left_ROI_list_in_mask;

region_counts = size(label_list,1);
voxel_index_lable = [];
for i = 1:region_counts
        temp = [];
        x = [];
        y = [];
        z = [];
        if region_counts==1
                region_id = label_list
        else
        region_id = label_list(i,:)
        end
        ind = find(img_mat_of_atlas==region_id);
        [x,y,z] = ind2sub(size(img_mat_of_atlas),ind);
        lable = repmat(region_id,size(ind));
        temp = [x,y,z,lable];
        voxel_index_lable = [voxel_index_lable;temp];
end
MNI_coordinate_label = double(voxel_index_lable);
zero_MNI = repmat(zero_point,size(voxel_index_lable,1),1);
MNI_coordinate_label(:,1:3) = MNI_coordinate_label(:,1:3) - zero_MNI;

MNI_coordinate_label = array2table(MNI_coordinate_label,'Variablenames',{'mni_x' 'mni_y' 'mni_z' 'region_lable'});
voxel_index_lable = array2table(voxel_index_lable,'Variablenames',{'x' 'y' 'z' 'region_lable'});
end


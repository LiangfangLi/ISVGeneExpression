%% To do: average normalized gene expression profiles across 6 donors to obtain a group-level gene expression matrix.

clear

cd D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
DataFolder = [Step_2nd_Folder '\wd_data'];
addpath(genpath(FunctionFolder),DataFolder);

% record the ROI owned by each donor
load('assign_sample_to_ROI.mat')
for i = 1:size(assign_sample_to_ROI,1)
    sample2roi = assign_sample_to_ROI{i};
    roi_list_subi = unique(sample2roi.matched_ROI_ID(sample2roi.matched_ROI_ID > 0,:));
    
    dor_id = repmat(i,size(roi_list_subi));
    temp = array2table(cat(2,roi_list_subi,dor_id),'VariableNames',{'spec_roi_id','sub_id'});
    roi_list_of_each_donor{i} = temp;
end
roi_list_of_each_donor = roi_list_of_each_donor';
roi2sub_list = cat(1, roi_list_of_each_donor{:});
save(fullfile(Step_2nd_Folder,'wd_data','roi2sub_list.mat'),'roi2sub_list')

%% average donors with same ROI
clear,clc
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';

load('roi2sub_list.mat')
load('union_roi_list_in6donors.mat') %union roi list in 6 donors
load('tbl_normalized_each_gene_acorssROI.mat')

for j = 1:size(union_roi_list_in6donors,1)
    tbl_gene_corsp_same_roi = [];
    gene_corsp_same_roi = [];
    roi_j = union_roi_list_in6donors(j) %roi id
    sub_id_list = roi2sub_list.sub_id(roi2sub_list.spec_roi_id==roi_j) %find out which donors have roi_j
    
    for i = 1:size(sub_id_list,1)
        if size(sub_id_list,1) == 1
            single_sub_id = sub_id_list
        else
            single_sub_id = sub_id_list(i)
        end
        complte_gene_exp =  tbl_normalized_each_gene_acorssROI{single_sub_id};
        name = ['ROI_' sprintf('%03d',roi_j)];%variable names
        tbl_gene_corsp_same_roi{i} = complte_gene_exp(:,strcmp(complte_gene_exp.Properties.VariableNames,name)==1);%extract the column where roi_j is located
        gene_corsp_same_roi{i} = table2array(complte_gene_exp(:,strcmp(complte_gene_exp.Properties.VariableNames,name)==1));
    end
    combine_roi_j_across_donors = cell2mat(gene_corsp_same_roi);
    average_6donors_grouplevel_expression(:,j) = mean(combine_roi_j_across_donors,2);
end

save(fullfile(Step_2nd_Folder,'wd_data','average_6donors_grouplevel_expression.mat'),'average_6donors_grouplevel_expression')

%% add variable names
load('tbl_normalized_each_gene_acorssROI.mat')
gene_name = tbl_normalized_each_gene_acorssROI{1}.Allen_Gene_Symbol;

tbl_average_6donors_grouplevel_expression = [gene_name,array2table(average_6donors_grouplevel_expression)];
for j = 1: size(union_roi_list_in6donors,1)
    reg_label = union_roi_list_in6donors(j)
    tbl_average_6donors_grouplevel_expression.Properties.VariableNames{1} = ['Allen_Gene_Symbol'];
    tbl_average_6donors_grouplevel_expression.Properties.VariableNames{j+1} = ['ROI_' sprintf('%03d',reg_label)];
end
save(fullfile(Step_2nd_Folder,'wd_data','tbl_average_6donors_grouplevel_expression.mat'),'tbl_average_6donors_grouplevel_expression')

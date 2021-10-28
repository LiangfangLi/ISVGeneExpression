%% To do: within each donor, gene expressions were normalized to Z scores across all cortical regions per gene.
% 
clear

cd D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
DataFolder = [Step_2nd_Folder '\wd_data'];
addpath(genpath(FunctionFolder),DataFolder);
%% calculate z score
load('average_same_sample.mat') 
for i = 1:size(average_same_sample,1)
        single_donor_gene_sample = average_same_sample{i}; 
        temp = single_donor_gene_sample'; 
        normalized_each_gene_acorssROI{i,:} = zscore(temp)';%normalized to Z scores across all cortical regions per gene
end
save(fullfile(Step_2nd_Folder,'wd_data','normalized_each_gene_acorssROI.mat'),'normalized_each_gene_acorssROI')

%% add variable names
load('assign_sample_to_ROI.mat') 
load('tbl_average_same_sample.mat')
gene_name = tbl_average_same_sample{1}.Allen_Gene_Symbol;

for i = 1:size(tbl_average_same_sample,1)
        sample2roi = assign_sample_to_ROI{i};
        roi_list_subi = unique(sample2roi.matched_ROI_ID(sample2roi.matched_ROI_ID > 0,:));
        tbl_normalized_each_gene_acorssROI{i,:} = [gene_name,array2table(normalized_each_gene_acorssROI{i})];
        
        for j = 1: size(roi_list_subi,1)
                reg_label = roi_list_subi(j)
                tbl_normalized_each_gene_acorssROI{i,:}.Properties.VariableNames{1} = ['Allen_Gene_Symbol'];
                tbl_normalized_each_gene_acorssROI{i,:}.Properties.VariableNames{j+1} = ['ROI_' sprintf('%03d',reg_label)];
        end
end
save(fullfile(Step_2nd_Folder,'wd_data','tbl_normalized_each_gene_acorssROI.mat'),'tbl_normalized_each_gene_acorssROI')

%% To do: average the expression data of the samples mapped to the same particular ROI.
%
clear
% prep path 
cd D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
DataFolder = [Step_2nd_Folder '\wd_data'];
addpath(genpath(FunctionFolder),DataFolder);

% find the union ROI emerged in 6 donors' sample-to-ROI assignment file
load('assign_sample_to_ROI.mat') 
for i = 1:size(assign_sample_to_ROI,1)
        donori = assign_sample_to_ROI{i};
        matched_roi_list{i} = unique(donori.matched_ROI_ID(donori.matched_ROI_ID > 0,:)); %specific 的 ROI list 不代表可用的 sample 的数量
end
matched_roi_list = matched_roi_list';
union_roi_list_in6donors = unique(cat(1, matched_roi_list{:}));
size(union_roi_list_in6donors,1)
save(fullfile(DataFolder,'union_roi_list_in6donors.mat'),'union_roi_list_in6donors')

%% load gene expression file and average the expression data of the samples mapped to the same particular ROI
clear

load('normalized_symbol_by_sample.mat') %normalized by devided by mean gene expression of each sample
donor_counts = size(normalized_symbol_sample,1);
% load sample assignment file
load('assign_sample_to_ROI.mat') 

for i = 1:donor_counts
        gene2sample = normalized_symbol_sample{i}; %gene symbol*sample
        sample2roi = assign_sample_to_ROI{i}; %assign sample to particular ROI
        use_sample = sample2roi(sample2roi.matched_ROI_ID > 0,:); %keep the sample labeled bigger than 0
        roi_list_subi = unique(sample2roi.matched_ROI_ID(sample2roi.matched_ROI_ID > 0,:));%corresponding ROI ID
        for j = 1: size(roi_list_subi,1)
                reg_label = roi_list_subi(j)
                region_sample_id = use_sample.sample_id(use_sample.matched_ROI_ID==reg_label);%pick out the sample_id of the sample assigned to reg_label
                corspd_gene_tbl = [gene2sample(:,1),gene2sample(:,region_sample_id+1)];
                temp = mean(table2array(gene2sample(:,region_sample_id+1)),2);%average
                average_same_sample{i,:}(:,j) = temp;
        end
end

Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
save(fullfile(Step_2nd_Folder,'wd_data','average_same_sample.mat'),'average_same_sample')

%% add variable names
load('assign_sample_to_ROI.mat') 
for i = 1:donor_counts
        % sub1 = array2table(average_same_sample{i});
        sample2roi = assign_sample_to_ROI{i};
        tbl_average_same_sample{i,:} = [gene2sample.Allen_Gene_Symbol,array2table(average_same_sample{i})];
        roi_list_subi = unique(sample2roi.matched_ROI_ID(sample2roi.matched_ROI_ID > 0,:));
        
        for j = 1: size(roi_list_subi,1)
                reg_label = roi_list_subi(j)
                tbl_average_same_sample{i,:}.Properties.VariableNames{1} = ['Allen_Gene_Symbol'];
                tbl_average_same_sample{i,:}.Properties.VariableNames{j+1} = ['ROI_' sprintf('%03d',reg_label)];
        end
end
save(fullfile(Step_2nd_Folder,'wd_data','tbl_average_same_sample.mat'),'tbl_average_same_sample')

%% To do: extract gene expression matrix of HAR-BRAIN genes and BRAIN genes (these two gene lists were both obtained from Wei et al., 2019).

clear
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
DataFolder = [Step_2nd_Folder '\wd_data'];
addpath(genpath(FunctionFolder),DataFolder);

%% HAR-BRAIN gene
HAR_BRAIN = readtable('HAR_brain_update_20200208.csv','Encoding', 'UTF-8');
load('tbl_average_6donors_grouplevel_expression.mat')

for i = 1:size(HAR_BRAIN,1)
    HAR_BRAIN_expression(i,:) = tbl_average_6donors_grouplevel_expression(strcmp(tbl_average_6donors_grouplevel_expression.Allen_Gene_Symbol,HAR_BRAIN.finnal_used_symbol{i}),:);
end
save(fullfile(Step_2nd_Folder,'wd_data','HAR_BRAIN_expression.mat'),'HAR_BRAIN_expression')

%% BRAIN genes
BRAIN = readtable('BRAIN_update_20200208.csv','Encoding', 'UTF-8');
load('tbl_average_6donors_grouplevel_expression.mat')

for i = 1:size(BRAIN,1)
    BRAIN_gene_expression(i,:) = tbl_average_6donors_grouplevel_expression(strcmp(tbl_average_6donors_grouplevel_expression.Allen_Gene_Symbol,BRAIN.finnal_used_symbol{i}),:);
end
save(fullfile(Step_2nd_Folder,'wd_data','BRAIN_gene_expression.mat'),'BRAIN_gene_expression')

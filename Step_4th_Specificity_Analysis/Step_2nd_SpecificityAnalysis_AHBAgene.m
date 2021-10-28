%% To do: validate specificity of HAR-BRAIN genes based on ~20k AHBA genes.

clear
cd D:\wd\Replication_CodeShare\Step_4th_Specificity_Analysis
Step_4th_Folder = 'D:\wd\Replication_CodeShare\Step_4th_Specificity_Analysis';
FunctionFolder = [Step_4th_Folder '\functions'];
ReplicationFolder = 'D:\wd\Replication_CodeShare\Replicate';
addpath(FunctionFolder,ReplicationFolder);

% load complete AHBA gene expression matrix
load('tbl_average_6donors_grouplevel_expression.mat')
% 415 HAR-BRAIN gene symbol
load('HAR_BRAIN_symbol.mat')
% delte 415 HAR-BRAIN gene from ~20k AHBA gene
AHBA_dlt_HARBRAIN_gene_expression= tbl_average_6donors_grouplevel_expression(~ismember(tbl_average_6donors_grouplevel_expression.Allen_Gene_Symbol,HAR_BRAIN_symbol),:);
save(fullfile(ReplicationFolder,'AHBA_dlt_HARBRAIN_gene_expression.mat'),'AHBA_dlt_HARBRAIN_gene_expression')
size(AHBA_dlt_HARBRAIN_gene_expression)

%% random select 415 gene from AHBA gene(delete HAR-BRAIN) to repeate PLS regression
load('response_var_file.mat')
output_dir = fullfile(ReplicationFolder,'\Specificity\AHBA')
[permutate_r1_PLS1,permutate_r2_PLS2] = PLS_random_select_gene(response_var_file,AHBA_dlt_HARBRAIN_gene_expression,2,10000,output_dir);

% real r1
load('PLS1_score.mat')
load('PLS2_score.mat')
load('response_var_file.mat')
real_r1 = corr(PLS1_score,response_var_file,'type','Spearman')
real_r2 = corr(PLS2_score,response_var_file,'type','Spearman')
% p value for PLS1 and 2 in specificity analysis
pvalue_r1_perm=(length(find(permutate_r1_PLS1>=real_r1))+1)/(10000+1)
pvalue_r2_perm=(length(find(permutate_r2_PLS2>=real_r2))+1)/(10000+1)

%% plot histogram
close all
hist(permutate_r1_PLS1,60)
%hist(permutate_r2_PLS2,60)

hold on
line([real_r1 real_r1],[0 800],'LineStyle','--','Color','r')
%line([real_r2 real_r2],[0 800],'LineStyle','--','Color','r')

set(gca,'Fontsize',14)
xlabel('Correlation between ISV and PLS1(Spearman)','FontSize',14);
%xlabel('Correlation between ISV and PLS2(Spearman)','FontSize',14);
ylabel('Permuted runs','FontSize',14);

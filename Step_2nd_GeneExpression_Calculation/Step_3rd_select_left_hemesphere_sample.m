%% To do: select samples located in left hemisphere according to the sample annotation in SampleAnnot.csv.

clear

cd D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
addpath(genpath(FunctionFolder));

% load SampleAnnot file
dornor_list = kb_ls(fullfile(Step_2nd_Folder,'raw_gene','combined_data','H*'))
for i=1:size(dornor_list,1)
        % confirm with donor 6
        SampleAnnot = readtable(fullfile(dornor_list{i},'gene','SampleAnnot.csv'),'Encoding', 'UTF-8'); % 895 for donor_6
        SampleAnnot = SampleAnnot(:,[11,12,13,5,6]); % keep only MNI and annot name
        SampleAnnot.sample_id = [1:size(SampleAnnot,1)]';
        SampleAnnot_only_left{i} = SampleAnnot(find(contains(SampleAnnot{:,5},'left')==1),:); % 418 for donor_6
end
SampleAnnot_only_left = SampleAnnot_only_left';
save(fullfile(Step_2nd_Folder,'wd_data','SampleAnnot_only_left.mat'), 'SampleAnnot_only_left');

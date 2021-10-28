%% To do: normalize gene expression values of all genes on each sample by dividing the average gene expression value of the sample.

clear
% prepare path
cd D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
addpath(genpath(FunctionFolder));
%% load symbol * sample
load(fullfile(Step_2nd_Folder,'wd_data','symbol_by_sample.mat'),'-mat');

%% dived by mean gene expression of each sample
for i=1:size(symbol_by_sample,1)
    temp = symbol_by_sample{i};
    temp_mean = varfun(@mean,temp(:,3:end));%mean expression of each sample
    normalized_symbol_sample{i,:} = [temp.updated_symbol, array2table(table2array(temp(:,3:end)) ./ table2array(temp_mean))];
    normalized_symbol_sample{i,:}.Properties.VariableNames{1} = 'Allen_Gene_Symbol';
    for j=1:size(normalized_symbol_sample{i,:}.Properties.VariableNames(2:end),2)
            normalized_symbol_sample{i,:}.Properties.VariableNames{j+1} = ['Sample_' sprintf('%03d',j)];
    end
end

%% export
save(fullfile(Step_2nd_Folder,'wd_data','normalized_symbol_by_sample.mat'),'normalized_symbol_sample')

% check
temp_1 = normalized_symbol_sample{1};
temp_3 = normalized_symbol_sample{3};
isequal(temp_1.Allen_Gene_Symbol,temp_3.Allen_Gene_Symbol)

for i=1:size(normalized_symbol_sample,1)
    tbl = normalized_symbol_sample{i};
    check(i) = sum(mean(table2array(tbl(:,2:end)))-1);%expect 0
end
check


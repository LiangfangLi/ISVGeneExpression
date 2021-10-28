%% To do: average expression values of multiple probes corresponding to the same gene to generate gene expression levels for each sample.

clear,clc
%prepare path
cd D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation
Step_2nd_Folder = 'D:\wd\Replication_CodeShare\Step_2nd_GeneExpression_Calculation';
FunctionFolder = [Step_2nd_Folder '\functions'];
addpath(genpath(FunctionFolder));
%% import data from all six donor
data_dir_list = kb_ls(fullfile(Step_2nd_Folder,'raw_gene','combined_data','H0351.*','gene'));
% donor only left hemi = H0351.1*; donor  both hemi = H0351.2*
% all is same probe-gene symbol relationship
for donor_id=1:size(data_dir_list,1)
    Probes_gene_correspondence_name = fullfile(data_dir_list{donor_id},'Probes.csv');
    temp= rmmissing(readtable(Probes_gene_correspondence_name,'Encoding', 'UTF-8'),'DataVariables',{'entrez_id','gene_symbol'}); % 19171
    donor{donor_id}.Probes_gene_corrsponse = temp(~strcmp(temp.gene_symbol,'na'),:); % 48164
    size(donor{donor_id}.Probes_gene_corrsponse)
    clear temp
end
donor = donor' % trans it

% to see if the probe-gene symbol relationship of the six donors are the same
s1=table2struct(donor{1}.Probes_gene_corrsponse);
for i=1:size(donor,1)
    if isequal(table2struct(donor{donor_id}.Probes_gene_corrsponse),s1)
        disp([ 'donor #' num2str(i) ' and donor #1 are equal']);
    end
end
% if the answer is equal, use the same reference update list

%% import update reference
allen_updated = readtable(fullfile(Step_2nd_Folder,'wd_data','allen_gene_probe_list_update_20200208.csv'),'Encoding', 'UTF-8');
size(allen_updated,1)
isequal(table2struct(allen_updated(:,1:end-1)),s1)

for donor_id=1:size(donor,1)
    donor{donor_id}.Probes_gene_corrsponse = [donor{donor_id}.Probes_gene_corrsponse,allen_updated.gene_symbol_update];
    donor{donor_id}.Probes_gene_corrsponse.Properties.VariableNames{8} = 'updated_symbol';
end

%% get sample and expression data of each donor
for donor_id=1:size(data_dir_list,1)
    Probes_gene_correspondence_name = fullfile(data_dir_list{donor_id},'MicroarrayExpression.csv');
    temp= readtable(Probes_gene_correspondence_name,'Encoding', 'UTF-8'); % e.g. for donor 6, 58692 * 894 (probe*(sample+1))
    count_of_sample = size(temp,2)-1;
    matched_probe_id_symbol_list = donor{donor_id}.Probes_gene_corrsponse;
    temp.Properties.VariableNames{1} =  matched_probe_id_symbol_list.Properties.VariableNames{1};
    
    search_table = innerjoin(temp,matched_probe_id_symbol_list); % 48164*(1+sample+matched_probe_id_symbol_list size 2)
    
    % group probe by symbol name
    symbol_by_sample{donor_id}= grpstats(search_table,{'updated_symbol'},'mean', 'DataVars', search_table.Properties.VariableNames(2:count_of_sample+1));
    
    % done notice
    disp(['#' num2str(donor_id) ' done!']);
    clear temp
end
symbol_by_sample = symbol_by_sample';

save(fullfile(Step_2nd_Folder,'wd_data','symbol_by_sample.mat'),'symbol_by_sample');
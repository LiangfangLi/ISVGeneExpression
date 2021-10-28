function isv_parameters_Network = adjust_fc_matrix(input_isv_parameters_Network)
isv_parameters_Network = input_isv_parameters_Network;
[path,~,~]=fileparts(input_isv_parameters_Network.output_path);
%% check input matrix size, modify it if needed
tmp_path = fullfile(path,'tmp');
if ~exist(tmp_path)
    mkdir(tmp_path);
end
for i=1:numel(input_isv_parameters_Network.data_sess_01)
    trim_this_s1 = importdata(input_isv_parameters_Network.data_sess_01{i});
    trim_this_s2 = importdata(input_isv_parameters_Network.data_sess_02{i});
    keep_these_nodes = input_isv_parameters_Network.opt.group(:,1);
    new_matrix_1= trim_this_s1(keep_these_nodes',keep_these_nodes');
    new_matrix_2= trim_this_s2(keep_these_nodes',keep_these_nodes');
    
    save(fullfile(tmp_path,['sess_1_' sprintf('%05d',i) '_new_matrix']),'new_matrix_1');
    save(fullfile(tmp_path,['sess_2_' sprintf('%05d',i) '_new_matrix']),'new_matrix_2');
    
    disp(['Reorganize the matrix...# ' sprintf('%05d',i)]);
end
isv_parameters_Network.data_sess_01 = f_ls(fullfile(tmp_path,['sess_1_*_new_matrix.mat']));
isv_parameters_Network.data_sess_02 = f_ls(fullfile(tmp_path,['sess_2_*_new_matrix.mat']));
isv_parameters_Network.opt.group(:,1) = [1:606]';


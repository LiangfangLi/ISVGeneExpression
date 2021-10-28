function temp_data_updated = calc_isv_intra(temp_data, opt, job_descript)
%% intra
%% network of each roi
grouping_rule = opt.group;
network_detected = unique(grouping_rule(:,2));
disp(['Detected ' num2str(length(network_detected)) ' network']);
roi_id = grouping_rule(:,1:2);
for i=1:length(network_detected)
    extract_this = network_detected(i);
    temp_data.network_roi_list{i} = roi_id(find(roi_id(:,2)==extract_this),1)';
end
%% split raw matrix to intra network and get intra network fc pattern (uptriangle vector)
disp('extracting intra network FC...(session 01)')
for i=1:length(network_detected)
    for j=1:size(temp_data.data_sess_01,1)
        subj_j_raw_data = cell2mat(temp_data.data_sess_01(j));
        temp_data.network_intra_s1{i,j} = subj_j_raw_data(temp_data.network_roi_list{i},temp_data.network_roi_list{i});
        A = triu(temp_data.network_intra_s1{i,j},1) ;
        %At = A.';
        m  = (1:size(A,1)).' < (1:size(A,2));
        v  = A(m);
        temp_data.network_intra_fc_s1{i,j} = v;
        clear v
    end
end
disp('Done!')
%
disp('extracting intra network FC...(session 02)')
for i=1:length(network_detected)
    for j=1:size(temp_data.data_sess_02,1)
        subj_j_raw_data = cell2mat(temp_data.data_sess_02(j));
        temp_data.network_intra_s2{i,j} = subj_j_raw_data(temp_data.network_roi_list{i},temp_data.network_roi_list{i});
        A = triu(temp_data.network_intra_s2{i,j},1) ;
        %At = A.';
        m  = (1:size(A,1)).' < (1:size(A,2));
        v  = A(m);
        temp_data.network_intra_fc_s2{i,j} = v;
        clear v
    end
end
disp('Done!')
%% between sess similarity
disp('calc bebetween sess similarity...')
% prep data access
input_1 = temp_data.network_intra_fc_s1;
input_2 = temp_data.network_intra_fc_s2;
%% calc corr
for i=1:length(network_detected)
    temp_1 = cell2mat(input_1(i,:));
    temp_2 = cell2mat(input_2(i,:));
    temp_data.network_intra_corr_s12{i,:} = diag(corr(temp_1,temp_2));
end
disp('Done!')
%% with other subjects similarity
disp('calc between subject similarity...(sess_01)')
% s1
%% calc corr
for i=1:length(network_detected)
    %extract_this = network_detected(i);
    temp_1 = cell2mat(input_1(i,:));
    subj_by_subj = corr(temp_1,temp_1);
    m  = (1:size(subj_by_subj,1)).' ~= (1:size(subj_by_subj,2));
    subj_by_others = reshape(subj_by_subj(m),size(subj_by_subj,1)-1,size(subj_by_subj,1))';
    temp_data.network_between_subj_corr_s1{i,:} = subj_by_others;
end
% s2
disp('calc between subject similarity...(sess_02)')
for i=1:length(network_detected)
    %extract_this = network_detected(i);
    temp_2 = cell2mat(input_2(i,:));
    subj_by_subj = corr(temp_2,temp_2);
    m  = (1:size(subj_by_subj,1)).' ~= (1:size(subj_by_subj,2));
    subj_by_others = reshape(subj_by_subj(m),size(subj_by_subj,1)-1,size(subj_by_subj,1))';
    temp_data.network_between_subj_corr_s2{i,:} = subj_by_others;
end
disp('Done!')
%% calc intra network isv
% mean between subject
disp('calc mean cross subject varitiy...')
s1 = temp_data.network_between_subj_corr_s1;
s2 = temp_data.network_between_subj_corr_s2;
for i=1:length(network_detected)
    %extract_this = network_detected(i);
    temp_1 = cell2mat(s1(i,:));
    temp_2 = cell2mat(s2(i,:));
    temp_avg = 1-(temp_1+temp_2)/2;
    temp_data.network_between_subject_mean_varity_s12{i,:} = temp_avg;
end
disp('Done!')

% calc isv
disp('calc intra network isv...')
between_subject = temp_data.network_between_subject_mean_varity_s12;
between_sess = temp_data.network_intra_corr_s12;
for i=1:length(network_detected)
    %extract_this = network_detected(i);
    between_sess_specific = cell2mat(between_sess(i,:));
    for j=1:size(between_sess_specific,1)
        between_sess_specific_rm_same_person(:,j) = 1-between_sess_specific([1:j-1,j+1:end]);
    end
    temp_data.network_between_sess_mean_varity_s12{i,:} = (((1-between_sess_specific')+between_sess_specific_rm_same_person)/2)';
    temp_data.network_intra_isv{:,i} = mean((between_subject{i,:} - temp_data.network_between_sess_mean_varity_s12{i,:})')';
end
temp_data.network_intra_isv = cell2mat(temp_data.network_intra_isv);
disp('Done!')

%% return results
temp_data_updated = temp_data;
end

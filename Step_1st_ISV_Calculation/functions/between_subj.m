function data_sess_r_s_inter = between_subj(sess_data, job_descript)
[subj_num roi_counter] = size(sess_data);
textprogressbar([job_descript, ' = inter subject corr   ']);
% disp('compute in parallel');
for i=1:subj_num
    textprogressbar(round(i/subj_num*100));
    %pause(0.001);
    %% fc map for specific subject with others
    %matrix_subj_i = repmat(sess_data(i,:),subj_num-1,1)
    for j=1:roi_counter
        matrix_subj_i = sess_data{i,j};
        other_subj_id = [1:i-1,i+1:subj_num];
        others_subj_fc = sess_data(other_subj_id,j);
        others_subj_fc_mat = cell2mat(others_subj_fc');
        data_sess_r_s_inter_temp{i, j} = corr(matrix_subj_i,others_subj_fc_mat)';
        %temp = cellfun(@(x,y) corr(x,y), matrix_subj_i, others_subj_fc, 'UniformOutput', false);
        %data_sess_r_s_inter_temp{i} = temp;
    end
end
data_sess_r_s_inter = data_sess_r_s_inter_temp;
textprogressbar(' done');
% disp('done')
end


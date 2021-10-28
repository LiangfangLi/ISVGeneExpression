function data_sess_0102_r_s_intra_inter_isv = calc_isv(data_package, job_descript)
%% mean intra
intra_isc = data_package.data_sess_0102_r_s_intra;
%% mean inter
inter_isc_s1 = data_package.data_sess_01_r_s_inter;
inter_isc_s2 = data_package.data_sess_02_r_s_inter;
%% isv
[subj_num, ~] = size(intra_isc);
textprogressbar([job_descript, ' = calc isv             ']);
for i=1:subj_num
    textprogressbar(round(i/subj_num*100));
    %pause(0.01);
    %% intra of subj_i
    intra_isc_subj_i = intra_isc(i,:);
    %% intra of subj_others
    intra_isc_subj_others = intra_isc([1:i-1, i+1:subj_num], :);
    %% mean intra
    mean_intra_isv = 1-(intra_isc_subj_i+intra_isc_subj_others)/2;
    %% mean inter
    inter_isc_s1_i = cell2mat(inter_isc_s1(i,:));
    inter_isc_s2_i = cell2mat(inter_isc_s2(i,:));
    mean_inter_isv = 1-(inter_isc_s1_i+inter_isc_s2_i)/2;
    %% isv
    data_sess_0102_r_s_intra_inter_isv(i,:) = mean(mean_inter_isv - mean_intra_isv);
end
textprogressbar(' done');
end


function data_sess_r_s = corr_sess(sess_01, sess_02, job_descript)
[subj_num roi_counter] = size(sess_01);
textprogressbar([job_descript, ' = intra subject corr   ']);
for i=1:subj_num
    textprogressbar(round(i/subj_num*100));
    %pause(0.01);
    for j=1:roi_counter
        %% fc map for specific subject
        matrix_s1 = sess_01{i,j};
        matrix_s2 = sess_02{i,j};
        data_sess_r_s(i,j) = corr(matrix_s1,matrix_s2);
    end
end
textprogressbar(' done');
end


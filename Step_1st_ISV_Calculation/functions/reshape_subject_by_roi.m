function data_sess_r_s = reshape_subject_by_roi(data_sess_r, job_descript )
%% extract specific roi for all subjects and combined it
roi_count = size(data_sess_r{1,:},1);
textprogressbar([job_descript, ' = reshape to subj*roi  ']);
for i=1:numel(data_sess_r)
    textprogressbar(round(i/numel(data_sess_r)*100));
    %pause(0.01);
    current_subject_data = data_sess_r{i,:};
    for j=1:roi_count
        data_sess_r_s{i,j} = current_subject_data(j,:)';
    end
end
textprogressbar(' done');
end


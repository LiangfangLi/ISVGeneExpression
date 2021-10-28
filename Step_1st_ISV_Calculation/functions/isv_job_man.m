function temp_data = isv_job_man(job_list, data_sess_01, data_sess_02, opt)
clc
tStart = tic;
for i=1:numel(job_list)
    switch job_list{i}
        case {'Loading raw data'}
            [temp_data.data_sess_01] = load_raw_data(data_sess_01, 'session 01');
            [temp_data.data_sess_02] = load_raw_data(data_sess_02, 'session 02');
        case {'Remove the diagonal line'}
            disp(' ');
            disp(['Step # ' sprintf('%02d',i) ' start!']);
            temp_data.data_sess_01_r = delete_diag(temp_data.data_sess_01, 'session 01');
            temp_data.data_sess_02_r = delete_diag(temp_data.data_sess_02, 'session 02');
            disp(['Step # ' sprintf('%02d',i) ' done!']);
        case {'Reshape to Subj x ROIs'}
            disp(' ');
            disp(['Step # ' sprintf('%02d',i) ' start!']);
            temp_data.data_sess_01_r_s = reshape_subject_by_roi(temp_data.data_sess_01_r, 'session 01');
            temp_data.data_sess_02_r_s = reshape_subject_by_roi(temp_data.data_sess_02_r, 'session 02');
            disp(['Step # ' sprintf('%02d',i) ' done!']);
        case {'Corr within subject'}
            disp(' ');
            disp(['Step # ' sprintf('%02d',i) ' start!']);
            temp_data.data_sess_0102_r_s_intra = corr_sess(temp_data.data_sess_01_r_s, temp_data.data_sess_02_r_s, 'session 12');
            disp(['Step # ' sprintf('%02d',i) ' done!']);
        case {'Corr between subject'}
            disp(' ');
            disp(['Step # ' sprintf('%02d',i) ' start!']);
            temp_data.data_sess_01_r_s_inter = between_subj(temp_data.data_sess_01_r_s, 'session 01');
            temp_data.data_sess_02_r_s_inter = between_subj(temp_data.data_sess_02_r_s, 'session 02');
            disp(['Step # ' sprintf('%02d',i) ' done!']);
        case {'Calc ISV'}
            disp(' ');
            disp(['Step # ' sprintf('%02d',i) ' start!']);
            temp_data.data_sess_0102_r_s_intra_inter_isv = calc_isv(temp_data, 'session 12');
            disp(['Step # ' sprintf('%02d',i) ' done!']);
        case {'Calc intra-network ISV'}
            if isfield(opt,'group')
                disp(' ');
                disp(['Step # ' sprintf('%02d',i) ' start!']);
                temp_data = calc_isv_intra(temp_data, opt, 'session 12');
                disp(['Step # ' sprintf('%02d',i) ' done!']);
            else
                disp('******');
                disp(['Step # ' sprintf('%02d',i) ' skiped! No group file!']);
            end
        otherwise
            disp(' ')
            disp('Error: did not identify the job!')
            return;
    end
end

tEnd = toc(tStart);
disp(' ');
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));
end
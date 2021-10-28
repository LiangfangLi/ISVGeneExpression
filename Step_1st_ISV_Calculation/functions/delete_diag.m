%%   delete diag
function [subject_data_rm_diag] = delete_diag(subject_data, job_descript)
%% clear the diag
textprogressbar([job_descript, ' = removing diag        ']);
for i=1:numel(subject_data)
    textprogressbar(round(i/numel(subject_data)*100));
    %pause(0.01);
    current_subject_data = subject_data{i,:};
    FC_Ndiag = zeros(length(current_subject_data)-1,length(current_subject_data));
    [m,n] = size(current_subject_data);
    for l = 1:n
        FC_Ndiag(:,l)=[current_subject_data([1:l-1 l+1:m],l)];
    end
    subject_data_rm_diag{i,:} = FC_Ndiag';
end
textprogressbar(' done');
end


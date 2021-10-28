function [subject_data] = load_raw_data(subject_filelst,job_descript)
%% search for all need mat file and load it
textprogressbar([job_descript, ' = loading matrix data  ']);
for i=1:numel(subject_filelst)
    textprogressbar(round(i/numel(subject_filelst)*100));
    %pause(0.01);
    subject_data{i,:} = importdata(subject_filelst{i});
end
textprogressbar(' done');
end


%% To do: generate input files for using BRAINSMASH.

clear
cd 'D:\wd\ISVGeneExpression\Step_8th_generate_SurrogateMap'
Step_8th_Folder = 'D:\wd\ISVGeneExpression\Step_8th_generate_SurrogateMap';
ReplicationFolder = 'D:\wd\Replication_CodeShare\Replicate';
addpath(ReplicationFolder);

%% generate input files for BRAINSMASH to generate surrogate ISV map
load('response_var_file.mat')
save('brain_map.txt','response_var_file','-ascii')%isv brain map, input to BRAINSMASH
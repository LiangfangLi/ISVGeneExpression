function [permutate_r1_PLS1,permutate_r2_PLS2] = PLS_random_select_gene(response_var_file,expression_matrix_delete_HARBRAIN,num_comp,perm_times,output_dir)

MRIdata=response_var_file;
%generate  predictor variables
%random pick 415 genes from BRAIN gene expression or AHBA gene expression matrix (both delete 415 HAR-BRAIN genes)
for i = 1:perm_times
    temp_geneid = randperm(size(expression_matrix_delete_HARBRAIN,1),415)';%randomly pick
    size(unique(temp_geneid),1)%415
    predictor_var_file = table2array(expression_matrix_delete_HARBRAIN(temp_geneid,2:end))';%first column is geneSymbol
    GENEdata=predictor_var_file;
    
    %% conduct PLS regression (dim=2)
    Y=zscore(MRIdata);
    dim= num_comp;
    [XL,YL,XS,YS,BETA,PCTVAR,MSE,stats]=plsregress(GENEdata,Y,dim);
        
    %% calculate correlations of PLS components with MRI variables
    [R1_with_pls1,~]=corr(XS(:,1),MRIdata,'type','Spearman');
    [R2_with_pls2,~]=corr(XS(:,2),MRIdata,'type','Spearman');
    
    permutate_r1_PLS1(i,:) = R1_with_pls1;
    permutate_r2_PLS2(i,:) = R2_with_pls2;

end
%print out results
csvwrite(fullfile(output_dir,'permutate_Spearman_r1_PLS1.csv'),permutate_r1_PLS1);
csvwrite(fullfile(output_dir,'permutate_Spearman_r2_PLS2.csv'),permutate_r2_PLS2);

end

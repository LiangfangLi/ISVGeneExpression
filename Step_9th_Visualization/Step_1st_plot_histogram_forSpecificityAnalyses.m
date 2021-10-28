%% To do: plot histogram for the specificity analysis based on BRAIN genes.

%% plot histogram
close all
%hist(permutate_r1_PLS1,60)
hist(permutate_r2_PLS2,60)

hold on
%line([real_r1 real_r1],[0 800],'LineStyle','--','Color','r')
line([real_r2 real_r2],[0 800],'LineStyle','--','Color','r')

set(gca,'Fontsize',14)
%xlabel('Correlation between ISV and PLS1(Spearman)','FontSize',14);
xlabel('Correlation between ISV and PLS2(Spearman)','FontSize',14);
ylabel('Permuted runs','FontSize',14);

%% plot histogram for the specificity analysis based on AHBA genes.
close all
hist(permutate_r1_PLS1,60)
%hist(permutate_r2_PLS2,60)

hold on
line([real_r1 real_r1],[0 800],'LineStyle','--','Color','r')
%line([real_r2 real_r2],[0 800],'LineStyle','--','Color','r')

set(gca,'Fontsize',14)
xlabel('Correlation between ISV and PLS1(Spearman)','FontSize',14);
%xlabel('Correlation between ISV and PLS2(Spearman)','FontSize',14);
ylabel('Permuted runs','FontSize',14);

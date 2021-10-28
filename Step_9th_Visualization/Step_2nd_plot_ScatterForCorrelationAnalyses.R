
# To do: figure 4bof correlation between ISV with CBF
setwd('D:/wd/Replication_CodeShare/Replicate/CBF')
data = read.csv('available_roi_cbf_isv.csv',header = TRUE,sep = ",")
library(ggpubr)
library(ggplot2)
library(patchwork)

summary(data$only_postive_voxel_meancbf)
cor(data$only_postive_voxel_meancbf,data$ISV,method = "spearman")

pic<-ggplot(data, aes(x=only_postive_voxel_meancbf, y=ISV)) + 
  scale_x_continuous(breaks=c(seq(20,90,20)), limits = c(20, 90))+
  geom_point( color = "black",size = 0.5)+
  geom_smooth(method=lm, color="firebrick",fill = "red",size=1)+             
  theme_classic() +
  theme(legend.position = "none",plot.background = element_rect(fill = "white"), panel.background = element_rect(fill = "white"),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.title.x = element_text(size=13,family="Arial"),#face="bold",
        axis.title.y = element_text(size=13,family="Arial")) +
  labs(x = "CBF", y = "ISV")+
  stat_cor(method = "spearman",cor.coef.name = 'rho',
           p.accuracy = 0.001, r.accuracy = 0.001,
           label.x = 22,label.y = 0.47, label.sep = "\n",label.x.npc = "left")  
pic

ggsave("D:/wd/Replication_CodeShare/Step_9th_Visualization/figure4b.png", pic, device = "png", dpi = 600, 
       width=4, height=3, unit="in")
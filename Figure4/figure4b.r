library(vegan)
data1 = read.table("./SGB_SGB.profile",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T,row.names = 1)

mapping = read.table("./mapping_file.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T)
mapping = mapping[mapping$type1!="control",]
#mapping = mapping[mapping$type2=="XZ",]
#mapping = mapping[mapping$type1=="A",]
mapping = mapping[mapping$type2=="XZ",]
#BGI = data1[,grep("1111",colnames(data1))]
#BGI = BGI[,1:88]
#data1 = data1[,mapping[,1]]
#data1 = cbind(data1,BGI)
#BGI_mapping = data.frame(sample = colnames(BGI),type1 = "A",type2 = "SZ",individual = 1:ncol(BGI))
#mapping = rbind(BGI_mapping,mapping)
mapping = mapping[mapping$type2!="SH",]

data1 = data1[,mapping[,1]]
a = adonis(t(data1)~mapping$type1,permutations = 999)
a$aov.tab
library(vegan)
library(ape)
library(ggplot2)
library(RColorBrewer)
data1_dict = vegdist(t(data1))
data1_dict = as.data.frame(as.matrix(data1_dict))
data1_dist = data1_dict[mapping[,1],mapping[,1]]

#for(i in 1:nrow(data1_dist)){
#  for(j in i:nrow(data1_dist)){
#    data1_dist[i,j] = 0
#  }
#}
#library(reshape2)
#data1_dist = melt(as.matrix(data1_dist))
#data1_dist = data1_dist[data1_dist[,3]!=0,]
#row.names(mapping) = mapping[,1]
#data1_dist$type1 = mapping[data1_dist$Var1,3]
#data1_dist$type2= mapping[data1_dist$Var2,3]
#data1_dist$type = "Inter"
#data1_dist$type[data1_dist$type1=="SZ"&data1_dist$type2=="SZ"] = "SZ"
#data1_dist$type[data1_dist$type1=="XZ"&data1_dist$type2=="XZ"] = "XZ"
#library(ggplot2)
#ggplot(data1_dist,aes(x = type,y = value))+geom_boxplot()
#wilcox.test(data1_dist$value[data1_dist$type=="XZ"],
#            data1_dist$value[data1_dist$type=="Inter"])
#data1_dict = sqrt(data1_dict)
PCOA = pcoa(data1_dist,correction = "none",rn = NULL)
result = PCOA$values[,"Relative_eig"]
pro1 = as.numeric(sprintf("%.3f",result[1]))*100
pro2 = as.numeric(sprintf("%.3f",result[2]))*100
x = PCOA$vectors
sample_names = row.names(x)
pc = as.data.frame(PCOA$vectors)
pc$names =sample_names
legend_title = ""
group = mapping
pc$group = group[,2]
pc$group2 = group[,2]
xlab = paste("PCOA(",pro1,"%",")",sep = "")
ylab = paste("PCOA(",pro2,"%",")",sep = "")
color = brewer.pal(8,"Set2")
ggplot(pc,aes(Axis.1,Axis.2))+
  geom_point(size = 3,aes(color=group2))+
  stat_ellipse(aes(x=pc[,1],y = pc[,2],fill=group2),size = 1,geom = "polygon",level = 0.8,alpha = 0.3)+
  labs(x=xlab,y = ylab,title = "PCOA",color = legend_title,shape = legend_title)+
  geom_hline(yintercept = 0,linetype = 5,color = "grey")+
  geom_vline(xintercept = 0,linetype = 5,color = "grey")+
  theme_bw()
#write.table(data1,"XZ_SZ.profile",sep = "\t",quote = F)
#write.table(mapping,"XZ_SZ_mapping",sep = "\t",quote = F)

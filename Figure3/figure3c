data1 = read.table("./XZ_SZ.profile",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T,row.names = 1)

mapping = read.table("./XZ_SZ_mapping",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T)
#mapping = mapping[mapping$type1!="control",]
##mapping = mapping[mapping$type1=="A",]
#mapping = mapping[mapping$type2!= "SH",]

SGB_ann = read.table("gtdbtk_ann.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T,row.names = 1)
SGB_ann = SGB_ann[row.names(data1),]
data1$ann = SGB_ann$classification
data1$ann = gsub(";c__.*","",data1$ann)
data1$ann = gsub("_A","",data1$ann)
data1$ann = gsub("_C","",data1$ann)
data1$ann = gsub("_B","",data1$ann)
data1 = aggregate(.~ann,data1,sum)
row.names(data1) = data1[,1]
data1 = data1[,-1]
filter_data = read.csv("phylum_diff_new.txt",sep="\t",header=T,check.names = F,
                       stringsAsFactors = F)
filter_data = filter_data[filter_data$q_XZ_VS_SZ<0.05,]
data1 = data1[filter_data[,1],]
data1 = data1[,mapping[,1]]
data1 = data.frame(t(data1),check.names = F,stringsAsFactors = F)
data1$type = mapping$type2
library(reshape2)
data2 = melt(data1)
library(ggplot2)
#colnames(data2)[1] = "type"
data2 = data2[data2$variable!="NA.1",]
data2 = data2[data2$variable!="NA",]
data2 = data2[data2$variable!="d_acteria;p_quificota",]
ggplot(data2,aes(x = variable,y = value,fill = type))+geom_boxplot()+
  scale_y_log10()+theme_classic()

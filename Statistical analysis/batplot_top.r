data1 = read.table("./SGB_SGB.profile",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T,row.names = 1)
data1 = sweep(data1, 2, apply(data1,2,sum), "/")
SGB_ann = read.table("gtdbtk_ann.txt",sep ="\t",check.names = F,stringsAsFactors = F,
                     header = T)
row.names(SGB_ann) = SGB_ann[,1]
SGB_ann = SGB_ann[row.names(data1),]
data1$ann = SGB_ann$classification

data1$ann = gsub(";c__.*","",data1$ann)
data1$ann = gsub("_A","",data1$ann)
data1$ann = gsub("_C","",data1$ann)
data1 = aggregate(.~ann,data1,sum)

row.names(data1) = data1[,1]
data1 = data1[,-1]
#row.names(data1) = gsub("_*.","",row.names(data1))
mapping = read.table("./mapping_file.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T)
mapping = mapping[mapping$type2=="XZ",]
mapping = mapping[mapping$type1!="control",]
name = data.frame(table(mapping$individual))
name  = name[name$Freq==4,]
mapping = mapping[mapping$individual%in%name[,1],]
mapping = mapping[order(mapping$individual),]
data1 = data1[,mapping[,1]]

data1_ann = SGB_ann$classification
data1 = data1[order(apply(data1, 1, sum),decreasing = T),]

data1 = data1[1:10,]
row.names(mapping) = mapping[,1]
data1 = rbind(data1,other = 1-apply(data1, 2, sum))
data1 = data1[,order(as.double(data1[1,]),decreasing = T)]
row.names(mapping) = mapping[,1]
mapping = mapping[colnames(data1),]
#name = as.character(mapping$individual)
part_a = data1[,mapping$sample[mapping$type1=="A"]]
part_a = part_a[,order(as.double(part_a[1,]),decreasing = T)]
part_a_num = mapping[colnames(part_a),]
library(reshape2)
library(ggplot2)
library(RColorBrewer)
#colnames(data1) = 1:ncol(data1)
data2 = melt(t(data1))
data2$type1 = mapping[as.character(data2[,1]),2]
data2$type2 = mapping[as.character(data2[,1]),4]
#data2$Var2 = factor(data2$Var2,levels = rev(row.names(data1)))
#ggplot(data2,aes(Var1, value,fill = Var2))+geom_area()+
#  scale_fill_manual(values = brewer.pal(11,"Set3"))

data2$type2 = as.character(data2$type2)
data2$type2 = factor(data2$type2,levels = part_a_num$individual)
ggplot(data2) +geom_col(
  aes(type2, value,fill = Var2),
  position = position_stack(reverse = TRUE),
  color = NA,
  width = 1
) +scale_fill_manual(values = brewer.pal(11,"Set3"))+theme_classic()+
  facet_grid(. ~ type1)
  

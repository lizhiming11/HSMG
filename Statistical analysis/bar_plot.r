data1 = read.table("./XZ_SZ.profile",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T,row.names = 1)
data1 = sweep(data1, 2, apply(data1,2,sum), "/")
#BGI = data1[,grep("1111",colnames(data1))]
SGB_ann = read.table("gtdbtk_ann.txt",sep ="\t",check.names = F,stringsAsFactors = F,
                     header = T)
row.names(SGB_ann) = SGB_ann[,1]
SGB_ann = SGB_ann[row.names(data1),]
data1$ann = SGB_ann$classification

data1$ann = gsub(";c__.*","",data1$ann)
#data1$ann = gsub("_A","",data1$ann)
#data1$ann = gsub("_C","",data1$ann)
data1 = aggregate(.~ann,data1,sum)
row.names(data1) = data1[,1]
data1 = data1[,-1]
mapping = read.table("./XZ_SZ_mapping",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T)

data1 = data1[order(apply(data1, 1, sum),decreasing = T),]
data1 = data1[1:20,]
data1 = rbind(data1,other = 1-apply(data1, 2, sum))
data1 = data.frame(t(data1),check.names = F,stringsAsFactors = F)
mapping$type1 = paste(mapping$type2,mapping$type1,sep = "_")
data1$type = mapping$type1
data1 = aggregate(.~type,data1,mean)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
data1 = melt(data1)
ggplot(data1) +geom_col(
  aes(type, value,fill = variable),
  position = position_stack(reverse = TRUE),
  color = NA,
  width = 1
) +scale_fill_manual(values =   colorRampPalette(brewer.pal(12,"Set3"))(21),
                     breaks = unique(data1$variable))+theme_classic()

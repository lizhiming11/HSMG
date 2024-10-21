data1 = read.csv("tree_ann.txt",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T)
name = unique(data1$classification)
data2 = matrix(rep(0,length(name)*3),ncol = 3)
colnames(data2) = c("name","isolated","unisolated")
data2[,1] = name
for(i in 1:length(name)){
  a = data1[data1$classification==name[i],]
  data2[i,2] = sum(a$ncbi_genome_category!="unclassified")
  data2[i,3] = sum(a$ncbi_genome_category=="unclassified")
}

library(reshape2)
row.names(data2) = name
data2 = data.frame(data2,check.names = F,stringsAsFactors = F)
data2$sum = as.double(data2[,2])+as.double(data2[,3])
data2 = data2[order(data2$sum,decreasing = T),]
name = data2[,1]
data2 = data2[,-4]
data2 = data2[,-1]
data2 = melt(as.matrix(data2))
data2 = data.frame(data2,check.names = F,stringsAsFactors = F)
data2$value = as.double(as.character(data2$value))
data2$Var1 = factor(data2$Var1,levels = rev(name))
library(ggplot2)
ggplot(data = data2, mapping = aes(x = Var1, y = value, fill = Var2)) + 
  geom_bar(stat = 'identity')+ coord_flip()+theme_classic()

Classified = data1[data1$fastani_reference!="N/A",]
unclassified = data1[data1$fastani_reference=="N/A",]

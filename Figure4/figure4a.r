library(vegan)


data1 = read.table("./SGB_SGB.profile",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T,row.names = 1)
mapping = read.table("./mapping_file.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T)
mapping = mapping[mapping$type1!="control",]
mapping = mapping[mapping$type2=="XZ",]
#mapping = mapping[mapping$type1=="A",]
#BGI = data1[,grep("1111",colnames(data1))]
data1 = data1[,mapping[,1]]
#data1 = cbind(data1,BGI)
#BGI_mapping = data.frame(sample = colnames(BGI),type1 = "A",type2 = "SZ",individual = 1:ncol(BGI))
#mapping = rbind(BGI_mapping,mapping)
#data1 = data1[,mapping[,1]]
library(vegan)

library(vegan)
data2 = data.frame(shannon = diversity(t(data1),index = "shannon"),type1 = mapping$type1,
                   type2 = mapping$type1)
library(ggplot2)
ggplot(data2,aes(x  = type1,y = shannon))+geom_boxplot()+theme_classic()



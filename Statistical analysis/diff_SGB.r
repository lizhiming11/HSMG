data1 = read.table("./SGB_SGB.profile",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T,row.names = 1)
#data1 = sweep(data1, 2, apply(data1,2,sum), "/")
SGB_ann = read.table("gtdbtk_ann.txt",sep ="\t",check.names = F,stringsAsFactors = F,
                     header = T)
row.names(SGB_ann) = SGB_ann[,1]
SGB_ann = SGB_ann[row.names(data1),]
data1$ann = SGB_ann$classification

data1$ann = gsub(";g__.*","",data1$ann)
#data1 = aggregate(.~ann,data1,sum)
#row.names(data1) = data1[,1]
#data1 = data1[,-1]
mapping = read.table("./mapping_file.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T)
mapping = mapping[mapping$type1!="control",]
mapping = mapping[mapping$type2=="XZ",]
mapping = mapping[mapping$individual%in%intersect(intersect(mapping[mapping$type1=="A",4],mapping[mapping$type1=="B",4]),
                                                  intersect(mapping[mapping$type1=="C",4],mapping[mapping$type1=="D",4])),]
mapping = mapping[order(mapping$individual),]
data1 = data1[,mapping[,1]]
data2 = matrix(rep(0,nrow(data1)*12),ncol = 12)
colnames(data2) = c("name","A_mean","B_mean","C_mean","D_mean","A_B.p","A_C.p",
                    "A_D.p","B_C.p","B_D.p","C_D.p","P.value")
data2[,1] = row.names(data1)
for(i in 1:nrow(data2)){
  a = as.double(data1[i,])
  data2[i,2] = mean(a[mapping$type1=="A"])
  data2[i,3] = mean(a[mapping$type1=="B"])
  data2[i,4] = mean(a[mapping$type1=="C"])
  data2[i,5] = mean(a[mapping$type1=="D"])
  data2[i,6] = wilcox.test(a[mapping$type1=="A"],a[mapping$type1=="B"],paired = T)$p.value
  data2[i,7] = wilcox.test(a[mapping$type1=="A"],a[mapping$type1=="C"],paired = T)$p.value
  data2[i,8] = wilcox.test(a[mapping$type1=="A"],a[mapping$type1=="D"],paired = T)$p.value
  data2[i,9] = wilcox.test(a[mapping$type1=="B"],a[mapping$type1=="C"],paired = T)$p.value
  data2[i,10] = wilcox.test(a[mapping$type1=="B"],a[mapping$type1=="D"],paired = T)$p.value
  data2[i,11] = wilcox.test(a[mapping$type1=="C"],a[mapping$type1=="D"],paired = T)$p.value
  data2[i,12] = kruskal.test(a~mapping$type1)$p.value
}
data2 = data.frame(data2,check.names = F,stringsAsFactors = F)
data2$q = p.adjust(data2$P.value, method = "bonferroni")

write.table(data2,"SGB_XZ_diff_SGB.txt",sep = "\t",quote = F,row.names = F)

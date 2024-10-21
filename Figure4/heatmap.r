data1=read.table("heatmap_data.txt",sep ="\t",check.names = F,
                 stringsAsFactors = F,header = T)
#filter_data = read.table("filter.txt",sep = "\t",check.names = F,
#                         stringsAsFactors = F)
#data1 = data1[data1$q<0.05,]
#data2 = data.frame()
#for(i in filter_data[,1]){
#  data2 = rbind(data2,data1[grep(i,data1$ann),])
#}
data1 = data1[order(data1$name),]
library(gplots)
#write.table(data2,"heatmap.txt",sep = "\t",quote = F,row.names = F)
data3 = data1[,c(1:5)]
row.names(data3) = data3[,1]
data3 = data3[,-1]
heatmap.2(as.matrix(data3),col = colorRampPalette(c("#66c2a5", "white", "#e78ac3"))(20), 
             scale = "row",Rowv = F,Colv = FALSE,
,             key = TRUE, symkey = FALSE, density.info = "none", 
             trace = "none", cexRow = 0.5,
             notecol = "black"#,行不聚类,Rowv = F列不聚类,Colv = FALSE,
)


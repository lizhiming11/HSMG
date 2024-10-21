AD_list = read.table("AD_list.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F)
smgc = read.table("SMGC_list.txt",sep = "\t",check.names = F,
                  stringsAsFactors = F)
all = read.table("cluster.txt",sep = "\t",check.names = F,
                 stringsAsFactors = F,header = T)
all$`Cluster MAGs`= gsub(".fa","",all$`Cluster MAGs`)
a = data.frame()
for(i in 1:nrow(all)){
  b = data.frame(v1 = all[i,2],v2 = unlist(strsplit(all[i,3],",")))
  a = rbind(a,b) 
}
AD_list = a[!(grepl("^T",a[,2])|grepl("^R",a[,2])|grepl("^SMGC",a[,2])),]
smgc = a[grepl("^SMGC",a[,2]),]
new_data = rbind(a[grep("^T",a[,2]),],a[grep("^R",a[,2]),])
AD_list = unique(AD_list[,1])
smgc = unique(smgc[,1])
new_data = unique(new_data[,1])

library(ggvenn)
data <- list(
  List1 = AD_list,
  List2 = smgc,
  List3 = new_data
)
ggvenn(data)


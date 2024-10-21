data1 = read.table("Ethno_diff_filter.txt",sep ="\t",check.names = F,
                   stringsAsFactors = F,header = T)
data1 = data1[data1$ann!="",]
data1$ann = gsub(";s__.*","",data1$ann)
data1$ann = gsub(".*;g__","",data1$ann)

ZANG = data1[data1$group=="ZANG",]
HAN = data1[data1$group=="HAN",]

combine_f <- function(x,y,z){
  row.names(x) = x[,1]
  row.names(y) = y[,1]
  name = as.character(unique(c(row.names(x),row.names(y))))
  x = x[name,]
  y = y[name,]
  a = data.frame(SGB = name, ZANG_enriched = x[,2],HAN_enriched = y[,2],type = z)
  return(a)
 }

ZANG_A = data.frame(table(ZANG$ann[ZANG$type=="A"]))
ZANG_A$type = "A"
ZANG_B = data.frame(table(ZANG$ann[ZANG$type=="B"]))
ZANG_B$type = "B"
ZANG_C = data.frame(table(ZANG$ann[ZANG$type=="C"]))
ZANG_C$type = "C"
ZANG_D = data.frame(table(ZANG$ann[ZANG$type=="D"]))
ZANG_D$type = "D"
HAN_A = data.frame(table(HAN$ann[HAN$type=="A"]))
HAN_A$type = "A"
HAN_B = data.frame(table(HAN$ann[HAN$type=="B"]))
HAN_B$type = "B"
HAN_C = data.frame(table(HAN$ann[HAN$type=="C"]))
HAN_C$type = "C"
HAN_D = data.frame(table(HAN$ann[HAN$type=="D"]))
HAN_D$type = "D"
data2 = rbind(combine_f(ZANG_A,HAN_A,"A"),
              #combine_f(ZANG_B,HAN_B,"B"),
              combine_f(ZANG_C,HAN_C,"C"),
              combine_f(ZANG_D,HAN_D,"D"))
data2 = rbind(data2,data.frame(SGB = HAN_B[,1],ZANG_enriched=0,HAN_enriched = HAN_B[,2],type= "B"))
filter_data = read.table("filter_genus.txt",sep = "\t",check.names = F,
                         stringsAsFactors = F)
data2 = data2[data2$SGB%in%filter_data[,1],]
data2$SGB = factor(data2$SGB,levels = unique(data2$SGB))
data2$HAN_enriched = -data2$HAN_enriched
library(ggplot2)
library(dplyr)
library(hrbrthemes)
ggplot(data2) +
  geom_segment( aes(x=SGB, xend=SGB, y=1, yend=ZANG_enriched,color = type), color="grey") +
  geom_segment( aes(x=SGB, xend=SGB, y=1, yend=HAN_enriched,color = type), color="grey") +
  geom_point( aes(x=SGB, y=ZANG_enriched,color = type), size=5 ) +
  geom_point( aes(x=SGB, y=HAN_enriched,color = type), size=5 ) +
  geom_text(aes(x=SGB, y=ZANG_enriched,label=ZANG_enriched,color = type),color ="white")+
  geom_text(aes(x=SGB, y=HAN_enriched,label=HAN_enriched,color = type),color ="white")+
  coord_flip()+
  theme_classic() +
  xlab("") +
  ylab("Value of Y")


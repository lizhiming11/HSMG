data1 = read.table("COG_num",sep = "\t",check.names = F,
                   stringsAsFactors = F,header = T,comment.char = "")
data1$num = as.double(data1$num)
data1$variable = 1
data1$type1 = factor(data1$type1,levels = rev(data1$type1))
library(ggplot2)
ggplot(data1, aes(x=variable, y=num,fill=type1)) + 
  geom_bar(stat="identity")+theme_classic()+
  scale_fill_manual(values = data1$color, breaks = data1$type1)


library(ggplot2)
library(RColorBrewer)
data1 = read.csv("SGB_diff_filter.txt",sep="\t",header=T,check.names = F,
                 stringsAsFactors = F)
data1 = data1[,c(1,3,4,8)]
data1 = data1[!is.na(data1$q_XZ_VS_SZ),]



data1$FC = log2(data1$SZ_mean/data1$XZ_mean)
data1$FC[data1$FC > 10] = 10
data1$FC[data1$FC < -10] = -10
data1$q = -log10(data1$q_XZ_VS_SZ)
data1$group = 'pass'
data1$group[data1$SZ_mean>data1$XZ_mean&data1$q>2&(data1$FC>2|data1$FC < -2)] = "SZ"
data1$group[data1$SZ_mean<data1$XZ_mean&data1$q>2&(data1$FC>2|data1$FC < -2)] = "XZ"
data1$Mean = (data1$SZ_mean*88+data1$XZ_mean*88)/(88+88)
data1$ann = data1$name
data1$ann[data1$group=="pass"] = ""
write.table(data1,"SGB_diff_filter.txt",sep = "\t",quote = F,row.names = F)
color = c(brewer.pal(3,"Set1"))
ggplot(data1,aes(x=FC,y=q,colour = group))+
  theme_classic()+
  geom_point(aes(size = Mean),shape=16)+
  #geom_text_repel(aes(x=fold_change,y = -log10(p_type),label=lable),size = 2)+
  geom_hline(aes(yintercept=2), linetype="dashed")+
  geom_vline(aes(xintercept=-2), linetype="dashed")+
  geom_vline(aes(xintercept=2), linetype="dashed")+
  theme(text=element_text(
    family="Helvetica",
    face="bold",
    colour="black",
    size=12
  ))+
  scale_colour_manual(values = rev(color),breaks=c(as.character(data1$group[1]),as.character(data1$group[2]),"pass"))+
  xlab("fold_change")+xlim(-10,10)

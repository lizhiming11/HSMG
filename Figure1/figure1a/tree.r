library(ggplot2)
library(ggtree)
library(ggtreeExtra)
library(treeio)
library(tidytree)
library(ggnewscale)
library(ggstar)
set.seed(1024)

tree=read.tree("gtdbtk.bac120.user_msa.fasta.treefile")
mapping1 = read.csv("tree_ann.txt",sep = "\t",check.names = F,stringsAsFactors = F)
mapping1$classification = factor(mapping1$classification,levels= unique(mapping1$classification))
#mapping1$fastani_reference = factor(mapping1$fastani_reference,levels = unique(mapping1$fastani_reference))
color <- unique(mapping1$classification_color)
mapping2 = mapping1[,c(1,2)]

p1= ggtree(tree,layout = "fan",size = 0.1,open.angle=5)  %<+% mapping2+
  geom_tippoint(aes(color=classification),size=1,position="identity",
                stroke=0.05)+ 
  scale_color_manual(values=color,breaks= unique(mapping2$classification))
p1
mapping8 = mapping1[,c(1,9,10)]
p7 = p1 +new_scale_fill()+
  geom_fruit(data=mapping8,
             geom=geom_bar,
             mapping=aes(y=user_genome,x = Cultured,fill = ncbi_genome_category),
             stat="identity",
             orientation="y",
             pwidth=0.07,
             position=position_dodgex()) + 
  scale_fill_manual(values=c("#FFFFFF","#93DE14"),
                    guide=guide_legend(keywidth=0.5, keyheight=0.5, order=2))
p7


mapping5 = mapping1[,c(1,7,8)]
p4 = p7 +new_scale_fill()+
  geom_fruit(data=mapping5,
             geom=geom_bar,
             mapping=aes(y=user_genome,x = checkM,fill = checkM_ann),
             stat="identity",
             orientation="y",
             pwidth=0.07,
             offset = 0,
             position=position_dodgex()) + 
  scale_fill_manual(values=c("#dfac03","#339933"),
                    guide=guide_legend(keywidth=0.5, keyheight=0.5, order=2))
p4

mapping6 = mapping1[,c(1,2,4)]
mapping6$Genome_size = mapping6$Genome_size/1e6
colnames(mapping6)[2] = "phylum"
p5 = p4 + new_scale_fill() +
  geom_fruit(data= mapping6,
             geom = geom_bar,
             mapping = aes(y=user_genome,x=Genome_size,fill=phylum),
             pwidth=0.3,
             offset = 0.01,
             stat="identity",
             orientation="y",
             position=position_stackx())+
  scale_fill_manual(values = color,breaks= unique(mapping6$phylum))+
  geom_treescale(fontsize=2, linesize=0.6, x=3, y=0.1)+
  theme(legend.position=c(1.2, 0.5),
        legend.background=element_rect(fill=NA),
        legend.title=element_text(size=6.5),
        legend.text=element_text(size=4.5),
        legend.spacing.y = unit(0.02, "cm")
  )

p5




SGB = read.table("SGB_SGB.profile",sep = "\t",check.names = F,
                 stringsAsFactors = F,header = T,row.names = 1)
mapping = read.table("mapping_file.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T,row.names = 1)
mapping = mapping[mapping$type2=="XZ",]
Med = read.csv("Med.txt",sep = "\t",check.names = F,stringsAsFactors = F,
                 header = T)


library(vegan)

adonis_self <- function(x,y,m){
  data1 = matrix(rep(0,ncol(x)*3),ncol = 3)
  data1[,1] = colnames(x)
  colnames(data1) = c("name","R2","P")
  for(i in 1:ncol(x)){
    a = adonis(t(y)~x[,i],permutations = 999)
    data1[i,2] = a$aov.tab$R2[1]
    data1[i,3] = a$aov.tab$`Pr(>F)`[1]
  }
  data1 = data.frame(data1,check.names = F,stringsAsFactors = F)
  data1$type = m
  return(data1)
}

adonis_all <- function(x,y,m){
  a = adonis2(t(y)~.,x,permutations = 999,by = "margin")
  data1 = data.frame(a,check.names = F,stringsAsFactors = F)
  data1$type = m
  return(data1)
}

adonis_R <-function(x,y,z,m){
  y = y[y$type1==m,]
  y = y[y$individual%in%z$Individual,]
  x = x[,row.names(y)]
  x = x[apply(x, 1, sum)!=0,]
  row.names(z) = as.character(z[,1])
  z = z[y$individual,]
  z = z[,-1]
  a = adonis_self(z,x,m)
  return(a)
}

adonis_A = adonis_R(SGB,mapping,Med,"A")
adonis_B = adonis_R(SGB,mapping,Med,"B")
adonis_C = adonis_R(SGB,mapping,Med,"C")
adonis_D = adonis_R(SGB,mapping,Med,"D")
adonis_data = rbind(adonis_A,adonis_B,adonis_C,adonis_D)
adonis_data = adonis_data[adonis_data$P<0.05,]
library(ggplot2)
adonis_data$R2 = as.double(adonis_data$R2)
ggplot(data = adonis_data, aes(name, y = R2)) + geom_bar(stat = 'identity')+
  coord_flip()+facet_wrap(~type, ncol=4)+theme_classic()

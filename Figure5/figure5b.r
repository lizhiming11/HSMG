SGB = read.table("SGB_SGB.profile",sep = "\t",check.names = F,
                 stringsAsFactors = F,header = T,row.names = 1)
mapping = read.table("mapping_file.txt",sep = "\t",check.names = F,
                     stringsAsFactors = F,header = T,row.names = 1)
mapping = mapping[mapping$type2=="XZ",]
Med = read.csv("Med.txt",sep = "\t",check.names = F,stringsAsFactors = F,
               header = T)

corr_1 = function(a,b){
  cor_r = matrix(rep(0,ncol(a)*ncol(b)),ncol(a),ncol(b))
  row.names(cor_r) = colnames(a)
  colnames(cor_r) = colnames(b)
  cor_p = matrix(rep(0,ncol(a)*ncol(b)),ncol(a),ncol(b))
  row.names(cor_p) = colnames(a)
  colnames(cor_p) = colnames(b)
  for(i in 1:ncol(a)){
    for(j in 1:ncol(b)){
      cor_1 = cor.test(as.double(a[,i]),as.double(b[,j]),method = "spearman")
      cor_r[i,j] = cor_1$estimate
      cor_p[i,j] = cor_1$p.value
    }
    print(i)
  }
  k = list(p = cor_p,r = cor_r)
  return(k) 
}


corr_R <-function(x,y,z,m){
  y = y[y$type1==m,]
  y = y[y$individual%in%z$Individual,]
  x = x[,row.names(y)]
  x = x[apply(x, 1, sum)!=0,]
  row.names(z) = as.character(z[,1])
  z = z[y$individual,]
  z = z[,-1]
  a = corr_1(z,t(x))
  a$SGB = row.names(a)
  return(a)
}

corr_A = corr_R(SGB,mapping,Med,"A")
corr_B = corr_R(SGB,mapping,Med,"B")
corr_C = corr_R(SGB,mapping,Med,"C")
corr_D = corr_R(SGB,mapping,Med,"D")

library(reshape2)

filter_data <- function(x){
  x_r = x$r
  x_p = x$p
  x_r = melt(x_r)
  x_p = melt(x_p)
  x_r$p = x_p[,3]
  x_r = x_r[x_r$p<0.05,]
  x_r = x_r[abs(x_r$value)>0.3,]
  #x_r = dcast(x_r[,c(1:3)],Var1~Var2)
 # row.names(x_r) = x_r[,1]
  #x_r = x_r[-1]
  #x_r = data.frame(t(x_r),check.names = F,stringsAsFactors = F)
  return(x_r)
}

heat_map <- function(x,y,z){
  y = t(y[,z[,1]])
  x = t(x[,z[,1]])
  #x = x[apply(y,1,min)<=0.05,]
  #y = y[apply(y,1,min)<=0.05,]
  #y = y[,apply(x,2,max)>=0.2]
  #x = x[,apply(x,2,max)>=0.2]
  #y = y[apply(x,1,max)>=0.2,]
  #x = x[apply(x,1,max)>=0.2,]
  y[y<0.01] = "*"
  y[y>0.01&y<0.05] = "+"
  y[y>0.05] = ""
  
  p<-heatmap.2(x,col = colorRampPalette(c("#66C2A5", "white", "#E78AC3"))(20), 
               #split = mtcars$cyl,
               key = TRUE, symkey = FALSE, density.info = "none", 
               trace = "none", cexRow = 0.5,Rowv = F,
               main = "Heatmap",cellnote = y,notecol = "black"#,行不聚类,Rowv = F列不聚类,Colv = FALSE,
  )
  return(p)
}


corr_A_r = filter_data(corr_A)
corr_B_r = filter_data(corr_B)
corr_C_r = filter_data(corr_C)
corr_D_r = filter_data(corr_D)
write.table(corr_D_r,"corr_D.txt",sep = "\t",quote = F,row.names = F)

corr_A_r = corr_A_r[row.names(corr_A_r)%in%row.names(corr_B_r),]
corr_A_r = corr_A_r[row.names(corr_A_r)%in%row.names(corr_C_r),]
corr_A_r = corr_A_r[row.names(corr_A_r)%in%row.names(corr_D_r),]
name = row.names(corr_A_r)
#write.table(name,"filter_name.txt",sep = "\t",quote = F)
name = read.table("filter_name.txt",sep = "\t",check.names = F,
                  stringsAsFactors = F,header = T)
library(gplots)
heat_map(corr_A$r,corr_A$p,name)
heat_map(corr_B$r,corr_B$p,name)
heat_map(corr_C$r,corr_C$p,name)
heat_map(corr_D$r,corr_D$p,name)

exp<-read.table("1-exp.txt",header=T,sep = "\t",stringsAsFactors = F)
motif<-read.csv("1-motif.csv",header=T)
ppi<-read.csv("1-ppi.csv",header=T)

list1<-vector(mode="list",length=3)
list1[[1]]<-exp
list1[[2]]<-motif
list1[[3]]<-ppi

library(netZooR)
linonessRes <- lioness(list1[[2]],
                       list1[[1]],
                       list1[[3]],
                       network.inference.method="panda")

sample<-data.frame(colnames(exp))
library(data.table)
library(tidyr)

list2<-vector(mode="list",length=ncol(exp))
for (i in 1:ncol(exp)){
  a<-linonessRes[[i]]
  a<-a[,colnames(a)%in%motif$target]
  TF<-data.frame(rownames(a))
  colnames(TF)<-"TF"
  a<-cbind(TF,a)
  measure_name=setdiff(colnames(a),c('TF'))
  b=reshape2::melt(a,
                   id.vars='TF', 
                   measure.vars=measure_name,
                   variable.name = "target", 
                   value.name = "score")
  samplename<-sample$colnames.exp.[i]
  colnames(b)<-c("TF","target",samplename)
  data<-unite(b, "TF-target", TF, target, sep = "-", remove = FALSE)
  motif<-unite(motif, "TF-target", TF, target, sep = "-", remove = FALSE)
  result<-data[data$`TF-target`%in%motif$`TF-target`,]
  result<-result[,c(1,4)]
  list2[[i]]<-result
}
result<-do.call(cbind,list2)
rownames(result)<-result$`TF-target`
result<-result[,-which(colnames(result) %in% c("TF-target"))]
rowname<-data.frame(rownames(result))
colnames(rowname)<-"TF-target"
result<-cbind(rowname,result)


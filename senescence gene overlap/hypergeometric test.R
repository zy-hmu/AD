load(file="AC-AD.RData")
table(AC_AD[["colors"]])
module<-data.frame(AC_AD[["colors"]])
module[,length(module[1,])+1]<-row.names(module)
colnames(module)<-c("module","gene")

data<-matrix(nrow = 14,ncol = 4)
data<-data.frame(data)
colnames(data)<-c("module","k","pvalue","pvalue.adjust")
data$module<-c(0:13)

library(dplyr)
library(tidyr)
M0<-filter(module,module=="0")
M1<-filter(module,module=="1")
M2<-filter(module,module=="2")
M3<-filter(module,module=="3")
M4<-filter(module,module=="4")
M5<-filter(module,module=="5")
M6<-filter(module,module=="6")
M7<-filter(module,module=="7")
M8<-filter(module,module=="8")
M9<-filter(module,module=="9")
M10<-filter(module,module=="10")
M11<-filter(module,module=="11")
M12<-filter(module,module=="12")
M13<-filter(module,module=="13")

gene<-read.table("senescence gene.txt",sep = "\t",header = T,stringsAsFactors = F)
mod<-list(M0,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,M13)

for(i in 1:14){
  data[i,2]<-length(intersect(gene[,1],mod[[i]][,2]))
}


for(i in 1:14){
  k=data[i,2]
  n=length(gene[,1])
  N=20000-length(gene[,1])
  m=length(mod[[i]][,2])
  data[i,3]=phyper(k-1,n,N,m,lower.tail = FALSE)
}


data[,length(data[1,])+1]<-"AC-AD"
data<-unite(data, "V5_module", V5, module, sep = "-", remove = FALSE)
data<-data[,c(1:5)]
colnames(data)<-c("region-module","module","k","pvalue","pvalue.adjust")


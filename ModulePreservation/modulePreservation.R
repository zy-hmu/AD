library(WGCNA)
library(tidyr)

load(file="CT region.RData")
load(file="AC-AD.RData")

datExpr23=t(AC_ADexp)
multiExpr[[23]] = list(data = as.data.frame(datExpr23))
names(multiExpr[[23]]$data) = row.names(AC_ADexp)
rownames(multiExpr[[23]]$data) = names(datExpr23)

genecolor[[23]] = AC_AD$colors

score<-WGCNA::modulePreservation(
  multiData=multiExpr,
  multiColor=genecolor,
  multiWeights = NULL,
  dataIsExpr = TRUE,
  networkType = "unsigned", 
  corFnc = "cor",
  corOptions = "use = 'p'",
  referenceNetworks = 23, 
  testNetworks = NULL,
  maxModuleSize = 5000,
  savePermutedStatistics = FALSE,
  verbose = 1, indent = 0)


nSets=22
list<-vector(mode = "list", length = 1)
list= score[["preservation"]][["Z"]][["ref.Set_23"]]

data=matrix(nrow = 15,ncol=22)
data=data.frame(data)
names(list)<-c(1:23)

for (i in 1:22){
  data[,i]= list[[i]][["Zsummary.pres"]]
}

region<-read.table("CT region.txt",header = T)
region=region[,2]

row.names(data)=row.names(list[[1]])
colnames(data)=region
data[,length(data[1,])+1]<-"AC-AD"
module<-data.frame(row.names(data))
colnames(module)<-"module"
data<-cbind(module,data)
data<-unite(data, "module", V23, module, sep = "-", remove = TRUE)

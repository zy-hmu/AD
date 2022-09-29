library(WGCNA)
library(tidyr)
load(file="AD region.RData")
load(file="AC-AD.RData")

datExpr27=t(AC_ADexp)
multiExpr[[27]] = list(data = as.data.frame(datExpr27))
names(multiExpr[[27]]$data) = row.names(AC_ADexp)
rownames(multiExpr[[27]]$data) = names(datExpr27)

genecolor[[27]] = AC_AD$colors

score<-WGCNA::modulePreservation(
  multiData=multiExpr,
  multiColor=genecolor,
  multiWeights = NULL,
  dataIsExpr = TRUE,
  networkType = "unsigned", 
  corFnc = "cor",
  corOptions = "use = 'p'",
  referenceNetworks = 27, 
  testNetworks = NULL,
  maxModuleSize = 5000,
  savePermutedStatistics = FALSE,
  verbose = 1, indent = 0)


nSets=26
list<-vector(mode = "list", length = 1)
list= score[["preservation"]][["Z"]][["ref.Set_27"]]

data=matrix(nrow = 15,ncol=26)
data=data.frame(data)
names(list)<-c(1:27)

for (i in 1:26){
  data[,i]= list[[i]][["Zsummary.pres"]]
}


region<-read.table("AD region.txt",header = T)
region=region[,2]

row.names(data)=row.names(list[[1]])
colnames(data)=region
data[,length(data[1,])+1]<-"AC-AD"
module<-data.frame(row.names(data))
colnames(module)<-"module"
data<-cbind(module,data)
data<-unite(data, "module", V27, module, sep = "-", remove = TRUE)

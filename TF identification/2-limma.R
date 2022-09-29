library(limma)
library(dplyr)
library(tidyr)

module<-"AC-AD-7"

group<-read.table("2-group.txt",header = T,sep = "\t",stringsAsFactors = F)
score<-read.table("2-score.txt",header = T,sep = "\t",stringsAsFactors = F)
sample<-colnames(score)
loc=match(sample,group$Sample)
class= group[loc,]

group_list<-class[,3]
design <- model.matrix(~0+factor(group_list))
colnames(design)=levels(factor(group_list))
rownames(design)=colnames(score)
contrast.matrix<-makeContrasts(" AD - Control",levels = design)
fit <- lmFit(score,design)
fit2 <- contrasts.fit(fit, contrast.matrix) 
fit2 <- eBayes(fit2) 
tempOutput = topTable(fit2, coef=1, n=Inf)
nrDEG = na.omit(tempOutput)
nrDEG[,length(nrDEG[1,])+1]<-module
DEG <- subset(nrDEG,adj.P.Val<0.05)

name<-data.frame(rownames(DEG))
colnames(name)<-"name"
DEG<-cbind(name,DEG)
TT<-separate(DEG,name,into = c("TF","Target"),sep = "-")
TT<-TT[,c(1,2)]
z<-TT$TF
y<-data.frame(unique(TT$TF))
x<-data.frame(matrix(ncol=2,nrow=nrow(y)))
x[,1]<-y$unique.TT.TF.
for ( i in 1:nrow(y)){
  w<-y$unique.TT.TF.[i]
  x[i,2]<-sum(z == w)
}
times<-subset(x,X2>2)

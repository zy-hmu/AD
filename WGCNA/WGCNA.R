library(dplyr)
library(tidyr)
library(WGCNA)
library(impute)   
library(dynamicTreeCut)
library(fastcluster) 
library(reshape)

gene<-read.table("genesymbol_mRNA.txt",header = T,sep = "\t",stringsAsFactors = F)
colnames(gene)<-"genesymbol"
exp<- read.table("combatdata.txt",header = T,sep = "\t",stringsAsFactors = F)
data <- exp[exp$genesymbol%in%gene$genesymbol,]
row.names(data)<-data$genesymbol
data<-data[,-which(colnames(data) %in% c("genesymbol"))]

datExpr <- data
WGCNA_matrix = t(datExpr[order(apply(datExpr,1,mean), decreasing = T),])
datExpr<-WGCNA_matrix[,c(1:5000)]
data<-data.frame(t(datExpr))

sample<-read.table("sample class.txt",header=T)
AC<-filter(sample,sample$Region%in%"AC")
AC<-filter(AC,AC$Class%in%"AD")
ACexp<-data[,colnames(data)%in%AC$Sample]
datExpr<-data.frame(t(ACexp))

powers = c(c(1:10),seq(from=12,to=20,by=2))
sft = pickSoftThreshold(datExpr, powerVector = powers, verbose = 5)
par(mfrow = c(1,2));
cex1 = 0.9;
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
     main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     labels=powers,cex=cex1,col="red");
abline(h=0.8,col="red")
plot(sft$fitIndices[,1], sft$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red")

AD<-blockwiseModules(
  datExpr,
  power = 6,
  TOMType = "signed", minModuleSize = 50,
  reassignThreshold = 0, mergeCutHeight = 0.20,
  pamRespectsDendro = FALSE,numericLabels = TRUE,
  verbose = 0)
table(AD$colors) 

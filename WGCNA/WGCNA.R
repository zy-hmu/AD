library(dplyr)
library(tidyr)
library(WGCNA)

ACexp<- read.table("ACexp-AD.txt",sep = "\t",header = T,stringsAsFactors = F)
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


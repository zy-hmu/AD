# AD Data
1.combat data:
The detailed information for 12 datasets utilized in this study from GEO. After data normalization, combined the gene expression profiles and removed batch effects between studies by the ComBat algorithm loaded from the R SVA package.

2.WGCNA:
Weighted gene co-expression network analysis was performed to identify the gene modules with coordinated expression patterns for each brain region. The top 5000 genes of average expression in each brain region were taken as input genes, and co-expression networks were constructed using the R package WGCNA.

3.Module Preservation Analysis:
To query the extent to which a module was preserved, every module of each region was tested against all modules of other regions. For each test, a composite Zsummary (Zsum) statistic was generated.

4.Senescence related modules identification:
Overlap test between senescence gene set and module genes was carried out using hypergeometric test. 

5.RSS modules:
Genes of 37 AD modules and 33 control modules.

6.TF identification:
The R/Bioconductor package lionessR version was used to obtain network estimates for single samples.In the example, the input data are the gene expression profiles of AD and normal samples in AC, the interaction information of TFs and targets (module AC-AD-7), and the protein interaction information of TFs regulating module genes.Then calculate TF-target relationship pairs that have significant differences between AD and normal samples by limma, to construct a TF-module network.

---
layout: page
---

# Tximport

Using tximport after running salmon (quasi-mapping and quantification of RNA-seq reads) to merge the results and the samples and create a matrix of raw counts. We will also use tximport to aggregate the transcripts counts to the gene level.

We will create an environment with R in the server and install tximport. We will then run tximport from the server and only download the resulting raw counts matrix, abundance matrix (TPM, transcripts per million) and vector containing the lengths of the transcripts.

```bash
mamba create -n env_r r-base=4.1.0
mamba activate env_r
```

After activating the environment, start R by typing R in your terminal and install tximport using the BiocManager package within R:

```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("tximport")
```

## Start of the script in R

These were the steps followed using R.

```r
# check the current working directory 
getwd()

# changing the working directory:
setwd("/home/datos_usuarios/igmestre/tfm_clara/salmon/")

# check again 
getwd()

# reading Sample Names

samples<- read.table("sample_names.txt", header = F)

# this line reads a text file named sample_names.txt, which contains the names of the samples without a header (header = F). Each line in the file represents a sample name. These names are stored in a data frame called samples, with the names in the first column ($V1).

files <- file.path(paste0(samples$V1, ".salmon.quant"), "quant.sf")
names(files) <-samples$V1
```

In the context of R, $V1 it refers to a way of accessing a specific column in a data frame or a similar data structure.
If a data frame that was created by reading a file or a table without specifying header names (as in header = F or header = FALSE), R automatically assigns column names as V1, V2, V3, etc., where V stands for "variable" and the number represents the column's position in the data frame.

With paste0, we are constructing file paths. For each sample name in samples$V1, we append .salmon.quant to the sample name and then further appends quant.sf to create a path to the Salmon quantification file for each sample. The full paths are stored in the files vector.
The names of the elements in the files vector are then set to the sample names from samples$V1 for easy reference.


```r
# Checking file existence. It returns TRUE if all files exist and FALSE otherwise.

all(file.exists(files))  

# Returns TRUE

# Reading transcript-to-gene mapping
# This file maps transcript IDs to gene IDs, needed for aggregating transcript-level estimates to gene-level estimates.

tx2gene <- read.table("Pecu23.transcriptome.mod.genemap")

# Setting the column names of the tx2gene data frame to "transcripts" and "genes" for clarity.

colnames(tx2gene)<-c("transcripts","genes")

# Importing Transcript-level Quantifications

txi <- tximport(files, type = "salmon", tx2gene = tx2gene, txOut = T)       # requires the installation of the package jsonlite

# txOut = T indicates that the output should remain at the transcript level.

# Look at the resulting txi object and especially the counts matrix. 
head(txi$counts)

# The counts for the transcripts are not discrete because of salmon's quasi-mapping probabilistic nature.
# For some cases such as limma, it is needed to adjust for transcript length with the countsFromAbundance = "lengthScaledTPM" parameter, but DESeq2 scales the lenghts itself.
```


# Aggregating to the Gene Level

```r
txi.genes <- summarizeToGene(txi, tx2gene)
head(txi.genes$counts)
```

This shows the counts of every aggregated gene for each sample. Gene counts are not discrete either.

PECUL_mtDNA         1424008.1    1208873.216    1633178.667      1278942.20
PECUL_nrDNA          419575.0     395344.842     438608.499       410829.99
PECUL23A000004         1200.4       1088.917        752.906          564.74
PECUL23A000005            0.0          0.000          0.000            0.00
PECUL23A000006            0.0          0.000          0.000            0.00
PECUL23A000008            0.0          0.000          0.000            0.00

We will save the txi object into an RDS object.

```r
saveRDS(txi, "salmon_counts.rds")
saveRDS(txi.genes, "salmon_gene_counts.rds")
```

Finally, quit the R session in the server by typing q(), quit abbreviated.

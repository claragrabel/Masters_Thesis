use tximport after salmon to merge the results and the samples and create matrix of raw counts (raw counts matrix).

either downloading salmon data and installing tximport in my computer (makes no sense, too heavy)
or create an environment with R in the server and install tximport and run it from there and only downloading the resulting raw count matrix, abundance matrix (TPM, transcripts per million)
and vector (vector containing the lenght of the transcripts)

mamba create -n env_r r-base=4.1.0

mamba activate env_r

after activating the environment, start R by typing R in your terminal and install tximport using the BiocManager package within R:

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("tximport")


# START OF THE SCRIPT IN R


check the current working directory getwd()
[1] "/home/igmestre"


so our data are in 
/home/datos_usuarios/igmestre/tfm_clara/salmon/


changing the working directory:
setwd("/home/datos_usuarios/igmestre/tfm_clara/salmon/")

check again getwd

# Reading Sample Names

samples<- read.table("sample_names.txt", header = F)

This line reads a text file named sample_names.txt, which contains the names of the samples without a header (header = F). Each line in the file represents a sample name. These names are stored in a data frame called samples, with the names in the first column ($V1).


files <- file.path(paste0(samples$V1, ".salmon.quant"), "quant.sf")
names(files) <-samples$V1


######################
In the context of R, when you see $V1 it refers to a way of accessing a specific column in a data frame or a similar data structure, such as a matrix or a list of lists. Here's a breakdown of what $V1 means:

The dollar sign $ is an operator used in R to access elements, columns, or components of an object by name.
V1 is commonly used as a default name for the first column of a data frame or matrix when column names are not explicitly provided.
So, when you encounter samples$V1 in an R script, it means "access the column named V1 in the data structure samples". If samples is a data frame that was created by reading a file or a table without specifying header names (as in header = F or header = FALSE), R automatically assigns column names as V1, V2, V3, etc., where V stands for "variable" and the number represents the column's position in the data frame.

For example, if you read a file with read.table("sample_names.txt", header = F) and it contains a single column of data without a header row, R assigns the name V1 to this column. Thus, samples$V1 refers to the values in this column.
#########################

########################
What it does is specifying the names of the files (actually the file paths) for each sample (it constructs the file paths)


For each sample name in samples$V1, it appends .salmon.quant to the sample name and then further appends quant.sf to create a path to the Salmon quantification file for each sample. The full paths are stored in the files vector.
The names of the elements in the files vector are then set to the sample names from samples$V1 for easy reference.
#######################

#Checking file existence

all(file.exists(files))  #returns TRUE so OK
This line checks if all files specified in the files vector exist. It returns TRUE if all files exist and FALSE otherwise. This is a good practice to ensure that all expected input files are available before proceeding.

#reading transcript-to-gene mapping

tx2gene <- read.table("Pecu23.transcriptome.mod.genemap")
tx2gene_limma <- read.table("Pcu23.transcriptome.mod.genemap")

#QUÉ ES ESTE FICHERO EL DE MOD.GENEMAP

colnames(tx2gene)<-c("transcripts","genes")
colnames(tx2gene_limma)<-c("transcripts","genes")

Reads a transcript-to-gene mapping file. This file maps each transcript ID to a gene ID, which is necessary for aggregating transcript-level estimates to gene-level estimates.
Sets the column names of the tx2gene data frame to "transcripts" and "genes" for clarity.

#Importing Transcript-level Quantifications
txi <- tximport(files, type = "salmon", tx2gene = tx2gene, txOut = T)
it said error we needed package jsonlite, so i installed it with install.packages
now load the library and run again 
(It said reading in files with read.delim (install 'readr' package for speed up)
 but it didn't take long at all, it as printing the numbers for each sample like 1,2,3.. until 48.)

head(txi$counts)

# THIS SHOWS EVERY GENE FOR EVERY SAMPLE AND A NUMBER (A LEVEL? BUT IT'S NOT DISCRETE THO)


Uses the tximport function to import transcript-level quantification files specified in files, indicating that the type of quantification is from Salmon (type = "salmon").
The tx2gene parameter is supplied with the mapping data frame created earlier.
txOut = T indicates that the output should remain at the transcript level.
The head(txi$counts) function call prints the first few rows of the transcript-level counts to the console, providing a quick peek at the data.


txi_limma <- tximport(files, type = "salmon", tx2gene = tx2gene_limma, countsFromAbundance = "lengthScaledTPM")

this is what i got in the console

reading in files with read.delim (install 'readr' package for speed up)
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48
summarizing abundance
summarizing counts
summarizing length



#genes
txi.genes <- summarizeToGene(txi, tx2gene)
head(txi.genes$counts)

THIS SHOWS: 
 Tur3H6_nonrrna Tur3L3_nonrrna Tur4H2_nonrrna Tur4L13_nonrrna
PECUL_mtDNA         1424008.1    1208873.216    1633178.667      1278942.20
PECUL_nrDNA          419575.0     395344.842     438608.499       410829.99
PECUL23A000004         1200.4       1088.917        752.906          564.74
PECUL23A000005            0.0          0.000          0.000            0.00
PECUL23A000006            0.0          0.000          0.000            0.00
PECUL23A000008            0.0          0.000          0.000            0.00

WHY DOES IT SAY PECULmtDNA


txi_genes_limma <- summarizeToGene(txi_limma, tx2gene_limma)

this is what i got in the console 
transcripts missing from tx2gene: 106234
summarizing abundance
summarizing counts
summarizing length
Warning message:
  In .local(object, ...) :
  the incoming counts have countsFromAbundance = 'lengthScaledTPM',
and so the original counts are no longer accessible.
to use countsFromAbundance='no', re-run objectmport() with this setting.
over-riding 'countsFromAbundance' to set it to: lengthScaledTPM

Since you are using lengthScaledTPM, tximport handles the transformation and 
summarization simultaneously. If you receive a warning about inaccessible original counts, it’s because the transformation to lengthScaledTPM makes direct use of raw counts infeasible. However, since your objective is to use the transformed counts, you can proceed with the gene-level data obtained


This function, summarizeToGene, will utilize the lengthScaledTPM data from txi and aggregate it at the gene level, as you desired.

Handling the Warning Message
The warning message is informational and confirms that the transformation has occurred as specified. If your analysis goals are met with the lengthScaledTPM data and you are aware that you are not working with the original raw counts, you can proceed with your analysis.



saveRDS(txi, "salmon_counts.rds")
saveRDS(txi.genes, "salmon_gene_counts.rds")

saveRDS(txi_limma, "salmon_counts_limma.rds")
saveRDS(txi_genes_limma, "salmon_gene_counts_limma.rds")
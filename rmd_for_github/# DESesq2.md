# DESesq2


# Explanation about the txi objecto from the rds files

Abundance: This entry typically contains the estimated abundance of transcripts, usually in terms of Transcripts Per Million (TPM) or similar units. Abundance measures take into account the length of the transcripts and the sequencing depth, providing a normalized value that allows for comparison across different genes and samples. It's a relative measure indicating how much of each transcript is present in your sample compared to others.

Counts: Unlike abundance, counts are the raw or estimated counts of reads that have been mapped to each transcript or gene. These counts are not normalized for transcript length or sequencing depth. In the context of RNA-seq data analysis, counts are often used as input for differential expression analysis because many statistical models for this analysis are designed to work with count data. Count data are assumed to follow certain statistical distributions (like the negative binomial distribution), which are appropriate for discrete data.

CountsFromAbundance: This field indicates the method used to derive count estimates from the abundance measurements. Since differential expression analysis often requires count data, but tools like Salmon provide abundance estimates, tximport provides a way to estimate counts from these abundances. The countsFromAbundance field can have several values, each representing a different approach to this estimation. For example:

"no": No transformation is applied, and the raw counts are used.
"scaledTPM": Counts are derived by scaling TPM values in a way that makes them suitable for differential expression analysis, maintaining the relative differences in expression levels but in count space.
"lengthScaledTPM": Similar to "scaledTPM", but it also takes into account the gene length, providing an adjustment that makes these counts more closely resemble raw counts for use in differential expression analysis.


# Exploratory Analysis

To do the exploratory analysis and visualize data structure, it is better to use the abundance measures such as Transcripts Per Million (TPM) or Fragments Per Kilobase of transcript per Million mapped reads (FPKM) is often preferred. The reason for this preference lies in the normalization that these measures provide, making them more suitable for comparing expression levels across different genes and samples. 



salmon_counts<-readRDS("salmon_counts.rds")
head(salmon_counts)
summary(salmon_counts)

txi<-readRDS("salmon_gene_counts.rds")


# Explore the data

class(txi)
head(txi)
summary(txi)
lapply(X=txi, FUN=head)


#It is a list with 4 entries, three arrays/matrices (abundance, counts, length) 
#and 1 character vector (countsFromAbundance).

dim(txi$abundance)

#We have the genes per rows and the samples per column


# Look at the distribution of the Data

#with this we would see the distruibution of the first column/sample of the abundance
#matrix and the counts matrix

#When applying the log10, a value around 0 in the X axis indicates that the value
#of a transcript would be or magnitude 10^0 --> 1-9
#if it's 2, that means the value of abundance for that transcript would be of order 10^2.
#the frequency indicates the amount of genes/transcripts that have that specific abundance. 

#for sample 1


#DOUBT: IF WE'RE APPLYING LOG10 WITHOUT ADDING 1, WE'RE MISSING THE VALUES THAT 
#HAVE AN ABUNDACE OF 0

Adding a pseudocount of 1 before taking the log10 (logarithm base 10) of RNA-seq abundance data is a common practice that allows for the inclusion of zero counts in the analysis and visualization, but it also has its implications.

Pros of Adding a Pseudocount:
  
  Enables Visualization and Analysis: By adding a pseudocount, you can include all genes in log-transformed analyses and visualizations, such as heatmaps or histograms, which otherwise exclude zero counts.
Stabilizes Variance: Logarithm transformation with a pseudocount can help stabilize the variance across genes, which is typically a function of the mean expression level.
Facilitates Comparisons: It allows for the comparison of expression levels across samples in a log scale, which is more interpretable because RNA-seq data typically follows a log-normal distribution.
Cons of Adding a Pseudocount:
  
  Artificial Inflation: Adding a pseudocount artificially inflates the expression levels of genes with zero counts, which might lead to misinterpretation as indicating expression when there is none.
Distorts Low Counts: It disproportionally affects genes with low counts more than those with high counts, potentially leading to biases in downstream analysis.
Arbitrary: The choice of pseudocount (often 1) is somewhat arbitrary and can influence the results of the analysis. Different pseudocounts can lead to different results, especially for genes with low expression levels.
Consequences of Adding a Pseudocount:
  
  Zero Counts Become Non-zero: Genes with zero counts are assigned a minimum value (after pseudocount addition), meaning that no genes will have an infinite or undefined log value.
Changes to Data Distribution: The distribution of the data will change, as zero counts will now contribute to the lower end of the expression spectrum rather than being absent from the log-transformed data.
Affects Downstream Statistical Analysis: The statistical tests and models that rely on log-transformed data will now include these previously excluded zero-count genes, potentially affecting the results of differential expression analysis or clustering.
Interpreting the Results:
  
  With Pseudocount: You need to be aware that genes with zero counts are now represented in the data but do not necessarily indicate biological expression. When you see low expression levels, consider that they may be influenced by the pseudocount addition.
Without Pseudocount: Any log-transformed visualizations or analyses will only include genes with non-zero counts. This may simplify interpretation since you only deal with genes that have some evidence of expression, but it could also mean missing out on potentially important patterns where expression is low or undetected due to technical limitations.


hist(log10(txi$abundance[,1]), breaks=50)

#if we do the same for the whole matrix, we can see that the frequency reached is much higher

hist(log10(txi$abundance), breaks=50)

#for sample 1

hist(log10(txi$counts[,1]), breaks=50)

# In counts,we can see the number of counts 

apply(X=txi$abundance, FUN=sum, MARGIN = 2)


# install pacman if not already installed
if (!require("pacman")) install.packages("pacman")

# use pacman to load libraries
pacman::p_load(tidyverse, DESeq2, pheatmap)

# a more detailed plot with the tidyverse:
txi$abundance %>%
  as_tibble(rownames = "transcript") %>%
  pivot_longer(-transcript, names_to="sample", values_to="TPM") %>%
  ggplot(aes(x=TPM)) +
  geom_histogram() +
  ylab("number of transcripts") +
  scale_x_log10() +
  facet_wrap(~sample)


We can see that the log abundance is fairly normally distributed. This is a good sign. 
Many 0 counts would indicate that you have targets that are heavily depleted. 
For example, if I would have included non-coding target sequences, we would probably see a peak of low counts, because these tend to be very depleted in RNAseq data.



# Preparation for DESeq2


Before creating a DESeqDataSet, we need to prepare a data frame that contains metadata about your samples, including the condition for each sample. This data frame is referred to as colData in DESeq2. Each row corresponds to a sample, and columns contain variables describing the samples, with one of these variables being the condition.


Undesr



Explanation for DESeq results

The output of assayNames(dds) for your DESeqDataSet (dds) object lists the names of assays and other components stored within it. Each of these names represents a different type of data or metadata associated with your RNA-seq dataset and the analysis performed by DESeq2. Here's what each of these terms means:

"counts": The raw count data from your RNA-seq experiment. These are the unnormalized counts of reads mapped to each gene.

"avgTxLength": Average transcript length. This is used for calculations that require length normalization, such as transforming counts to FPKM (Fragments Per Kilobase of transcript per Million mapped reads) or TPM (Transcripts Per Million).

"normalizationFactors": These are factors calculated by DESeq2 used to normalize the counts data across samples. Normalization is necessary to account for differences in sequencing depth and RNA composition between samples.

"mu": The expected count values based on the model fitted by DESeq2. These are not directly observed but are estimated by the model, considering the effects of conditions, normalization factors, and other parameters.

"H": This likely refers to a matrix related to hypothesis testing or model parameters. In the context of DESeq2, it could be related to the dispersion or size factor estimates, but the specific use might vary depending on the version of DESeq2 or additional context from the analysis.

"cooks": Cook's distance for each observation. This is a measure used to identify outliers in the data. High Cook's distance values can indicate points (i.e., genes) that have a large influence on the parameter estimates and might be considered for exclusion in some analyses.

"replaceCounts" and "replaceCooks": These likely refer to internal mechanisms DESeq2 uses for handling outliers or influential points identified by Cook's distance. "replaceCounts" could be adjusted counts used in place of the original counts for certain analyses, and "replaceCooks" could be adjusted Cook's distance values after some form of transformation or outlier mitigation.



Minimal Number of Samples: For pre-filtering, the suggestion to use the smallest group size (in your case, considering you have conditions crossed, you might think in terms of the smallest combination of conditions) is meant to ensure that a gene shows a minimal level of expression across what might be considered a biologically coherent group. Given your design, every unique condition combination (e.g., high water level in the southern region) is represented by multiple samples and replicates, providing a strong basis for applying this pre-filtering step. However, since your experimental design is balanced, you might consider a gene expressed if it meets the minimum count threshold across several replicates in any of the condition combinations, rather than just the smallest group.

Application to Your Data:
Filtering Decision: If your goal is to ensure that the genes included in the differential expression analysis show consistent expression across replicates within any condition combination, you could set your minimal number of samples for filtering based on the number of replicates. For example, you might require that a gene has at least 10 counts in at least 4 of the replicates within any single condition combination to be kept for analysis.


* normalizationFactors: factors calculated by DESeq2 used to normalize the counts data across samples. Normalization is necessary to account for differences in sequencing depth and RNA composition between samples.

```{r}

#assay(dds, "normalizationFactors") %>% head()

```

* mu: The expected count values based on the model fitted by DESeq2. These are not directly observed but are estimated by the model, considering the effects of conditions, normalization factors, and other parameters.

```{r}
assay(dds, "normalizationFactors") %>% head()
```



# EXPLAIN THE REST OF THE ASSAYS AFTER SECOND DDS<-DESEQ>
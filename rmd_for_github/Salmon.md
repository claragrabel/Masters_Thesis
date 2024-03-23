# Salmon

+ Creating an environment for salmon

mamba create -n env_salmon
mamba activate env_salmon

+ Installing salmon



Using Salmon for quantifying transcript abundances from RNA-seq data involves a few steps, especially when you have multiple samples. Salmon is designed to quickly and accurately quantify the abundance of transcripts from RNA-seq data by using quasi-mapping. Below is a general workflow for using Salmon with multiple samples against a reference transcriptome.

1. Install Salmon
First, ensure that Salmon is installed on your system. You can install Salmon using Bioconda with the following command if you have Conda:

sh
Copy code
conda install -c bioconda salmon
Alternatively, you can download pre-compiled binaries or source code from the Salmon GitHub releases page and follow the installation instructions.

2. Download or Prepare the Reference Transcriptome
You need a reference transcriptome in FASTA format that corresponds to the organism from which your RNA-seq data was generated. If you don't have one, you can download it from sources like Ensembl or NCBI.

3. Index the Transcriptome
Before quantifying your samples, you need to build an index of the reference transcriptome. This step is done only once for a given reference.

sh
Copy code
salmon index -t transcriptome.fasta -i transcriptome_index
Replace transcriptome.fasta with the path to your transcriptome FASTA file, and transcriptome_index with the name for the directory to store the index.

4. Quantify Each Sample
For each of your RNA-seq samples, you will use the salmon quant command to quantify transcript abundances. If your RNA-seq data is single-end, the command looks like this:


sh
Copy code
salmon quant -i transcriptome_index -l A -1 reads_1.fq -2 reads_2.fq -o sample_output
-i specifies the index directory.
-l A lets Salmon automatically detect the library type (though it's better to specify it explicitly if you know it).
-r is used for single-end reads, pointing to the file containing them.
-1 and -2 are used for paired-end reads, pointing to the files containing the forward and reverse reads, respectively.
-o specifies the output directory for the quantification results.
Repeat the salmon quant command for each of your samples, changing the reads file(s) and output directory each time.

5. Analyzing Quantification Results
After quantifying all samples, you will have a set of output directories (one per sample), each containing several files. The most important file for downstream analysis is quant.sf, which contains the estimated transcript abundances.

Automating for Multiple Samples
If you have many samples, it's efficient to automate the process with a script. Here’s a simple example using Bash for paired-end samples:


#!/bin/bash

# Directory where your samples are located
SAMPLE_DIR="/path/to/samples"

# Location of the Salmon index
INDEX_DIR="transcriptome_index"

# Loop through each pair of files in the directory
for fwd in ${SAMPLE_DIR}/*_1.fq.gz
do
    # Assuming the file naming convention is consistent,
    # construct the reverse read file name
    rev="${fwd%_1.fq.gz}_2.fq.gz"
    
    # Extract the base name for output directory naming
    sample_base=$(basename "${fwd}" _1.fq.gz)
    
    # Run Salmon quantification
    salmon quant -i ${INDEX_DIR} -l A \
         -1 "${fwd}" \
         -2 "${rev}" \
         -o "${SAMPLE_DIR}/${sample_base}_quant"
done

This script uses Bash parameter expansion to manipulate the file name strings, specifically:

${fwd%_1.fq.gz} strips the _1.fq.gz suffix from the forward read file name to help generate the corresponding reverse read file name.
basename "${fwd}" _1.fq.gz extracts the base sample name by removing the _1.fq.gz part from the forward file name, which is then used to name the output directory for the Salmon quantification results.

Final Steps
Downstream Analysis: You can use the quantification results for downstream analysis such as differential expression analysis, pathway analysis, etc.
Tools for Downstream Analysis: Tools like DESeq2, edgeR, or Limma (with the voom method) in R can be used for further analysis of the quantified transcripts.


# EXPLANATION OF THE SCRIPT PROVIDED 

This script is designed for running a quantitative analysis of RNA-Seq data using the salmon tool, followed by compressing the output SAM file with pigz. Let's break down the script into its components to understand the inputs, outputs, and functioning:

Variables
SAMPLE=$1: The script takes the first argument passed to it and assigns it to the SAMPLE variable. This is used to dynamically work with sample-specific file names.
THREADS=18: Sets the number of threads to 18, which salmon and pigz will use for parallel processing.
salmon Command
salmon is a tool for quantifying the expression of transcripts using RNA-seq data. It doesn't require alignment to a reference genome, which makes it faster and requires less memory than traditional alignment-based methods.

Inputs:

--libType A: Specifies the library type. Here, A is a placeholder and should be replaced with the actual library type based on the sequencing data (e.g., I, IU, ISF, etc.).
--index ../Pcu23_transcriptome/Pcu23.salmon.index: The path to the salmon index for the transcriptome, which must be pre-built using salmon index.
--mates1 and --mates2: Specifies the paths to the paired-end FASTQ files for the sample. The script constructs these paths dynamically using the SAMPLE variable.
--geneMap ../Pcu23_transcriptome/Pecu23.transcriptome.mod.genemap: Path to the file that maps transcripts to genes. This is used for aggregating transcript-level quantifications to the gene level.
--seqBias, --gcBias, --useVBOpt, --validateMappings: Flags to enable sequence-specific bias correction, GC bias correction, variational Bayesian optimization for inference, and more sensitive and accurate mapping, respectively.
--writeMappings=$SAMPLE".salmon.sam": Instructs salmon to write the mappings (alignments) to a SAM file, which is named dynamically using the SAMPLE variable.
Output:

$SAMPLE".salmon.quant": The directory where salmon will write its quantification outputs, named dynamically based on the SAMPLE variable.
$SAMPLE".salmon.sam": The SAM file containing the mappings, which is later compressed.
$SAMPLE".salmon.log.txt": The log file where the standard output and standard error of the salmon run are redirected

# BEHIND SALMON...

Salmon performs both mapping and quantification of RNA-seq reads, but it does so in a unique and efficient way through a process known as "quasi-mapping." This method allows Salmon to quickly and accurately estimate transcript abundances without generating traditional alignments, which are computationally expensive. Here’s a deeper dive into how Salmon works and the concept of quasi-mapping:

Quasi-Mapping
Quasi-mapping is a technique that allows the rapid and approximate mapping of sequencing reads to a reference transcriptome. Unlike traditional read mapping, which requires exact alignments and can be computationally intensive, quasi-mapping focuses on finding the potential locations a read could come from in the transcriptome based on a highly efficient data structure such as a hash table or a suffix array. This approach doesn't compute detailed base-by-base alignments but instead identifies the transcripts that the read is likely to originate from, along with the approximate position.

How Salmon Works
Indexing: Before quantification, Salmon constructs an index of the target transcriptome. The index represents a condensed version of the transcriptome, optimized for rapid look-up of sequence information.

Quasi-Mapping of Reads: During quantification, Salmon processes each read or read pair from the RNA-seq data and uses quasi-mapping to quickly identify which transcripts those reads could have originated from. This step leverages the index to efficiently map reads to the transcriptome without requiring full alignments.

Transcript Abundance Estimation: Once reads are quasi-mapped to transcripts, Salmon uses sophisticated statistical models to estimate the abundance of each transcript. This involves solving an optimization problem to distribute reads among transcripts in a way that is consistent with the observed data, taking into account factors like read ambiguity (reads that could map to multiple transcripts), sequencing errors, and biases inherent in the RNA-seq data (e.g., GC content bias, positional bias).

Advantages of Salmon and Quasi-Mapping
Speed: Quasi-mapping significantly reduces the computational time required to map reads to a transcriptome, making Salmon much faster than traditional aligners and quantifiers.
Accuracy: Despite its speed, Salmon provides highly accurate quantification estimates, comparable to or better than those obtained from methods that rely on full alignments.
Bias Correction: Salmon incorporates models to correct for known biases in RNA-seq data, improving the accuracy of its quantification estimates.
Memory Efficiency: The data structures used by Salmon for indexing and quasi-mapping are designed to be memory-efficient, allowing it to run on a wide range of hardware.

# PROS AND CONS

Salmon, along with other transcriptome quantification tools like kallisto, represents a shift from traditional exact mapping tools (such as Bowtie, BWA, or STAR) towards more efficient and specialized approaches for analyzing RNA-seq data. Here's a comparison highlighting the differences, including pros and cons.

Traditional Exact Mapping Tools
Examples: Bowtie, BWA, STAR.

How They Work: These tools perform exact or near-exact alignment of reads to a reference genome or transcriptome. They generate detailed alignments that specify how each read maps to the reference, including mismatches, insertions, and deletions.

Pros:

Versatility: Can be used for a wide range of applications beyond RNA-seq, including DNA-seq, ChIP-seq, etc.
Detailed Alignments: Provide precise information about how each read aligns to the reference, useful for variant calling and detailed analysis of splice junctions.
High Accuracy: Especially with tools like STAR, which are designed to handle the complexities of splicing in eukaryotic genomes.
Cons:

Computational Intensity: Require significant computational resources, especially in terms of CPU and memory, to perform alignments.
Slower: Because they compute detailed alignments, they are generally slower than tools like Salmon, especially for large datasets.
Complexity: Generating and handling alignment files (e.g., SAM/BAM) can be computationally expensive and complex, especially for high-throughput or large-scale studies.
Salmon and Quasi-Mapping Tools
How They Work: Salmon uses a technique called quasi-mapping, which rapidly identifies potential transcripts a read could originate from without computing a full alignment. It then uses statistical models to estimate transcript abundances.

Pros:

Speed: Very fast compared to traditional aligners, thanks to the efficiency of quasi-mapping and specialized algorithms for transcript quantification.
Memory Efficiency: Designed to use less memory, making it suitable for running on a wide range of systems, including those with limited resources.
Bias Correction: Incorporates models to correct for known biases in RNA-seq data, improving accuracy in quantification.
Direct Quantification: Outputs quantification of transcript abundances directly, eliminating the need for additional steps to derive expression levels from alignments.
Cons:

Limited to Transcriptome Analysis: Specifically designed for RNA-seq quantification, and cannot be used for tasks that require detailed alignments, such as variant calling or detailed splice junction analysis.
Less Detail on Read Placement: Does not provide detailed alignment information, which may be necessary for some analyses.
Dependent on Transcriptome Quality: The accuracy of quantification is heavily dependent on the quality and completeness of the reference transcriptome used for analysis.
Summary
Use Case: Choose traditional exact mapping tools when you need detailed alignment information for a broad range of applications, including those requiring precise location of reads. Opt for Salmon or similar tools when the primary goal is fast and accurate transcript quantification from RNA-seq data.
Computational Resources: For environments where computational resources are limited, Salmon offers a more efficient alternative that still delivers high-quality quantification results.
Analysis Goals: If your analysis requires beyond quantification, such as mutation analysis or detailed examination of alternative splicing patterns, traditional mapping tools followed by specialized analysis pipelines might be necessary.



Salmon parameters:

## Basic

+ -i / --index: Path to the Salmon index directory. You must build an index on your reference transcriptome before quantification.
+ -l / --libType: The library type. For 100bp reads from toads, you'll need to determine if your reads are single-end (A, I, or U) or paired-end (A, I, SR, or SF). The A option lets Salmon automatically infer the library type, which is useful if you're unsure about the orientation and strandedness of your reads.
+ -r / --unmatedReads: For single-end reads, use this option followed by the path to your reads.
+ -1 and -2: For paired-end reads, these options are followed by the paths to the forward and reverse read files, respectively.
+ -o / --output: The output directory for Salmon's quantification results.

## More advanced

--seqBias: Corrects for sequence-specific biases in the reads. This is recommended for most datasets, as it can improve the accuracy of quantification.

Description: Corrects for sequence-specific biases that occur due to preferences in the sequencing process for certain nucleotide compositions at the beginning of reads.
When to Use: Almost always recommended, especially if your RNA-seq library preparation method is known to introduce sequence-specific biases (e.g., random hexamer priming in Illumina sequencing).

--gcBias: Corrects for GC content biases in the reads. Considering that toad genomes, like many amphibians, might exhibit significant GC content variation, enabling this option might be beneficial if you suspect GC bias in your data.
--validateMappings: Enables more accurate mapping validation. This can lead to more accurate quantification results and is generally recommended for all datasets.
-p / --threads: Specifies the number of threads to use. Adjust this based on your available computational resources to speed up the quantification process.


# Salmon counts with decimals

Summary: Due to the nature of salmon (quasi-mapping), probabilistics.
If there is a read that could map to several transcripts, it doesn't force map against one only transcript but divides the probability of that read to map against the possible transcripts, and therefore the transcripts end with fractional abundances. That's why the counts matrix has decimals.

Apparently deseq2 is design to work seamlessly with tximport and there is a specific function called to create a DESeqDataSet object, which is used by DESeq2 for the analysis. I still need to check how to specify the conditions (the experimental design I know, through the desing matrix
).
DESeqDataSetFromTximport(txi, colData = sampleTable, design = ~ condition)


### **Background**

In RNA-seq experiments, the goal is to measure the abundance of transcripts in a sample. This involves sequencing short fragments of RNA (reads) and then mapping those reads back to a reference transcriptome. However, this mapping process is complicated by several factors:

- **Sequence Similarity**: Many genes produce multiple transcript variants (isoforms), which share significant portions of their sequences. Additionally, different genes may have regions of high sequence similarity.
- **Ambiguity in Mapping**: Given the short length of RNA-seq reads and the sequence similarities among transcripts, it's often not clear to which transcript (or even gene) a given read should be attributed. This ambiguity makes it challenging to accurately quantify transcript abundance.

### **Probabilistic Assignment Explained**

Salmon tackles these challenges using a sophisticated probabilistic model. Here's how it works:

- **Likelihood-Based Mapping**: Instead of trying to assign each read to a single transcript definitively, Salmon assesses the likelihood that a given read came from each possible transcript. This assessment takes into account the sequence of the read, the sequences of all potential transcripts, and the current estimates of transcript abundance.
- **Fractional Assignment**: Based on these likelihoods, a read can be fractionally assigned to multiple transcripts. For example, if a read could have come from two different transcripts with equal likelihood, it might be assigned half (0.5) to one transcript and half (0.5) to the other. This fractional assignment is more realistic than forcing a binary choice when the evidence is ambiguous.

### **Advantages of This Approach**

- **Improved Accuracy**: By accounting for the uncertainty in read mapping, Salmon can provide a more accurate estimate of transcript abundance. This method acknowledges that our data and our reference transcriptomes are imperfect and that absolute certainty in read mapping is often not achievable.
- **Reflects Biological Reality**: The fractional assignment aligns with the biological reality that RNA molecules from different but similar transcripts can coexist in a sample and may not be distinguishable based on short reads alone. This approach avoids artificially inflating the count of one transcript at the expense of others, providing a more balanced and accurate view of the transcriptome.
- **Statistical Robustness**: Probabilistic assignment allows for the use of statistical models in downstream analyses that can incorporate the uncertainty of read assignments into their calculations. This leads to more nuanced and potentially more accurate interpretations of gene expression data.


Direct Compatibility: DESeq2, through its integration with tximport, directly accepts the summarized experiment object that may contain decimal counts. This is particularly relevant when dealing with transcript-level quantifications aggregated to the gene level, where the aggregation could result in non-integer values.

No Forced Conversion: During the DESeq2 analysis workflow, these decimal counts are not forcibly converted to integers. The model used by DESeq2, which is based on the negative binomial distribution, fundamentally requires integer counts. However, the package handles the fractional counts in a way that does not disrupt its underlying statistical models. Specifically, DESeq2 uses the decimal counts for size factor estimation (normalization) and dispersion estimation, integrating them into its model fitting process without requiring an explicit conversion to integer values.

Statistical Models and Fractional Counts: The use of fractional counts does not invalidate the statistical models underpinning DESeq2. The main impact of starting with fractional counts is on the estimation of size factors (used for normalizing libraries) and on dispersion estimates. The developers have noted that the impact of using rounded versus fractional counts on the final differential expression results is minimal.
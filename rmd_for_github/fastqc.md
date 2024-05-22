# Performing Quality Control with FastQC

We will proceed with the fastqc of the raw reads

### Creating an environment for fastqc

```bash
mamba create -n env_fastqc

mamba activate env_fastqc

mamba install -c bioconda fastqc

# to check if it was installed correctly: 
which fastqc
fastqc --version
fastqc -h 
```


## fastqc command

```bash
fastqc ./*.fq.gz -o ../fastqc_raw --nogroup
```
Explanation of the line of code:

fastqc: This is the command to execute FastQC.

./*.fq.gz: This specifies the input files for FastQC. The ./ represents the current directory, and *.fq.gz is a wildcard that matches all files with the extension .fq.gz (compressed FASTQ files).

-o ../fastqc_raw: This option specifies the output directory where FastQC will save the results. In this case, it's set to ../fastqc_raw, indicating that the results will be saved in a directory named fastqc_raw one level up from the current directory.

--nogroup: This option tells FastQC not to generate an additional data file containing the results for each individual sequence. Instead, it will generate a single report for all sequences in the input files.

## HTML Reports

The main output is a set of HTML reports that can be opened in a web browser. These reports contain various modules assessing different aspects of the sequencing data quality, such as per-base sequence quality, per-sequence quality scores, GC content distribution, sequence length distribution, adapter content, duplication.

The summary section in the HTML reports provides an overall assessment of the data quality, highlighting any potential issues or areas of concern.

* Basic statistics 
Shows the number of reads and the length, as well as the GC content. 
The GC content must be the same as the GC content in the original organism, since this value is characteristic of every species.
If the GC content is significantly different, there could be cross contamination. 

* Per base sequence quality
It represents the quality of every position in each one of the reads (from the very first nt to the last one).
    + There are three areas: green (very good quality), yellow (dubious quality), red (bad quality). For each base of the sequence, a boxplot is generated. The IQR should be all in the green area, meaning that the vast majority of the sequences have a good quality. It is fine if punctually there are minimums in the yellow or red area.

    + "Phred Quality Score," The Phred score is a way to express the accuracy of a base call in a convenient scale. A higher Phred score indicates a higher probability that the base call is correct. 

        + For example, a Phred score of 30 corresponds to an error probability of 10^-3 or 1 in 1000 , meaning there is a 0.1% chance that the base call is incorrect. Q30 is often considered sufficient for many genomics applications, including variant calling and genome assembly.
        + A Phred score of 20 corresponds to an error probability of 10^-2 or 1 in 100. While Q20 is considered a moderate quality score, it may still be acceptable for certain applications, especially if higher coverage compensates for lower individual base quality.

* Per base sequence content: this plot represents the percentage of every base (% of A,C,G,T) vs the position in the sequence/read. On the 5' end of the reads it is common to observe some distortion, meaning variability in the base composition. This is due to the non optimal elimination of the adapter in this end during the sequencing process using Illumina technology, because differently from the 3' end, the 5' end is not always eliminated correctly. 

* Adapter content
The adapter content ought to be low. The adapters are frequently removed by the sequencing company. If not, the adapters must be trimmed or we may want to perform an additional adapter removal step.
This would result in low adapter content in the FastQC report.

* Duplication
The duplication section might alert of duplicated sequences. However, this is considered normal in RNA-seq studies, since some transcripts are supposed to be either expressed than others or whose genes appear in a higher copy number in the genome. These transcripts may be considered as overrepresented compared to other transcripts with lower expression or copy number and therefore identified as duplications. 

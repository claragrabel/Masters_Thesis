# Performing Quality Control with FastQC

We will proceed with the fastqc of the raw reads

### Creating an environment for fastqc

```{bash}
mamba create -n env_fastqc

mamba activate env_fastqc

mamba install -c bioconda fastqc

# to check if it was installed correctly: 
which fastqc
fastqc --version
fastqc -h 
```

## fastqc command

```{bash}
fastqc ./*.fq.gz -o ../fastqc_raw --nogroup
```

fastqc: This is the command to execute FastQC.

./*.fq.gz: specifies the input files for FastQC
-o ../fastqc_raw: specifies the output directory where FastQC will save the results
--nogroup: this option tells FastQC not to generate an additional data file containing the results for each individual sequence. Instead, it will generate a single report for all sequences in the input files.

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

* Per base sequence content: this plot represents the percentage of every base (% of A,C,G,T) vs the position in the sequence/read. On the 5' end of the reads it is common to observe some distortion, meaning variability in the base composition. This is due to the biased selection of random adapters in the sequencing processes of Next Generation Sequencing technologies.

_Biased fragmentation: Any library which is generated based on the ligation of random hexamers or through tagmentation should theoretically have good diversity through the sequence, but experience has shown that these libraries always have a selection bias in around the first 12bp of each run. This is due to a biased selection of random primers, but doesn't represent any individually biased sequences. Nearly all RNA-Seq libraries will fail this module because of this bias, but this is not a problem which can be fixed by processing, and it doesn't seem to adversely affect the ablity to measure expression._

* Adapter content
The adapter content ought to be low. The adapters are frequently removed by the sequencing company. If not, the adapters must be trimmed or we may want to perform an additional adapter removal step.
This would result in low adapter content in the FastQC report.

* Duplication
The duplication section might alert of duplicated sequences. However, this is considered normal in RNA-seq studies, since some transcripts are supposed to be either expressed than others or whose genes appear in a higher copy number in the genome. These transcripts may be considered as overrepresented compared to other transcripts with lower expression or copy number and therefore identified as duplications.

_In RNA-Seq libraries sequences from different transcripts will be present at wildly different levels in the starting population. In order to be able to observe lowly expressed transcripts it is therefore common to greatly over-sequence high expressed transcripts, and this will potentially create large set of duplicates. This will result in high overall duplication in this test, and will often produce peaks in the higher duplication bins._

* Overrepresented Sequences
This section can be interpreted similarly to the duplication section.

_This module will often be triggered when used to analyse small RNA libraries where sequences are not subjected to random fragmentation, and the same sequence may natrually be present in a significant proportion of the library._


References:
https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/

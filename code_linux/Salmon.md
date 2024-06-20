---
layout: minimal
---

# Salmon

We used Salmon for quantifying transcript abundances from RNA-seq data. Salmon  performs both mapping and quantification of RNA-seq reads using a quasi-mapping approach. Instead of performing detailed base-by-base alignments as in traditional mapping, quasi-mapping matches k-mers (short, fixed-length substrings) from the reads to the indexed transcriptome. Once k-mers are matched, reads are assigned to transcripts probabilistically. The likelihood of a read originating from a particular transcript is calculated based on the number of matching k-mers and their distribution. Hence, a read can be fractionally assigned to multiple transcripts taking into account read ambiguity, sequencing errors, and biases inherent in the RNA-seq data; rather than forcing a binary single exact match.

### Creating an environment for salmon

```bash
mamba create -n env_salmon
mamba activate env_salmon
```

### Installing salmon

```bash
conda install -c bioconda salmon
```

## Indexing the Reference Genome and Transcriptome

When mapping RNA-seq reads, sometimes reads may map to similar or repetitive sequences in the genome that are not actual transcripts. This can lead to incorrect mapping and quantification. To improve mapping accuracy, we can create a combined reference (gentrome) that includes both the transcriptome and the genome, and use a decoy file to help salmon identify and ignore non-specific mappings.
False positives can be reduced because the decoy list contains sequences from the genome that are similar to the transcript sequences but are not part of the actual transcriptome. These decoys help salmon ignore reads that could incorrectly map to the transcriptome due to sequence similarity.
Also, including the genome can help distinguish reads that come from repetitive regions of the genome and reads that map to multiple similar transcripts.


### Prepare for Salmon indexing 

Salmon indexing requires the names of the genome targets, which is extractable by using the grep command.

* Setting the directory for the genome.

```bash
PCU23=~/ecoevodevo/project_files/genomes/Pelobates_cultripes/Pcu23_genome/
```
* Get names of genome scaffolds (pieces of the genome)

```bash
grep "^>" <(gunzip -c $PCU23/Pcu23.ss.fa.gz) | cut -d " " -f 1 > decoys.txt
# Looking for lines starting with > (lines with > in fasta format are the headers of the sequences) in the uncompressed genome file.
# Extracting the first word (separated by space) from each header line and saves it to decoys.txt. These are the scaffold names.
sed -i.bak -e 's/>//g' decoys.txt
# Removing the > from the scaffold names in decoys.txt. -i.bak creates a backup of the original decoys.txt 
```

The decoys.txt file lists all the genome scaffolds, helping salmon to recognize which sequences in the combined gentrome are from the genome (potential decoys) and should be treated with caution to avoid non-specific mappings.

* Concatenate transcriptome to genome

```bash
cat Pcu23.transcriptome.mod.fa $PCU23/Pcu23.ss.fa > Pcu23.gentrome.fa
```

## Index with Salmon

```bash
salmon index -t Pcu23.gentrome.fa -d decoys.txt -p 12 -i Pcu23.salmon.index --gencode
salmon index: This command is used to create an index for quasi-mapping of RNA-seq reads with salmon.
```

## Quantification with Salmon

We created a script for automating for multiple samples

```bash
SAMPLE=$1
THREADS=20

mkdir $SAMPLE".salmon.quant"

salmon quant \
--libType A \
--index Pcu23.salmon.index \
--mates1 ~/datos/tfm_clara/ribodetector_all_samples/$SAMPLE"_1.fq.gz" \
--mates2 ~/datos/tfm_clara/ribodetector_all_samples/$SAMPLE"_2.fq.gz" \
--output $SAMPLE".salmon.quant" \
--threads $THREADS \
--geneMap Pcu23.transcriptome.mod.genemap \
--validateMappings \
--writeMappings=$SAMPLE".salmon.sam" \
&> $SAMPLE".salmon.log.txt"

pigz -p $THREADS -5 $SAMPLE".salmon.sam"
```

* Variables
SAMPLE=$1: Will store the names of the samples given to the script.

* Inputs:

  + --libType A: Lets salmon identify the type of library
  + --index: path to the salmon index
  + --mates1 and --mates2: paths to the paired-end FASTQ files for the sample
  + --geneMap: path to the genemap file
  + --validateMappings: Flag to enable more sensitive and accurate mapping. Is generally recommended for all datasets.
  + --writeMappings=$SAMPLE".salmon.sam": write the mappings (alignments) to a sam file

* pigz to compress the resulting sam files and reduce their size


### Salmon counts with decimals

Due to the nature of salmon (quasi-mapping), if there is a read that could map to several transcripts, it doesn't force map against one only transcript but instead divides the probability of that read to map against the possible transcripts, and the transcripts have fractional abundances. Therefore, the counts matrix has decimals.


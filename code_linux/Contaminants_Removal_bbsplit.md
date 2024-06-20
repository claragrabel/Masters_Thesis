---
layout: page
---

# Contaminants removal with bbsplit.sh (from BBMap)

## Introducing bbsplit

It is important to remove DNA or RNA contamination from samples, since contamination leads to lower-quality results and might affect results and worsen their reliability.

The most common contaminants in DNA or RNA sequencing is human and bacterial.

We used the tool bbsplit from the BBMap package. This tool maps reads to multiple references simultaneously our sequences (such as human or bacterial) and outputs mapped and unmapped reads (which would be the clean reads) in separate files.

We used the masked human genome and bacterial genomes as contaminants references.
The human genome was masked with BBMask by the author of the BBMap tools to address the following gaps that had been observed:

* Contaminants in the Human Reference: The human reference genome (HG19) itself contains sequences from other organisms.
* Highly Conserved Features: Ribosomal RNA and other conserved regions show high nucleotide identity across different species, including plants and fungi, leading to false positives.
* Low-Complexity Sequences: Repetitive sequences such as ACACAC... are common across many organisms, again causing false positives.
These false positives could disrupt assemblies, breaking at places homologous to human sequences and missing essential features.

The masking process involved three methods:

* Short Kmer Repeats: Masking regions with multiple short kmer repeats.
* Low Entropy Windows: Masking regions with low complexity or low entropy, identified by analyzing pentamer frequencies.
* Cross-Species Mapping: Using a comprehensive set of fungal, plant, and other genomes, including danio rerio and the entire Silva ribosomal database, to identify and mask regions in the human genome that align with these sequences at high identity (minimum 85%).
This resulted in masking less than 1.4% of the human genome, leaving 98.6% of it intact for capturing human reads.


First, the reference genomes must be indexed, and then our reads can be mapped against the indexed references.

```{bash}
echo "This script maps the reads against several bacteria and the human"
echo "genome. The outputs are fq.gz files for the sequences that mapped"
echo "against the contaminats references, and files for unmapped sequences"
echo "which are the clean samples."
echo ""
echo "Usage:"
echo ""
echo "bash contamination_removal.sh clean_data_foldername R1_ending"
echo ""
echo "* raw paired end data has no uniform ending for filenames R1_ending may be _R1.fq.gz, _R1_.fastq.gz, _1.fastq.gz, etc"
echo ""
echo ""
echo "###########################################"
echo "# Separating contaminants with bbsplit.sh #"
echo "###########################################"
echo ""

# Create folder for decontaminated reads
mkdir contamination_screen

# Switch to input folder given by first argument $1
cd $1

# R1 ending pattern is given in $2
patternI1=$2
read1="_1.fq.gz"
readH="_#.fq.gz"

# Set the references for the contaminants

ref_1="fusedEPmasked2.fa.gz"
ref_2="hg19_main_mask_ribo_animal_allplant_allfungus.fa.gz"

# RAM for bbduk.sh
RAM="-Xmx32g"

# Remove adapters with bbduk, single round
for file in *$patternI1; do
	echo "Separating contaminants: "${file//$patternI1/}
	bbsplit.sh $RAM in=${file//$patternI1/$readH} \
	basename=../contamination_screen/${file//$patternI1/_%.fq.gz} \
	outu=../contamination_screen/${file//$patternI1/$readH} \
	ref=../contaminants/ep/$ref_1,../contaminants/ribo/$ref_2 \
	minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 \
	refstats=../contamination_screen/${file//$patternI1/.bbsplit.refstats.txt} \
	scafstats=../contamination_screen/${file//$patternI1/.bbsplit.scafstats.txt} \
	&>../contamination_screen/${file//$patternI1/.bbsplit.contaminants.log.txt}
	echo "Result:"
	column -t ../contamination_screen/${file//$patternI1/.bbsplit.refstats.txt}
	echo ""
done

cd ..

echo "Done."

```

As for the prameters:

* minid= sets the minimum identity percentage for a match to be considered valid. In this case, it is set to 95%, meaning only reads that match the reference with at least 95% identity will be considered as mapped.
* maxindel= specifies the maximum number of insertions or deletions allowed in the alignment. Here, it is set to 3, allowing for small indels.
* bwr= (bandwidth ratio) and bw= (bandwidth) control the sensitivity and speed of the alignment. These settings balance the trade-off between the alignment speed and sensitivity.
* quickmatch fast: flags to increase the speed of the alignment process, potentially at the cost of some sensitivity.
* minhits= minimum number of hits required for a read to be considered mapped. In this case, it is set to 2.
* refstats= specifies the output file for reference statistics. 
* scafstats= specifies the output file for scaffold statistics, saved in a similar manner to refstats.
* &>../contamination_screen/${file//$patternI1/.bbsplit.contaminants.log.txt}: saving a log for the each sample running process

References:

https://github.com/BioInfoTools/BBMap/blob/master/sh/bbsplit.sh
https://www.seqanswers.com/forum/bioinformatics/bioinformatics-aa/35881-introducing-bbsplit-read-binning-tool-for-metagenomes-and-contaminated-libraries

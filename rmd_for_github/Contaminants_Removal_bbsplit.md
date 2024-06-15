# Contaminants removal with bbsplit.sh (from BBMap)

## Introducing bbsplit


It is important to remove DNA or RNA contamination from samples, since contamination leads to lower-quality results and might affect results and worsen their reliability.

The most common contaminants in DNA or RNA sequencing is human and bacterial.

We used the tool bbsplit from the BBMap package. This tool maps reads to multiple references simultaneously our sequences (such as human or bacterial) and outputs mapped and unmapped reads (which would be the clean reads) in separate files.

First, the reference genomes must be indexed, and then our reads can be mapped against the indexed references.



References:

https://github.com/BioInfoTools/BBMap/blob/master/sh/bbsplit.sh
https://www.seqanswers.com/forum/bioinformatics/bioinformatics-aa/35881-introducing-bbsplit-read-binning-tool-for-metagenomes-and-contaminated-libraries
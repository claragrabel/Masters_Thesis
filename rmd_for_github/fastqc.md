# Understanding fastqc

+ Basic statistics 
Shows the number of reads and the length, as well as the GC content. 
It is very important that the GC content is the same as the GC content in the original organism, since this value is characteristic of every species.
If the GC content is different, there is cross contamination. The most common contamination sources are bacterial ARN and human ARN.

+ Per base sequence quality
Represents quality vs position in the reads (from the very first nt to the last one). It represents the quality of every position in each one of the lecturas (reads?, sequences better instead of reads) 25827581 sequences in the case of Bui1H9_1.fq.gz. There are three areas: green (very good quality), yellow (suspicious/dubious quality), red (bad quality). For each base of the sequence, a boxplot is generated. The IQR (recorrido intercuartílico) should be all in the green area, meaning that the vast majority of the sequences have a good quality. It is fine if punctually there are minimums in the yellow or red area.

    + "Phred Quality Score," is a numerical representation of the quality of a base call in DNA sequencing. Phred scores are often reported in modules related to base quality. For example, you may find information in the "Per Base Sequence Quality" module. Q=−10×log10(P)

Where:
Q is the Phred score.
P is the probability of the base call being incorrect.

The Phred score is a way to express the accuracy of a base call in a convenient scale. A higher Phred score indicates a higher probability that the base call is correct. 

+ For example, a Phred score of 30 corresponds to an error probability of 10^-3 or 1 in 1000 , meaning there is a 0.1% chance that the base call is incorrect. Q30 is often considered sufficient for many genomics applications, including variant calling and genome assembly.
Phred Score of 20 (Q20):

+ A Phred score of 20 corresponds to an error probability of 10^-2 or 1 in 100. While Q20 is considered a moderate quality score, it may still be acceptable for certain applications, especially if higher coverage compensates for lower individual base quality.
Higher Phred Scores (Q40 and above):

Phred scores above 40 (Q40) represent extremely high-quality base calls, with error probabilities less than 10^-4 or 1 in 10,000. These scores are often seen in high-throughput sequencing technologies with robust base-calling accuracy.


+ Per base sequence content: this plot represents the percentage of every base (% of A,C,G,T) vs the position in the sequence/read. On the 5' end of the reads there is always some distortion, meaning variabilidy in the base composition. This is due to the non optimal elimination of the adapter in this end, because differently from the 3' end, the 5' end is not always eliminated correctly. If the distortion is minimun (around ~50 of an average value of 45)

    + In eukaryotes we expect a higher % of AT than GC and the lines should be more or less stable. 
Even tho the adapters had already been trimmed because the reads were clean (by the sequencing company), the 5' end had fluctuations in the % of bases.  



Mixed Samples: If your dataset is a mixture of samples with varying library sizes, it could be that most of your samples have no adapter contamination, but a few do. In aggregation, even a small number of contaminated samples could manifest as a slight increase in the combined plot.



Sequencing Reads and Adapter Sequences
During the preparation of libraries for sequencing, short DNA sequences known as adapters are ligated to the ends of the DNA fragments. These adapters serve several purposes:

They provide a binding site for the DNA to attach to the sequencing flow cell.
They include primer sequences needed for the sequencing reaction to initiate.
They may contain barcodes or indices that allow for the identification of different samples when pooled together.
Adapter Contamination
Ideally, the sequencing reads should represent only the actual DNA or RNA insert of interest. However, if the insert size (the actual DNA or RNA fragment you're interested in sequencing) is smaller than the read length that the sequencing machine is set to generate, the sequencer will continue sequencing into the adapter sequence once it has finished reading through the insert.

Here's a step-by-step explanation of how this happens:

Short Inserts: Let's say you have a DNA insert that is 50 base pairs (bp) long, but your sequencer is set up to generate reads that are 100 bp long.
Sequencing Read Length: As the sequencing progresses, it will read through the entire 50 bp insert.
Continuing Past the Insert: Since the sequencer is set to read 100 bp, it will continue past the insert and into the adapter sequence ligated to the insert.
Resulting Read Composition: The resulting read will consist of 50 bp of your DNA insert followed by 50 bp of the adapter sequence.
Adapter Content in FastQC
FastQC checks each read to determine whether it contains known adapter sequences and plots this information across the read length:

At the beginning of the read (5' end), you typically see the DNA insert.
If the insert is shorter than the read length, towards the end of the read (3' end), you may start to see adapter sequences.
Interpretation of the Rising Line
Flat Line at 0%: If the DNA insert is longer than or equal to the read length, you would expect the adapter content to be 0% across the entire read length, resulting in a flat line at the bottom of the FastQC plot.
Rising Line: A rising line in the FastQC Adapter Content plot suggests that a higher proportion of reads contain adapter sequences as you look further towards the 3' end. This is indicative of many reads where the sequencer ran out of the insert to sequence and thus started sequencing into the adapter.
Why the 3' End: The reason the line rises towards the 3' end is that the sequencer starts reading from one end of the insert (5' end) and moves towards the other (3' end). If the insert were long enough, the sequencer would never reach the adapter sequence, and no rising line would be observed.
Consequences of Adapter Contamination
Adapter sequences are not part of the actual biological sample and can interfere with data analysis, especially in applications that rely on the accurate determination of the insert sequence, such as de novo assembly, variant calling, or alignment. Therefore, it's common practice to trim adapter sequences from reads before further analysis. Tools like Trimmomatic, Cutadapt, or the trim_galore wrapper can detect and remove adapter contamination based on known adapter sequences.
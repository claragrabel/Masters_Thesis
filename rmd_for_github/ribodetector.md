# ribodetector

CPU mode

requires pytorch 

  conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia


Example
ribodetector_cpu -t 20 \
  -l 100 \
  -i inputs/reads.1.fq.gz inputs/reads.2.fq.gz \
  -e rrna \
  --chunk_size 256 \
  -o outputs/reads.nonrrna.1.fq outputs/reads.nonrrna.2.fq
The above command line excutes ribodetector for paired-end reads with mean length 100 using 20 CPU cores. The input reads do not need to be same length. RiboDetector supports reads with variable length. Setting -l to the mean read length is recommended. If you need to save the log into a file, you can specify it with --log <logfile>

Note: when using SLURM job submission system, you need to specify --cpus-per-task to the number you CPU cores you need and set --threads-per-core to 1.


My code

ribodetector_cpu -t 50 \
  -l 100 \
  -i *_1.fq.gz *_2.fq.gz \
  -e rrna \
  --chunk_size 1000 \
  -o ../ribodetector/*_nonrrna_1.fq ../ribodetector/*_nonrrna_2.fq

  (In the end I run 40 cores/threads and chunk size 300)

ribodetector_cpu -t 50   -l 100   -i Bui1H9_1.fq.gz Bui1H9_2.fq.gz   -e rrna   --chunk_size 256   -o ../ribodetector/Bui1H9_nonrrna_1.fq ../ribodetector/Bui1H9_nonrrna_2.fq



Full help
usage: ribodetector_cpu [-h] [-c CONFIG] -l LEN -i [INPUT [INPUT ...]] 
  -o [OUTPUT [OUTPUT ...]] [-r [RRNA [RRNA ...]]] [-e {rrna,norrna,both,none}] 
  [-t THREADS] [--chunk_size CHUNK_SIZE] [-v]

rRNA sequence detector

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG, --config CONFIG
                        Path of config file
  -l LEN, --len LEN     Sequencing read length (mean length). Note: the accuracy reduces for reads shorter than 40.
  -i [INPUT [INPUT ...]], --input [INPUT [INPUT ...]]
                        Path of input sequence files (fasta and fastq), the second file will be considered as 
                        second end if two files given.
  -o [OUTPUT [OUTPUT ...]], --output [OUTPUT [OUTPUT ...]]
                        Path of the output sequence files after rRNAs removal (same number of files as input).
                        (Note: 2 times slower to write gz files)
  -r [RRNA [RRNA ...]], --rrna [RRNA [RRNA ...]]
                        Path of the output sequence file of detected rRNAs (same number of files as input)
  -e {rrna,norrna,both,none}, --ensure {rrna,norrna,both,none}
                        Ensure which classificaion has high confidence for paired end reads.
                        norrna: output only high confident non-rRNAs, the rest are clasified as rRNAs;
                        rrna: vice versa, only high confident rRNAs are classified as rRNA and the rest output as non-rRNAs;
                        both: both non-rRNA and rRNA prediction with high confidence;
                        none: give label based on the mean probability of read pair.
                              (Only applicable for paired end reads, discard the read pair when their predicitons are discordant)
  -t THREADS, --threads THREADS
                        number of threads to use. (default: 20)
  --chunk_size CHUNK_SIZE
                        chunk_size * 1024 reads to load each time.
                        When chunk_size=1000 and threads=20, consumming ~20G memory, better to be multiples of the number of threads..
  --log LOG             Log file name
  -v, --version         Show program's version number and exit


FAQ
What should I set for -l when I have reads with variable length?
You can set the -l parameter to the mean read length if you have reads with variable length. The mean read length can be computed with seqkit stats. This parameter tells how many bases will be used to capture the sequences patterns for classification.

How does -e parameter work? What should I set (rrna, norrna, none, both)?
This parameter is only necessary for paired end reads. When setting to rrna, the paired read ends will be predicted as rRNA only if both ends were classified as rRNA. If you want to identify or remove rRNAs with high confidence, you should set it to rrna. Conversely, norrna will predict the read pair as nonrRNA only if both ends were classified as nonrRNA. This setting will only output nonrRNAs with high confidence. both will discard the read pairs with two ends classified inconsistently, only pairs with concordant prediction will be reported in the corresponding output. none will take the mean of the probabilities of both ends and decide the final prediction. This is also the default setting.

I have very large input file but limited memory, what should I do?
You can set the --chunk_size parameter which specifies how many reads the software load into memory once.
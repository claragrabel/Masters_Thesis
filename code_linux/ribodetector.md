# Ribodetector

Ribodetector has several modes. It can be run on GPU or CPU. We chose the CPU mode.

```{bash}
%requires pytorch 
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
```

```{bash}
ribodetector_cpu -t 40 \
  -l 100 \
  -i *_1.fq.gz *_2.fq.gz \
  -e rrna \
  --chunk_size 400 \
  -o ../ribodetector/*_nonrrna_1.fq ../ribodetector/*_nonrrna_2.fq
```

* -l parameter: length parameter was set to the mean read length. All our sequences as 100nt long.

* -e parameter: this parameter is only necessary for paired end reads. When setting to rrna, the paired read ends will be predicted as rRNA only if both ends were classified as rRNA. If you want to identify or remove rRNAs with high confidence, you should set it to rrna. Conversely, norrna will predict the read pair as nonrRNA only if both ends were classified as nonrRNA. This setting will only output nonrRNAs with high confidence. both will discard the read pairs with two ends classified inconsistently, only pairs with concordant prediction will be reported in the corresponding output. none will take the mean of the probabilities of both ends and decide the final prediction. 

I have very large input file but limited memory, what should I do?
You can set the --chunk_size parameter which specifies how many reads the software load into memory once.

### Log results

Processing Progress:

The log provides updates every time a chunk of 307200 sequences is processed.
This continues incrementally, showing the progress at regular intervals until completion.

Summary Statistics:

Total Sequences Processed: 25,954,399
Non-rRNA Sequences Detected: 25,931,949
rRNA Sequences Detected: 22,450

This represents approximately 0.086% of the total sequences, which is a relatively small proportion, suggesting that the majority of your sequences are non-rRNA.
There is no immediate indication of errors or problems in the log. The process seems to have run smoothly, with consistent progress updates.
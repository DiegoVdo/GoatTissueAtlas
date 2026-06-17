#!/bin/bash

# FastQC on raw reads

fastqc rawdata/*1.fq.gz rawdata/*2.fq.gz \
  --threads 5 \
  --nogroup \
  --outdir FASTQC/

multiqc FASTQC/ -o FASTQC/multiqc/

# Raw data was trimmed by BMK using Fastp parameter：-Q -y -g -Y 10  -l 100 -b 150 -B 150 -- q30 >=85%
# FastQC after BMK trimming

fastqc trimmed/*1.fq.gz trimmed/*2.fq.gz \
  --threads 5 \
  --nogroup \
  --outdir FASTQC_TRIM/

multiqc FASTQC_TRIM/ -o FASTQC_TRIM/multiqc/

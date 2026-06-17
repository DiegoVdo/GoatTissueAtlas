# GoatTissueAtlas
This repository contains the bioinformatic workflow used for the identification, classification and quantification of long non-coding RNAs (lncRNAs) in goat tissues.
## Workflow overview

1. Raw read quality assessment using FastQC and MultiQC.
2. Removal of rRNA contamination using BBDuk and SILVA database release 138.2.
3. Genome alignment against the Capra hircus ARS1.2 reference genome using STAR.
4. Transcriptome assembly using StringTie.
5. Comparison with reference annotation using gffcompare.
6. Selection of putative lncRNA candidates based on transcript class and length.
7. Coding potential evaluation using CPC2, CPAT and LGC.
8. Protein domain filtering using HMMER and Pfam.
9. Classification and naming of novel lncRNAs.
10. Expression quantification using Kallisto.
11. Generation of gene-level count matrices using tximport.

## Reference genome

Capra hircus ARS1.2

## Software versions

FastQC v0.12

MultiQC v1.19

BBDuk v38.96

STAR v2.7.11b

SAMtools v1.8

StringTie v2.2.1

gffcompare v0.12.6

gffread v0.12.7

CPC2 v1.0.1

CPAT v3.0.4

LGC v1.0

HMMER v3.4

Kallisto v0.46.2

tximport (R package)

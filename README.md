# GoatTissueAtlas
This repository contains the bioinformatic workflow used for the identification, classification and quantification of long non-coding RNAs (lncRNAs) in goat tissues.
## Workflow overview

1. Raw read quality assessment using FastQC and MultiQC.
2. Removal of rRNA contamination using BBDuk and SILVA database release 138.2.
3. Genome alignment against the Capra hircus ARS1.2 reference genome using STAR.
4. Transcriptome assembly using StringTie and comparison with reference annotation using gffcompare.
5. Selection of putative lncRNA candidates based on transcript class and length.
6. Coding potential evaluation using CPC2, CPAT and LGC.
7. Protein domain filtering using HMMER and Pfam.
8. Classification and naming of novel lncRNAs.
9. Expression quantification using Kallisto.
10. Generation of gene-level count matrices using tximport.

## Reference genome

Capra hircus ARS1.2

## Software versions

FastQC v0.11.9

MultiQC v1.12

BBDuk v38.96

STAR v2.7.11b

SAMtools v1.22.1

StringTie v2.2.1

gffcompare v0.12.6

gffread v0.12.7

CPC2 v1.0.1

CPAT v3.0.4

LGC v1.0

HMMER v3.4

Kallisto v0.46.2

tximport (R package)

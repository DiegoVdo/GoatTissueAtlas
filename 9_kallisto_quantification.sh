#!/bin/bash

###############################################################################
# Transcript expression quantification using Kallisto
#
# Kallisto v0.46.2
###############################################################################

THREADS=4

REFERENCE_GENOME="reference/GCF_001704415.2_ARS1.2_genomic.fna"
REFERENCE_GTF="reference/genomic.gtf"

LNCRNA_GTF="lncRNAs.gtf"

INDEX="ARS1andlncRNAs.idx"

READS_DIR="rRNA"

OUTPUT_DIR="quantification"


###############################################################################
# Create combined annotation
###############################################################################

cat ${REFERENCE_GTF} ${LNCRNA_GTF} \
    > ARS1andlncRNAs.gtf



###############################################################################
# Generate transcript fasta
###############################################################################

gffread \
    -g ${REFERENCE_GENOME} \
    -w ARS1andlncRNAs.fa \
    ARS1andlncRNAs.gtf



###############################################################################
# Build kallisto index
###############################################################################

kallisto index \
    -i ${INDEX} \
    ARS1andlncRNAs.fa



###############################################################################
# Quantification
###############################################################################

mkdir -p ${OUTPUT_DIR}


while read SAMPLE

do

mkdir -p ${OUTPUT_DIR}/${SAMPLE}


kallisto quant \
    -i ${INDEX} \
    -o ${OUTPUT_DIR}/${SAMPLE} \
    -b 100 \
    -t ${THREADS} \
    --fr-stranded \
    --bias \
    ${READS_DIR}/${SAMPLE}_1.fq.gz \
    ${READS_DIR}/${SAMPLE}_2.fq.gz \
    >> kallisto.log 2>&1


done < Sample_list.txt

#!/bin/bash

###############################################################################
# Alignment of paired-end RNA-seq reads against Capra hircus ARS1.2 genome
# STAR v2.7.11b
###############################################################################

THREADS=8

GENOME_FASTA="reference/GCF_001704415.2_ARS1.2_genomic.fna"
ANNOTATION_GTF="reference/genomic.gtf"

GENOME_INDEX="genome_index"

READS_DIR="rRNA"
OUTPUT_DIR="Mapping"

###############################################################################
# Generate STAR index
###############################################################################

STAR \
    --runThreadN ${THREADS} \
    --runMode genomeGenerate \
    --genomeDir ${GENOME_INDEX} \
    --genomeFastaFiles ${GENOME_FASTA} \
    --sjdbGTFfile ${ANNOTATION_GTF} \
    --sjdbOverhang 50

###############################################################################
# Align samples
###############################################################################

while read SAMPLE
do

    STAR \
        --genomeDir ${GENOME_INDEX} \
        --readFilesIn \
        ${READS_DIR}/${SAMPLE}_1.fq.gz \
        ${READS_DIR}/${SAMPLE}_2.fq.gz \
        --readFilesCommand zcat \
        --outFileNamePrefix ${OUTPUT_DIR}/${SAMPLE}. \
        --outSAMtype BAM SortedByCoordinate \
        --outMultimapperOrder Random \
        --outSAMattrIHstart 0 \
        --twopassMode Basic

done < Sample_list.txt

###############################################################################
# BAM indexing
###############################################################################

for BAM in ${OUTPUT_DIR}/*.Aligned.sortedByCoord.out.bam
do
    samtools index -@ 4 ${BAM}
done

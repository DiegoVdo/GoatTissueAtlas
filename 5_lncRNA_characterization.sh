#!/bin/bash

###############################################################################
# Identification of candidate lncRNAs
###############################################################################

REFERENCE_GENOME="reference/GCF_001704415.2_ARS1.2_genomic.fna"

###############################################################################
# Select transcripts with class codes:
# u = intergenic
# i = intronic
# x = antisense
# o = exonic overlap
###############################################################################

awk -F "\t" '
$3=="u" || $3=="i" || $3=="x" || $3=="o"
{print $0}
' gffcmp.merged.gtf.tmap > lncRNA_candidate.tmap

###############################################################################
# Length filtering
#
# Multi-exonic transcripts:
# length >= 200 nt
#
# Single-exon transcripts:
# length >= 2000 nt
###############################################################################

awk -F "\t" '
{
    if($6>=2 && $10>=200)
        print $0
    else if($6==1 && $10>=2000)
        print $0
}
' lncRNA_candidate.tmap > tmp.tmap

mv tmp.tmap lncRNA_candidate.tmap

###############################################################################
# Extract transcript IDs
###############################################################################

awk -F "\t" '{print $5}' \
lncRNA_candidate.tmap \
> lncRNA_list.txt

###############################################################################
# Recover candidate transcripts from annotated GTF
###############################################################################

awk -F "\t" '

FNR==NR {
    keep[$1]
    next
}

{
    tx=$9

    gsub(/^transcript_id "/,"",tx)
    gsub(/".+/,"",tx)

    if(tx in keep)
        print
}

' lncRNA_list.txt gffcmp.annotated.gtf \
> lncRNA_candidate.gtf

###############################################################################
# Generate transcript FASTA
###############################################################################

gffread \
    -w lncRNA_candidate.fa \
    -g ${REFERENCE_GENOME} \
    lncRNA_candidate.gtf

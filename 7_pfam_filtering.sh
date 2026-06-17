#!/bin/bash

###############################################################################
# Protein domain filtering using HMMER/Pfam
#
# HMMER v3.4
# Pfam-A database v37.4
###############################################################################

INPUT="lncRNA_candidate.fa"

PFAM_DB="Pfam-A.hmm"


###############################################################################
# Translate transcripts into ORFs
###############################################################################

transeq \
    --sequence ${INPUT} \
    --frame F \
    --outseq lncRNA_translated.fa


###############################################################################
# Remove excessively large translated proteins
###############################################################################

awk '
/^>/ {

    if(seq && length(seq)<=100000)
        print header "\n" seq

    header=$0
    seq=""
    next
}

{
seq=seq$0
}

END {

if(seq && length(seq)<=100000)
    print header "\n" seq

}

' lncRNA_translated.fa \
> lncRNA_translated_filtered.fa



###############################################################################
# Prepare Pfam database
###############################################################################

hmmpress ${PFAM_DB}


###############################################################################
# Search protein domains
###############################################################################

hmmscan \
    --tblout lncRNA_hmmscan.persequence.txt \
    --noali \
    ${PFAM_DB} \
    lncRNA_translated_filtered.fa



###############################################################################
# Select significant domains
# E-value < 1e-5
###############################################################################

sed '1d' lncRNA_hmmscan.persequence.txt | \
awk '
$5<1e-5 && $8<1e-5
{
gsub(/_[0-9]/,"",$3)
print $3
}
' | sort -u > Pfam_hits.txt



###############################################################################
# Intersect CPC2/LGC/Pfam results
###############################################################################

grep -w ncRNA CPC2_summary.txt | \
awk '{print $1}' | sed 's/>//' > CPC2_ID.txt


grep -w ncRNA LGC_summary.txt | \
awk '{print $1}' | sed 's/>//' > LGC_ID.txt


sort CPC2_ID.txt LGC_ID.txt | uniq -d > CPC_LGC_intersection.txt


sort CPC_LGC_intersection.txt Pfam_hits.txt | uniq -d \
> lncRNA_final_list.txt

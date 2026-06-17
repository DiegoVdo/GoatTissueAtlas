#!/bin/bash

###############################################################################
# Coding potential analysis of lncRNA candidates
#
# Tools:
# CPC2 v1.0.1
# CPAT v3.0.4
# LGC v1.0
###############################################################################

INPUT="lncRNA_candidate.fa"


###############################################################################
# CPC2
###############################################################################

CPC2_PATH="CPC2.py"

python3 ${CPC2_PATH} \
    -i ${INPUT} \
    -o CPC2_results \
    > CPC2.log


###############################################################################
# LGC
###############################################################################

LGC_PATH="LGC-1.0.py"

python2.7 ${LGC_PATH} \
    ${INPUT} \
    LGC_results.txt \
    > LGC.log


###############################################################################
# CPAT
###############################################################################

CPAT_PATH="cpat.py"

HEXAMER="Human_Hexamer.tsv"
LOGIT_MODEL="Human_logitModel.RData"


${CPAT_PATH} \
    -g ${INPUT} \
    -d ${LOGIT_MODEL} \
    -x ${HEXAMER} \
    -o CPAT_results \
    > CPAT.log


###############################################################################
# Convert results to common format
###############################################################################

# CPAT

awk -F "\t" '
{
print $1"\tncRNA"
}
' CPAT_results.no_ORF.txt > CPAT_summary.txt


sed '1d' CPAT_results.ORF_prob.best.tsv | \
awk -F "\t" '
$11>=0.364 {print $1"\tprotein_coding"}
$11<0.364  {print $1"\tncRNA"}
' >> CPAT_summary.txt


# CPC2

sed '1d' CPC2_results.txt | \
awk -F "\t" '
$8=="noncoding" {print $1"\tncRNA"}
$8=="coding"    {print $1"\tprotein_coding"}
' > CPC2_summary.txt


# LGC

sed '1d' LGC_results.txt | \
awk -F "\t" '
$5=="Non-coding" {print $1"\tncRNA"}
$5=="Coding"     {print $1"\tprotein_coding"}
' > LGC_summary.txt

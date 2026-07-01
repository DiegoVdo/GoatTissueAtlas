## Gene body coverage

Gene body coverage was assessed using **RSeQC**.

### Generate a BED12 annotation

```bash
###############################################################################
# Generate BED12 annotation
###############################################################################

ANNOTATION_GTF="ARS1andlncRNAs.gtf"

gtfToGenePred \
    ${ANNOTATION_GTF} \
    ARS1andlncRNAs.genePred

genePredToBed \
    ARS1andlncRNAs.genePred \
    ARS1andlncRNAs.bed
```

### Compute gene body coverage

```bash
#!/bin/bash

###############################################################################
# Gene body coverage
#
# RSeQC
###############################################################################

BED12="ARS1andlncRNAs.bed"

MAPPING_DIR="Mapping"

OUTPUT_DIR="geneBodyCoverage"

mkdir -p ${OUTPUT_DIR}

###############################################################################
# Create BAM list
###############################################################################

while read SAMPLE
do
    echo "${PWD}/${MAPPING_DIR}/${SAMPLE}.Aligned.sortedByCoord.out.bam"
done < Sample_list.txt > bam_path.txt

###############################################################################
# Compute gene body coverage
###############################################################################

geneBody_coverage.py \
    -r ${BED12} \
    -i bam_path.txt \
    -o ${OUTPUT_DIR}/geneBodyCoverage
```

This produces a gene body coverage report for all samples listed in `bam_path.txt`.

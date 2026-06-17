# SILVA release 138.2
# BBDuk v38.96


# Remove any rRNA contamination with Silva database (Release 138.2) and bbduk (v38.96)

input_folder=/trimmed/
output_folder=/rRNA/
silva=/SILVA_DATABASE/
parallel -j 5 -a sample_list.txt "bbduk.sh -Xmx20g threads=5 \
in={2}/{1}_trimmed_1.fq.gz in2={2}/{1}_trimmed_2.fq.gz \
ref={4}/SILVA_138.2_LSURef_tax_silva_trunc.fasta.gz,{4}/SILVA_138.2_SSURef_tax_silva_trunc.fasta.gz \
out={3}/{1}_rRNA_1.fq.gz out2={3}/{1}_rRNA_2.fq.gz" \
::: ${input_folder} ::: ${output_folder} ::: ${silva}

# QC after rRNA removal

fastqc rRNA/*1.fq.gz rRNA/*2.fq.gz \
  --threads 5 \
  --nogroup \
  --outdir FASTQC_rRNA/

multiqc FASTQC_TRIM/ -o FASTQC_TRIM/multiqc/

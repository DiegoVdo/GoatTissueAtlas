#!/usr/bin/env Rscript

library("tximport")

# Required arguments:
# 1. Two column file: 1. full paths to kallisto abundance.h5 outputs; 2. Sample name.
# 2. Path to the file describing transcript gene relationships.
# 3. Output file name: txi.kallisto_name.Rdata
# Output will be generated in working directory.

# Read passed arguments
args <- commandArgs(trailingOnly=TRUE)

# test if there is three arguments: if not, return an error
if (length(args)!=3) {
  stop("Three arguments must be provided: 1. File with paths of sample abundances; 2. File with transcript/gene information; 3. Output file name.", call.=FALSE)
}

# Read input data
h5_list <- as.character(read.table(args[1], header=FALSE)[,1])
sample_list <- as.character(read.table(args[1], header=FALSE)[,2])
names(h5_list) <- sample_list
tx2gene <- read.table(args[2], header=TRUE)

# Execute tximport
txi.kallisto <- tximport(h5_list,
                         type="kallisto",
                         tx2gene=tx2gene,
                         countsFromAbundance="no")

save(txi.kallisto, file=paste0("txi.kallisto_",args[3],".Rdata"))

write.table(txi.kallisto$counts,"counts_GeneLevel.txt",
            quote=FALSE,
            sep="\t",
            row.names=TRUE,
            col.names=TRUE)
write.table(txi.kallisto$length,"length_GeneLevel.txt",
            quote=FALSE,
            sep="\t",
            row.names=TRUE,
            col.names=TRUE)

library('org.Mm.eg.db')
library('stringr')
library('tidyverse')

# Process counts data

# Load counts data
exonCount <- read.table("~/Github/Blellochlab/DSCB257/counts/Counts_unstranded.txt",
                        header = T)
exonCount$geneid <- sapply(exonCount$Geneid, function(x) as.character(str_split(x, "[.]")[[1]][1]))
exonCount$symbol <- mapIds(org.Mm.eg.db, exonCount$geneid, 'SYMBOL', 'ENSEMBL')

geneid_symbol <- dplyr::select(exonCount, geneid, symbol)
write_csv(geneid_symbol, '~/Github/Blellochlab/DSCB257/geneid_symbol.csv')

# Make the rownames equal to the gene id
rownames(exonCount) <- exonCount$geneid

# Clean up column names 
colnames(exonCount) <- gsub("E.MTAB.2958.", "",
                            gsub(".bam", "", colnames(exonCount)))
# Select just the gene counts from the matrix
exonCount <- dplyr::select(exonCount, matches("E3.5|E4.5|E5.5"))
write.table(exonCount, '~/Github/Blellochlab/DSCB257/counts_discussion.txt', quote = F)



#install.packages("dplyr")
#source("https://bioconductor.org/biocLite.R")
#biocLite("DESeq2")

library("dplyr")
library("DESeq2")

# Read gene id and gene symbol files
geneid_symbol <- read.csv('~/Github/Blellochlab/DSCB257/download/geneid_symbol.csv')

# Load counts data
counts <- read.table("~/Github/Blellochlab/DSCB257/download/counts_discussion.txt")

# Set up the sample table
sampleTable <- data.frame(row.names = colnames(exonCount),
                          stage = c('E3.5', 'E3.5', 'E3.5',
                                    'E4.5', 'E4.5', 'E4.5',
                                    'E5.5', 'E5.5', 'E5.5'))
# Run DESeq2 for differential expression
dds <- DESeqDataSetFromMatrix(countData = exonCount,
                              colData = sampleTable,
                              design = ~ stage)
dds <- DESeq(dds)

# Compare E4.5 vs E3.5 gene expression changes
E4.5_vs_E3.5 <- results(dds, contrast = c("stage", "E4.5", "E3.5"), alpha = 0.05)

# Print a summary of differential expression results
summary(E4.5_vs_E3.5)

# Convert output to a data frame for further manipulation
E4.5_vs_E3.5_dataframe <- data.frame(E4.5_vs_E3.5, geneid = rownames(E4.5_vs_E3.5))

# Add gene symbol to results data frame
E4.5_vs_E3.5_dataframe <- dplyr::inner_join(E4.5_vs_E3.5_dataframe, geneid_symbol, by = 'geneid')

E5.5_vs_E4.5 <- results(dds, contrast = c("stage", "E5.5", "E4.5"), alpha = 0.05)
summary(E5.5_vs_E4.5)

# Volcano plot


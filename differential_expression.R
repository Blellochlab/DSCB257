install.packages("dplyr")
install.packages("ggplot")
source("https://bioconductor.org/biocLite.R")
biocLite("DESeq2")

library("dplyr")
library("DESeq2")
library("ggplot")

# --------------------Interactive code ----------------------------------

# variables are defined with <-
# set x equal to 3
x <- 3
x

# set y equal to 5
y <- 5
y

# information can be stored in a vector
name <- c('Tim', 'Matt', 'Lucy', 'Michelle')
name

age <- c(22, 24, 26, 28)
age

# Data frames store tabular data in R
# data frames are used to store associated data
age_dataframe <- data.frame(names = c('Tim', 'Matt', 'Lucy', 'Michelle'), age = c(22, 24, 26, 28))
age_dataframe

# dplyr is a package that allows you to easily manipulate data frames and extract features
# filter allows you to extract specific rows that meet a criteria
filter(age_dataframe, names == 'Matt')
filter(age_dataframe, names == 'Tim')

# Can filter based on whether multiple values are in a vector
filter(age_dataframe, names %in% c('Tim', 'Matt'))

# Subsets can be saved to a new data frame  
boys_ages <- filter(age_dataframe, names %in% c('Tim', 'Matt'))
boys_ages

# -----------------------------------------------------------
# -----------------Pre set code for DESeq -------------------
# Read gene id and gene symbol files
# Replace with download location on your computer
geneid_symbol <- read.csv('~/Github/Blellochlab/DSCB257/download/geneid_symbol.csv')

# Load counts data
# Replace with download location on your computer
counts <- read.table("~/Github/Blellochlab/DSCB257/download/counts_discussion.txt")

# Set up the sample table
sampleTable <- data.frame(row.names = colnames(counts),
                          stage = c('E3.5', 'E3.5', 'E3.5',
                                    'E4.5', 'E4.5', 'E4.5',
                                    'E5.5', 'E5.5', 'E5.5'))

# Run DESeq2 for differential expression
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = sampleTable,
                              design = ~ stage)
dds <- DESeq(dds)

# ------------- Results -----------------------------
# Compare E4.5 vs E3.5 gene expression changes
E4.5_vs_E3.5 <- results(dds, contrast = c("stage", "E4.5", "E3.5"), alpha = 0.05)

# Convert output to a data frame for further manipulation
E4.5_vs_E3.5_dataframe <- data.frame(E4.5_vs_E3.5, geneid = rownames(E4.5_vs_E3.5))

# Remove genes that did not get an adjusted p value
E4.5_vs_E3.5_dataframe <- filter(E4.5_vs_E3.5_dataframe, padj != 'NA')

# Add gene symbol to results data frame
E4.5_vs_E3.5_dataframe <- dplyr::inner_join(E4.5_vs_E3.5_dataframe, geneid_symbol, by = 'geneid')
# --------------------------------------------------------------------

# --------------------Interactive code ----------------------------------

# Exploring E4.5 vs E3.5 gene expression changes

# head command allows you to view the top several lines of a data frame
head(E4.5_vs_E3.5_dataframe)

# This is the results of the RNA-seq data
# We are most interested in log2FoldChange, padj (the adjusted p-value), and the gene symbol
# This data frame contains significant and non significant results
# Lets filter for significant changes
significant <- filter(E4.5_vs_E3.5_dataframe, padj < 0.05)

# nrow gives the number of rows in a data frame
age_dataframe
nrow(age_dataframe)

# 1) How many significant genes change? (hint: each row in significant dataframe is a gene)

# 2) How many significant genes are upregulated and how many are downregulated?
# (hint: filter on log2FoldChange)

# We can order data using the arrange command, which takes a data frame and what we want to order by
arrange(age_dataframe, age)
# If we want to reverse the order 
arrange(age_dataframe, -age)

# 3) What is the most upregulated gene by fold change? The most significant by adjusted p value?

# 4) Looking at the code for the results section above, can you generate a data frame of
# gene expression changes for E5.5 vs E4.5?

#############################################
# Compare E5.5 vs E4.5 gene expression changes
E5.5_vs_E4.5 <- results(dds, contrast = c("stage", "E5.5", "E4.5"), alpha = 0.05)

# Convert output to a data frame for further manipulation
E5.5_vs_E4.5_dataframe <- data.frame(E5.5_vs_E4.5, geneid = rownames(E5.5_vs_E4.5))

# Remove genes that did not get an adjusted p value
E5.5_vs_E4.5_dataframe <- filter(E5.5_vs_E4.5_dataframe, padj != 'NA')

# Add gene symbol to results data frame
E5.5_vs_E4.5_dataframe <- dplyr::inner_join(E5.5_vs_E4.5_dataframe, geneid_symbol, by = 'geneid')
####################################################

# We can generate a number of plots using ggplot
# ggplot takes a dataframe, a set of x values, a set of y values, and a plot type
age_dataframe
# To plot each person's age
ggplot(age_dataframe, aes(x = names, y = age)) + geom_bar(stat = 'identity')

# Based on the paper or Robert's lecture, pick 6 genes that you would expect to change between
# E4.5 and E5.5

# 5) Generate a data frame of significant changes, filter based on the gene names, plot the fold change


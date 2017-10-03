library('tidyverse')
library('edgeR')
theme_set(theme_classic())

# Load counts data
exonCount <- read.table('~/Github/Blellochlab/DSCB257/counts/Counts_unstranded.txt',
                        header = T)
rownames(exonCount) <- exonCount$Geneid
colnames(exonCount) <- gsub('E.MTAB.2958.', '',
                            gsub('.bam', '', colnames(exonCount)))
exonCount <- dplyr::select(exonCount, matches('E3.5|E4.5|E5.5'))

count_mat <- as.matrix(exonCount)
count_mat_filtered <- count_mat[rowSums(cpm(count_mat) > 5) >= 3, ]
lcpm <- log2(cpm(count_mat_filtered) + .5)

# PCA
pca <- prcomp(t(lcpm))
pca_df <- data.frame(samples = c(rep('E3.5', 3), rep('E4.5', 3), rep('E5.5', 3)), pca$x[,1:2])
ggplot(pca_df, aes(x = PC1, y = PC2, color = samples)) + geom_point(size = 4) +
  xlab(paste0('PC1: ', round(summary(pca)$importance[2,1]*100, 0),'% Variance')) +
  ylab(paste0('PC2: ', round(summary(pca)$importance[2,2]*100, 0),'% Variance'))
ggsave('~/Dropbox/dscb257/paper_pca.pdf', width = 4, height = 4)

#Clustering
library('dendextend')
dend <- as.dendrogram(hclust(dist(t(lcpm))))
labels_colors(dend) <- c(rep('red', 3), rep('blue', 3), rep('black', 3))
labels(dend) <- c(rep('E3.5', 3), rep('E5.5', 3), rep('E4.5', 3))
plot(dend)
  
d <- dist(t(lcpm))
plot(hclust(d), hang = -1)


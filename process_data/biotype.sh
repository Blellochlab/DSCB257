#!/bin/bash
#PBS -V
#PBS -l nodes=1:ppn=1,vmem=25gb,walltime=2:00:00
#PBS -M jfreimer+mason@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -t 1-9

# Load conda programs
source activate stable

# set up directories
DIR=/N/dc2/projects/RNAMap/jake/dscb257

mkdir -p ${DIR}/biotype
mkdir -p ${DIR}/biotype_tmp
cd ${DIR}/biotype_tmp

SAMPLE=$(awk -v line=${PBS_ARRAYID} '{if (NR == line) { print $1 }}' ../sampleList.txt)

# Count over biotypes
# Unique counts
featureCounts -a /N/dc2/projects/RNAMap/jake/genome_ercc/gencode.vM14.basic.rRNA.biotype.gtf -g gene_type -s 2 -o ${SAMPLE}_biotype_unique.txt ${DIR}/E-MTAB-2958.${SAMPLE}.bam

echo "# section_name: 'featureCounts Biotype'" > ${SAMPLE}_unique_biotype_counts_mqc.txt
cut -f 1,7 ${SAMPLE}_biotype_unique.txt | tail -n +3 >> ${SAMPLE}_unique_biotype_counts_mqc.txt

# Multimapper counts
featureCounts -a /N/dc2/projects/RNAMap/jake/genome_ercc/gencode.vM14.basic.rRNA.biotype.gtf -g gene_type -s 2 -M --fraction -o ${SAMPLE}_biotype_multi.txt ${DIR}/E-MTAB-2958.${SAMPLE}.bam

echo "# section_name: 'featureCounts Biotype'" > ${SAMPLE}_multi_biotype_counts_mqc.txt
cut -f 1,7 ${SAMPLE}_biotype_multi.txt | tail -n +3 >> ${SAMPLE}_multi_biotype_counts_mqc.txt

# Move final count to ther folder
mv ${SAMPLE}_unique_biotype_counts_mqc.txt ${DIR}/biotype/
mv ${SAMPLE}_multi_biotype_counts_mqc.txt ${DIR}/biotype/
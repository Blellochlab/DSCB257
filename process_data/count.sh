#!/bin/bash
#PBS -S /bin/bash
#PBS -V
#PBS -l nodes=1:ppn=1,vmem=25gb,walltime=2:00:00
#PBS -M jfreimer+mason@gmail.com
#PBS -m abe
#PBS -j oe

# Load conda programs
source activate stable

cd /N/dc2/projects/RNAMap/jake/dscb257

INPUT=$(find *.bam)

featureCounts -a /N/dc2/projects/RNAMap/jake/genome_ercc/gencode.vM14.basic.annotation.gtf -s 1 -o Counts_s1.txt ${INPUT}
featureCounts -a /N/dc2/projects/RNAMap/jake/genome_ercc/gencode.vM14.basic.annotation.gtf -s 2 -o Counts_s2.txt ${INPUT}
featureCounts -a /N/dc2/projects/RNAMap/jake/genome_ercc/gencode.vM14.basic.annotation.gtf -o Counts_unstranded.txt ${INPUT}
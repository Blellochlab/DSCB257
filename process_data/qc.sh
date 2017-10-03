#!/bin/bash
#PBS -V
#PBS -l nodes=1:ppn=1,vmem=25gb,walltime=8:00:00
#PBS -M jfreimer+mason@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -t 1-9

# Load conda programs
source activate stable

# set up directories
DIR=/N/dc2/projects/RNAMap/jake/dscb257

mkdir -p ${DIR}/fastqc
cd ${DIR}/fastq

INPUT=$(awk -v line=${PBS_ARRAYID} '{if (NR == line) { print $1 }}' ../sampleList.txt)
BED=/N/dc2/projects/RNAMap/jake/genome_ercc/rseqc/mm10_GENCODE_VM11_basic.bed

# Check fastq files (after trimming) with fastqc
fastqc --outdir=${DIR}/fastqc/ ${INPUT}_1.fastq.gz
fastqc --outdir=${DIR}/fastqc/ ${INPUT}_2.fastq.gz

# Run RSeQC
source activate python2

# QC bam files with rseqc
mkdir -p ${DIR}/rseqc
cd ${DIR}/rseqc

samtools index ${DIR}/E-MTAB-2958.${INPUT}.bam

geneBody_coverage.py -r ${BED} -i ${DIR}/E-MTAB-2958.${INPUT}.bam -o ${INPUT}

read_distribution.py -i ${DIR}/E-MTAB-2958.${INPUT}.bam -r ${BED} > ${INPUT}_distribution.txt

read_GC.py -i ${DIR}/E-MTAB-2958.${INPUT}.bam -o ${INPUT}

read_duplication.py -i ${DIR}/E-MTAB-2958.${INPUT}.bam -o ${INPUT}

infer_experiment.py -r ${BED} -i ${DIR}/E-MTAB-2958.${INPUT}.bam

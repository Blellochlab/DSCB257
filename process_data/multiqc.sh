#!/bin/bash
#PBS -V
#PBS -l nodes=1:ppn=1,vmem=15gb,walltime=0:30:00
#PBS -M jfreimer+mason@gmail.com
#PBS -m abe
#PBS -j oe

# Load conda programs
source activate python2

# set up directories
DIR=/N/dc2/projects/RNAMap/jake/dscb257

mkdir -p ${DIR}/multiqc
cd ${DIR}/

multiqc -f -o ${DIR}/multiqc . --ignore bam_multi --ignore biotype_tmp
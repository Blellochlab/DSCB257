#!/bin/bash
#PBS -S /bin/bash
#PBS -V
#PBS -l nodes=1:ppn=1,vmem=10gb,walltime=6:00:00
#PBS -M jfreimer+mason@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -t 1-18

cd /N/dc2/projects/RNAMap/jake/dscb257/fastq

FILES=$(awk -v line=${PBS_ARRAYID} '{if (NR == line) { print $2 }}' fastqList.txt)

wget ${FILES}
#!/bin/bash
#PBS -S /bin/bash
#PBS -V
#PBS -l nodes=1:ppn=1,vmem=10gb,walltime=1:00:00
#PBS -M jfreimer+mason@gmail.com
#PBS -m abe
#PBS -j oe
#PBS -t 1-9

cd /N/dc2/projects/RNAMap/jake/dscb257/fastq

NAME=$(awk -v line=${PBS_ARRAYID} '{if (NR == line) { print $1 }}' sampleList.txt)
ID=$(awk -v line=${PBS_ARRAYID} '{if (NR == line) { print $2 }}' sampleList.txt)

mv ${ID}_1.fastq.gz ${NAME}_1.fastq.gz
mv ${ID}_2.fastq.gz ${NAME}_2.fastq.gz
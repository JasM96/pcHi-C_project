#!/bin/bash --login
###
#SBATCH --partition=htc
#SBATCH --account=<project_account>
#SBATCH --job-name=align
#SBATCH --output=OUT/align.out.%J
#SBATCH --error=ERR/align.err.%J
#SBATCH --time=0-01:30
#SBATCH --ntasks=40 
#SBATCH --mem-per-cpu=8000 
#SBATCH --ntasks-per-node=40
###

# bin directory as working directory
working=${pwd}
# pre indexed reference genome
preindex_hg38=../resources/GRCh38.primary_assembly.genome.fa
# hg38 files directory
hg38=../hg38

# load modules
module load samtools
module load bwa

# pre-alignment

# transfer pre indexed hg38 reference genome to hg38 directory
cp $preindex_hg38 $hg38
ref_hg38=../hg38/GRCh38.primary_assembly.genome.fa
# create .fai index of reference
samtools faidx $ref_hg38
cut -f1,2 $ref_hg38.fai > $hg38/hg38.genome
# index the reference genome
bwa index $hg38/$ref_hg38

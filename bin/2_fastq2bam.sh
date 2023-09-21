#!/bin/bash --login 
###
#SBATCH --partition=htc
#SBATCH --account=<project_account>
#SBATCH --job-name=fq2bm
#SBATCH --output=OUT/fq2bm.out.%J
#SBATCH --error=ERR/fq2bm.err.%J
#SBATCH --time=0-10:00
#SBATCH --mem-per-cpu=8000
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
###

# ENVIRONMENT SETUP

# working directory
working=${pwd}

# hg38 files
indexed_hg38_fasta=../hg38/GRCh38.primary_assembly.genome.fa
hg38_genome=../hg38/hg38.genome

# tmp dir
tmp=../tmp
# Fastq R1 and R2 location
Fastq=../resources
# Sample 1
R1=$Fastq/<R1>.fastq.gz
R2=$Fastq/<R2>.fastq.gz

# from fastq to bam files

# Enter tmp directory
cd $tmp

# load module packages
module load bwa
module load samtools

# alignment
bwa mem -5SP -T0 -t16 $indexed_hg38_fasta $R1 $R2 -o aligned_hg38.sam

# recording valid ligation events
python3 -m pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 \
--nproc-in 8 --nproc-out 8 --chroms-path $hg38_genome aligned_hg38.sam > parsed_hg38.pairsam

# sorting the pairsam file
python3 -m pairtools sort --nproc 16 --tmpdir=$tmp/ parsed_hg38.pairsam > sorted_hg38.pairsam

# remove PCR duplicates
python3 -m pairtools dedup --nproc-in 8 --nproc-out 8 --mark-dups --output-stats hg38_Stats.txt --output dedup_hg38.pairsam sorted_hg38.pairsam

# generating .pairs and bam files
python3 -m pairtools split --nproc-in 8 --nproc-out 8 --output-pairs mapped_hg38.pairs --output-sam unsorted_hg38.bam dedup_hg38.pairsam

# generating the dedup, sorted bam file
samtools sort -@ 16 -T $tmp -o mapped_hg38_PT.bam unsorted_hg38.bam
samtools index mapped_hg38_PT.bam

# CHiCAGO compatible bam file
samtools view -@ 16 -Shu -F 2048 mapped_hg38_PT.bam|samtools sort -n -T $tmp --threads 16 -o CHiCAGO_hg38.bam -
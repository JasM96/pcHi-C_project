# pcHi-C_project
Pipeline designed to conduct promoter capture Hi-C interaction calling using CHiCAGO.

## System Requirements

* Supercomputing remote server scratch directory
* SLURM workflow manager available

## File Requirements
* reference genome.fa file
* R1.fastq.gz and R2.fastq.gz paired-end pcHi-C RNA-Seq sample files acquired from pcHi-C protocols

## Repository Requirements
* CHiCAGO: https://github.com/dovetail-genomics/chicago.git
* Dovetail Genomics: https://github.com/dovetail-genomics/capture.git

## Software/Package Requirements
* Python
* Packages: BWA, Samtools, Pairtools, mosdepth, bedtools
* R package: argparser
  * BioConductor packages (R): Delaporte, Chicago, Rsamtools

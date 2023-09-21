#!/bin/bash --login 
###
#SBATCH --partition=htc
#SBATCH --account=scw1684
#SBATCH --job-name=QC
#SBATCH --output=OUT/QC.out.%J
#SBATCH --error=ERR/QC.err.%J
#SBATCH --time=0-03:00
#SBATCH --mem-per-cpu=8000
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
###

# QC

# locations
working=${pwd}
tmp=../tmp
agilent_probes=../resources/<probes>.bed

cd $tmp

# samtools module
module load samtools
module load mosdepth

# proximity ligation properties
python3 /scratch/c.c22085422/MET584/Repository/capture/get_qc.py -p stats.txt

# target enrichment QC
samtools view mapped_hg38_PT.bam -L $agilent_probes -@ 16\
|awk -F "\t" '{print "@"$1}'|sort -u|wc -l

# coverage depth
mosdepth -t 16 -b $agilent_probes -x hg38_probes -n mapped_hg38_PT.bam

cd $working
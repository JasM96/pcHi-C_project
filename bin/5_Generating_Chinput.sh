#!/bin/bash --login 
###
#SBATCH --partition=htc
#SBATCH --account=<project_account>
#SBATCH --job-name=Chinput
#SBATCH --output=OUT/Chinput.out.%J
#SBATCH --error=ERR/Chinput.err.%J
#SBATCH --time=0-03:00
#SBATCH --mem-per-cpu=8000
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
###

# ENVIRONMENT SETUP

# tmp
tmp=../tmp
# design directory location
design_dir=../resources/h_20kDesignFiles
# bait and r maps
baitmap=$design_dir/pooled_20kb_200bp.baitmap
rmap=$design_dir/digest20kb_pooled200bp.rmap
# chicago scripts
bam2chicago_script=../repository/chicago/chicagoTools/bam2chicago.sh
runChicago_script=../repository/chicago/chicagoTools/runChicago.R

# load module packages
module load bedtools

# Chinput file creation
$bam2chicago_script $tmp/CHiCAGO_hg38.bam \
$baitmap \
$rmap \
$tmp/20kb_chinput_hg38

# #!/bin/bash

# working
working=${pwd}
# hg38 genome file location
hg38_genome=../hg38/hg38.genome
#baits:
baits=../resources/<baits>.bed

#Create and enter design file directory:
cd ../resources
mkdir h_20kDesignFiles
cd h_20kDesignFiles

# load bedtools module
module load bedtools

# Add 200bp on both sides of each bait, rename baits and merge overlapping baits
# Change -b parameter value to use different number of base pairs
cut -f1,2,3 $baits |bedtools slop -g $hg38_genome  -b 200 -i stdin|\
awk -F'\t' 'NR>0{$0=$0"\t""bait_"NR} 1'|\
bedtools merge -i stdin -c 4 -o collapse -delim "_">pooled_baits200bp.bed

# 20kb OEF fragments. Change -w value if you wish to change the fragment size

bedtools makewindows -g $hg38_genome -w 20000 > genome.20kb.bed

# Subtract regions with probe fragments

bedtools subtract -a genome.20kb.bed -b pooled_baits200bp.bed > 20kb_sub_probe.bed

# Combine intervals

cat pooled_baits200bp.bed >temp.bed
awk '{print $1"\t"$2"\t"$3"\t""label"}' 20kb_sub_probe.bed >>temp.bed
bedtools sort -i temp.bed |awk -F'\t' 'NR>0{$0=$0"\t"NR} 1'>digest_and_probes.bed

# Generate rmap:

awk '{print $1"\t"$2"\t"$3"\t"$5}' digest_and_probes.bed > digest20kb_pooled200bp.rmap

# Generate baitmap:

awk '{if ($4 != "label") print $1"\t"$2"\t"$3"\t"$5"\t"$4}' digest_and_probes.bed > pooled_20kb_200bp.baitmap

# Generate design files (adjust parameters as needed):
# Depending on the python version supported by your system, use either ./chicago/chicagoTools/makeDesignFiles.py or ./chicago/chicagoTools/makeDesignFiles_py3.py

python $MET584/chicago/chicagoTools/makeDesignFiles.py \
--minFragLen 75 \
--maxFragLen 30000 \
--maxLBrownEst 1000000 \
--binsize 20000 \
--rmapfile $MET584/h_20kDesignFiles/digest20kb_pooled200bp.rmap \
--baitmapfile $MET584/h_20kDesignFiles/pooled_20kb_200bp.baitmap --outfilePrefix 20kDesignFiles

# return to bin
cd $working
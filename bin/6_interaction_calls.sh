# tmp
tmp=../tmp
# output location
output=../output
# design directory location
design_dir=../resources/h_20kDesignFiles
# bait and r maps
baitmap=$design_dir/pooled_20kb_120bp.baitmap
rmap=$design_dir/digest20kb_pooled120bp.rmap
# chicago scripts
bam2chicago_script=../repository/chicago/chicagoTools/bam2chicago.sh
runChicago_script=../repository/chicago/chicagoTools/runChicago.R

# enter results directory
cd $results

echo
echo "Interaction Calling"

# Interaction Calling S1
Rscript $runChicago_script --design-dir $design_dir \
--cutoff 5 \
--export-format interBed,washU_text,seqMonk,washU_track \
$tmp/20kb_chinput_hg38/20kb_chinput_hg38.chinput \
hg38_chicago_calls

echo "Interaction Calling Complete"
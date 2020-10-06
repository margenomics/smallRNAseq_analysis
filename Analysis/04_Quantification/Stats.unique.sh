#!/bin/bash
#SBATCH -p short            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 29Gb     # Memory in MB
#SBATCH -J quant.stats           # job name
#SBATCH -o quant.stats.%j.out    # File to which standard out will be written
#SBATCH -e quant.stats.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData


mkdir $DIR/Analysis/04_Quantification/Stats


featurecountsDIR=$DIR/Analysis/04_Quantification/FeatureCounts
umicountsDIR=$DIR/Analysis/04_Quantification/UMI_Counts
OUTDIR=$DIR/Analysis/04_Quantification/Stats

cd $OUTDIR
for line in $(ls $umicountsDIR/*.tsv ); do  name=`basename -s .tsv $line` ; featurecounts=`awk -F '\t' '$1 ~ /hsa/ {sum += $7} END {print sum}' $featurecountsDIR/${name}.txt`; umicounts=`cat $line | awk '{sum+=$2} END{print sum}' `; printf $name"\t"$featurecounts"\t"$umicounts"\n";  done > $OUTDIR/Stats.txt


# Copy files for multiqc
cp $featurecountsDIR/*.txt.summary $DIR/QC/QC_trimmed/

cd $DIR/QC/QC_trimmed/
module load  Python/3.5.2-foss-2016b
multiqc -f .

#!/bin/bash
#SBATCH -p lowmem            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 4Gb     # Memory in MB
#SBATCH -J quantification.loop           # job name
#SBATCH -o quantification.loop.%j.out    # File to which standard out will be written
#SBATCH -e quantification.loop.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData

mkdir $DIR/Analysis/04_Quantification/logs
mkdir $DIR/Analysis/04_Quantification/FeatureCounts
mkdir $DIR/Analysis/04_Quantification/UMI_Counts

cd $DIR/Analysis/04_Quantification
INDIR=$DIR/Analysis/03_ReadMapping/BAM_Files
featurecountsDIR=$DIR/Analysis/04_Quantification/FeatureCounts
umicountsDIR=$DIR/Analysis/04_Quantification/UMI_Counts

#=========================#
#   COUNTS                #
#=========================#


for line in $(ls $INDIR/*.bam)
	do 
	name=`basename $line` 
	echo $name
	sbatch $DIR/Analysis/04_Quantification/quantification.sh $line $name $featurecountsDIR $umicountsDIR;
done



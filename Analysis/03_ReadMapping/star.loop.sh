#!/bin/bash
#SBATCH -p lowmem            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 4Gb     # Memory in MB
#SBATCH -J star.loop           # job name
#SBATCH -o star.loop.%j.out    # File to which standard out will be written
#SBATCH -e star.loop.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData

mkdir $DIR/Analysis/03_ReadMapping/logs
mkdir $DIR/Analysis/03_ReadMapping/BAM_Files

cd $DIR/Analysis/03_ReadMapping
INDIR=$DIR/Analysis/02_Cutadapt/Trimmed_Merged_Files
OUTDIR=$DIR/Analysis/03_ReadMapping/BAM_Files

#=========================#
#   STAR ALIGNMENT        #
#=========================#

for line in $(ls $INDIR/*.fastq.gz)
	do 
	name=`basename -s .fastq.gz $line` 
	echo $name
	sbatch $DIR/Analysis/03_ReadMapping/star.sh $name $INDIR $OUTDIR;
	sleep 1; 
done



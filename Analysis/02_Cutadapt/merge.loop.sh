#!/bin/bash
#SBATCH -p lowmem            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 4Gb     # Memory in MB
#SBATCH -J merge.loop           # job name
#SBATCH -o merge.loop.%j.out    # File to which standard out will be written
#SBATCH -e merge.loop.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData


mkdir $DIR/Analysis/02_Cutadapt/Trimmed_Merged_Files

cd $DIR/Analysis/02_Cutadapt
INDIR=$DIR/Analysis/02_Cutadapt/Trimmed_Files
OUTDIR=$DIR/Analysis/02_Cutadapt/Trimmed_Merged_Files

#=========================#
#   Merge 4 Lanes         #
#=========================#

for line in $(ls $DIR/Analysis/02_Cutadapt/Trimmed_Files/*.fastq.gz | cut -d "/" -f 8 | cut -d "_" -f 1,2 | uniq)
	do 
	echo $line
	sbatch $DIR/Analysis/02_Cutadapt/merge_fastq.sh $line $INDIR $OUTDIR;
	sleep 1; 
done


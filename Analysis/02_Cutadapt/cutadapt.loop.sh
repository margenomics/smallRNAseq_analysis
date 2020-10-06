#!/bin/bash
#SBATCH -p lowmem            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 4Gb     # Memory in MB
#SBATCH -J Cutadapt.loop           # job name
#SBATCH -o Cutadapt.loop.%j.out    # File to which standard out will be written
#SBATCH -e Cutadapt.loop.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData

mkdir $DIR/Analysis/02_Cutadapt/logs
mkdir $DIR/Analysis/02_Cutadapt/Trimmed_Files

cd $DIR/Analysis/02_Cutadapt
OUTDIR=$DIR/Analysis/02_Cutadapt/Trimmed_Files

#=========================#
#   Cutadapt              #
#=========================#
# Keep reads with minimum length of 15nt ( cutadapt -m 15)

for line in $(ls $DIR/Analysis/01_ExtractUMI/Fastq_Files/*.fastq)
	do 
	echo $line
	sbatch $DIR/Analysis/02_Cutadapt/cutadapt.sh $line $OUTDIR;
	sleep 1; 
done


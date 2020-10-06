#!/bin/bash
#SBATCH -p lowmem            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 6Gb     # Memory in MB
#SBATCH -J QC_loop           # job name
#SBATCH -o QC_loop.%j.out    # File to which standard out will be written
#SBATCH -e QC_loop.%j.err    # File to which standard err will be written

# QC Analysis of RNASeq samples of project: 

PROJECT=$1
RUN=$2

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData

# Prepare folders
#------------------
mkdir $DIR/QC/logs
mkdir $DIR/QC/$RUN

#============#
#   FASTQC   #
#============#
mkdir $DIR/QC/$RUN/FastQC
outdir=$DIR/QC/$RUN/FastQC

for i in $(ls $FASTQDIR/*fastq.gz) 
	do
	echo $i
	sbatch $DIR/QC/fastqc.sh $i $outdir
	sleep 1
done


#=================#
#   FASTQSCREEN   #
#=================#
mkdir $DIR/QC/$RUN/FastqScreen
outdir=$DIR/QC/$RUN/FastqScreen
	
for i in $(ls $FASTQDIR/*fastq.gz) 
	do
	echo $i
	sbatch $DIR/QC/fastq_screen.sh $i $outdir
	sleep 1
done



#!/bin/bash
#SBATCH -p short            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 4Gb     # Memory in MB
#SBATCH -J UMI_extract.loop           # job name
#SBATCH -o UMI_extract.loop.%j.out    # File to which standard out will be written
#SBATCH -e UMI_extract.loop.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData

mkdir $DIR/Analysis/01_ExtractUMI/logs
mkdir $DIR/Analysis/01_ExtractUMI/Fastq_Files

cd $DIR/Analysis/01_ExtractUMI
OUTDIR=$DIR/Analysis/01_ExtractUMI/Fastq_Files
#=========================#
#   EXTRACT UMI + FASTQC  #
#=========================#


# https://uofuhealth.utah.edu/huntsman/shared-resources/gba/htg/library-prep/small-rna.php
#The Read 1 sequence of a library constructed with the Qiagen QIAseq miRNA Library Kit may include the following sequences: miRNA sequence, a 19 base Qiagen adapter sequence, a 12 base unique molecular index (UMI), a 34 base Illumina adapter sequence, and a 6 base p7 index. Adapter sequences need to be trimmed prior to alignment.

#    ** TAGCTTATCAGACTGATGTTGA (example of miRNA sequence)
#    ** AACTGTAGGCACCATCAAT (19 base Qiagen adapter)
#    ** NNNNNNNNNNNN (12 base random sequence representing the UMI)
#    ** AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC (Illumina adapter sequence)
#    ** ATCACG (example of i7 index sequence)


for line in $(ls $FASTQDIR/*.gz)
	do 
	name=`basename -s .fastq.gz $line` 
	echo $name 
	sbatch $DIR/Analysis/01_ExtractUMI/umi_extract_1mm.sh $line $name $OUTDIR;
	sleep 1; 
done



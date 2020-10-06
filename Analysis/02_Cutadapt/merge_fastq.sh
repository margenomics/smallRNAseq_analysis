#!/bin/bash
#SBATCH -p normal            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 45Gb    # Memory in MB
#SBATCH -J merge_fastq           # job name
#SBATCH -o logs/merge_fastq.%j.out    # File to which standard out will be written
#SBATCH -e logs/merge_fastq.%j.err    # File to which standard err will be written




LANE1=_L001_R1_001.fastq.gz
LANE2=_L002_R1_001.fastq.gz
LANE3=_L003_R1_001.fastq.gz
LANE4=_L004_R1_001.fastq.gz

name=$1
DIR=$2
OUTDIR=$3
#######################################################################
################################ MERGE ###############################

zcat $DIR/$name$LANE1 > $OUTDIR/$name.fastq
zcat $DIR/$name$LANE2 >> $OUTDIR/$name.fastq
zcat $DIR/$name$LANE3 >> $OUTDIR/$name.fastq
zcat $DIR/$name$LANE4 >> $OUTDIR/$name.fastq

gzip $OUTDIR/$name.fastq

#######################################################################
################################ FASTQC ###############################


module load FastQC/0.11.5-Java-1.7.0_80

fastqc --outdir $OUTDIR --threads $SLURM_CPUS_PER_TASK $OUTDIR/$name.fastq.gz


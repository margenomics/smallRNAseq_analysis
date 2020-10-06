#!/bin/bash
#SBATCH -p short            # Partition to submit to
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu 7Gb     # Memory in MB
#SBATCH -J cutadapt           # job name
#SBATCH -o logs/cutadapt.%j.out    # File to which standard out will be written
#SBATCH -e logs/cutadapt.%j.err    # File to which standard err will be written

module purge  ## Why? Clear out .bashrc /.bash_profile settings that might interfere
module load Python/3.5.2-foss-2016b

INFILE=$1
name=`basename $1`
OUTDIR=$2

cutadapt -j $SLURM_CPUS_PER_TASK -m 15 -o $OUTDIR/$name $INFILE


module load FastQC/0.11.5-Java-1.7.0_80

fastqc --outdir $OUTDIR --threads $SLURM_CPUS_PER_TASK $OUTDIR/$name 

gzip $OUTDIR/$name


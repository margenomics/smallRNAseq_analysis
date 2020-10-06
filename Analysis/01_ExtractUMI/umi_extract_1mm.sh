#!/bin/bash
#SBATCH -p normal            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 45Gb     # Memory in MB
#SBATCH -J UMI_extract           # job name
#SBATCH -o logs/UMI_extract.%j.out    # File to which standard out will be written
#SBATCH -e logs/UMI_extract.%j.err    # File to which standard err will be written



module purge 
module load Python/3.6.2

#------------------------
INFILE=$1
name=$2
OUTDIR=$3


#------------------------
# Pattern that allows 1 substitution in adapter 1 (QIAGEN) 
# Then requires 12bp as UMI
# Then discards anything beyond
umi_tools extract --stdin $INFILE \
                    --bc-pattern='.*(?P<discard_1>AACTGTAGGCACCATCAAT){s<=1}(?P<umi_1>.{12})(?P<discard_2>.*$)' \
                    --extract-method=regex \
		    --log ${OUTDIR}/${name}.log \
		    --stdout ${OUTDIR}/${name}.fastq



module purge 
module load FastQC/0.11.5-Java-1.7.0_80        


#------------------------

fastqc --outdir $OUTDIR --threads $SLURM_CPUS_PER_TASK ${OUTDIR}/${name}.fastq


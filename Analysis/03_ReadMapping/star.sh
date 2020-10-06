#!/bin/bash
#SBATCH -p normal                       # Partition to submit to
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu 11Gb               # Memory in MB
#SBATCH -J STAR               		# job name
#SBATCH -o logs/STAR.%j.out    		# File to which standard out will be written
#SBATCH -e logs/STAR.%j.err    		# File to which standard err will be written

module load STAR/2.6.0a


GNMIDX=/bicoh/MARGenomics/AnalysisFiles/Index_Genomes_STAR/miRBase/miRBase_v22.1_hsa_hairpin_cDNA

name=$1
FASTQDIR=$2
OUTDIR=$3
######################################################################################################
#####################################ALIGNMENT########################################################

STAR --runThreadN $SLURM_CPUS_PER_TASK --genomeDir $GNMIDX --readFilesIn $FASTQDIR/$name.fastq.gz --readFilesCommand zcat --outFileNamePrefix $OUTDIR/$name --outSAMattributes All --outSAMtype BAM SortedByCoordinate --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 15 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --alignIntronMax 1 

####################################################################################################
##################################### INDEX ######################################################

module purge  
module load SAMtools/1.8-foss-2016b

samtools index ${OUTDIR}/${name}Aligned.sortedByCoord.out.bam ${OUTDIR}/${name}Aligned.sortedByCoord.out.bai

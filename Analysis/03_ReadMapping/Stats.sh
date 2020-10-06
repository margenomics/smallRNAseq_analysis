#!/bin/bash
#SBATCH -p short            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 29Gb     # Memory in MB
#SBATCH -J star.stats           # job name
#SBATCH -o star.stats.%j.out    # File to which standard out will be written
#SBATCH -e star.stats.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData


mkdir $DIR/Analysis/03_ReadMapping/Stats


INDIR=$DIR/Analysis/03_ReadMapping/BAM_Files
OUTDIR=$DIR/Analysis/03_ReadMapping/Stats


cd $OUTDIR
#Inspeccionem el resultat dels alineaments
for i in ${INDIR}/*.final.out; do basename $i >> ${OUTDIR}/TotalCounts_Alignment; grep "Uniquely mapped reads number" "$i" >> ${OUTDIR}/TotalCounts_Alignment; grep "Number of reads mapped to multiple loci" "$i" >> ${OUTDIR}/TotalCounts_Alignment; grep "Number of reads mapped to too many loci" "$i" >> ${OUTDIR}/TotalCounts_Alignment; grep "reads unmapped: too short" "$i" >> ${OUTDIR}/TotalCounts_Alignment; done


# Copy files for multiqc
cp $INDIR/*.final.out $DIR/QC/QC_trimmed/

cd $DIR/QC/QC_trimmed/
module load  Python/3.5.2-foss-2016b
multiqc -f .

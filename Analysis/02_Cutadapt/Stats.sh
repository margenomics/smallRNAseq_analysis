#!/bin/bash
#SBATCH -p short            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 29Gb     # Memory in MB
#SBATCH -J cutadapt.stats           # job name
#SBATCH -o cutadapt.stats.%j.out    # File to which standard out will be written
#SBATCH -e cutadapt.stats.%j.err    # File to which standard err will be written



PROJECT=$1

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData


mkdir $DIR/Analysis/02_Cutadapt/Stats


INDIR=$DIR/Analysis/02_Cutadapt/Trimmed_Merged_Files
OUTDIR=$DIR/Analysis/02_Cutadapt/Stats


cd $OUTDIR
# Histogram values
for line in $(ls $INDIR/*.fastq.gz)
	do 
	name=`basename -s .fastq.gz $line` 
	zcat $line | awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' > $OUTDIR/${name}_lengths.txt
done 

# R script for plots 

# Histogram plots
for line in $(ls $INDIR/*.fastq.gz)
	do 
 	Treads=$(zcat $line | grep -c @)
	echo "====================================="
	echo $line. Total reads = $Treads
	echo "====================================="
	find $line -not -name \*raw\* -printf "zcat %p | awk '{if(NR%%4==2) print length(\$1)}' | ../scripts/textHistogram -maxBinCount=59 stdin \n" | sh
	printf "\n"
done > $OUTDIR/Histograms_length.txt



# Copy files for multiqc
mkdir $DIR/QC/QC_trimmed/
cp $INDIR/*.zip $DIR/QC/QC_trimmed/

cd $DIR/QC/QC_trimmed/
module load  Python/3.5.2-foss-2016b
multiqc -f .

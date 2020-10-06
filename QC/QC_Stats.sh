#!/bin/bash
#SBATCH -p normal,short,long            # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 20Gb     # Memory in MB
#SBATCH -J QC_Stats           # job name
#SBATCH -o QC_Stats.%j.out    # File to which standard out will be written
#SBATCH -e QC_Stats.%j.err    # File to which standard err will be written

# QC Stats of RNASeq samples of project: 

PROJECT=$1
RUN=$2

# Prepare variables
#------------------

path=/bicoh/MARGenomics
DIR=${path}/${PROJECT}
FASTQDIR=${DIR}/rawData


#=================#
#     MultiQC     #
#=================#
mkdir $DIR/QC/$RUN/multiQC
outdir=$DIR/QC/$RUN/multiQC

cd $DIR/QC/$RUN
module load Python/3.5.2-foss-2016b

multiqc . -f -o $outdir


###################################
## Check adapter distributions:
##################################
cd $DIR/QC/$RUN

A1=(AACTGTAGGCACCATCAAT)
for ((i=0; i<${#A1[0]}; i++)); do 
   A1+=( "${A1[0]:0:i}.${A1[0]:i+1}" )
 done
regexA1=$(IFS='|'; echo "${A1[*]:1:${#A1[0]}}")
echo "$regexA1"meet.google.com/vos-pdew-dqu

A2=(AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC)
for ((i=0; i<${#A2[0]}; i++)); do 
   A2+=( "${A2[0]:0:i}.${A2[0]:i+1}" )
 done
regexA2=$(IFS='|'; echo "${A2[*]:1:${#A2[0]}}")
echo "$regexA2"


printf "Sample\tA1\tA1 one mismatch\tA2\tA2 one mismatch\tA2+A1\tA2noA1\n" > Adapters_Stats.txt

for line in $(ls $FASTQDIR/*.gz)
	do 
	name=`basename -s .fastq.gz $line` 
	echo $name 
	# Number A1 exact
	nA1=$(zcat $line | grep -E -c $A1)
	# Number A1 + 1 mismatch
	nA1mm=$(zcat $line | grep -E -c $regexA1)
	# Number A2 exact
	nA2=$(zcat $line | grep -E -c $A2)
	# Number A2 +1 exact
	nA2mm=$(zcat $line | grep -E -c $regexA2)
	# Number of A2 with A1
	nA2A1=$(zcat $line | grep -E $regexA2 |  grep -E -c $regexA1)
	# Number of A2 with no A1
	nA2noA1=$(zcat $line | grep -E $regexA2 |  grep -E -c -v $regexA1)

	# Write numbers to file
	printf $name"\t"$nA1"\t"`expr $nA1mm - $nA1`"\t"$nA2"\t"`expr $nA2mm - $nA2`"\t"$nA2A1"\t"$nA2noA1"\n" >> Adapters_Stats.txt
	sleep 1; 
done


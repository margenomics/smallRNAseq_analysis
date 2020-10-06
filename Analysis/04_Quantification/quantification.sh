#!/bin/bash
#SBATCH -p normal,long              # Partition to submit to
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu 90Gb   	    # Memory in MB
#SBATCH -J quantification           # job name
#SBATCH -o logs/quantification.%j.out    # File to which standard out will be written
#SBATCH -e logs/quantification.%j.err    # File to which standard err will be written


INPUT=$1
name=$2
featurecountsDIR=$3
umicountsDIR=$4

REFGENE=/bicoh/MARGenomics/Ref_Genomes_fa/miRBase
ANNOTGENE=/bicoh/MARGenomics/AnalysisFiles/Annot_files_GTF/Human_miRNAs



module load subread/1.6.4

######################################################################################################
##################################### COUNTS ########################################################
featureCounts -T $SLURM_CPUS_PER_TASK -t miRNA -g miRNA_id -a $ANNOTGENE/miRNA.str.v21_over_hairpin.hsa.gtf -G $REFGENE/miRBase_v22.1_hsa_hairpin_cDNA.fa -M --fraction --fracOverlapFeature 0.85 -o ${featurecountsDIR}/${name}.txt -R BAM $INPUT



######################################################################################################
##################################### INDEX ########################################################
module load SAMtools/1.8-foss-2016b

samtools sort ${featurecountsDIR}/${name}.featureCounts.bam -o ${featurecountsDIR}/${name}_sorted.bam;
samtools index ${featurecountsDIR}/${name}_sorted.bam;



######################################################################################################
##################################### UMI COUNT ########################################################
module load Python/3.6.2

# Count UMIs per gene per cell (unique method)
umi_tools count --per-gene --gene-tag=XT --method=unique -I ${featurecountsDIR}/${name}_sorted.bam -S ${umicountsDIR}/${name}.tsv

# Default method (directional) is more strict (detects more duplicates) but it uses graphs
# RAM requirements grow exponentially and some samples get stucked never finishing to sove the graph
#umi_tools count --per-gene --gene-tag=XT -I ${featurecountsDIR}/${name}_sorted.bam -S ${umicountsDIR}/${name}.tsv


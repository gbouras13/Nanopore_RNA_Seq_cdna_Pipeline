#!/bin/bash -l

#SBATCH --job-name=ghais_rna_seq
#SBATCH --mail-user=george.bouras@adelaide.edu.au
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --err="ghais_rna_seq_snk.err"
#SBATCH --output="ghais_rna_seq_snk.out"

# Resources allocation request parameters
#SBATCH -p batch
#SBATCH -N 1                                                    # number of tasks (sequential job starts 1 task) (check this if your job unexpectedly uses 2 nodes)
#SBATCH -c 1                                                    # number of cores (sequential job calls a multi-thread program that uses 8 cores)
#SBATCH --time=23:00:00                                         # time allocation, which has the format (D-HH:MM), here set to 1 hou                                           # generic resource required (here requires 1 GPUs)
#SBATCH --mem=10GB                                              # specify memory required per node


SNK_DIR="/hpcfs/users/a1667917/Ghais/Rat_RNA_Seq/Nanopore_RNA_Seq_cdna_Pipeline"
PROF_DIR="/hpcfs/users/a1667917/snakemake_slurm_profile"

cd $SNK_DIR

module load Anaconda3/2020.07
conda activate snakemake_clean_env

snakemake -s rna_seq_runner.smk --use-conda \
--config Reads=/hpcfs/users/a1667917/Ghais/Rat_RNA_Seq/aggregated_fastqs  Output=/hpcfs/users/a1667917/Ghais/Rat_RNA_Seq/RNA_Seq_Pipeline_Out  --profile $PROF_DIR/wgs_tcga

conda deactivate

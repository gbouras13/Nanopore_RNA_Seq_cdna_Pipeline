"""
The snakefile that runs the pipeline.
# HPC
# on login node from pipeline dir
snakemake -s rna_seq_runner.smk -c 1 --use-conda --config Reads=Fastqs Output=test hg38_dir='/hpcfs/users/a1667917/STAR_Ref_Genomes' --conda-create-envs-only --conda-frontend conda
# to run
snakemake -s rna_seq_runner.smk --use-conda --config Reads=Fastqs/ Output=RNA_EGA_Out HG38_dir='/hpcfs/users/a1667917/STAR_Ref_Genomes' --profile wgs_tcga
"""


### DEFAULT CONFIG FILE
configfile: os.path.join(workflow.basedir,  'config', 'config.yaml')

BigJobMem = config["BigJobMem"]
BigJobCpu = config["BigJobCpu"]
# STAR can only use 16 threads on hpc for some reason
# https://github.com/alexdobin/STAR/issues/1074
MediumJobCpu = config["MediumJobCpu"]

# need to specify the reads directory
READS = config['Reads']

### DIRECTORIES
include: "rules/directories.smk"

# Parse the samples and read files
include: "rules/samples.smk"
sampleReads = parseSamples(READS)
SAMPLES = sampleReads.keys()
# write tsv
writeSamplesTsv(sampleReads, os.path.join(OUTPUT, 'rna_seq_samples.tsv'))


# Import rules and functions
include: "rules/targets.smk"
include: "rules/qc.smk"


rule all:
    input:
        QCFiles
        # ## Assembly
        # AssemblyFiles,
        # ## Translated (nt-to-aa) search
        # SecondarySearchFilesAA,
        # ## Untranslated (nt-to-nt) search
        # SecondarySearchFilesNT,
        # ## Contig annotation
        # ContigAnnotFiles,
        # ## Mapping (read-based contig id)
        # MappingFiles,
        # ## Summary
        # SummaryFiles

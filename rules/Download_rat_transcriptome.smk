"""
Snakefile for downloading files for the rattus norvegicus 
snakemake -c 1 -s rules/Download_rat_transcriptome.smk --config Reference_Dir='/hpcfs/users/a1667917/Reference_Rat_Transcriptome/'
"""
import os

# load default config
configfile: os.path.join(workflow.basedir, '..', 'config', 'config.yaml')

if config['Reference_Dir'] is None:
    Reference_Dir = "/hpcfs/users/a1667917/Reference_Rat_Transcriptome/"
else:
    Reference_Dir = config["Reference_Dir"]

# needs to be created before (should exist)
if not os.path.exists(os.path.join(Reference_Dir)):
  os.makedirs(os.path.join(Reference_Dir))

rule all:
    input:
        os.path.join(Reference_Dir,'download_fasta.dlflag'),
        os.path.join(Reference_Dir,'download_gtf.dlflag'),
        os.path.join(Reference_Dir, 'unzip.dlflag')

rule download_fasta:
    """Rule to Download rat fasta."""
    output:
        os.path.join(Reference_Dir,'download_fasta.dlflag'),
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz')
    threads:
        1
    shell:
        """
        wget -c "http://ftp.ensembl.org/pub/release-105/fasta/rattus_norvegicus/dna/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz" -O Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz
        mv "Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz" {output[1]}
        touch {output[0]}
        """

rule gunzip_fasta:
    """Rule to Download rat fasta."""
    input:
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz')
    output:
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa')
    threads:
        1
    shell:
        """
        gunzip {input[0]}
        """

rule download_gtf:
    """Rule to Download rat gtf."""
    output:
        os.path.join(Reference_Dir,'download_gtf.dlflag'),
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.105.gtf.gz')
    threads:
        1
    shell:
        """
        wget -c "http://ftp.ensembl.org/pub/release-105/gtf/rattus_norvegicus/Rattus_norvegicus.mRatBN7.2.105.gtf.gz" -O Rattus_norvegicus.mRatBN7.2.105.gtf.gz
        mv "Rattus_norvegicus.mRatBN7.2.105.gtf.gz" {output[1]}
        touch {output[0]}
        """

rule unzip:
    """gunzip files."""
    input:
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz').
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.105.gtf.gz')
    output:
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa'),
        os.path.join(Reference_Dir, 'Rattus_norvegicus.mRatBN7.2.105.gtf'),
        os.path.join(Reference_Dir, 'unzip.dlflag')
    threads:
        1
    shell:
        """
        gunzip {input[0]}
        gunzip {input[1]}
        touch {output[2]}
        """

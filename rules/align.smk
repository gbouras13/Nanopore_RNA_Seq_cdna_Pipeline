rule minimap:
    input:
        os.path.join(TMP,"{sample}_porechopped.fastq.gz")
    output:
        os.path.join(TMP,"{sample}.sam")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.minimap.log")
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        minimap2 -ax splice Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa {input[0]} > {output[0]}
        '''

rule convert_sam_bam:
    input:
        os.path.join(TMP,"{sample}.sam")
    output:
        os.path.join(TMP,"{sample}.bam")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.sam_to_bam.log")
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        samtools view -S -b {input[0]} > {output[0]}
        '''


#### aggregation rule
rule align_aggr:
    """aggregate qc"""
    input:
        expand(os.path.join(TMP,"{sample}.bam"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "align.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """




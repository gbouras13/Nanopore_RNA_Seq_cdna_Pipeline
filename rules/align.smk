rule minimap:
    input:
        os.path.join(TMP,"{sample}_porechopped.fastq.gz")
    output:
        os.path.join(TMP,"{sample}.sam")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    params:
        os.path.join(DBDIR,"Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa")
    log:
        os.path.join(LOGS,"{sample}.minimap.log")
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        minimap2 -ax splice {params[0]} {input[0]} > {output[0]}
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




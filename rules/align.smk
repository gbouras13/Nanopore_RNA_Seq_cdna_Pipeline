# rule transcriptome_create:
#     input:
#         os.path.join(TMP,"{sample}_porechopped.fastq.gz")
#     output:
#         os.path.join(TMP,"{sample}.bam")
#     threads:
#         BigJobCpu
#     resources:
#         mem_mb=BigJobMem
#     params:
#         os.path.join(DBDIR,"Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa")
#     log:
#         os.path.join(LOGS,"{sample}.minimap.log")
#     conda:
#         os.path.join('..', 'envs','align.yaml')
#     shell:
#         '''
#         #minimap2 -ax splice -k9 {params[0]} {input[0]} | samtools view -S -b > {output[0]}
#         minimap2 -ax map-ont {params[0]} {input[0]} | samtools view -S -b > {output[0]}
#         '''
# gffread -F -w test_transcriptome.fa -g Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa Rattus_norvegicus.mRatBN7.2.105.gtf

rule minimap:
    input:
        os.path.join(TMP,"{sample}_porechopped.fastq.gz")
    output:
        os.path.join(TMP,"{sample}.bam")
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
        minimap2 -ax splice -t {threads} {params[0]} {input[0]} | samtools view -@ {threads} -S -b > {output[0]}
        '''

rule bam_sort:
    input:
        os.path.join(TMP,"{sample}.bam")
    output:
        os.path.join(TMP,"{sample}_sorted.bam")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.sort_bam.log")
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        samtools sort -@ {threads} {input[0]} -o {output[0]}
        '''


rule bam_stats:
    input:
        os.path.join(TMP,"{sample}_sorted.bam")
    output:
        os.path.join(BAM_STATS,"{sample}_bam.stats")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.stats_bam.log")
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        samtools stats -@ {threads} {input[0]} | grep ^SN | cut -f 2- > {output[0]} 
        '''


#### aggregation rule
rule align_aggr:
    """aggregate qc"""
    input:
        expand(os.path.join(TMP,"{sample}.bam"), sample = SAMPLES),
        expand(os.path.join(BAM_STATS,"{sample}_bam.stats"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "align.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """




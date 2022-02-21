rule porechop:
    input:
        os.path.join(READS, "{sample}.fastq.gz")
    output:
        os.path.join(TMP,"{sample}_porechopped.fastq.gz")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.porechop.log")
    conda:
        os.path.join('..', 'envs','qc.yaml')
    shell:
        '''
        porechop -i {input} -o {output} --threads {threads}
        '''

rule nanoplot:
    input:
        os.path.join(TMP,"{sample}_porechopped.fastq.gz")
    output:
        dir = directory(os.path.join(QC, "{sample}")) 
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.nanoplot.log")
    conda:
        os.path.join('..', 'envs','qc.yaml')
    shell:
        'NanoPlot --prefix pass --fastq {input} -t {threads} -o {output.dir}'

#### aggregation rule
rule qc_aggr:
    """aggregate qc"""
    input:
        expand(os.path.join(QC, "{sample}"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "qc.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """


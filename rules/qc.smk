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

rule gunzip:
    input:
        os.path.join(READS, "{sample}.fastq.gz")
    output:
        os.path.join(TMP,"{sample}.fastq")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.gunzip.log")
    conda:
        os.path.join('..', 'envs','qc.yaml')
    shell:
        '''
        gunzip -c {input} > {output}
        '''

rule pychopper:
    input:
        os.path.join(TMP,"{sample}.fastq")
    output:
        os.path.join(TMP,"{sample}_pychop.fastq"),
        os.path.join(TMP,"{sample}_pychop_rescued.fastq"),
        os.path.join(TMP,"{sample}_pychop_unclassified.fastq"),
        os.path.join(QC,"{sample}_pychop_report.pdf"),
        os.path.join(TMP,"{sample}_pychop_below_qc.fastq")

    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"{sample}.pychop.log")
    conda:
        os.path.join('..', 'envs','qc.yaml')
    shell:
        '''
        cdna_classifier.py -m edlib -K {output[4]} -r {output[3]} -u {output[2]} -w {output[1]} -t {threads} {input[0]} {output[0]}
        '''



#### aggregation rule
rule qc_aggr:
    """aggregate qc"""
    input:
        expand(os.path.join(QC, "{sample}"), sample = SAMPLES),
        expand(os.path.join(TMP,"{sample}_pychop.fastq"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "qc.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """


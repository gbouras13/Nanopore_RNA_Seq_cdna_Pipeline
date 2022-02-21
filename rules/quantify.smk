rule index_transcriptome:
    """index fasta for bambu"""
    input:
        os.path.join(DBDIR,"Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa")
    output:
        os.path.join(DBDIR,"Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.fai")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"faidx.log")
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        "samtools faidx {input[0]}"

rule bambu:
    input:
        bams = expand(os.path.join(TMP,"{sample}.bam"), sample = SAMPLES),
        index = os.path.join(DBDIR,"Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.fai")
    output:
        os.path.join(R_OBJECTS,"se.rds")
    params:
        os.path.join(DBDIR,"Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa"),
        os.path.join(DBDIR,"Rattus_norvegicus.mRatBN7.2.105.gtf")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    log:
        os.path.join(LOGS,"bambu.log")
    conda:
        os.path.join('..', 'envs','quantify.yaml')
    script:
        "../scripts/bambu.R"




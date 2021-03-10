rule run_all_of_me:
    input: "results/all.cmp.matrix.png"
    

rule download_genomes:
    output:
        file1 = "raw_data/1.fa.gz", 
        file2 = "raw_data/2.fa.gz", 
        file3 = "raw_data/3.fa.gz", 
        file4 = "raw_data/4.fa.gz", 
        file5 = "raw_data/5.fa.gz",
        file6 = "raw_data/6.fa.gz",
        file7 = "raw_data/7.fa.gz",
        file8 = "raw_data/8.fa.gz",
        file9 = "raw_data/9.fa.gz",
        file10 = "raw_data/10.fa.gz",
        file11 = "raw_data/11.fa.gz"
    shell: """
       wget https://osf.io/t5bu6/download -O {output.file1}
       wget https://osf.io/ztqx3/download -O {output.file2}
       wget https://osf.io/w4ber/download -O {output.file3}
       wget https://osf.io/dnyzp/download -O {output.file4}
       wget https://osf.io/ajvqk/download -O {output.file5}
       wget https://osf.io/qh5wv/download -O {output.file6}
       wget https://osf.io/fbyq7/download -O {output.file7}
       wget https://osf.io/8amhx/download -O {output.file8}
       wget https://osf.io/ce2kv/download -O {output.file9}
       wget https://osf.io/w8v3f/download -O {output.file10}
       wget https://osf.io/jscdk/download -O {output.file11}
    """

rule sketch_genomes:
    conda: "environment.yml"
    input:
        "raw_data/{name}.fa.gz"
    output:
        "results/{name}.fa.gz.sig"
    shell: """
        sourmash compute -k 31 {input} -o {output}
    """

rule compare_genomes:
    conda: "environment.yml"
    input:
        expand("results/{n}.fa.gz.sig", n= range(1, 12, 1))
    output:
        cmp = "results/all.cmp",
        labels = "results/all.cmp.labels.txt"
    shell: """
        sourmash compare {input} -o {output.cmp}
    """

rule plot_genomes:
    conda: "environment.yml"
    input:
        cmp = "results/all.cmp",
        labels = "results/all.cmp.labels.txt"
    output:
        "results/all.cmp.matrix.png",
        "results/all.cmp.hist.png",
        "results/all.cmp.dendro.png",
    shell: """
        sourmash plot {input.cmp} --output-dir results
    """
